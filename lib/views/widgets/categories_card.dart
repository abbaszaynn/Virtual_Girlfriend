import 'dart:ui';
import 'package:craveai/views/widgets/my_text.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final String emoji;

  const CategoryCard({
    super.key,
    required this.title,
    required this.description,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withOpacity(0.15),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(text: title, size: 18, weight: FontWeight.bold),
                  const SizedBox(height: 4),
                  MyText(text: description, size: 10),
                ],
              ),
              MyText(text: emoji, size: 10),
            ],
          ),
        ),
      ),
    );
  }
}
