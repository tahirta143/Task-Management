// models/company_model.dart
import 'dart:convert';

class CreatedBy {
  final String id;
  final String name;
  final String email;

  CreatedBy({
    required this.id,
    required this.name,
    required this.email,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
    };
  }
}

class Company {
  final String id;
  final String name;
  final String description;
  final String address;
  final String phone;
  final String email;
  final CreatedBy? createdBy;
  final bool isActive;
  final int totalUser;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  Company({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.email,
    this.createdBy,
    required this.isActive,
    required this.totalUser,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      createdBy: json['createdBy'] != null
          ? CreatedBy.fromJson(json['createdBy'])
          : null,
      isActive: json['isActive'] ?? false,
      totalUser: json['totalUser'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'address': address,
      'phone': phone,
      'email': email,
      'createdBy': createdBy?.toJson(),
      'isActive': isActive,
      'totalUser': totalUser,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
  }

  // Helper method for creating empty/dummy companies
  static Company empty() {
    return Company(
      id: '',
      name: '',
      description: '',
      address: '',
      phone: '',
      email: '',
      createdBy: null,
      isActive: false,
      totalUser: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      version: 0,
    );
  }

  // Helper method for creating placeholder
  static Company placeholder({String name = 'Loading...'}) {
    return Company(
      id: '',
      name: name,
      description: '',
      address: '',
      phone: '',
      email: '',
      createdBy: null,
      isActive: false,
      totalUser: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      version: 0,
    );
  }

  // Copy with method for updates
  Company copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    String? phone,
    String? email,
    CreatedBy? createdBy,
    bool? isActive,
    int? totalUser,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      createdBy: createdBy ?? this.createdBy,
      isActive: isActive ?? this.isActive,
      totalUser: totalUser ?? this.totalUser,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}

class CompanyListResponse {
  final bool success;
  final int count;
  final List<Company> companies;
  final String userRole;
  final Map<String, dynamic> filters;

  CompanyListResponse({
    required this.success,
    required this.count,
    required this.companies,
    required this.userRole,
    required this.filters,
  });

  factory CompanyListResponse.fromJson(Map<String, dynamic> json) {
    return CompanyListResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      companies: (json['companies'] as List<dynamic>?)
          ?.map((companyJson) => Company.fromJson(companyJson))
          .toList() ??
          [],
      userRole: json['userRole'] ?? '',
      filters: json['filters'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'companies': companies.map((company) => company.toJson()).toList(),
      'userRole': userRole,
      'filters': filters,
    };
  }
}