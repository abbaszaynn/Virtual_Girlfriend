import 'package:kraveai/data/character_data.dart';
import 'package:kraveai/models/character_model.dart';
import 'package:kraveai/views/screens/home/detail_screen.dart';
import 'package:kraveai/views/widgets/home_card.dart';
import 'package:kraveai/views/widgets/my_text.dart';
import 'package:kraveai/views/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: MyText(
                    text: "Discover AI Models",
                    size: 24,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                MyTextField(
                  hint: "Search AI Model",
                  radius: 12,
                  prefix: Icon(Icons.search),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: characterList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final Character character = characterList[index];
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
