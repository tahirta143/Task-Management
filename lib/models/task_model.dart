// // models/task_model.dart
// import 'dart:convert';
//
// class AssignedUser {
//   final String id;
//   final String name;
//   final String email;
//
//   AssignedUser({
//     required this.id,
//     required this.name,
//     required this.email,
//   });
//
//   factory AssignedUser.fromJson(Map<String, dynamic> json) {
//     return AssignedUser(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       email: json['email'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'name': name,
//       'email': email,
//     };
//   }
//
//   AssignedUser copyWith({
//     String? id,
//     String? name,
//     String? email,
//   }) {
//     return AssignedUser(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       email: email ?? this.email,
//     );
//   }
//
//   static AssignedUser empty() {
//     return AssignedUser(
//       id: '',
//       name: '',
//       email: '',
//     );
//   }
// }// In task_model.dart, update the Day class
// class Day {
//   DateTime date;
//   List<SubTask> subTasks;
//
//   Day({
//     required this.date,
//     required this.subTasks,
//   });
//
//   // Add fromJson constructor
//   factory Day.fromJson(Map<String, dynamic> json) {
//     // Parse date
//     DateTime date;
//     if (json['date'] is String) {
//       date = DateTime.parse(json['date']).toLocal();
//     } else {
//       date = DateTime.now();
//     }
//
//     // Parse subTasks
//     List<SubTask> subTasks = [];
//     if (json['subTasks'] != null && json['subTasks'] is List) {
//       subTasks = (json['subTasks'] as List).map((subTaskJson) {
//         return SubTask.fromJson(subTaskJson);
//       }).toList();
//     }
//
//     return Day(
//       date: date,
//       subTasks: subTasks,
//     );
//   }
//
//   // Add toJson method
//   Map<String, dynamic> toJson() {
//     return {
//       'date': date.toIso8601String(),
//       'subTasks': subTasks.map((subTask) => subTask.toJson()).toList(),
//     };
//   }
// }
//
// class Company {
//   final String id;
//   final String name;
//
//   Company({
//     required this.id,
//     required this.name,
//   });
//
//   factory Company.fromJson(Map<String, dynamic> json) {
//     return Company(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'name': name,
//     };
//   }
//
//   Company copyWith({
//     String? id,
//     String? name,
//   }) {
//     return Company(
//       id: id ?? this.id,
//       name: name ?? this.name,
//     );
//   }
//
//   static Company empty() {
//     return Company(
//       id: '',
//       name: '',
//     );
//   }
// }
//
// class SubTask {
//   final String id;
//   final DateTime date;
//   final String description;
//   final String status;
//   final int hoursSpent;
//   final String remarks;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//
//   SubTask({
//     required this.id,
//     required this.date,
//     required this.description,
//     required this.status,
//     required this.hoursSpent,
//     required this.remarks,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory SubTask.fromJson(Map<String, dynamic> json) {
//     return SubTask(
//       id: json['_id'] ?? '',
//       date: json['date'] != null
//           ? DateTime.parse(json['date']).toLocal()
//           : DateTime.now(),
//       description: json['description'] ?? '',
//       status: json['status'] ?? 'pending',
//       hoursSpent: json['hoursSpent'] ?? 0,
//       remarks: json['remarks'] ?? '',
//       createdAt: json['createdAt'] != null
//           ? DateTime.parse(json['createdAt']).toLocal()
//           : null,
//       updatedAt: json['updatedAt'] != null
//           ? DateTime.parse(json['updatedAt']).toLocal()
//           : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'date': date.toIso8601String(),
//       'description': description,
//       'status': status,
//       'hoursSpent': hoursSpent,
//       'remarks': remarks,
//       if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
//       if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
//     };
//   }
//
//   SubTask copyWith({
//     String? id,
//     DateTime? date,
//     String? description,
//     String? status,
//     int? hoursSpent,
//     String? remarks,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) {
//     return SubTask(
//       id: id ?? this.id,
//       date: date ?? this.date,
//       description: description ?? this.description,
//       status: status ?? this.status,
//       hoursSpent: hoursSpent ?? this.hoursSpent,
//       remarks: remarks ?? this.remarks,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }
//
//   static SubTask empty() {
//     return SubTask(
//       id: '',
//       date: DateTime.now(),
//       description: '',
//       status: 'pending',
//       hoursSpent: 0,
//       remarks: '',
//     );
//   }
// }
//
// class Task {
//   final String id;
//   final String title;
//   final String description;
//   final Company company;
//   final AssignedUser assignedTo;
//   final AssignedUser assignedBy;
//   final DateTime startDate;
//   final DateTime endDate;
//   final String priority; // 'low', 'medium', 'high'
//   final String status; // 'pending', 'in-progress', 'completed'
//   final int progress;
//   final List<String> tags;
//   final List<SubTask> subTasks;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final int version;
//   final List<dynamic> days;
//
//   final int completedSubtasks;
//   final int totalSubtasks;
//
//   Task({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.company,
//     required this.assignedTo,
//     required this.assignedBy,
//     required this.startDate,
//     required this.endDate,
//     required this.priority,
//     required this.status,
//     required this.progress,
//     required this.tags,
//     required this.subTasks,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.version,
//     this.days = const [],
//     this.completedSubtasks = 0,
//     this.totalSubtasks = 0,
//   });
//
//   factory Task.fromJson(Map<String, dynamic> json) {
//     return Task(
//       id: json['_id'] ?? '',
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       company: Company.fromJson(json['company'] ?? {}),
//       assignedTo: AssignedUser.fromJson(json['assignedTo'] ?? {}),
//       assignedBy: AssignedUser.fromJson(json['assignedBy'] ?? {}),
//       startDate: json['startDate'] != null
//           ? DateTime.parse(json['startDate']).toLocal()
//           : DateTime.now(),
//       endDate: json['endDate'] != null
//           ? DateTime.parse(json['endDate']).toLocal()
//           : DateTime.now(),
//       priority: json['priority'] ?? 'medium',
//       status: json['status'] ?? 'pending',
//       progress: json['progress'] ?? 0,
//       tags: List<String>.from(json['tags'] ?? []),
//       subTasks: List<SubTask>.from(
//         (json['subTasks'] ?? []).map((x) => SubTask.fromJson(x)),
//       ),
//       days: json['days'] ?? [],
//       createdAt: json['createdAt'] != null
//           ? DateTime.parse(json['createdAt']).toLocal()
//           : DateTime.now(),
//       updatedAt: json['updatedAt'] != null
//           ? DateTime.parse(json['updatedAt']).toLocal()
//           : DateTime.now(),
//       version: json['__v'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'title': title,
//       'description': description,
//       'company': company.toJson(),
//       'assignedTo': assignedTo.toJson(),
//       'assignedBy': assignedBy.toJson(),
//       'startDate': startDate.toIso8601String(),
//       'endDate': endDate.toIso8601String(),
//       'priority': priority,
//       'status': status,
//       'progress': progress,
//       'tags': tags,
//       'subTasks': subTasks.map((task) => task.toJson()).toList(),
//       'days': days,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//       '__v': version,
//     };
//   }
//
//   Map<String, dynamic> toCreateJson() {
//     return {
//       'title': title,
//       'description': description,
//       'company': company.id,
//       'assignedTo': assignedTo.id,
//       'assignedBy': assignedBy.id,
//       'startDate': startDate.toIso8601String(),
//       'endDate': endDate.toIso8601String(),
//       'priority': priority,
//       'status': status,
//       'progress': progress,
//       'tags': tags,
//       'subTasks': subTasks.map((task) => task.toJson()).toList(),
//     };
//   }
//
//   Task copyWith({
//     String? id,
//     String? title,
//     String? description,
//     Company? company,
//     AssignedUser? assignedTo,
//     AssignedUser? assignedBy,
//     DateTime? startDate,
//     DateTime? endDate,
//     String? priority,
//     String? status,
//     int? progress,
//     List<String>? tags,
//     List<SubTask>? subTasks,
//     List<dynamic>? days,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//     int? version, required int completedSubtasks, required int totalSubtasks,
//   }) {
//     return Task(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       company: company ?? this.company,
//       assignedTo: assignedTo ?? this.assignedTo,
//       assignedBy: assignedBy ?? this.assignedBy,
//       startDate: startDate ?? this.startDate,
//       endDate: endDate ?? this.endDate,
//       priority: priority ?? this.priority,
//       status: status ?? this.status,
//       progress: progress ?? this.progress,
//       tags: tags ?? this.tags,
//       subTasks: subTasks ?? this.subTasks,
//       days: days ?? this.days,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//       version: version ?? this.version,
//     );
//   }
//
//   static Task empty() {
//     return Task(
//       id: '',
//       title: '',
//       description: '',
//       company: Company.empty(),
//       assignedTo: AssignedUser.empty(),
//       assignedBy: AssignedUser.empty(),
//       startDate: DateTime.now(),
//       endDate: DateTime.now(),
//       priority: 'medium',
//       status: 'pending',
//       progress: 0,
//       tags: [],
//       subTasks: [],
//       days: [],
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//       version: 0,
//     );
//   }
//
//   // Helper methods
//   double get completionPercentage {
//     if (subTasks.isEmpty) return progress / 100.0;
//
//     final completedSubTasks = subTasks.where((st) => st.status == 'completed').length;
//     return completedSubTasks / subTasks.length;
//   }
//
//   int get totalHoursSpent {
//     return subTasks.fold(0, (sum, subtask) => sum + subtask.hoursSpent);
//   }
//
//   int get completedSubTasks {
//     return subTasks.where((st) => st.status == 'completed').length;
//   }
//
//   int get inProgressSubTasks {
//     return subTasks.where((st) => st.status == 'in-progress').length;
//   }
//
//   int get pendingSubTasks {
//     return subTasks.where((st) => st.status == 'pending').length;
//   }
// }
//
// class TaskListResponse {
//   final bool success;
//   final List<Task> tasks;
//   final int total;
//   final int pages;
//   final int page;
//
//   TaskListResponse({
//     required this.success,
//     required this.tasks,
//     required this.total,
//     required this.pages,
//     required this.page,
//   });
//
//   factory TaskListResponse.fromJson(Map<String, dynamic> json) {
//     return TaskListResponse(
//       success: json['success'] ?? false,
//       tasks: List<Task>.from(
//         (json['data'] ?? json['tasks'] ?? []).map((x) => Task.fromJson(x)),
//       ),
//       total: json['total'] ?? (json['data'] != null ? (json['data'] as List).length : 0),
//       pages: json['pages'] ?? 1,
//       page: json['page'] ?? 1,
//     );
//   }
// }


// models/task_model.dart
import 'dart:convert';

// models/task_model.dart - Update User class
class User {
  final String id;
  final String name;
  final String email;
  final String role; // Add this field

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role, // Add this
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'member', // Default to 'member'
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role, // Add this
    };
  }

  // Helper getters
  bool get isAdmin => role == 'admin';
  bool get isManager => role == 'manager';
  bool get canEditTasks => isAdmin || isManager;
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
  final String description;
  final String status;
  final int hoursSpent;
  final String remarks;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubTask({
    required this.id,
    required this.description,
    required this.status,
    required this.hoursSpent,
    required this.remarks,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      id: json['_id'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'pending',
      hoursSpent: json['hoursSpent'] ?? 0,
      remarks: json['remarks'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'description': description,
      'status': status,
      'hoursSpent': hoursSpent,
      'remarks': remarks,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  SubTask copyWith({
    String? id,
    String? description,
    String? status,
    int? hoursSpent,
    String? remarks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubTask(
      id: id ?? this.id,
      description: description ?? this.description,
      status: status ?? this.status,
      hoursSpent: hoursSpent ?? this.hoursSpent,
      remarks: remarks ?? this.remarks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class DayEntry {
  final DateTime date;
  final List<SubTask> subTasks;

  DayEntry({
    required this.date,
    required this.subTasks,
  });

  factory DayEntry.fromJson(Map<String, dynamic> json) {
    return DayEntry(
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      subTasks: List<SubTask>.from(
        (json['subTasks'] ?? []).map((x) => SubTask.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'subTasks': subTasks.map((task) => task.toJson()).toList(),
    };
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
  final List<DayEntry> days;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  // Helper getter to get all subtasks from all days
  List<SubTask> get allSubTasks {
    return days.expand((day) => day.subTasks).toList();
  }

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
    required this.days,
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
      days: List<DayEntry>.from(
        (json['days'] ?? []).map((x) => DayEntry.fromJson(x)),
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
      'company': company.toJson(),
      'assignedTo': assignedTo.toJson(),
      'assignedBy': assignedBy.toJson(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'priority': priority,
      'status': status,
      'progress': progress,
      'tags': tags,
      'days': days.map((day) => day.toJson()).toList(),
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
    List<DayEntry>? days,
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
      days: days ?? this.days,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }

  // Helper method to calculate total hours spent on all subtasks
  int get totalHoursSpent {
    return allSubTasks.fold(0, (sum, subtask) => sum + subtask.hoursSpent);
  }

  // Helper method to get subtasks by status
  List<SubTask> getSubTasksByStatus(String status) {
    return allSubTasks.where((subtask) => subtask.status == status).toList();
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

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'total': total,
      'pages': pages,
      'page': page,
    };
  }
}