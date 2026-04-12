// lib/data/models/user_model.dart

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? avatar;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'].toString(),
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    role: json['role'] ?? 'CUSTOMER',
    avatar: json['avatar'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
    'avatar': avatar,
  };

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
  }

  /// Server may store initials ("AB") or a Google profile image URL.
  bool get hasNetworkAvatar {
    final a = avatar;
    if (a == null || a.isEmpty) return false;
    final t = a.trim().toLowerCase();
    return t.startsWith('http://') || t.startsWith('https://');
  }
}
