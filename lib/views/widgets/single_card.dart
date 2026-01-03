import 'dart:ui';
import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/generated/assets.dart';
import 'package:kraveai/views/widgets/my_text.dart';
import 'package:flutter/material.dart';

class SingleCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String? image;
  final String? name;
  final String? age;

  const SingleCard({super.key, this.onTap, this.image, this.name, this.age});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(image ?? Assets.maya),
            fit: BoxFit.cover,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Glass Blur Layer
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.15),
                        Colors.black.withValues(alpha: 0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1.2,
                    ),
                  ),
                ),
              ),

              // Content
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MyText(
                          text: name ?? "Maya",
                          size: 20,
                          weight: FontWeight.bold,
                        ),
                        MyText(
                          text: age ?? "23",
                          size: 16,
                          weight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 30,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.20),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.wifi,
                                color: AppColors.primary,
                                size: 14,
                              ),
                              const SizedBox(width: 10),
                              MyText(
                                text: "Online Now",
                                size: 14,
                                weight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
