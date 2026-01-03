import 'dart:ui';

import 'package:kraveai/generated/app_colors.dart';

import 'package:kraveai/views/screens/chat_screens/chat_screen.dart';
import 'package:kraveai/services/supabase_service.dart';
import 'package:kraveai/views/screens/chat_screens/widgtes/inbox_card_widget.dart';
import 'package:kraveai/views/widgets/common_image_view.dart';
import 'package:kraveai/views/widgets/my_text.dart';
import 'package:kraveai/views/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kraveai/data/character_data.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    text: "Message",
                    size: 24,
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(
                          alpha: 0.3,
                        ), // light white border
                        width: 1.2,
                      ),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 0,
                        sigmaY: 0,
                      ), // glass blur effect
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // frosted background
                        ),
                        child: Center(
                          child: Icon(
                            Icons.tune, // filter icon
                            color: AppColors.secondary, // red color
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              MyText(text: "Activities", size: 18),
              const SizedBox(height: 16),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 20,
                  children: characterList.map((char) {
                    return CommonImageView(
                      imagePath: char.imagePath,
                      height: 60,
                      width: 60,
                      radius: 30,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              MyTextField(
                hint: "Search",
                prefix: Icon(Icons.search),
                radius: 12,
              ),
              const SizedBox(height: 10),
              MyText(text: "Messages", size: 18),
              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: characterList.length,
                  itemBuilder: (context, index) {
                    final character = characterList[index];
                    return GestureDetector(
                      onTap: () async {
                        try {
                          final String charId = await SupabaseService()
                              .getOrCreateCharacter(character);
                          Get.to(
                            () => ChatScreen(
                              characterId: charId,
                              name: character.name,
                              image: character.imagePath,
                            ),
                          );
                        } catch (e) {
                          Get.snackbar("Error", "Failed to open chat: $e");
                        }
                      },
                      child: InboxCard(
                        name: character.name,
                        message: "Hey! What are you up to? 😉",
                        time: "Now",
                        image: character.imagePath,
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
