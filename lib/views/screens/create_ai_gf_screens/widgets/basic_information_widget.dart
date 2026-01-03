import 'dart:ui';
import 'package:kraveai/controllers/create_ai_gf_controller.dart';
import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/views/widgets/my_text.dart';
import 'package:kraveai/views/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BasicInformationWidget extends StatelessWidget {
  BasicInformationWidget({super.key});

  final CreateAiGfController controller = Get.find<CreateAiGfController>();
  final List<String> genders = ["Female", "Male", "Non-binary"];

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
                  MyText(text: "Basic Information", size: 18),
                  const SizedBox(height: 14),
                  MyTextField(
                    controller: controller.nameController,
                    label: "Model Name",
                    hint: "Enter a name",
                  ),
                  const SizedBox(height: 8),
                  MyText(
                    text: "Gender",
                    size: 12,
                    paddingBottom: 8,
                    color: AppColors.primary,
                    weight: FontWeight.w400,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(genders.length, (index) {
                      return Expanded(
                        // Placeholder for future gender logic if needed
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: index == 0
                                      ? Colors.white.withValues(alpha: 0.18)
                                      : Colors.white.withValues(
                                          alpha: 0.05,
                                        ), // Force Female for now or bind later
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: index == 0
                                        ? AppColors.secondary
                                        : Colors.white.withValues(alpha: 0.25),
                                    width: 1.4,
                                  ),
                                ),
                                child: MyText(
                                  text: genders[index],
                                  size: 14,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(text: "Choose Appearance Age", size: 14),
                      Obx(
                        () => MyText(
                          text: controller.age.value.toInt().toString(),
                          size: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Slider
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.secondary,
                      inactiveTrackColor: AppColors.primary,
                      trackHeight: 6,
                      thumbColor: AppColors.secondary,
                      overlayColor: AppColors.secondary.withValues(alpha: 0.2),
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 0,
                      ),
                    ),
                    child: Obx(
                      () => Slider(
                        min: 18,
                        max: 60,
                        value: controller.age.value,
                        onChanged: (val) {
                          controller.age.value = val;
                        },
                      ),
                    ),
                  ),

                  // Min & Max labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "18",
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                      Text(
                        "60",
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ],
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
