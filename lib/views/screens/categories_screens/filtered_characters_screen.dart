import 'dart:ui';

import 'package:kraveai/data/character_data.dart';
import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/generated/assets.dart';
import 'package:kraveai/models/character_model.dart';
import 'package:kraveai/services/guest_service.dart';
import 'package:kraveai/services/supabase_service.dart';
import 'package:kraveai/views/screens/home/detail_screen.dart';
import 'package:kraveai/views/widgets/home_card.dart';
import 'package:kraveai/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilteredCharactersScreen extends StatefulWidget {
  final String categoryName;
  final String categoryDescription;
  final String categoryEmoji;

  const FilteredCharactersScreen({
    super.key,
    required this.categoryName,
    required this.categoryDescription,
    required this.categoryEmoji,
  });

  @override
  State<FilteredCharactersScreen> createState() =>
      _FilteredCharactersScreenState();
}

class _FilteredCharactersScreenState extends State<FilteredCharactersScreen> {
  final GuestService _guestService = GuestService();
  final SupabaseService _supabaseService = SupabaseService();
  List<Character> allCharacters = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllCharacters();
  }

  Future<void> _loadAllCharacters() async {
    try {
      // Start with default characters
      allCharacters = List.from(characterList);

      // If user is logged in (not guest), fetch their custom characters
      if (!_guestService.isGuestMode) {
        final userId = _supabaseService.client.auth.currentUser?.id;
        if (userId != null) {
          final response = await _supabaseService.client
              .from('characters')
              .select()
              .eq('user_id', userId);

          // Convert database records to Character objects
          for (var charData in response) {
            // Get categories from database or default to ['Custom']
            List<String> categories = ['Custom'];
            if (charData['categories'] != null) {
              categories = List<String>.from(charData['categories']);
            }

            allCharacters.add(
              Character(
                id: charData['id'].toString(),
                name: charData['name'],
                age: charData['description']?.split('yo')[0] ?? '25',
                imagePath: charData['image_url'] ?? Assets.maya,
                vibe: charData['vibe'] ?? 'Custom',
                categories: categories,
                description: charData['description'] ?? '',
                systemPrompt: charData['system_prompt'] ?? '',
                voiceId: charData['voice_id'] ?? '21m00Tcm4TlvDq8ikWAM',
                imagePromptDescription: charData['description'] ?? '',
              ),
            );
          }
        }
      }

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading characters for filtering: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  List<Character> _getFilteredCharacters() {
    return allCharacters
        .where(
          (character) => character.categories.contains(widget.categoryName),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCharacters = _getFilteredCharacters();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  MyText(text: "Back", size: 16),
                ],
              ),

              const SizedBox(height: 30),

              // Category Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: MyText(text: widget.categoryEmoji, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: widget.categoryName,
                          size: 24,
                          weight: FontWeight.bold,
                        ),
                        const SizedBox(height: 4),
                        MyText(
                          text: widget.categoryDescription,
                          size: 14,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Results count
              if (!isLoading)
                MyText(
                  text:
                      "${filteredCharacters.length} ${filteredCharacters.length == 1 ? 'Character' : 'Characters'} Available",
                  size: 16,
                  color: AppColors.secondary,
                ),

              const SizedBox(height: 20),

              // Characters Grid
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.secondary,
                        ),
                      )
                    : filteredCharacters.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 16),
                            MyText(
                              text: "No characters in this category yet",
                              size: 16,
                              color: Colors.white60,
                            ),
                            const SizedBox(height: 8),
                            MyText(
                              text: "Check back soon for more!",
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: 0.9,
                            ),
                        itemCount: filteredCharacters.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final Character character = filteredCharacters[index];
                          return HomeCard(
                            image: character.imagePath,
                            title: character.name,
                            age: character.age,
                            ontap: () {
                              Get.to(() => DetailScreen(character: character));
                            },
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
