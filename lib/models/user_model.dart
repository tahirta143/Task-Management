// // models/user_model.dart
// class User {
//   final String id;
//   final String name;
//   final String email;
//   final String? number;
//   final String role;
//   final Company? company;
//   final bool isActive;
//   final String? profileImage;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final String? managerId;
//
//   User({
//     required this.id,
//     required this.name,
//     required this.email,
//     this.number,
//     required this.role,
//     this.company,
//     required this.isActive,
//     this.profileImage,
//     required this.createdAt,
//     required this.updatedAt,
//     this.managerId,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['_id'],
//       name: json['name'],
//       email: json['email'],
//       number: json['number']?.toString(),
//       role: json['role'],
//       company: json['company'] != null
//           ? Company.fromJson(json['company'])
//           : null,
//       isActive: json['isActive'] ?? true,
//       profileImage: json['profileImage'] ?? '',
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//       managerId: json['manager']?['_id'],
//     );
//   }
// }
//
// class Company {
//   final String id;
//   final String name;
//
//   Company({required this.id, required this.name});
//
//   factory Company.fromJson(Map<String, dynamic> json) {
//     return Company(
//       id: json['_id'],
//       name: json['name'],
//     );
//   }
// }
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

  // Add this getter to easily access company ID
  String? get companyId => company?.id;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      number: json['number']?.toString(),
      role: json['role'] ?? '',
      company: json['company'] != null
          ? Company.fromJson(json['company'])
          : null,
      isActive: json['isActive'] ?? true,
      profileImage: json['profileImage'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      managerId: json['manager']?['_id'],
    );
  }

  // Add this method for debugging
  Map<String, dynamic> toDebugMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'companyId': companyId,
      'companyName': company?.name,
      'isActive': isActive,
    };
  }
}

class Company {
  final String id;
  final String name;

  Company({required this.id, required this.name});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}