import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageMessageBubble extends StatelessWidget {
  final String imageUrl;
  final String? time;

  const ImageMessageBubble({super.key, required this.imageUrl, this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft, // Always AI
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(2),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) => SizedBox(
                  height: 200,
                  width: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            if (time != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  time!,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
