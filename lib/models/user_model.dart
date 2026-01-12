// models/user_model.dart
class User {
  final String id;
  final String name;
  final String email;
  final String? number;
  final String role;
  final Company? company;
  final bool isActive;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? managerId;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.number,
    required this.role,
    this.company,
    required this.isActive,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
    this.managerId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      number: json['number']?.toString(),
      role: json['role'],
      company: json['company'] != null
          ? Company.fromJson(json['company'])
          : null,
      isActive: json['isActive'] ?? true,
      profileImage: json['profileImage'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      managerId: json['manager']?['_id'],
    );
  }
}

class Company {
  final String id;
  final String name;

  Company({required this.id, required this.name});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['_id'],
      name: json['name'],
    );
  }
}