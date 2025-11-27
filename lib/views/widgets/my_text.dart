// ignore_for_file: unnecessary_string_interpolations

import 'package:craveai/generated/app_colors.dart';
import 'package:craveai/generated/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ignore: must_be_immutable
class MyText extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final String text;
  final String? fontFamily;
  final TextAlign? textAlign;
  final TextDecoration decoration;
  final FontWeight? weight;
  final TextOverflow? textOverflow;
  final Color? color;
  final FontStyle? fontStyle;
  final VoidCallback? onTap;
  final Color decorationColor; // Add this

  final int? maxLines;
  final double? size;
  final double? lineHeight;
  final double? paddingTop;
  final double? paddingLeft;
  final double? paddingRight;
  final double? paddingBottom;
  final double? letterSpacing;

  MyText({
    Key? key,
    required this.text,
    this.size,
    this.lineHeight,
    this.maxLines = 100,
    this.decoration = TextDecoration.none,
    this.color,
    this.letterSpacing,
    this.weight = FontWeight.w400,
    this.textAlign,
    this.textOverflow,
    this.fontFamily,
    this.decorationColor = Colors.transparent, // Default to transparent

    this.paddingTop = 0,
    this.paddingRight = 0,
    this.paddingLeft = 0,
    this.paddingBottom = 0,
    this.onTap,
    this.fontStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [FadeEffect(duration: Duration(milliseconds: 500))],
      child: Padding(
        padding: EdgeInsets.only(
          top: paddingTop!,
          left: paddingLeft!,
          right: paddingRight!,
          bottom: paddingBottom!,
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Text(
            "$text",
            style: TextStyle(
              fontSize: size,
              color: color ?? AppColors.primary,
              fontWeight: weight,
              decoration: decoration,
              decorationColor: decorationColor, // Apply the color here

              fontFamily: fontFamily ?? AppFonts.inter,
              height: lineHeight ?? 0,
              fontStyle: fontStyle,
              letterSpacing: letterSpacing,
            ),
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: textOverflow,
          ),
        ),
      ),
    );
  }
}
