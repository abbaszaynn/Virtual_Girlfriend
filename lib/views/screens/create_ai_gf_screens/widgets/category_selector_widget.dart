import 'dart:ui';
import 'package:kraveai/controllers/create_ai_gf_controller.dart';
import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategorySelectorWidget extends StatelessWidget {
  CategorySelectorWidget({super.key});

  final CreateAiGfController controller = Get.find<CreateAiGfController>();

  // Available categories that match the filter categories
  final List<Map<String, String>> availableCategories = const [
    {"emoji": "💋", "name": "Flirty"},
    {"emoji": "🔥", "name": "Passionate"},
    {"emoji": "😊", "name": "Friendly"},
    {"emoji": "🤭", "name": "Shy"},
    {"emoji": "😈", "name": "Bold"},
    {"emoji": "🎭", "name": "Dramatic"},
    {"emoji": "💘", "name": "Romantic"},
    {"emoji": "😂", "name": "Funny"},
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
                  MyText(text: "Categories", size: 18),
                  const SizedBox(height: 8),
                  MyText(
                    text:
                        "Select categories where this character will appear (Select Multiple)",
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
                      children: availableCategories.map((category) {
                        bool isSelected = controller.selectedCategories
                            .contains(category["name"]);

                        return GestureDetector(
                          onTap: () {
                            if (isSelected) {
                              controller.selectedCategories.remove(
                                category["name"],
                              );
                            } else {
                              controller.selectedCategories.add(
                                category["name"]!,
                              );
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
                                      ? AppColors.secondary
                                      : Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      category["emoji"]!,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      category["name"]!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.w400,
                                        color: isSelected
                                            ? AppColors.primary
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
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
