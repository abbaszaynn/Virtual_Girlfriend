import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/views/widgets/my_text.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: MyText(text: "Terms of Service", size: 20),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: "Terms of Service for CraveAI",
                size: 22,
                weight: FontWeight.w600,
              ),
              const SizedBox(height: 10),
              MyText(
                text: "Effective Date: January 2026",
                size: 12,
                color: AppColors.primary.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 30),

              _buildSection(
                "1. Acceptance of Terms",
                "By accessing and using CraveAI ('the Service'), you accept and agree to be bound by these Terms of Service. "
                    "If you do not agree to these terms, please discontinue use of the Service immediately.",
              ),

              _buildSection(
                "2. Service Description",
                "CraveAI provides AI-powered chat companions with customization features including:\n\n"
                    "• Conversational AI interactions\n"
                    "• Custom character creation\n"
                    "• Voice message generation\n"
                    "• Image generation capabilities\n"
                    "• Personalized experience based on user preferences",
              ),

              _buildSection(
                "3. User Eligibility",
                "You must be at least 18 years old to use CraveAI. By using the Service, you represent and warrant that:\n\n"
                    "• You are 18 years of age or older\n"
                    "• You have the legal capacity to enter into these Terms\n"
                    "• You will comply with all applicable laws and regulations",
              ),

              _buildSection(
                "4. Account Responsibilities",
                "You are responsible for:\n\n"
                    "• Maintaining the confidentiality of your account\n"
                    "• All activities that occur under your account\n"
                    "• Ensuring your account information is accurate\n"
                    "• Notifying us immediately of unauthorized access\n"
                    "• Not sharing your account credentials",
              ),

              _buildSection(
                "5. Acceptable Use",
                "When using CraveAI, you agree NOT to:\n\n"
                    "• Use the Service for illegal purposes\n"
                    "• Attempt to hack or compromise the system\n"
                    "• Upload malicious content or viruses\n"
                    "• Harass, abuse, or harm others\n"
                    "• Violate intellectual property rights\n"
                    "• Scrape or automatically extract data\n"
                    "• Reverse engineer the Service",
              ),

              _buildSection(
                "6. Content and Intellectual Property",
                "• The Service and its content are owned by CraveAI\n"
                    "• You retain ownership of custom characters you create\n"
                    "• You grant us license to use your content to provide the Service\n"
                    "• AI-generated content may not be unique to you\n"
                    "• You may not use our trademarks without permission",
              ),

              _buildSection(
                "7. Subscription and Payments",
                "• Some features may require paid subscription\n"
                    "• Subscription fees are billed in advance\n"
                    "• Cancellation must be done before renewal date\n"
                    "• Refunds are provided per our Refund Policy\n"
                    "• Prices may change with 30 days notice",
              ),

              _buildSection(
                "8. Service Availability",
                "We strive to provide reliable service, but:\n\n"
                    "• We do not guarantee uninterrupted access\n"
                    "• Maintenance may temporarily limit availability\n"
                    "• We may modify or discontinue features\n"
                    "• We are not liable for service interruptions",
              ),

              _buildSection(
                "9. Limitation of Liability",
                "TO THE MAXIMUM EXTENT PERMITTED BY LAW:\n\n"
                    "• The Service is provided 'AS IS'\n"
                    "• We are not liable for indirect damages\n"
                    "• Our liability is limited to fees paid in the last 12 months\n"
                    "• We are not responsible for third-party content\n"
                    "• AI responses are not professional advice",
              ),

              _buildSection(
                "10. Termination",
                "We may terminate or suspend your access if you:\n\n"
                    "• Violate these Terms\n"
                    "• Engage in fraudulent activity\n"
                    "• Pose security risks\n"
                    "• Request account deletion\n\n"
                    "Upon termination, your data will be deleted per our Privacy Policy.",
              ),

              _buildSection(
                "11. Dispute Resolution",
                "• Any disputes shall be resolved through binding arbitration\n"
                    "• Arbitration will be conducted online or in your jurisdiction\n"
                    "• You waive the right to join class-action lawsuits\n"
                    "• Informal resolution should be attempted first",
              ),

              _buildSection(
                "12. Changes to Terms",
                "We may update these Terms from time to time. Continued use of the Service after changes constitutes acceptance. "
                    "We will notify you of material changes via email or in-app notification.",
              ),

              _buildSection(
                "13. Contact Information",
                "For questions about these Terms, contact us at:\n\n"
                    "Email: legal@craveai.com\n"
                    "Support: Through the app's Help Center",
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: title,
            size: 16,
            weight: FontWeight.w600,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 12),
          MyText(
            text: content,
            size: 14,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ],
      ),
    );
  }
}
