import 'dart:ui';

import 'package:craveai/generated/app_colors.dart';
import 'package:craveai/views/widgets/my_button.dart';
import 'package:craveai/views/widgets/my_text.dart';
import 'package:craveai/views/widgets/my_text_field.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: MyText(
                    text: "My Profile",
                    size: 24,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.person_2_outlined,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: MyTextField(
                        hint: "Your Name",
                        radius: 12,
                        label: "Display Name",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: MyTextField(
                        hint: "your@email.com",
                        radius: 12,
                        label: "Email",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: MyText(
                          text: "Email Can,t be changed",
                          size: 10,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 20,
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.transparent,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        width: 0.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 24,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(text: "Preferred Role"),
                              const SizedBox(height: 10),
                              MyText(
                                text: "How do you want Maya to support?",
                                size: 10,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 6),
                              MyText(
                                text: "Edit Role",
                                size: 12,
                                color: AppColors.secondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10,
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.transparent,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        width: 0.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(text: "Stats"),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  MyText(text: "120"),
                                  MyText(
                                    text: "Chats",
                                    size: 10,
                                    color: AppColors.primary.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  MyText(text: "8"),
                                  MyText(
                                    text: "Unlocked Photos",
                                    size: 10,
                                    color: AppColors.primary.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  MyText(text: "3"),
                                  MyText(
                                    text: "Current Level",
                                    size: 10,
                                    color: AppColors.primary.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 34),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: MyButton(
                    onTap: () {},
                    buttonText: "Save Canges",
                    radius: 12,
                  ),
                ),
                const SizedBox(height: 34),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
