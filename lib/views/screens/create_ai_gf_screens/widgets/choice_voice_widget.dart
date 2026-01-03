import 'dart:ui';
import 'package:kraveai/controllers/create_ai_gf_controller.dart';
import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChoiceVoiceWidget extends StatelessWidget {
  ChoiceVoiceWidget({super.key});

  final CreateAiGfController controller = Get.find<CreateAiGfController>();
  final List<Map<String, dynamic>> voiceList = [
    {
      "icon": Icons.mic,
      "title": "Gentle",
      "subtitle": "Confident",
      "id": "gentle_voice_id",
    },
    {
      "icon": Icons.mic,
      "title": "Soft",
      "subtitle": "Gentle",
      "id": "soft_voice_id",
    },
    {
      "icon": Icons.mic,
      "title": "Bold",
      "subtitle": "Smooth",
      "id": "bold_voice_id",
    },
    {
      "icon": Icons.mic,
      "title": "Calm",
      "subtitle": "Soft",
      "id": "calm_voice_id",
    },
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
                  MyText(text: "Choose Voice", size: 18),
                  const SizedBox(height: 14),
                  Obx(
                    () => Column(
                      children: List.generate(voiceList.length, (index) {
                        final item = voiceList[index];
                        // Just checking index equality for simplicity, or could check ID
                        bool isSelected =
                            controller.selectedVoiceId.value == item["id"];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _selectedCard(
                            isSelected: isSelected,
                            icon: item["icon"],
                            title: item["title"],
                            subtitle: item["subtitle"],
                            onTap: () =>
                                controller.selectedVoiceId.value = item["id"],
                          ),
                        );
                      }),
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

  Widget _selectedCard({
    required bool isSelected,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.secondary
                : Colors.white.withValues(alpha: 0.8),
            width: 0.8,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white.withValues(alpha: 0.03),
              child: Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? AppColors.secondary : Colors.white,
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(text: title, size: 16),
                      const SizedBox(height: 4),
                      MyText(text: subtitle, size: 12),
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
