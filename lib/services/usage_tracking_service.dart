import 'package:flutter/foundation.dart';
import 'package:kraveai/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsageTrackingService {
  final SupabaseClient _client = SupabaseService().client;

  // Daily limits for free users
  static const int messageLimit = 10;
  static const int imageLimit = 2;
  static const int voiceLimit = 2;

  /// Get or create today's usage record for a user
  Future<Map<String, dynamic>?> _getTodayUsage(String userId) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];

      // Try to get existing record
      final response = await _client
          .from('user_usage_tracking')
          .select()
          .eq('user_id', userId)
          .eq('usage_date', today)
          .maybeSingle();

      if (response != null) {
        return response;
      }

      // Create new record for today
      final newRecord = await _client
          .from('user_usage_tracking')
          .insert({
            'user_id': userId,
            'usage_date': today,
            'message_count': 0,
            'image_count': 0,
            'voice_count': 0,
          })
          .select()
          .single();

      return newRecord;
    } catch (e) {
      debugPrint('ERROR getting usage data: $e');
      return null;
    }
  }

  /// Check if user is premium
  Future<bool> isPremiumUser() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return false;

      final usage = await _getTodayUsage(userId);
      if (usage == null) return false;

      final isPremium = usage['is_premium'] ?? false;
      final expiresAt = usage['premium_expires_at'];

      // Check if premium and not expired
      if (isPremium && expiresAt != null) {
        final expiry = DateTime.parse(expiresAt);
        if (expiry.isBefore(DateTime.now())) {
          // Premium expired, update status
          await _client
              .from('user_usage_tracking')
              .update({'is_premium': false})
              .eq('id', usage['id']);
          return false;
        }
      }

      return isPremium;
    } catch (e) {
      debugPrint('ERROR checking premium status: $e');
      return false;
    }
  }

  /// Check if user can send a message
  Future<bool> canSendMessage() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return false;

      final usage = await _getTodayUsage(userId);
      if (usage == null) return false;

      // Premium users have unlimited messages
      if (usage['is_premium'] == true) return true;

      // Check if under limit
      final messageCount = usage['message_count'] ?? 0;
      return messageCount < messageLimit;
    } catch (e) {
      debugPrint('ERROR checking message limit: $e');
      return false;
    }
  }

  /// Check if user can generate an image
  Future<bool> canGenerateImage() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return false;

      final usage = await _getTodayUsage(userId);
      if (usage == null) return false;

      // Premium users have unlimited images
      if (usage['is_premium'] == true) return true;

      // Check if under limit
      final imageCount = usage['image_count'] ?? 0;
      return imageCount < imageLimit;
    } catch (e) {
      debugPrint('ERROR checking image limit: $e');
      return false;
    }
  }

  /// Check if user can use voice feature
  Future<bool> canUseVoice() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return false;

      final usage = await _getTodayUsage(userId);
      if (usage == null) return false;

      // Premium users have unlimited voice
      if (usage['is_premium'] == true) return true;

      // Check if under limit
      final voiceCount = usage['voice_count'] ?? 0;
      return voiceCount < voiceLimit;
    } catch (e) {
      debugPrint('ERROR checking voice limit: $e');
      return false;
    }
  }

  /// Increment message count
  Future<void> incrementMessageCount() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;

      final usage = await _getTodayUsage(userId);
      if (usage == null) return;

      // Don't increment for premium users (they're unlimited anyway)
      if (usage['is_premium'] == true) return;

      final currentCount = usage['message_count'] ?? 0;
      await _client
          .from('user_usage_tracking')
          .update({'message_count': currentCount + 1})
          .eq('id', usage['id']);

      debugPrint(
        '✅ Message count incremented: ${currentCount + 1}/$messageLimit',
      );
    } catch (e) {
      debugPrint('ERROR incrementing message count: $e');
    }
  }

  /// Increment image count
  Future<void> incrementImageCount() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;

      final usage = await _getTodayUsage(userId);
      if (usage == null) return;

      // Don't increment for premium users
      if (usage['is_premium'] == true) return;

      final currentCount = usage['image_count'] ?? 0;
      await _client
          .from('user_usage_tracking')
          .update({'image_count': currentCount + 1})
          .eq('id', usage['id']);

      debugPrint('✅ Image count incremented: ${currentCount + 1}/$imageLimit');
    } catch (e) {
      debugPrint('ERROR incrementing image count: $e');
    }
  }

  /// Increment voice count
  Future<void> incrementVoiceCount() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;

      final usage = await _getTodayUsage(userId);
      if (usage == null) return;

      // Don't increment for premium users
      if (usage['is_premium'] == true) return;

      final currentCount = usage['voice_count'] ?? 0;
      await _client
          .from('user_usage_tracking')
          .update({'voice_count': currentCount + 1})
          .eq('id', usage['id']);

      debugPrint('✅ Voice count incremented: ${currentCount + 1}/$voiceLimit');
    } catch (e) {
      debugPrint('ERROR incrementing voice count: $e');
    }
  }

  /// Get remaining limits for all features
  Future<Map<String, int>> getRemainingLimits() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        return {'messages': 0, 'images': 0, 'voice': 0};
      }

      final usage = await _getTodayUsage(userId);
      if (usage == null) {
        return {'messages': 0, 'images': 0, 'voice': 0};
      }

      // Premium users have unlimited
      if (usage['is_premium'] == true) {
        return {
          'messages': -1, // -1 indicates unlimited
          'images': -1,
          'voice': -1,
        };
      }

      final messageCount = (usage['message_count'] ?? 0) as int;
      final imageCount = (usage['image_count'] ?? 0) as int;
      final voiceCount = (usage['voice_count'] ?? 0) as int;

      return {
        'messages': messageLimit - messageCount,
        'images': imageLimit - imageCount,
        'voice': voiceLimit - voiceCount,
      };
    } catch (e) {
      debugPrint('ERROR getting remaining limits: $e');
      return {'messages': 0, 'images': 0, 'voice': 0};
    }
  }

  /// Get current usage counts
  Future<Map<String, int>> getCurrentUsage() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        return {'messages': 0, 'images': 0, 'voice': 0};
      }

      final usage = await _getTodayUsage(userId);
      if (usage == null) {
        return {'messages': 0, 'images': 0, 'voice': 0};
      }

      return {
        'messages': (usage['message_count'] ?? 0) as int,
        'images': (usage['image_count'] ?? 0) as int,
        'voice': (usage['voice_count'] ?? 0) as int,
      };
    } catch (e) {
      debugPrint('ERROR getting current usage: $e');
      return {'messages': 0, 'images': 0, 'voice': 0};
    }
  }
}
