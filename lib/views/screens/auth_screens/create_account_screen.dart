import 'dart:ui';

import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/generated/assets.dart';
import 'package:kraveai/services/supabase_service.dart';
import 'package:kraveai/views/widgets/common_image_view.dart';
// import 'package:kraveai/views/widgets/my_button.dart'; // Removing custom button for debug
import 'package:kraveai/views/widgets/my_text.dart';
import 'package:kraveai/views/widgets/my_text_field.dart';
import 'package:kraveai/views/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  String? selectedRole; // Changed from roleController to dropdown selection
  bool isAgeVerified = false; // Checkbox for age verification
  bool isTermsAccepted = false; // Checkbox for terms acceptance

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final List<String> availableRoles = [
    'Friend',
    'Romantic Partner',
    'Therapist',
    'Mentor',
    'Creative Partner',
  ];

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnack(String message, {bool isError = false}) {
    debugPrint("DEBUG SNACK: $message"); // Console log
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _createAccount() async {
    debugPrint("DEBUG: _createAccount called");
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    debugPrint(
      "DEBUG: Inputs - Name: $name, Email: $email, Role: $selectedRole",
    );

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showSnack("Please fill in all fields", isError: true);
      return;
    }

    if (selectedRole == null || selectedRole!.isEmpty) {
      _showSnack("Please select a preferred role", isError: true);
      return;
    }

    if (!isAgeVerified) {
      _showSnack(
        "You must be 18 years or older to create an account",
        isError: true,
      );
      return;
    }

    if (!isTermsAccepted) {
      _showSnack(
        "You must agree to the Terms of Service and Privacy Policy",
        isError: true,
      );
      return;
    }

    if (password != confirmPassword) {
      _showSnack("Passwords do not match", isError: true);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      debugPrint("DEBUG: Attempting Supabase SignUp...");

      // Accessing client directly here to ensuring service is checked
      final client = SupabaseService().client;

      final AuthResponse res = await client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name, 'role': selectedRole},
      );

      debugPrint("DEBUG: SignUp Response User: ${res.user}");

      if (res.user != null) {
        _showSnack("Account created successfully!");

        // Slight delay to let snackbar be seen? No, immediate is fine usually.
        debugPrint("DEBUG: Navigating to CustomBottomNav");
        Get.offAll(() => const CustomBottomNav());
      } else {
        _showSnack("Account creation failed (User is null)", isError: true);
      }
    } on AuthException catch (e) {
      debugPrint("DEBUG: AuthException: ${e.message}");
      _showSnack(e.message, isError: true);
    } catch (e) {
      debugPrint("DEBUG: Exception: $e");
      _showSnack("An unexpected error occurred: $e", isError: true);
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
                                text: "Create Account",
                                size: 22,
                                weight: FontWeight.w600,
                              ),
                              MyText(
                                text: "Start your personalized AI experience",
                                size: 13,
                              ),
                              const SizedBox(height: 20),
                              MyTextField(
                                controller: nameController,
                                label: "Name",
                                prefix: Icon(Icons.person_outline),
                                hint: "Your name",
                                radius: 12,
                              ),
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
                              MyTextField(
                                controller: confirmPasswordController,
                                label: "Confirm Password",
                                prefix: Icon(Icons.lock_outline),
                                hint: "Re-enter your password",
                                radius: 12,
                                showVisibilityToggle: true,
                                isObSecure: true,
                              ),
                              // Preferred Role Dropdown
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(text: "Preferred Role", size: 14),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: DropdownButton<String>(
                                      value: selectedRole,
                                      hint: MyText(
                                        text:
                                            "Choose how you like AI to support you",
                                        size: 12,
                                      ),
                                      isExpanded: true,
                                      underline: SizedBox(),
                                      dropdownColor: AppColors.background,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      items: availableRoles.map((role) {
                                        return DropdownMenuItem(
                                          value: role,
                                          child: MyText(text: role, size: 14),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedRole = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
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
                                    : SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: _createAccount,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors
                                                .secondary, // Using same color as MyButton
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const Text(
                                            "Create an account",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
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
                        padding: const EdgeInsets.all(16),
                        color: Colors.white.withValues(alpha: 0.1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _checkboxTile(
                              title: "I am 18 years or older",
                              value: isAgeVerified,
                              subtitle:
                                  "Age verification is required to unlock mature features and ensure a safe experience.",
                              onChanged: (val) {
                                setState(() {
                                  isAgeVerified = val ?? false;
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            _checkboxTile(
                              title:
                                  "I agree to the Terms of Service and Privacy Policy",
                              value: isTermsAccepted,
                              subtitle:
                                  "Your comfort and privacy always come first.",
                              onChanged: (val) {
                                setState(() {
                                  isTermsAccepted = val ?? false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _checkboxTile({
    required String title,
    required bool value,
    required String subtitle,
    required Function(bool?) onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          activeColor: AppColors.secondary,
          checkColor: Colors.white,
          onChanged: onChanged,
        ),

        /// 🔥 Fix overflow by wrapping content with Expanded
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                softWrap: true,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
