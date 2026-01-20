import 'dart:ui';

import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/services/supabase_service.dart';
import 'package:kraveai/views/screens/auth_screens/login_screen.dart';
import 'package:kraveai/views/screens/legal/privacy_policy_screen.dart';
import 'package:kraveai/views/screens/legal/terms_of_service_screen.dart';
import 'package:kraveai/views/screens/profile/profile_screen.dart';
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
  final SupabaseService _supabaseService = SupabaseService();
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() {
    final user = _supabaseService.currentUser;
    setState(() {
      userEmail = user?.email;
    });
  }

  Future<void> _logout() async {
    try {
      await _supabaseService.signOut();
      Get.offAll(() => const LoginScreen());
      Get.snackbar(
        "Logged Out",
        "You have been logged out successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to logout: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

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

                // Account Section
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
                                subTitle: userEmail ?? "View your profile",
                                ontap: () {
                                  // Navigate to profile tab
                                  Get.to(() => const ProfileScreen());
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // About Section
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
                              MyText(text: "About", size: 15),
                              const SizedBox(height: 20),
                              settingTile(
                                title: "App Version",
                                subTitle: "1.0.0",
                                ontap: () {},
                                showArrow: false,
                              ),
                              const SizedBox(height: 10),
                              settingTile(
                                title: "Privacy Policy",
                                subTitle: "View our privacy policy",
                                ontap: () {
                                  Get.to(() => const PrivacyPolicyScreen());
                                },
                              ),
                              const SizedBox(height: 10),
                              settingTile(
                                title: "Terms of Service",
                                subTitle: "View terms and conditions",
                                ontap: () {
                                  Get.to(() => const TermsOfServiceScreen());
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Logout Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MyButton(
                    onTap: _logout,
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
    bool showArrow = true,
  }) {
    return GestureDetector(
      onTap: ontap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(text: title),
                if (subTitle != null) ...[
                  const SizedBox(height: 5),
                  MyText(
                    text: subTitle,
                    size: 10,
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                ],
              ],
            ),
          ),
          if (showArrow)
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.primary.withValues(alpha: 0.5),
              size: 14,
            ),
        ],
      ),
    );
  }
}
