import 'dart:ui';

import 'package:craveai/controllers/app_colors.dart';
import 'package:craveai/generated/assets.dart';
import 'package:craveai/views/widgets/common_image_view.dart';
import 'package:craveai/views/widgets/my_button.dart';
import 'package:craveai/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogScreen extends StatelessWidget {
  const DialogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  child: Center(
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      /// 🔥 ICON
                      CommonImageView(imagePath: Assets.dLogo, height: 60),
                      const SizedBox(height: 20),

                      /// 🔥 TEXT
                      MyText(
                        text: "Check Your Email",
                        size: 20,
                        weight: FontWeight.w600,
                      ),
                      const SizedBox(height: 10),

                      MyText(
                        text:
                            "We have sent a password reset link to your email address.",
                        size: 14,
                        color: Colors.white70,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 60),

                      /// 🔥 BUTTON — go to login screen
                      MyButton(
                        buttonText: "Go to Login",
                        radius: 12,
                        onTap: () {
                          Get.back(); // close dialog
                          Get.back(); // go back to login screen
                        },
                      ),

                      const SizedBox(height: 10),
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
