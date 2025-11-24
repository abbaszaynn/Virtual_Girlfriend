import 'package:craveai/generated/assets.dart';
import 'package:craveai/views/widgets/common_image_view.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CommonImageView(
              imagePath: Assets.welcomeImage,
              height: 300,
              width: double.maxFinite,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
