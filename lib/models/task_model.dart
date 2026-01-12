// models/task_model.dart
import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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

  Company({
    required this.id,
    required this.name,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}

class SubTask {
  final String id;
  final DateTime date;
  final String description;
  final String status;
  final int hoursSpent;
  final String remarks;

  SubTask({
    required this.id,
    required this.date,
    required this.description,
    required this.status,
    required this.hoursSpent,
    required this.remarks,
  });

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      id: json['_id'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      description: json['description'] ?? '',
      status: json['status'] ?? 'pending',
      hoursSpent: json['hoursSpent'] ?? 0,
      remarks: json['remarks'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'date': date.toIso8601String(),
      'description': description,
      'status': status,
      'hoursSpent': hoursSpent,
      'remarks': remarks,
    };
  }

  SubTask copyWith({
    String? id,
    DateTime? date,
    String? description,
    String? status,
    int? hoursSpent,
    String? remarks,
  }) {
    return SubTask(
      id: id ?? this.id,
      date: date ?? this.date,
      description: description ?? this.description,
      status: status ?? this.status,
      hoursSpent: hoursSpent ?? this.hoursSpent,
      remarks: remarks ?? this.remarks,
    );
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final Company company;
  final User assignedTo;
  final User assignedBy;
  final DateTime startDate;
  final DateTime endDate;
  final String priority; // 'low', 'medium', 'high'
  final String status; // 'pending', 'in-progress', 'completed'
  final int progress;
  final List<String> tags;
  final List<SubTask> subTasks;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.company,
    required this.assignedTo,
    required this.assignedBy,
    required this.startDate,
    required this.endDate,
    required this.priority,
    required this.status,
    required this.progress,
    required this.tags,
    required this.subTasks,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      company: Company.fromJson(json['company'] ?? {}),
      assignedTo: User.fromJson(json['assignedTo'] ?? {}),
      assignedBy: User.fromJson(json['assignedBy'] ?? {}),
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : DateTime.now(),
      priority: json['priority'] ?? 'medium',
      status: json['status'] ?? 'pending',
      progress: json['progress'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      subTasks: List<SubTask>.from(
        (json['subTasks'] ?? []).map((x) => SubTask.fromJson(x)),
      ),
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
      'title': title,
      'description': description,
      'company': company.id,
      'assignedTo': assignedTo.id,
      'assignedBy': assignedBy.id,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'priority': priority,
      'status': status,
      'progress': progress,
      'tags': tags,
      'subTasks': subTasks.map((task) => task.toJson()).toList(),
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    Company? company,
    User? assignedTo,
    User? assignedBy,
    DateTime? startDate,
    DateTime? endDate,
    String? priority,
    String? status,
    int? progress,
    List<String>? tags,
    List<SubTask>? subTasks,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      company: company ?? this.company,
      assignedTo: assignedTo ?? this.assignedTo,
      assignedBy: assignedBy ?? this.assignedBy,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      tags: tags ?? this.tags,
      subTasks: subTasks ?? this.subTasks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}

class TaskListResponse {
  final bool success;
  final List<Task> tasks;
  final int total;
  final int pages;
  final int page;

  TaskListResponse({
    required this.success,
    required this.tasks,
    required this.total,
    required this.pages,
    required this.page,
  });

  factory TaskListResponse.fromJson(Map<String, dynamic> json) {
    return TaskListResponse(
      success: json['success'] ?? false,
      tasks: List<Task>.from(
        (json['tasks'] ?? []).map((x) => Task.fromJson(x)),
      ),
      total: json['total'] ?? 0,
      pages: json['pages'] ?? 1,
      page: json['page'] ?? 1,
    );
  }
}