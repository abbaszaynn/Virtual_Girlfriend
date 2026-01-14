import 'dart:ui';
import 'package:kraveai/controllers/chat_controller.dart';
import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/views/screens/chat_screens/widgets/message_bubble.dart';
import 'package:kraveai/views/screens/chat_screens/widgets/image_message_bubble.dart'; // Add this
import 'package:kraveai/views/screens/chat_screens/widgets/registration_prompt_bubble.dart'; // Guest limit widget
import 'package:kraveai/views/screens/chat_screens/widgets/usage_indicator_widget.dart'; // Usage indicator
import 'package:kraveai/views/screens/home/unlock_premium_features_screen.dart'; // Premium screen
import 'package:kraveai/services/supabase_service.dart'; // For logout
import 'package:kraveai/views/screens/auth_screens/login_screen.dart'; // For logout navigation
import 'package:kraveai/views/widgets/common_image_view.dart';
import 'package:kraveai/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kraveai/models/character_model.dart';

class ChatScreen extends StatefulWidget {
  final String characterId;
  final String name;
  final String image;
  final Character?
  character; // Optional: if provided, will use detailed descriptions

  const ChatScreen({
    super.key,
    required this.characterId,
    required this.name,
    required this.image,
    this.character, // Make this optional for backwards compatibility
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChatController());
    controller.initializeRequest(
      widget.characterId,
      widget.name,
      widget.image,
      character: widget.character, // Pass character object if available
    );
  }

  @override
  void dispose() {
    Get.delete<ChatController>(); // Cleanup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.6),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CommonImageView(
              imagePath: widget.image, // Temporarily assuming asset or network
              height: 40,
              width: 40,
              radius: 20,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(text: widget.name, size: 16, weight: FontWeight.w600),
                Row(
                  children: [
                    Container(
                      height: 8,
                      width: 8,
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    MyText(text: "Online", size: 12, color: Colors.white70),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Only show voice call for registered users
          Obx(() {
            if (controller.isGuestUser.value) {
              return const SizedBox.shrink(); // Hide for guests
            }
            return IconButton(
              onPressed: () {
                Get.snackbar("Coming Soon", "Voice Calls enabled in Phase 2!");
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.call, color: Colors.white, size: 20),
              ),
            );
          }),
          // Premium Upgrade Button for non-premium registered users
          Obx(() {
            if (controller.isGuestUser.value || controller.isPremium.value) {
              return const SizedBox.shrink(); // Hide for guests and premium
            }
            return IconButton(
              onPressed: () {
                Get.to(() => const UnlockPremiumFeaturesScreen());
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            );
          }),
          // Logout Button for registered users
          Obx(() {
            if (controller.isGuestUser.value) {
              return const SizedBox.shrink(); // Hide for guests
            }
            return IconButton(
              onPressed: () {
                // Show confirmation dialog
                Get.dialog(
                  AlertDialog(
                    backgroundColor: const Color(0xFF1A1A1A),
                    title: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                    content: const Text(
                      "Are you sure you want to logout?",
                      style: TextStyle(color: Colors.white70),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          Get.back(); // Close dialog
                          await SupabaseService().signOut();
                          // Navigate to login screen and clear navigation stack
                          Get.offAll(() => const LoginScreen());
                          Get.snackbar(
                            "Success",
                            "You have been logged out",
                            backgroundColor: Colors.green.withOpacity(0.8),
                            colorText: Colors.white,
                          );
                        },
                        child: const Text(
                          "Logout",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.3),
                    width: 1.2,
                  ),
                ),
                child: const Icon(
                  Icons.logout,
                  color: Colors.redAccent,
                  size: 20,
                ),
              ),
            );
          }),
          const SizedBox(width: 10),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.image), // Background wallpaper effect
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.8),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Message List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (controller.messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommonImageView(
                            imagePath: widget.image,
                            height: 80,
                            width: 80,
                            radius: 40,
                          ),
                          const SizedBox(height: 20),
                          MyText(
                            text: "Say Hi to ${widget.name}!",
                            size: 16,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: controller.scrollController,
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final msg = controller.messages[index];
                      final isMe = msg['sender_type'] == 'user';
                      final messageId = msg['id'].toString();

                      // 1. Check if Guest Limit Message (Registration Prompt)
                      if (msg['sender_type'] == 'guest_limit') {
                        return RegistrationPromptBubble(
                          blurredImageUrl: msg['content'] ?? widget.image,
                          time: _formatTime(msg['created_at']),
                        );
                      }

                      // 2. Check if Image
                      if (msg['sender_type'] == 'image') {
                        return ImageMessageBubble(
                          imageUrl: msg['content'] ?? '',
                          time: _formatTime(msg['created_at']),
                        );
                      }

                      // 3. Text Message
                      return Obx(() {
                        final isPlaying =
                            controller.playingMessageId.value == messageId &&
                            !controller.isAudioLoading.value;
                        final isLoading =
                            controller.playingMessageId.value == messageId &&
                            controller.isAudioLoading.value;

                        return MessageBubble(
                          message: msg['content'] ?? '',
                          isMe: isMe,
                          time: _formatTime(msg['created_at']),
                          messageId: messageId,
                          isPlaying: isPlaying,
                          isLoading: isLoading,
                          onPlay: isMe
                              ? null
                              : () => controller.playMessageAudio(
                                  messageId,
                                  msg['content'] ?? '',
                                ),
                        );
                      });
                    },
                  );
                }),
              ),

              // Input Area
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  border: Border(
                    top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                ),
                child: Column(
                  children: [
                    // Usage Indicator for registered users
                    const UsageIndicatorWidget(),
                    // Guest Message Counter
                    Obx(() {
                      if (controller.isGuestUser.value &&
                          !controller.guestLimitReached.value) {
                        final remaining =
                            5 - controller.guestMessageCount.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: MyText(
                            text:
                                "$remaining message${remaining != 1 ? 's' : ''} remaining as guest",
                            size: 11,
                            color: remaining <= 2
                                ? Colors.orange
                                : Colors.white60,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    Row(
                      children: [
                        // Camera Button - Only for registered users
                        Obx(() {
                          if (controller.isGuestUser.value) {
                            return const SizedBox.shrink(); // Hide for guests
                          }
                          return InkWell(
                            onTap: () => controller.requestImage(),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Obx(
                                () => controller.isImageGenerating.value
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white70,
                                        size: 20,
                                      ),
                              ),
                            ),
                          );
                        }),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: TextField(
                              controller: controller.textController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: "Type a message...",
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => controller.sendMessage(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: () => controller.sendMessage(),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.4,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Obx(
                              () => controller.isSending.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.send,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ), // Closing bracket for Row
                  ], // Closing bracket for Column children
                ), // Closing bracket for Column
              ), // Closing bracket for Container
            ], // Closing bracket for the main Column's children
          ), // Closing bracket for the main Column
        ), // Closing bracket for the Scaffold body's Padding/Center
      ), // Closing bracket for Scaffold
    ); // Closing bracket for build method's return
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return "";
    final date = DateTime.parse(timestamp).toLocal();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }
}
