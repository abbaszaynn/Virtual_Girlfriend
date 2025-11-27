import 'dart:ui';

import 'package:craveai/generated/app_colors.dart';
import 'package:craveai/generated/assets.dart';
import 'package:craveai/views/screens/auth_screens/dialog_screen.dart';
import 'package:craveai/views/widgets/common_image_view.dart';
import 'package:craveai/views/widgets/my_button.dart';
import 'package:craveai/views/widgets/my_text.dart';
import 'package:craveai/views/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassordScreen extends StatelessWidget {
  const ForgetPassordScreen({super.key});

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
              const SizedBox(height: 20),
              Center(
                child: CommonImageView(
                  imagePath: Assets.logo,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.2,
                  ),
                ),
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
                            MyText(
                              text: "Forgot password",
                              size: 22,
                              weight: FontWeight.w600,
                            ),
                            const SizedBox(height: 8),
                            MyText(
                              text:
                                  "Please enter your email to reset the password",
                              size: 12,
                              color: Color(0xff989898),
                            ),
                            const SizedBox(height: 20),
                            MyTextField(
                              label: "Your Email",
                              prefix: Icon(Icons.email_outlined),
                              hint: "Enter your email",
                              radius: 12,
                            ),

                            const SizedBox(height: 60),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                              ),
                              child: MyButton(
                                onTap: () {
                                  Get.to(() => const DialogScreen());
                                },
                                buttonText: "Reset Password",
                                radius: 12,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
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
