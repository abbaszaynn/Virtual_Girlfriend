import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:kraveai/models/guest_user_model.dart';
import 'package:kraveai/services/supabase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info_plus/device_info_plus.dart';

class GuestService {
  static final GuestService _instance = GuestService._internal();

  factory GuestService() {
    return _instance;
  }

  GuestService._internal();

  final SupabaseService _supabase = SupabaseService();
  final Uuid _uuid = const Uuid();
  GuestUser? _currentGuestUser;

  static const String _guestSessionKey = 'guest_session_id';
  static const int _messageLimit = 5;

  /// Get current guest user
  GuestUser? get currentGuestUser => _currentGuestUser;

  /// Check if user is in guest mode
  bool get isGuestMode =>
      _currentGuestUser != null && _currentGuestUser!.isValid;

  /// Create a new guest session
  Future<GuestUser> createGuestSession({
    required bool ageVerified,
    required bool consentGiven,
  }) async {
    try {
      // Generate unique session ID
      final sessionId = _uuid.v4();

      // Get device fingerprint
      final deviceFingerprint = await _getDeviceFingerprint();

      // Get IP address (you may need a service for this)
      final ipAddress = await _getIpAddress();

      // Get user agent
      final userAgent = await _getUserAgent();

      // Create guest user in database
      final data = await _supabase.client
          .from('guest_users')
          .insert({
            'session_id': sessionId,
            'device_fingerprint': deviceFingerprint,
            'age_verified': ageVerified,
            'consent_given': consentGiven,
            'ip_address': ipAddress,
            'user_agent': userAgent,
          })
          .select()
          .single();

      // Create GuestUser object
      final guestUser = GuestUser.fromJson(data);
      _currentGuestUser = guestUser;

      // Save session ID locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_guestSessionKey, sessionId);

      // Log age verification
      await _logAgeVerification(sessionId: sessionId, ipAddress: ipAddress);

      debugPrint('✅ Guest session created: $sessionId');
      return guestUser;
    } catch (e) {
      debugPrint('❌ Failed to create guest session: $e');
      rethrow;
    }
  }

  /// Restore guest session from local storage
  Future<GuestUser?> restoreGuestSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString(_guestSessionKey);

      if (sessionId == null) {
        return null;
      }

      // Fetch guest user from database
      final data = await _supabase.client
          .from('guest_users')
          .select()
          .eq('session_id', sessionId)
          .single();

      final guestUser = GuestUser.fromJson(data);

      // Check if session is still valid
      if (!guestUser.isValid) {
        await clearGuestSession();
        return null;
      }

      // Update last active timestamp
      await _supabase.client
          .from('guest_users')
          .update({'last_active_at': DateTime.now().toIso8601String()})
          .eq('session_id', sessionId);

      _currentGuestUser = guestUser;
      debugPrint('✅ Guest session restored: $sessionId');
      return guestUser;
    } catch (e) {
      debugPrint('❌ Failed to restore guest session: $e');
      return null;
    }
  }

  /// Clear guest session
  Future<void> clearGuestSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_guestSessionKey);
      _currentGuestUser = null;
      debugPrint('✅ Guest session cleared');
    } catch (e) {
      debugPrint('❌ Failed to clear guest session: $e');
    }
  }

  /// Get guest message count for a conversation
  Future<int> getGuestMessageCount(String conversationId) async {
    try {
      final data = await _supabase.client
          .from('conversations')
          .select('guest_message_count')
          .eq('id', conversationId)
          .single();

      return data['guest_message_count'] as int? ?? 0;
    } catch (e) {
      debugPrint('❌ Failed to get guest message count: $e');
      return 0;
    }
  }

  /// Increment guest message count
  Future<void> incrementGuestMessageCount(String conversationId) async {
    try {
      // Get current count
      final currentCount = await getGuestMessageCount(conversationId);
      final newCount = currentCount + 1;

      // Update count and check if limit reached
      await _supabase.client
          .from('conversations')
          .update({
            'guest_message_count': newCount,
            'guest_limit_reached': newCount >= _messageLimit,
          })
          .eq('id', conversationId);

      debugPrint('✅ Guest message count incremented: $newCount/$_messageLimit');
    } catch (e) {
      debugPrint('❌ Failed to increment guest message count: $e');
      rethrow;
    }
  }

  /// Check if guest has reached message limit
  Future<bool> hasReachedLimit(String conversationId) async {
    try {
      final data = await _supabase.client
          .from('conversations')
          .select('guest_limit_reached, guest_message_count')
          .eq('id', conversationId)
          .single();

      final limitReached = data['guest_limit_reached'] as bool? ?? false;
      final messageCount = data['guest_message_count'] as int? ?? 0;

      return limitReached || messageCount >= _messageLimit;
    } catch (e) {
      debugPrint('❌ Failed to check guest limit: $e');
      return false;
    }
  }

  /// Get remaining messages
  Future<int> getRemainingMessages(String conversationId) async {
    final count = await getGuestMessageCount(conversationId);
    return (_messageLimit - count).clamp(0, _messageLimit);
  }

  /// Convert guest to registered user
  Future<void> convertGuestToUser(String userId) async {
    try {
      if (_currentGuestUser == null) {
        throw Exception('No active guest session');
      }

      final sessionId = _currentGuestUser!.sessionId;

      // Update guest user as converted
      await _supabase.client
          .from('guest_users')
          .update({'is_converted': true, 'converted_to_user_id': userId})
          .eq('session_id', sessionId);

      // Migrate conversations to the new user
      await _supabase.client
          .from('conversations')
          .update({
            'user_id': userId,
            'guest_session_id': null, // Clear guest session
          })
          .eq('guest_session_id', sessionId);

      // Clear local guest session
      await clearGuestSession();

      debugPrint('✅ Guest converted to registered user: $userId');
    } catch (e) {
      debugPrint('❌ Failed to convert guest to user: $e');
      rethrow;
    }
  }

  /// Get device fingerprint for tracking
  Future<String> _getDeviceFingerprint() async {
    try {
      final deviceInfo = DeviceInfoPlugin();

      // Check web FIRST before using Platform
      if (kIsWeb) {
        final webInfo = await deviceInfo.webBrowserInfo;
        return '${webInfo.userAgent}_${webInfo.vendor}_web';
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return '${androidInfo.id}_${androidInfo.model}_${androidInfo.device}';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return '${iosInfo.identifierForVendor}_${iosInfo.model}';
      }
      return 'unknown';
    } catch (e) {
      debugPrint('⚠️ Failed to get device fingerprint: $e');
      return 'web_fallback_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  /// Get IP address (placeholder - you may need an external service)
  Future<String?> _getIpAddress() async {
    // TODO: Implement IP address retrieval
    // You can use a service like ipify.org or get it from your backend
    return null;
  }

  /// Get user agent
  Future<String?> _getUserAgent() async {
    try {
      if (kIsWeb) {
        final deviceInfo = DeviceInfoPlugin();
        final webInfo = await deviceInfo.webBrowserInfo;
        return webInfo.userAgent;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Log age verification for audit trail
  Future<void> _logAgeVerification({
    required String sessionId,
    String? ipAddress,
  }) async {
    try {
      await _supabase.client.from('age_verification_logs').insert({
        'guest_session_id': sessionId,
        'ip_address': ipAddress,
        'verification_method': 'self_declaration',
        'consent_version': '1.0',
      });
    } catch (e) {
      debugPrint('⚠️ Failed to log age verification: $e');
      // Don't throw - logging failure shouldn't block user flow
    }
  }

  /// Check if device has too many active guest sessions (anti-abuse)
  Future<bool> hasExceededSessionLimit() async {
    try {
      final deviceFingerprint = await _getDeviceFingerprint();
      final twentyFourHoursAgo = DateTime.now().subtract(
        const Duration(hours: 24),
      );

      final response = await _supabase.client
          .from('guest_users')
          .select()
          .eq('device_fingerprint', deviceFingerprint)
          .gte('created_at', twentyFourHoursAgo.toIso8601String());

      // Limit: 5 guest sessions per device per 24 hours
      return (response as List).length >= 5;
    } catch (e) {
      debugPrint('⚠️ Failed to check session limit: $e');
      return false; // Fail open - don't block users on error
    }
  }
}
