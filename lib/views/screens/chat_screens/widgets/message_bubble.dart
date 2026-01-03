import 'package:kraveai/generated/app_colors.dart';
import 'package:kraveai/views/widgets/my_text.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String? time;
  final String? messageId;
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback? onPlay;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.time,
    this.messageId,
    this.isPlaying = false,
    this.isLoading = false,
    this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.secondary : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe
                ? const Radius.circular(16)
                : const Radius.circular(2),
            bottomRight: isMe
                ? const Radius.circular(2)
                : const Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            MyText(
              text: message,
              size: 14,
              color: isMe ? Colors.white : Colors.white.withValues(alpha: 0.9),
              textAlign: TextAlign.left,
            ),
            if (time != null) ...[
              const SizedBox(height: 4),
              MyText(
                text: time!,
                size: 10,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ],
            if (!isMe && onPlay != null) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: isLoading ? null : onPlay,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLoading)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    else
                      Icon(
                        isPlaying ? Icons.stop_circle : Icons.play_circle,
                        color: Colors.white,
                        size: 20,
                      ),
                    const SizedBox(width: 4),
                    Text(
                      isLoading
                          ? "Loading..."
                          : isPlaying
                          ? "Stop"
                          : "Play Voice",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
