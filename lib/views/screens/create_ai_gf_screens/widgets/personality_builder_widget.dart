import 'dart:ui';
import 'package:kraveai/controllers/create_ai_gf_controller.dart';
import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/views/widgets/my_text.dart';
import 'package:kraveai/views/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalityBuilderWidget extends StatelessWidget {
  PersonalityBuilderWidget({super.key});

  final CreateAiGfController controller = Get.find<CreateAiGfController>();
  final List<String> personalityTypes = [
    "Shy",
    "Bold",
    "Romantic",
    "Funny",
    "Serious",
    "Adventurous",
    "Calm",
    "Energetic",
    "Intellectual",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            alignment: Alignment.center,
            color: Colors.white.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(text: "Personality Builder", size: 18),
                  const SizedBox(height: 14),
                  MyText(
                    text: "Personality Type (Select Multiple)",
                    size: 12,
                    paddingBottom: 8,
                    color: AppColors.primary,
                    weight: FontWeight.w400,
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: personalityTypes.map((type) {
                        bool isSelected = controller.personalityTraits.contains(
                          type,
                        );

                        return GestureDetector(
                          onTap: () {
                            if (isSelected) {
                              controller.personalityTraits.remove(type);
                            } else {
                              controller.personalityTraits.add(type);
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: isSelected ? 10 : 0,
                                sigmaY: isSelected ? 10 : 0,
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  type,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 24),
                  MyTextField(
                    maxLines: 4,
                    label: "Behavior Prompt",
                    hint: "Describe how you want your AI to behave...",
                    radius: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
