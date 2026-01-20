import 'dart:ui';

import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/generated/assets.dart';
import 'package:kraveai/services/guest_service.dart';
import 'package:kraveai/services/supabase_service.dart';
import 'package:kraveai/views/screens/auth_screens/create_account_screen.dart';
import 'package:kraveai/views/screens/auth_screens/login_screen.dart'; // For logout navigation
import 'package:kraveai/views/screens/categories_screens/more_categories_screen.dart';
import 'package:kraveai/views/screens/categories_screens/filtered_characters_screen.dart';
import 'package:kraveai/views/screens/chat_screens/inbox_screen.dart';
import 'package:kraveai/views/screens/create_ai_gf_screens/create_ai_gf_screen.dart';
import 'package:kraveai/views/screens/home/detail_screen.dart';
import 'package:kraveai/views/widgets/categories_card.dart';
import 'package:kraveai/views/widgets/common_image_view.dart';
import 'package:kraveai/views/widgets/dynamic_container.dart';
import 'package:kraveai/views/widgets/home_card.dart';
import 'package:kraveai/views/widgets/my_button.dart';
import 'package:kraveai/views/widgets/my_text.dart';
import 'package:kraveai/views/widgets/single_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kraveai/data/character_data.dart';
import 'package:kraveai/models/character_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GuestService _guestService = GuestService();
  final SupabaseService _supabaseService = SupabaseService();
  List<Character> displayCharacterList = [];
  bool isLoadingCharacters = true;
  bool _hasLoadedOnce = false; // Flag to track initial load

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload characters when returning to this screen (not on first build)
    if (_hasLoadedOnce) {
      _loadCharacters();
    }
    _hasLoadedOnce = true;
  }

  Future<void> _loadCharacters() async {
    try {
      // Start with default characters
      displayCharacterList = List.from(characterList);

      // If user is logged in (not guest), fetch their custom characters
      if (!_guestService.isGuestMode) {
        final userId = _supabaseService.client.auth.currentUser?.id;
        if (userId != null) {
          final response = await _supabaseService.client
              .from('characters')
              .select()
              .eq('user_id', userId);

          // Convert database records to Character objects
          for (var charData in response) {
            displayCharacterList.add(
              Character(
                id: charData['id'].toString(),
                name: charData['name'],
                age: charData['description']?.split('yo')[0] ?? '25',
                imagePath: charData['image_url'] ?? Assets.maya,
                vibe: 'Custom',
                categories: [
                  'Custom',
                ], // Custom characters have their own category
                description: charData['description'] ?? '',
                systemPrompt: charData['system_prompt'] ?? '',
                voiceId: charData['voice_id'] ?? '21m00Tcm4TlvDq8ikWAM',
                imagePromptDescription: charData['description'] ?? '',
              ),
            );
          }
        }
      }

      if (mounted) {
        setState(() {
          isLoadingCharacters = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading characters: $e');
      if (mounted) {
        setState(() {
          isLoadingCharacters = false;
        });
      }
    }
  }

  final List<String> tags = [
    "#Flirty",
    "#Romantic",
    "#Supportive",
    "#Funny",
    "#Intelligent",
    "#Adventurous",
    "#Caring",
    "#Mysterious",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonImageView(imagePath: Assets.logo, height: 40),
                    Row(
                      children: [
                        // Chat icon
                        InkWell(
                          onTap: () {
                            Get.to(() => InboxScreen());
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    width: 1.2,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.chat,
                                    size: 16,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Logout icon (only for registered users)
                        if (!_guestService.isGuestMode)
                          InkWell(
                            onTap: () async {
                              // Show confirmation dialog
                              Get.dialog(
                                AlertDialog(
                                  backgroundColor: const Color(0xFF1A1A1A),
                                  title: const Text(
                                    "Logout",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: const Text(
                                    "Are you sure you want to logout?",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Get.back(); // Close dialog
                                        await _supabaseService.signOut();
                                        // Navigate to login screen and clear navigation stack
                                        Get.offAll(() => const LoginScreen());
                                        Get.snackbar(
                                          "Success",
                                          "You have been logged out",
                                          backgroundColor: Colors.green
                                              .withOpacity(0.8),
                                          colorText: Colors.white,
                                        );
                                      },
                                      child: const Text(
                                        "Logout",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 15,
                                  sigmaY: 15,
                                ),
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.red.withValues(alpha: 0.3),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.logout,
                                      size: 16,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.7), // green
                        Color(0xFFD01005).withValues(alpha: 0.08), // red
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 16,
                      bottom: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  MyText(
                                    text: "Meet Your",
                                    size: 13,
                                    weight: FontWeight.w600,
                                  ),
                                  MyText(
                                    text: " Perfect AI",
                                    size: 13,
                                    weight: FontWeight.w600,
                                    color: AppColors.secondary,
                                  ),
                                ],
                              ),
                              MyText(
                                text: "Companion",
                                size: 13,
                                weight: FontWeight.w600,
                              ),
                              const SizedBox(height: 10),

                              MyText(
                                text:
                                    "Choose from fully unlocked, personality-rich models tailored for you",
                                size: 10,
                                weight: FontWeight.w600,
                              ),
                              const SizedBox(height: 10),

                              InkWell(
                                onTap: _guestService.isGuestMode
                                    ? () {
                                        // Show registration prompt for guests
                                        Get.snackbar(
                                          "Registration Required",
                                          "Please register to create your own AI girlfriend",
                                          backgroundColor: Colors.orange
                                              .withOpacity(0.8),
                                          colorText: Colors.white,
                                        );
                                        Get.to(() => CreateAccountScreen());
                                      }
                                    : () {
                                        Get.to(() => CreateAiGfScreen());
                                      },
                                child: Container(
                                  height: 30,
                                  width: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: _guestService.isGuestMode
                                        ? Colors.grey.shade700
                                        : AppColors.secondary,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        _guestService.isGuestMode
                                            ? Icon(
                                                Icons.lock,
                                                size: 16,
                                                color: Colors.white60,
                                              )
                                            : CommonImageView(
                                                imagePath: Assets.aiIcon,
                                                height: 20,
                                              ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: MyText(
                                            text: _guestService.isGuestMode
                                                ? "Register to Create"
                                                : "Create AI Girlfriend",
                                            size: 9,
                                            weight: FontWeight.w600,
                                            color: _guestService.isGuestMode
                                                ? Colors.white60
                                                : AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: CommonImageView(
                            imagePath: Assets.aiGroup,
                            height: 90,
                            width: double.maxFinite,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Divider(
                  color: Colors.white.withValues(alpha: 0.1),
                  thickness: 1,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 40, // enough for dynamic text container
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemBuilder: (context, index) {
                      return DynamicContainer(text: tags[index]);
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemCount: tags.length,
                  ),
                ),
                const SizedBox(height: 20),

                SingleCard(
                  image: characterList[0].imagePath,
                  name: characterList[0].name,
                  age: characterList[0].age,
                  onTap: () {
                    Get.to(() => DetailScreen(character: characterList[0]));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 20.0,
                  ),
                  child: MyButton(
                    onTap: () {
                      Get.to(() => DetailScreen(character: characterList[0]));
                    },
                    buttonText: "Chat Now",
                    radius: 16,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(text: "Categories", size: 20),
                        MyText(text: "Choose Your Vibe", size: 14),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 100.0),
                        child: MyBorderButton(
                          buttonText: "see More",
                          onTap: () {
                            Get.to(() => MoreCategoriesScreen());
                          },
                          radius: 8,
                          bgColor: Colors.transparent,
                          height: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CategoryCard(
                  title: "Flirty",
                  description: "Playful, bold & romantic.",
                  emoji: "💋",
                  onTap: () {
                    Get.to(
                      () => const FilteredCharactersScreen(
                        categoryName: "Flirty",
                        categoryDescription: "Playful, bold & romantic.",
                        categoryEmoji: "💋",
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                CategoryCard(
                  title: "Shy",
                  description: "Soft, sweet & gentle energy.",
                  emoji: "🤭",
                  onTap: () {
                    Get.to(
                      () => const FilteredCharactersScreen(
                        categoryName: "Shy",
                        categoryDescription: "Soft, sweet & gentle energy.",
                        categoryEmoji: "🤭",
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                isLoadingCharacters
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.secondary,
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: 0.9,
                            ),
                        itemCount: displayCharacterList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final Character character =
                              displayCharacterList[index];
                          return HomeCard(
                            image: character.imagePath,
                            title: character.name,
                            age: character.age,
                            ontap: () {
                              Get.to(() => DetailScreen(character: character));
                            },
                          );
                        },
                      ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: MyBorderButton(
                    buttonText: "See More",
                    onTap: () {},
                    bgColor: Colors.transparent,
                    borderColor: AppColors.secondary,
                    radius: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
