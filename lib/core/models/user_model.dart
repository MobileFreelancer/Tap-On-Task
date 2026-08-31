enum UserRole { customer, trader }

class UserModel {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String? avatarUrl;
  final UserRole role;
  final double rating;
  final int taskCount;
  final int completedTasks;
  final DateTime createdAt;
  final bool isVerified;

  UserModel({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.email,
    this.avatarUrl,
    required this.role,
    this.rating = 0.0,
    this.taskCount = 0,
    this.completedTasks = 0,
    DateTime? createdAt,
    this.isVerified = false,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? json['userId'] ?? '').toString(),
      phoneNumber: json['phone'] as String? ?? json['phoneNumber'] as String? ?? '',
      name: json['name'] as String?,
      email: json['email'] as String?,
      avatarUrl: json['avatarUrl'] as String? ?? json['image'] as String?,
      role: _parseRole(json['role'] as String? ?? 'customer'),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      taskCount: (json['taskCount'] as num?)?.toInt() ?? 0,
      completedTasks: (json['completedTasks'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : (json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now()),
      isVerified: json['email_verified_at'] != null || (json['isVerified'] as bool? ?? false),
    );
  }

  static UserRole _parseRole(String role) {
    switch (role.toLowerCase()) {
      case 'trader':
        return UserRole.trader;
      default:
        return UserRole.customer;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'phoneNumber': phoneNumber,
        'name': name,
        'email': email,
        'avatarUrl': avatarUrl,
        'role': role.name,
        'rating': rating,
        'taskCount': taskCount,
        'completedTasks': completedTasks,
        'createdAt': createdAt.toIso8601String(),
        'isVerified': isVerified,
      };

  UserModel copyWith({
    String? id,
    String? phoneNumber,
    String? name,
    String? email,
    String? avatarUrl,
    UserRole? role,
    double? rating,
    int? taskCount,
    int? completedTasks,
    DateTime? createdAt,
    bool? isVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      rating: rating ?? this.rating,
      taskCount: taskCount ?? this.taskCount,
      completedTasks: completedTasks ?? this.completedTasks,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  String get initials {
    if (name == null || name!.isEmpty) return phoneNumber.length > 4 ? phoneNumber.substring(phoneNumber.length - 4) : phoneNumber;
    final parts = name!.trim().split(' ');
    if (parts.length >= 2) return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    return parts.first[0].toUpperCase();
  }
}
