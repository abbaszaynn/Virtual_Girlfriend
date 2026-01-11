import 'dart:ui';
import 'package:kraveai/controllers/create_ai_gf_controller.dart';
import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/generated/assets.dart';
import 'package:kraveai/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppearancePreferenceWidget extends StatelessWidget {
  AppearancePreferenceWidget({super.key});

  final CreateAiGfController controller = Get.find<CreateAiGfController>();

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
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(text: "Appearance Preference", size: 18),
                  const SizedBox(height: 8),
                  MyText(
                    text: "Choose your desired model appearance",
                    size: 12,
                    color: AppColors.primary,
                    weight: FontWeight.w400,
                  ),
                  const SizedBox(height: 16),

                  // Grid of preference images
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.7,
                        ),
                    itemCount: Assets.preferenceImages.length,
                    itemBuilder: (context, index) {
                      final imagePath = Assets.preferenceImages[index];
                      return Obx(() {
                        final isSelected =
                            controller.selectedPreferenceImage.value ==
                            imagePath;
                        return GestureDetector(
                          onTap: () {
                            controller.selectedPreferenceImage.value =
                                imagePath;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.secondary
                                    : Colors.white.withValues(alpha: 0.25),
                                width: isSelected ? 3 : 1.4,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(imagePath, fit: BoxFit.cover),
                                  if (isSelected)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.check_circle,
                                          color: AppColors.secondary,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                    },
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
