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
  final age = 18.0.obs; // Slider usually returns double
  final bodyType = "Slim".obs;
  final ethnicity = "Caucasian".obs;

  // Personality
  final personalityTraits = <String>[].obs;
  final relationshipType = "Girlfriend".obs;

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

      // Construct System Prompt based on traits
      final String systemPrompt =
          "You are $name, a ${age.value.toInt()} year old ${ethnicity.value} woman. "
          "You are my ${relationshipType.value}. "
          "Your personality is: ${personalityTraits.join(', ')}. "
          "You strictly follow this persona. Be engaging, human-like, and immersive.";

      final response = await client
          .from('characters')
          .insert({
            'user_id': userId,
            'name': name,
            'description':
                "${age.value.toInt()}yo ${ethnicity.value} ${bodyType.value}",
            'system_prompt': systemPrompt,
            'image_url':
                Assets.maya, // Default for now, Phase 2 will generate this
            'voice_id': selectedVoiceId.value.isNotEmpty
                ? selectedVoiceId.value
                : 'default_voice_id',
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

      // Navigate to Chat
      Get.off(
        () => ChatScreen(
          characterId: characterId,
          name: name,
          image: Assets.maya,
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
