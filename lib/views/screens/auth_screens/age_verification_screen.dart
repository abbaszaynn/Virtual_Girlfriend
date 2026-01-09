import 'dart:ui';
import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/generated/assets.dart';
import 'package:kraveai/services/guest_service.dart';
import 'package:kraveai/views/screens/dashboard/dashboard_screen.dart';
import 'package:kraveai/views/widgets/common_image_view.dart';
import 'package:kraveai/views/widgets/my_button.dart';
import 'package:kraveai/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AgeVerificationScreen extends StatefulWidget {
  const AgeVerificationScreen({super.key});

  @override
  State<AgeVerificationScreen> createState() => _AgeVerificationScreenState();
}

class _AgeVerificationScreenState extends State<AgeVerificationScreen> {
  bool ageConfirmed = false;
  bool consentGiven = false;
  bool isLoading = false;
  DateTime? selectedDate;

  final GuestService _guestService = GuestService();

  Future<void> _continueAsGuest() async {
    // Validation
    if (!ageConfirmed || !consentGiven) {
      Get.snackbar(
        "Verification Required",
        "Please confirm you are 18+ and consent to adult content",
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Check if user has exceeded session limit (anti-abuse)
      final hasExceeded = await _guestService.hasExceededSessionLimit();
      if (hasExceeded) {
        Get.snackbar(
          "Limit Reached",
          "Too many guest sessions from this device. Please create an account.",
          backgroundColor: Colors.orange.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Create guest session
      await _guestService.createGuestSession(
        ageVerified: ageConfirmed,
        consentGiven: consentGiven,
      );

      Get.snackbar(
        "Welcome",
        "You can send up to 5 messages to any model",
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
      );

      // Navigate to dashboard
      Get.offAll(() => const CustomBottomNav());
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to create guest session: $e",
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

  Future<void> _selectDateOfBirth() async {
    final now = DateTime.now();
    final eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: eighteenYearsAgo,
      firstDate: DateTime(1900),
      lastDate: eighteenYearsAgo,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: const Color(0xFF1A1A1A),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1A1A1A),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        // Auto-check age if user selects valid date
        final age = now.year - picked.year;
        if (age >= 18) {
          ageConfirmed = true;
        }
      });
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
                // Logo
                CommonImageView(
                  imagePath: Assets.logo,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 30),

                // Warning Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.warning_rounded,
                    size: 50,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 30),

                // Main Content Card
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
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                text: "Age Verification Required",
                                size: 22,
                                weight: FontWeight.w600,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              MyText(
                                text:
                                    "This platform contains adult content (18+). You must confirm your age to continue.",
                                size: 13,
                                color: Colors.white70,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 30),

                              // Date of Birth Selector (Optional)
                              GestureDetector(
                                onTap: _selectDateOfBirth,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        color: Colors.white70,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: MyText(
                                          text: selectedDate == null
                                              ? "Date of Birth (Optional)"
                                              : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                                          size: 14,
                                          color: selectedDate == null
                                              ? Colors.white54
                                              : Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Age Confirmation Checkbox
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    ageConfirmed = !ageConfirmed;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: ageConfirmed
                                            ? AppColors.primary
                                            : Colors.white.withValues(
                                                alpha: 0.1,
                                              ),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: ageConfirmed
                                              ? AppColors.primary
                                              : Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                          width: 2,
                                        ),
                                      ),
                                      child: ageConfirmed
                                          ? const Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: MyText(
                                        text:
                                            "I confirm I am 18 years or older",
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Content Consent Checkbox
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    consentGiven = !consentGiven;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: consentGiven
                                            ? AppColors.primary
                                            : Colors.white.withValues(
                                                alpha: 0.1,
                                              ),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: consentGiven
                                              ? AppColors.primary
                                              : Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                          width: 2,
                                        ),
                                      ),
                                      child: consentGiven
                                          ? const Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: MyText(
                                        text:
                                            "I consent to viewing adult content",
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Continue as Guest Button
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primary,
                                        ),
                                      )
                                    : MyButton(
                                        onTap: _continueAsGuest,
                                        buttonText: "Continue as Guest",
                                        radius: 12,
                                      ),
                              ),
                              const SizedBox(height: 16),

                              // Terms and Privacy
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyText(
                                    text: "By continuing, you agree to our ",
                                    size: 11,
                                    color: Colors.white60,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                spacing: 15,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // TODO: Navigate to Terms of Service
                                      Get.snackbar(
                                        "Terms of Service",
                                        "Opening terms...",
                                      );
                                    },
                                    child: MyText(
                                      text: "Terms of Service",
                                      color: AppColors.secondary,
                                      size: 11,
                                      weight: FontWeight.w600,
                                    ),
                                  ),
                                  MyText(
                                    text: "•",
                                    size: 11,
                                    color: Colors.white60,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // TODO: Navigate to Privacy Policy
                                      Get.snackbar(
                                        "Privacy Policy",
                                        "Opening privacy policy...",
                                      );
                                    },
                                    child: MyText(
                                      text: "Privacy Policy",
                                      color: AppColors.secondary,
                                      size: 11,
                                      weight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Divider
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

                // Create Account Option
                MyText(
                  text: "Already have an account?",
                  size: 13,
                  color: Colors.white70,
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    Get.back(); // Return to login screen
                  },
                  child: MyText(
                    text: "Sign In",
                    size: 15,
                    color: AppColors.secondary,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
