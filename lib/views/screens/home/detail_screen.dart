import 'dart:ui';

import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/views/screens/chat_screens/chat_screen.dart';
import 'package:kraveai/views/widgets/dynamic_container.dart';
import 'package:kraveai/services/supabase_service.dart';
import 'package:kraveai/views/widgets/my_button.dart';
import 'package:kraveai/views/widgets/my_text.dart';
import 'package:kraveai/views/widgets/single_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kraveai/models/character_model.dart';

class DetailScreen extends StatefulWidget {
  final Character character;
  const DetailScreen({super.key, required this.character});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    final List<String> tags = widget.character.vibe.split(
      ',',
    ); // Assuming vibe can be multiple or just use one for now. Or just dynamic tags.
    // Let's just use the vibe as the first tag and some generic ones if needed, or update Model to have tags.
    // For now, I'll keep the hardcoded tags but add the character's vibe to the front.
    final List<String> displayTags = [
      "#${widget.character.vibe}",
      "#Romantic",
      "#Supportive",
      "#Funny",
      "#Intelligent",
      "#Adventurous",
      "#Caring",
      "#Mysterious",
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16,
                  bottom: 10,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back, color: AppColors.onPrimary),
                    ),
                    const SizedBox(width: 16),
                    MyText(text: "Back", size: 16),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleCard(
                        image: widget.character.imagePath,
                        name: widget.character.name,
                        age: widget.character.age,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 40, // enough for dynamic text container
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemBuilder: (context, index) {
                            return DynamicContainer(text: displayTags[index]);
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          itemCount: displayTags.length,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          right: 12.0,
                          bottom: 8,
                        ),
                        child: MyText(
                          text: "Bio",
                          size: 18,
                          weight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          right: 12.0,
                          bottom: 16,
                        ),
                        child: MyText(
                          text: widget.character.description,
                          size: 12,
                          color: Colors.white70,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  color: AppColors.secondary.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                MyText(
                                  text: '120k Chats',
                                  size: 12,
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Row(
                              children: [
                                Icon(
                                  Icons.star_border,
                                  color: AppColors.secondary.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                MyText(
                                  text: '4.8 Rating', // Valid dummy data
                                  size: 12,
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(
                                  alpha: 0.2,
                                ), // glassy background
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MyText(
                                      text:
                                          "All interactions are private and AI-generated for entertainment.",
                                      size: 14,
                                      weight: FontWeight.w500,
                                      color: Colors.white70,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          bottom: 8,
                        ),
                        child: MyButton(
                          onTap: () async {
                            try {
                              final String charId = await SupabaseService()
                                  .getOrCreateCharacter(widget.character);
                              Get.to(
                                () => ChatScreen(
                                  characterId: charId,
                                  name: widget.character.name,
                                  image: widget.character.imagePath,
                                  character: widget
                                      .character, // Pass full character object
                                ),
                              );
                            } catch (e) {
                              Get.snackbar(
                                "Error",
                                "Failed to start chat: $e",
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          },
                          buttonText: "Chat Now",
                          radius: 12,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          bottom: 8,
                        ),
                        child: MyButton(
                          onTap: () {
                            Get.back(); // Or navigate to grid
                          },
                          buttonText: "View More Models",
                          radius: 12,
                          backgroundColor: Colors.white60.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
