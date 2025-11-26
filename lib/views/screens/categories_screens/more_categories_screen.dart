import 'package:craveai/controllers/app_colors.dart';
import 'package:craveai/views/widgets/categories_card.dart';
import 'package:craveai/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoreCategoriesScreen extends StatelessWidget {
  const MoreCategoriesScreen({super.key});

  // --- Category Data ---
  final List<Map<String, String>> categories = const [
    {"emoji": "💋", "title": "Flirty", "desc": "Playful, bold & romantic."},
    {"emoji": "🔥", "title": "Passionate", "desc": "Intense & full of fire."},
    {"emoji": "😊", "title": "Friendly", "desc": "Warm, sweet & easygoing."},
    {"emoji": "🤭", "title": "Shy", "desc": "Soft, quiet & adorable."},
    {"emoji": "😈", "title": "Bold", "desc": "Fearless, daring & confident."},
    {"emoji": "🎭", "title": "Dramatic", "desc": "Expressive & emotional."},
    {"emoji": "💼", "title": "Professional", "desc": "Smart & classy vibes."},
    {"emoji": "💘", "title": "Romantic", "desc": "Soft, loving and dreamy."},
    {"emoji": "🤖", "title": "Cool", "desc": "Calm, composed & smooth."},
    {"emoji": "😂", "title": "Funny", "desc": "Witty, silly & fun."},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 20,
            bottom: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- BACK BUTTON ---
              Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back, color: AppColors.onPrimary),
                  ),
                  const SizedBox(width: 16),
                  MyText(text: "Back", size: 16),
                ],
              ),

              const SizedBox(height: 20),

              // --- TITLES ---
              MyText(text: "Categories", size: 20, weight: FontWeight.bold),
              const SizedBox(height: 8),
              MyText(text: "Choose Your Vibe", size: 14),

              const SizedBox(height: 20),

              // --- LIST OF CATEGORIES ---
              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final cat = categories[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CategoryCard(
                        emoji: cat["emoji"]!,
                        title: cat["title"]!,
                        description: cat["desc"]!,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
