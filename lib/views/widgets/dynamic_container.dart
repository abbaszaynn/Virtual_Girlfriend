import 'dart:ui';
import 'package:craveai/views/widgets/my_text.dart';
import 'package:flutter/material.dart';

class DynamicContainer extends StatelessWidget {
  final String text;
  const DynamicContainer({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15), // glass effect
            borderRadius: BorderRadius.circular(18),
          ),
          child: MyText(text: text, size: 12, weight: FontWeight.w500),
        ),
      ),
    );
    ;
  }
}
