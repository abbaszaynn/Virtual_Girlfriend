import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/views/screens/auth_screens/login_screen.dart';
import 'package:kraveai/views/widgets/my_button.dart';
import 'package:kraveai/views/widgets/my_text.dart';

class RegistrationPromptBubble extends StatelessWidget {
  final String blurredImageUrl;
  final String time;

  const RegistrationPromptBubble({
    super.key,
    required this.blurredImageUrl,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Message Bubble
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar placeholder
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),

              // Message Container
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Blurred Image with Lock Overlay
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 300,
                        maxHeight: 400,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Stack(
                          children: [
                            // Blurred Image
                            ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaX: 25.0,
                                sigmaY: 25.0,
                              ),
                              child: Image.asset(
                                blurredImageUrl,
                                fit: BoxFit.cover,
                                width: 300,
                                height: 400,
                              ),
                            ),

                            // Dark Overlay
                            Container(
                              width: 300,
                              height: 400,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                              ),
                            ),

                            // Lock Icon and Text Overlay
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Lock Icon with Glow
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary.withValues(
                                        alpha: 0.2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.5,
                                          ),
                                          blurRadius: 30,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.lock_rounded,
                                      size: 60,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // "18+" Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withValues(alpha: 0.9),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: MyText(
                                      text: "18+",
                                      size: 20,
                                      weight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // System Message
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              MyText(
                                text: "Guest Limit Reached",
                                size: 14,
                                weight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          MyText(
                            text:
                                "Unlock this photo and continue the conversation",
                            size: 13,
                            color: Colors.white70,
                          ),
                          const SizedBox(height: 16),

                          // Register Button
                          MyButton(
                            onTap: () {
                              // Show premium features dialog
                              _showPremiumDialog(context);
                            },
                            buttonText: "REGISTER NOW",
                            backgroundColor: AppColors.primary,
                            fontColor: Colors.white,
                            radius: 12,
                            height: 45,
                          ),
                          const SizedBox(height: 12),

                          // Premium Features List
                          _buildFeatureRow(Icons.image, "Unlimited photos"),
                          const SizedBox(height: 8),
                          _buildFeatureRow(
                            Icons.chat_bubble,
                            "Unlimited messages",
                          ),
                          const SizedBox(height: 8),
                          _buildFeatureRow(Icons.mic, "Voice messages"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Timestamp
                    MyText(text: time, size: 11, color: Colors.white54),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.secondary),
        const SizedBox(width: 8),
        MyText(text: text, size: 12, color: Colors.white70),
      ],
    );
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Premium Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  size: 50,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),

              MyText(
                text: "Unlock Premium Features",
                size: 20,
                weight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              MyText(
                text: "Create a free account to enjoy:",
                size: 14,
                color: Colors.white70,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Features
              _buildDialogFeature(Icons.image, "Unlimited 18+ photos"),
              _buildDialogFeature(Icons.chat, "Unlimited conversations"),
              _buildDialogFeature(Icons.mic, "Voice messages"),
              _buildDialogFeature(Icons.video_library, "Video content"),
              _buildDialogFeature(Icons.star, "Premium AI models"),

              const SizedBox(height: 24),

              // Register Button
              MyButton(
                onTap: () {
                  Get.back(); // Close dialog
                  Get.offAll(() => const LoginScreen());
                },
                buttonText: "Create Free Account",
                backgroundColor: AppColors.primary,
                fontColor: Colors.white,
                radius: 12,
              ),
              const SizedBox(height: 12),

              // Already have account
              GestureDetector(
                onTap: () {
                  Get.back();
                  Get.offAll(() => const LoginScreen());
                },
                child: MyText(
                  text: "Already have an account? Sign In",
                  size: 12,
                  color: AppColors.secondary,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogFeature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 20, color: Colors.green),
          const SizedBox(width: 12),
          Icon(icon, size: 18, color: AppColors.secondary),
          const SizedBox(width: 8),
          Expanded(
            child: MyText(text: text, size: 13, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
