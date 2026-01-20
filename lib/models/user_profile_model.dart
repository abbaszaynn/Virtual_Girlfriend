class UserProfile {
  final String id;
  final String userId;
  final String? displayName;
  final String? avatarUrl;
  final String? preferredRole;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.userId,
    this.displayName,
    this.avatarUrl,
    this.preferredRole,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      userId: json['user_id'],
      displayName: json['display_name'],
      avatarUrl: json['avatar_url'],
      preferredRole: json['preferred_role'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'preferred_role': preferredRole,
    };
  }
}
