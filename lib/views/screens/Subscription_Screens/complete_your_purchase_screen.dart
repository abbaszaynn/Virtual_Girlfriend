import 'dart:ui';

import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/views/screens/help_report_screens/help_support_screen.dart';
import 'package:kraveai/views/widgets/my_button.dart';
import 'package:kraveai/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompleteYourPurchaseScreen extends StatefulWidget {
  const CompleteYourPurchaseScreen({super.key});

  @override
  State<CompleteYourPurchaseScreen> createState() =>
      _CompleteYourPurchaseScreenState();
}

class _CompleteYourPurchaseScreenState
    extends State<CompleteYourPurchaseScreen> {
  int selectedIndex = -1;
  final List<Map<String, dynamic>> paymentMethod = [
    {
      "title": "Credit / Debit Card",
      "subtitle": "Visa • MasterCard • Amex supported",
    },
    {"title": "PayPal", "subtitle": "Login will open in a popup"},
    {
      "title": "Google Play Billing",
      "subtitle": "Pay with saved payment methods",
    },
    {
      "title": "Apple In-App Purchase",
      "subtitle": "Uses your Apple ID payment",
    },
    {"title": "Redeem Code", "subtitle": "Enter your promotional code"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20,
              bottom: 12,
              top: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.arrow_back, color: AppColors.onPrimary),
                    ),
                    const SizedBox(width: 16),
                    MyText(text: "Back", size: 16),
                  ],
                ),
                const SizedBox(height: 20),
                MyText(
                  text: "Complete Your Purchase",
                  size: 24,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                MyText(text: "Secure payment • Encrypted • Fast", size: 12),
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
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: MyText(
                                        text: "C+",
                                        size: 18,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MyText(text: "Crave+ Monthly"),
                                      const SizedBox(height: 6),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          MyText(
                                            text: "\$14.99",
                                            weight: FontWeight.bold,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 6),
                                          MyText(
                                            text: "/month",
                                            size: 10,
                                            color: AppColors.primary.withValues(
                                              alpha: 0.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),
                              featuresCircles(title: "Unlimited Chat"),
                              SizedBox(height: 12),

                              featuresCircles(title: "NSFW Access"),
                              SizedBox(height: 12),

                              featuresCircles(title: "Voice + Photo Replies"),
                              SizedBox(height: 12),

                              featuresCircles(title: "Leveling Up to Level 6"),
                              const SizedBox(height: 20),
                              MyText(
                                text: "Auto-renews • Cancel anytime",
                                size: 12,
                                color: AppColors.primary.withValues(alpha: 0.6),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Divider(color: AppColors.primary.withValues(alpha: 0.2)),
                const SizedBox(height: 20),
                MyText(text: "Choose Payment Method", size: 18),
                const SizedBox(height: 12),

                ...List.generate(paymentMethod.length, (index) {
                  final item = paymentMethod[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: selectedCard(
                      index: index,
                      title: item["title"],
                      subtitle: item["subtitle"],
                    ),
                  );
                }),
                const SizedBox(height: 20),
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
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
                              MyText(text: "Billing Summary", size: 12),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText(
                                    text: "Subtotal",
                                    size: 12,
                                    color: AppColors.primary.withValues(
                                      alpha: 0.08,
                                    ),
                                  ),
                                  MyText(
                                    text: "\$14.99",
                                    size: 12,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText(
                                    text: "Taxes",
                                    size: 12,
                                    color: AppColors.primary.withValues(
                                      alpha: 0.08,
                                    ),
                                  ),
                                  MyText(
                                    text: "\$0.00",
                                    size: 12,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Divider(
                                color: AppColors.primary.withValues(alpha: 0.2),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText(
                                    text: "Total",
                                    size: 12,
                                    color: AppColors.primary,
                                  ),
                                  MyText(
                                    text: "\$14.99",
                                    size: 12,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              MyText(
                                text:
                                    "Recurring payments. You can cancel anytime in Settings.",
                                size: 10,
                                color: AppColors.primary.withValues(
                                  alpha: 0.08,
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
                MyButton(onTap: () {}, buttonText: "Pay Now", radius: 12),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 12,
                          color: AppColors.primary.withValues(alpha: 0.08),
                        ),
                        const SizedBox(width: 8),
                        MyText(
                          text: "100% Secure",
                          size: 12,
                          color: AppColors.primary.withValues(alpha: 0.08),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Row(
                      children: [
                        Icon(
                          Icons.auto_mode_outlined,
                          size: 12,
                          color: AppColors.primary.withValues(alpha: 0.08),
                        ),
                        const SizedBox(width: 8),
                        MyText(
                          text: "Auto-renewal control",
                          size: 12,
                          color: AppColors.primary.withValues(alpha: 0.08),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.payment,
                      size: 12,
                      color: AppColors.primary.withValues(alpha: 0.08),
                    ),
                    const SizedBox(width: 8),
                    MyText(
                      text: "Encrypted Payments",
                      size: 12,
                      color: AppColors.primary.withValues(alpha: 0.08),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(
                      text: "Encrypted Payments? ",
                      size: 12,
                      color: AppColors.primary.withValues(alpha: 0.08),
                    ),
                    const SizedBox(width: 4),
                    MyText(
                      text: "Contact Support",
                      size: 14,
                      color: AppColors.secondary,
                      onTap: () {
                        Get.to(() => HelpSupportScreen());
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget featuresCircles({required String title}) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.1),
          ),
          child: Center(
            child: Icon(Icons.done, size: 14, color: AppColors.secondary),
          ),
        ),
        const SizedBox(width: 10),
        MyText(text: title, size: 12),
      ],
    );
  }

  Widget selectedCard({
    required int index,
    required String title,
    required String subtitle,
  }) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index; // ✅ Select only this card
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.secondary
                : Colors.white.withValues(alpha: 0.8),
            width: 0.8,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white.withValues(alpha: 0.03),
              child: Row(
                children: [
                  // 🔴 Glassy Radio Button Circle
                  Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.secondary
                            : Colors.white.withValues(alpha: 0.6),
                        width: 2,
                      ),
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    child: Center(
                      child: Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppColors.secondary
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Texts
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(text: title, size: 16),
                      const SizedBox(height: 4),
                      MyText(text: subtitle, size: 12),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
