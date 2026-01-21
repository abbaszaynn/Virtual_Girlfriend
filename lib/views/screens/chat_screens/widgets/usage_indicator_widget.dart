import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kraveai/controllers/chat_controller.dart';

class UsageIndicatorWidget extends StatelessWidget {
  const UsageIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return Obx(() {
      // Don't show for guest users
      if (controller.isGuestUser.value) {
        return const SizedBox.shrink();
      }

      // Show unlimited badge for premium users
      if (controller.isPremium.value) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.workspace_premium, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Text(
                "PREMIUM",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }

      // Show usage stats for free users
      final messages = controller.dailyMessageCount.value;
      final images = controller.dailyImageCount.value;
      final voice = controller.dailyVoiceCount.value;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildUsagePill(
              icon: Icons.message,
              current: messages,
              limit: controller.messageLimit.value,
              color: _getUsageColor(messages, controller.messageLimit.value),
            ),
            const SizedBox(width: 8),
            _buildUsagePill(
              icon: Icons.image,
              current: images,
              limit: 2,
              color: _getUsageColor(images, 2),
            ),
            const SizedBox(width: 8),
            _buildUsagePill(
              icon: Icons.volume_up,
              current: voice,
              limit: 2,
              color: _getUsageColor(voice, 2),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildUsagePill({
    required IconData icon,
    required int current,
    required int limit,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Text(
          "$current/$limit",
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getUsageColor(int current, int limit) {
    final percentage = current / limit;
    if (percentage >= 1.0) {
      return Colors.red; // At limit
    } else if (percentage >= 0.8) {
      return Colors.orange; // Warning
    } else {
      return Colors.greenAccent; // Good
    }
  }
}
