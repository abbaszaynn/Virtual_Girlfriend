import 'dart:ui';

import 'package:craveai/generated/app_colors.dart';
import 'package:craveai/views/screens/home/unlock_screen.dart';
import 'package:craveai/views/widgets/dynamic_container.dart';
import 'package:craveai/views/widgets/my_button.dart';
import 'package:craveai/views/widgets/my_text.dart';
import 'package:craveai/views/widgets/single_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withValues(alpha: 0.3),
                    ),
                    child: Center(
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
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
                      SingleCard(),
                      const SizedBox(height: 12),
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
                          text:
                              "Maya is a sweet, playful companion who loves deep conversations, late-night flirting, and making you feel special.",
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
                                  text: '120k Chats',
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
                                color: Colors.white.withOpacity(
                                  0.2,
                                ), // glassy background
                                borderRadius: BorderRadius.circular(12),

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
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
                          onTap: () {
                            Get.to(() => UnlockScreen());
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
                          onTap: () {},
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
