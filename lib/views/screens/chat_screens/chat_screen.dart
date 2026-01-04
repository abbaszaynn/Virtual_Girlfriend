import 'dart:ui';
import 'package:kraveai/controllers/chat_controller.dart';
import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/views/screens/chat_screens/widgets/message_bubble.dart';
import 'package:kraveai/views/screens/chat_screens/widgets/image_message_bubble.dart'; // Add this
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
          onPressed: () => Get.back(),
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
          IconButton(
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
          ),
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

                      // 1. Check if Image
                      if (msg['sender_type'] == 'image') {
                        return ImageMessageBubble(
                          imageUrl: msg['content'] ?? '',
                          time: _formatTime(msg['created_at']),
                        );
                      }

                      // 2. Text Message
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
                child: Row(
                  children: [
                    // Camera Button
                    InkWell(
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
                    ),
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
                              color: AppColors.primary.withValues(alpha: 0.4),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return "";
    final date = DateTime.parse(timestamp).toLocal();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }
}
