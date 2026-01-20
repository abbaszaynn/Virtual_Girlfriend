import 'package:kraveai/generated/assets.dart';
import 'package:kraveai/services/supabase_service.dart';
import 'package:kraveai/views/screens/chat_screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateAiGfController extends GetxController {
  final SupabaseClient client = SupabaseService().client;

  // Basic Info
  final nameController = TextEditingController();
  final gender = "Female".obs; // Female, Male, Non-binary
  final age = 18.0.obs; // Slider usually returns double
  final bodyType = "Slim".obs;
  final ethnicity = "Caucasian".obs;
  final selectedPreferenceImage = Assets.image1.obs; // Default to first image

  // Personality
  final personalityTraits = <String>[].obs;
  final relationshipType = "Girlfriend".obs;

  // Categories for filtering
  final selectedCategories = <String>[].obs;

  // Voice
  final selectedVoiceId = "".obs;

  // Status
  final isLoading = false.obs;

  // -- Data Lists (Mocking what might be in widgets) --
  final List<String> availableBodyTypes = [
    "Slim",
    "Athletic",
    "Curvy",
    "Petite",
  ];
  final List<String> availableEthnicities = [
    "Caucasian",
    "Asian",
    "Latina",
    "Black",
    "Arab",
  ];
  final List<String> availableTraits = [
    "Flirty",
    "Shy",
    "Dominant",
    "Submissive",
    "Funny",
    "Intelligent",
    "Caring",
    "Adventurous",
  ];

  // Save to Database
  Future<void> createCharacter() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar(
        "Error",
        "Please give your companion a name",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (personalityTraits.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select at least one personality trait",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final userId = client.auth.currentUser!.id;

      // Construct System Prompt based on traits and gender
      final String genderPronoun = gender.value == 'Male'
          ? 'man'
          : gender.value == 'Female'
          ? 'woman'
          : 'person';

      final String genderModifier = gender.value == 'Male'
          ? 'masculine, confident'
          : gender.value == 'Female'
          ? 'feminine, alluring'
          : 'unique, engaging';

      final String relationshipRole = gender.value == 'Male'
          ? relationshipType.value
                .replaceAll('Girlfriend', 'Boyfriend')
                .replaceAll('girlfriend', 'boyfriend')
          : relationshipType.value;

      final String systemPrompt =
          "You are $name, a ${age.value.toInt()} year old ${ethnicity.value} $genderPronoun. "
          "You are my $relationshipRole. "
          "Your personality is: ${personalityTraits.join(', ')}. "
          "You are $genderModifier and embody your gender naturally. "
          "When describing yourself or actions, always maintain your ${gender.value.toLowerCase()} perspective. "
          "You strictly follow this persona. Be engaging, human-like, and immersive.";

      // Map personality traits to categories for filtering
      final List<String> categories = List<String>.from(selectedCategories);

      // Always include Custom for user-created characters
      if (!categories.contains('Custom')) {
        categories.add('Custom');
      }

      // If no categories selected, default to Custom only
      if (categories.length == 1 && categories[0] == 'Custom') {
        Get.snackbar(
          "Tip",
          "No categories selected. Character will only appear in 'Custom' section",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }

      // Create gender-based image prompt description
      final String imagePromptDesc;
      if (gender.value == 'Male') {
        imagePromptDesc =
            "handsome $name, ${age.value.toInt()} year old ${ethnicity.value} man, ${bodyType.value} athletic build, masculine features";
      } else if (gender.value == 'Female') {
        imagePromptDesc =
            "beautiful $name, ${age.value.toInt()} year old ${ethnicity.value} woman, ${bodyType.value} body type, feminine features";
      } else {
        imagePromptDesc =
            "$name, ${age.value.toInt()} year old ${ethnicity.value} person, ${bodyType.value} build, attractive features";
      }

      final response = await client
          .from('characters')
          .insert({
            'user_id': userId,
            'name': name,
            'description':
                "${age.value.toInt()}yo ${ethnicity.value} ${bodyType.value}",
            'system_prompt': systemPrompt,
            'image_url': selectedPreferenceImage.value,
            'voice_id': selectedVoiceId.value.isNotEmpty
                ? selectedVoiceId.value
                : (gender.value == 'Male'
                      ? 'ErXwobaYiN019PkySvjV' // Antoni - Male default
                      : '21m00Tcm4TlvDq8ikWAM'), // Rachel - Female default
            'gender': gender.value, // Save gender for image generation
            'image_prompt_description':
                imagePromptDesc, // Gender-based image description
            'categories': categories, // Add categories for filtering
          })
          .select()
          .single();

      final characterId = response['id'];

      Get.snackbar(
        "Success",
        "Character created successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.to(
        () => ChatScreen(
          characterId: characterId,
          name: name,
          image: selectedPreferenceImage.value,
        ),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to create character: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
