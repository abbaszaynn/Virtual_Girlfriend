import 'dart:ui';

import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/generated/assets.dart';
import 'package:kraveai/services/supabase_service.dart';
import 'package:kraveai/views/screens/auth_screens/age_verification_screen.dart';
import 'package:kraveai/views/screens/auth_screens/create_account_screen.dart';
import 'package:kraveai/views/screens/auth_screens/forget_passord_screen.dart';
import 'package:kraveai/views/screens/dashboard/dashboard_screen.dart';
import 'package:kraveai/views/widgets/common_image_view.dart';
import 'package:kraveai/views/widgets/my_button.dart';
import 'package:kraveai/views/widgets/my_text.dart';
import 'package:kraveai/views/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final AuthResponse res = await SupabaseService().client.auth
          .signInWithPassword(email: email, password: password);

      if (res.user != null) {
        Get.snackbar(
          "Success",
          "Logged in successfully!",
          backgroundColor: Colors.green.withValues(alpha: 0.8),
          colorText: Colors.white,
        );

        // Navigate to dashboard
        Get.offAll(() => const CustomBottomNav());
      }
    } on AuthException catch (e) {
      Get.snackbar(
        "Error",
        e.message,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred: $e",
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
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
                                text: "Welcome Back",
                                size: 22,
                                weight: FontWeight.w600,
                              ),
                              MyText(
                                text: "Your companion is always here",
                                size: 13,
                              ),
                              const SizedBox(height: 20),
                              MyTextField(
                                controller: emailController,
                                label: "Email",
                                prefix: Icon(Icons.email_outlined),
                                hint: "your@email.com",
                                radius: 12,
                              ),
                              MyTextField(
                                controller: passwordController,
                                label: "Password",
                                prefix: Icon(Icons.lock_outline),
                                hint: "Enter your password",
                                radius: 12,
                                showVisibilityToggle: true,
                                isObSecure: true,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: MyText(
                                  onTap: () {
                                    Get.to(() => ForgetPassordScreen());
                                  },
                                  text: "Forgot Password?",
                                  size: 10,
                                  color: AppColors.secondary,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                ),
                                child: isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primary,
                                        ),
                                      )
                                    : MyButton(
                                        onTap: _login,
                                        buttonText: "Login",
                                        radius: 12,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: MyText(text: "or sign up with", size: 12),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Divider(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(
                            0xFFE8E6EA,
                          ).withValues(alpha: 0.4), // stroke color
                          width: 1.2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.white.withValues(alpha: 0.1),
                            child: CommonImageView(
                              imagePath: Assets.fb,
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(
                            0xFFE8E6EA,
                          ).withValues(alpha: 0.4), // stroke color
                          width: 1.2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.white.withValues(alpha: 0.1),
                            child: CommonImageView(
                              imagePath: Assets.google,
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(
                            0xFFE8E6EA,
                          ).withValues(alpha: 0.4), // stroke color
                          width: 1.2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.white.withValues(alpha: 0.1),
                            child: CommonImageView(
                              imagePath: Assets.apple,
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Create Account Button (Primary Action)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0),
                  child: MyButton(
                    onTap: () {
                      Get.to(() => const CreateAccountScreen());
                    },
                    buttonText: "Create Account",
                    radius: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: MyText(
                    text: "New here? Sign up to unlock full features",
                    size: 11,
                    color: Colors.white60,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),

                // Divider with "or"
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: MyText(text: "or", size: 12),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Divider(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Continue as Guest Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0),
                  child: MyButton(
                    onTap: () {
                      Get.to(() => const AgeVerificationScreen());
                    },
                    buttonText: "Continue as Guest",
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    fontColor: Colors.white,
                    radius: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: MyText(
                    text: "Send up to 5 messages without account",
                    size: 11,
                    color: Colors.white60,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(text: "Terms of use", color: AppColors.secondary),
                    MyText(text: "Privacy Policy", color: AppColors.secondary),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
