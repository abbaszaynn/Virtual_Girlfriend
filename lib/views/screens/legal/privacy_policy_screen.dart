import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/views/widgets/my_text.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
        title: MyText(text: "Privacy Policy", size: 20),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: "Privacy Policy for CraveAI",
                size: 22,
                weight: FontWeight.w600,
              ),
              const SizedBox(height: 10),
              MyText(
                text: "Last Updated: January 2026",
                size: 12,
                color: AppColors.primary.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 30),

              _buildSection(
                "1. Information We Collect",
                "We collect information you provide directly to us when you create an account, customize AI characters, send messages, and use our services. This includes:\n\n"
                    "• Email address and display name\n"
                    "• Chat messages and conversations\n"
                    "• Custom AI character configurations\n"
                    "• Usage statistics and preferences\n"
                    "• Google account information (when using Google Sign-In)",
              ),

              _buildSection(
                "2. How We Use Your Information",
                "We use the collected information to:\n\n"
                    "• Provide and maintain our AI chat services\n"
                    "• Generate personalized AI responses\n"
                    "• Improve and optimize user experience\n"
                    "• Send important updates about our service\n"
                    "• Analyze usage patterns to enhance features",
              ),

              _buildSection(
                "3. Data Storage & Security",
                "Your data is stored securely using Supabase infrastructure with industry-standard encryption. We implement:\n\n"
                    "• Encrypted data transmission (HTTPS)\n"
                    "• Secure authentication protocols\n"
                    "• Row-level security policies\n"
                    "• Regular security audits\n"
                    "• Password hashing and protection",
              ),

              _buildSection(
                "4. Third-Party Services",
                "We use the following third-party services:\n\n"
                    "• Google Sign-In for authentication\n"
                    "• Supabase for data storage\n"
                    "• OpenRouter for AI processing\n"
                    "• ElevenLabs for voice generation\n"
                    "• Replicate for image generation\n\n"
                    "These services have their own privacy policies governing their use of your information.",
              ),

              _buildSection(
                "5. Your Data Rights",
                "You have the right to:\n\n"
                    "• Access your personal data\n"
                    "• Update or correct your information\n"
                    "• Delete your account and associated data\n"
                    "• Export your conversation history\n"
                    "• Opt-out of data collection for analytics",
              ),

              _buildSection(
                "6. Data Retention",
                "We retain your data as long as your account is active. When you delete your account:\n\n"
                    "• Profile data is permanently removed\n"
                    "• Conversations are deleted from our servers\n"
                    "• Custom characters are removed\n"
                    "• Backup copies are purged within 30 days",
              ),

              _buildSection(
                "7. Children's Privacy",
                "CraveAI is intended for users aged 18 and above. We do not knowingly collect information from users under 18. If we become aware of such collection, we will promptly delete the data.",
              ),

              _buildSection(
                "8. Changes to Privacy Policy",
                "We may update this privacy policy from time to time. We will notify users of significant changes via email or in-app notifications. Continued use of the service constitutes acceptance of the updated policy.",
              ),

              _buildSection(
                "9. Contact Us",
                "If you have questions about this privacy policy or your data, contact us at:\n\n"
                    "Email: privacy@craveai.com\n"
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
