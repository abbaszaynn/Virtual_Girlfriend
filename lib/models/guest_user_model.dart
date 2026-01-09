class GuestUser {
  final String id;
  final String sessionId;
  final String? deviceFingerprint;
  final DateTime createdAt;
  final DateTime lastActiveAt;
  final DateTime expiresAt;
  final String? convertedToUserId;
  final bool isConverted;
  final bool ageVerified;
  final bool consentGiven;
  final String? ipAddress;
  final String? userAgent;

  GuestUser({
    required this.id,
    required this.sessionId,
    this.deviceFingerprint,
    required this.createdAt,
    required this.lastActiveAt,
    required this.expiresAt,
    this.convertedToUserId,
    required this.isConverted,
    required this.ageVerified,
    required this.consentGiven,
    this.ipAddress,
    this.userAgent,
  });

  /// Create GuestUser from Supabase JSON
  factory GuestUser.fromJson(Map<String, dynamic> json) {
    return GuestUser(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      deviceFingerprint: json['device_fingerprint'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastActiveAt: DateTime.parse(json['last_active_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      convertedToUserId: json['converted_to_user_id'] as String?,
      isConverted: json['is_converted'] as bool? ?? false,
      ageVerified: json['age_verified'] as bool? ?? false,
      consentGiven: json['consent_given'] as bool? ?? false,
      ipAddress: json['ip_address'] as String?,
      userAgent: json['user_agent'] as String?,
    );
  }

  /// Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'device_fingerprint': deviceFingerprint,
      'created_at': createdAt.toIso8601String(),
      'last_active_at': lastActiveAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'converted_to_user_id': convertedToUserId,
      'is_converted': isConverted,
      'age_verified': ageVerified,
      'consent_given': consentGiven,
      'ip_address': ipAddress,
      'user_agent': userAgent,
    };
  }

  /// Check if guest session is still valid
  bool get isValid => DateTime.now().isBefore(expiresAt) && !isConverted;

  /// Check if guest session has expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Days remaining before expiration
  int get daysRemaining => expiresAt.difference(DateTime.now()).inDays;

  /// Copy with method for updating fields
  GuestUser copyWith({
    String? id,
    String? sessionId,
    String? deviceFingerprint,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    DateTime? expiresAt,
    String? convertedToUserId,
    bool? isConverted,
    bool? ageVerified,
    bool? consentGiven,
    String? ipAddress,
    String? userAgent,
  }) {
    return GuestUser(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      deviceFingerprint: deviceFingerprint ?? this.deviceFingerprint,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      expiresAt: expiresAt ?? this.expiresAt,
      convertedToUserId: convertedToUserId ?? this.convertedToUserId,
      isConverted: isConverted ?? this.isConverted,
      ageVerified: ageVerified ?? this.ageVerified,
      consentGiven: consentGiven ?? this.consentGiven,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
    );
  }
}
