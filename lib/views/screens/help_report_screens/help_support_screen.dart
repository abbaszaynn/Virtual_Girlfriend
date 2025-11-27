import 'dart:ui';

import 'package:craveai/generated/app_colors.dart';
import 'package:craveai/views/screens/help_report_screens/report_screen.dart';
import 'package:craveai/views/screens/terms_condition_screens/terms_conditions_screen.dart';
import 'package:craveai/views/widgets/my_button.dart';
import 'package:craveai/views/widgets/my_text.dart';
import 'package:craveai/views/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back, color: AppColors.onPrimary),
                    ),
                    const SizedBox(width: 16),
                    MyText(text: "Back", size: 16),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: MyText(
                    text: "Help & Support",
                    size: 24,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                MyText(text: "FAQs", size: 18, textAlign: TextAlign.center),
                const SizedBox(height: 10),
                MyTextField(
                  hint: "Search FAQ...",
                  radius: 12,
                  prefix: Icon(Icons.search),
                ),
                const SizedBox(height: 14),
                faqContainer(text: "How subscription works?"),
                const SizedBox(height: 8),
                faqContainer(text: "How to restore purchase?"),
                const SizedBox(height: 8),
                faqContainer(text: "AI Models are not responding?"),
                const SizedBox(height: 8),
                faqContainer(text: "How tokens work?"),
                const SizedBox(height: 20),

                MyText(
                  text: "Contact Options",
                  size: 18,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                contactOptionsContainer(
                  icon: Icons.mail,
                  title: "Contact Support",
                  subTitle: 'Get help from our support team',
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    Get.to(() => ReportScreen());
                  },
                  child: contactOptionsContainer(
                    icon: Icons.report_problem,
                    title: "Report a Problem",
                    subTitle: 'Facing an issue? Report here',
                  ),
                ),
                const SizedBox(height: 16),
                contactOptionsContainer(
                  icon: Icons.chat_bubble,
                  title: "Chat Support",
                  subTitle: 'Live chat support (Premium users)',
                ),
                const SizedBox(height: 16),
                contactOptionsContainer(
                  icon: Icons.payment,
                  title: "Billing Support",
                  subTitle: 'Payments, refunds & subscription queries',
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(
                      text: " Terms & Conditions",
                      onTap: () {
                        Get.to(() => TermsConditionsScreen());
                      },
                    ),
                    const SizedBox(width: 20),
                    MyText(text: "Privacy Policy"),
                  ],
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
                        alignment: Alignment.center,
                        color: Colors.white.withValues(alpha: 0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: MyButton(
                                  onTap: () {},
                                  buttonText: "Help & Support",
                                  radius: 12,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColors.primary.withValues(
                                      alpha: 0.08,
                                    ),
                                  ),
                                  child: Center(
                                    child: MyText(text: "Block/Report"),
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
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget faqContainer({required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(text: text),
              Icon(Icons.arrow_drop_down_outlined, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget contactOptionsContainer({
    required String title,
    required String subTitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(text: title),
                  const SizedBox(width: 10),

                  MyText(text: subTitle, size: 12),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
