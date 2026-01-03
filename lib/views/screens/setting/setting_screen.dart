import 'dart:ui';

import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/views/screens/help_report_screens/help_support_screen.dart';
import 'package:kraveai/views/screens/help_report_screens/report_screen.dart';
import 'package:kraveai/views/widgets/my_button.dart';
import 'package:kraveai/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  List<bool> toggles = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: MyText(
                    text: "Settings",
                    size: 24,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),

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
                              MyText(text: "Account", size: 15),
                              const SizedBox(height: 20),
                              settingTile(
                                title: "Profile",
                                subTitle: "Edit name, email, age",
                                ontap: () {},
                              ),
                              const SizedBox(height: 10),

                              settingTile(
                                title: "Security & Privacy",
                                subTitle:
                                    "Password, 2-step verification, data controls",
                                ontap: () {},
                              ),
                              const SizedBox(height: 10),

                              settingTile(
                                title: "Preferred Role",
                                subTitle: "Choose how AI interacts with you",
                                ontap: () {},
                              ),
                              const SizedBox(height: 10),

                              settingTile(
                                title: "Blocked Models",
                                subTitle: "View & manage blocked AI models",
                                ontap: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

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
                              MyText(text: "Notifications", size: 15),
                              const SizedBox(height: 20),
                              _toggleItem("Message Alerts", 0),
                              const SizedBox(height: 12),
                              _toggleItem("New Model Alerts", 1),
                              const SizedBox(height: 12),
                              _toggleItem("Subscription Alerts", 2),
                              const SizedBox(height: 12),
                              _toggleItem("Sounds & Vibrations", 3),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

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
                              MyText(text: "App Preferences", size: 15),
                              const SizedBox(height: 20),
                              settingTile(
                                title: "Language",
                                subTitle: "English (Default)",
                                ontap: () {},
                              ),
                              const SizedBox(height: 10),

                              settingTile(
                                title: "Chat Settings",
                                subTitle: "Typing indicators, read receipts",
                                ontap: () {},
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

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
                              MyText(text: "Subscription", size: 15),
                              const SizedBox(height: 20),
                              settingTile(
                                title: "My Subscription",
                                subTitle: "Current Plan, Renewal Date",
                                ontap: () {},
                              ),
                              const SizedBox(height: 10),

                              settingTile(
                                title: "Purchase History",
                                subTitle: "List of payments",
                                ontap: () {},
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                              MyText(text: "Support & Help", size: 15),
                              const SizedBox(height: 20),
                              settingTile(
                                title: "Help Center",
                                subTitle: "FAQs, tutorials",
                                ontap: () {
                                  Get.to(() => HelpSupportScreen());
                                },
                              ),
                              const SizedBox(height: 10),

                              settingTile(
                                title: "Report a Problem",
                                subTitle: "Submit an issue",
                                ontap: () {
                                  Get.to(() => ReportScreen());
                                },
                              ),
                              const SizedBox(height: 10),
                              const SizedBox(height: 10),

                              settingTile(
                                title: "Contact Support",
                                subTitle: "Email / Live Chat",
                                ontap: () {},
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                              MyText(text: "Legal", size: 15),
                              const SizedBox(height: 20),
                              settingTile(
                                title: "Privacy Policy",
                                ontap: () {},
                                isTitle: false,
                              ),
                              const SizedBox(height: 10),

                              settingTile(title: "Refund Policy", ontap: () {}),

                              // const SizedBox(height: 10),
                              settingTile(
                                title: "Community Guidelines",
                                ontap: () {},
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MyButton(
                    onTap: () {},
                    buttonText: "Logout",
                    radius: 12,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget settingTile({
    required String title,
    String? subTitle,
    required VoidCallback ontap,
    bool isTitle = true,
  }) {
    return GestureDetector(
      onTap: ontap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(text: title),
              const SizedBox(height: 5),
              isTitle
                  ? MyText(
                      text: subTitle ?? "",
                      size: 10,
                      color: AppColors.primary.withValues(alpha: 0.5),
                    )
                  : SizedBox.shrink(),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.primary.withValues(alpha: 0.5),
            size: 14,
          ),
        ],
      ),
    );
  }

  Widget _toggleItem(String text, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyText(text: text, size: 14),

        // 🔴 Custom Toggle Button
        GestureDetector(
          onTap: () {
            setState(() {
              toggles[index] = !toggles[index];
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 26,
            width: 48,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: toggles[index]
                  ? AppColors.secondary.withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.2),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: toggles[index]
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
