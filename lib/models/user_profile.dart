class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String location;
  final String? avatarUrl;      // ← Supabase টেবিলের কলামের সাথে মিল
  final DateTime? createdAt;
  final String role;            // 'app_admin' | 'normal_user'

  UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.location,
    this.avatarUrl,
    this.createdAt,
    this.role = 'normal_user',
  });

  // ===== Convenience getters =====
  bool get isAdmin => role == 'app_admin';
  bool get isNormalUser => role == 'normal_user';
  bool get hasAvatar => avatarUrl != null && avatarUrl!.isNotEmpty;

  // ===== Supabase থেকে Map → UserProfile =====
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString() ?? '',
      fullName: (json['full_name'] ?? json['fullName'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      phone: (json['phone'] ?? '') as String,
      location: (json['location'] ?? '') as String,
      avatarUrl: (json['avatar_url'] ?? json['profile_image_url'] ?? json['profileImageUrl']) as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      role: (json['role'] ?? 'normal_user') as String,
    );
  }

  // ===== UserProfile →
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'location': location,
      'avatar_url': avatarUrl,
      'role': role,

    };
  }

  // ===== copyWith =====
  UserProfile copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? location,
    String? avatarUrl,
    DateTime? createdAt,
    String? role,
  }) {
    return UserProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      role: role ?? this.role,
    );
  }
}