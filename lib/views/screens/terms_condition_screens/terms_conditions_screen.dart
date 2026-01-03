import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/views/screens/terms_condition_screens/widgets/faqs_widget.dart';
import 'package:kraveai/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsConditionsScreen extends StatelessWidget {
  TermsConditionsScreen({super.key});
  final List<Map<String, String>> faqData = [
    {
      "q": "Introduction",
      "a":
          "Welcome to Crave AI. By using this app, you agree to the following terms and conditions.",
    },
    {
      "q": "Eligibility (18+ Requirement)",
      "a":
          "Crave AI is strictly for adults. You must be 18 years or older to use the app, create a profile, or access any AI model.",
    },
    {
      "q": "Account Responsibilities",
      "a":
          "You are responsible for maintaining the confidentiality of your account and password. Any misuse is your responsibility.",
    },
    {
      "q": "AI Content Usage",
      "a":
          "All AI interactions, messages, images, and voice replies are fictional and generated for entertainment purposes only.",
    },
    {
      "q": "Subscription & Payments",
      "a":
          "Paid features are billed automatically unless you cancel. All purchases follow our Refund Policy.",
    },
    {
      "q": "Community Rules",
      "a":
          "No harassment, abuse, or harmful behavior towards AI models or users is allowed.",
    },
    {
      "q": "Data & Privacy",
      "a":
          "We collect limited user data to improve your experience. Please refer to our Privacy Policy.",
    },
    {
      "q": "Account Suspension",
      "a":
          "Crave AI may suspend or terminate accounts that violate our policies.",
    },
    {
      "q": "Updates to Terms",
      "a":
          "We may update these terms as needed. Continued usage equals acceptance.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
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
                    text: "Terms & Conditions",
                    size: 24,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                for (int i = 0; i < faqData.length; i++)
                  FAQItem(
                    number: i + 1,
                    question: faqData[i]["q"]!,
                    answer: faqData[i]["a"]!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
