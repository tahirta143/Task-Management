class DashboardStats {
  final Tasks tasks;
  final Subtasks subtasks;
  final Summary summary;
  final List<RecentTask> recentTasks;

  DashboardStats({
    required this.tasks,
    required this.subtasks,
    required this.summary,
    required this.recentTasks,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      tasks: Tasks.fromJson(json['tasks'] ?? {}),
      subtasks: Subtasks.fromJson(json['subtasks'] ?? {}),
      summary: Summary.fromJson(json['summary'] ?? {}),
      recentTasks: List<RecentTask>.from(
        (json['recentTasks'] ?? []).map((x) => RecentTask.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tasks': tasks.toJson(),
      'subtasks': subtasks.toJson(),
      'summary': summary.toJson(),
      'recentTasks': recentTasks.map((x) => x.toJson()).toList(),
    };
  }
}

class Tasks {
  final int total;
  final int completed;
  final int pending;
  final int inProgress;
  final int delayed;

  Tasks({
    required this.total,
    required this.completed,
    required this.pending,
    required this.inProgress,
    required this.delayed,
  });

  factory Tasks.fromJson(Map<String, dynamic> json) {
    return Tasks(
      total: json['total'] ?? 0,
      completed: json['completed'] ?? 0,
      pending: json['pending'] ?? 0,
      inProgress: json['inProgress'] ?? 0,
      delayed: json['delayed'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'completed': completed,
      'pending': pending,
      'inProgress': inProgress,
      'delayed': delayed,
    };
  }
}

class Subtasks {
  final int total;
  final int completed;
  final int pending;
  final int inProgress;
  final int delayed;

  Subtasks({
    required this.total,
    required this.completed,
    required this.pending,
    required this.inProgress,
    required this.delayed,
  });

  factory Subtasks.fromJson(Map<String, dynamic> json) {
    return Subtasks(
      total: json['total'] ?? 0,
      completed: json['completed'] ?? 0,
      pending: json['pending'] ?? 0,
      inProgress: json['inProgress'] ?? 0,
      delayed: json['delayed'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'completed': completed,
      'pending': pending,
      'inProgress': inProgress,
      'delayed': delayed,
    };
  }
}

class Summary {
  final int totalWork;
  final int completedWork;
  final double productivity;

  Summary({
    required this.totalWork,
    required this.completedWork,
    required this.productivity,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalWork: json['totalWork'] ?? 0,
      completedWork: json['completedWork'] ?? 0,
      productivity: (json['productivity'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalWork': totalWork,
      'completedWork': completedWork,
      'productivity': productivity,
    };
  }
}

class RecentTask {
  final String id;
  final String title;
  final String description;
  final Company company;
  final AssignedUser assignedTo;
  final AssignedUser assignedBy;
  final DateTime startDate;
  final DateTime endDate;
  final String priority;
  final String status;
  final int progress;
  final List<dynamic> tags;
  final List<Day> days;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  RecentTask({
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

  factory RecentTask.fromJson(Map<String, dynamic> json) {
    return RecentTask(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      company: Company.fromJson(json['company'] ?? {}),
      assignedTo: AssignedUser.fromJson(json['assignedTo'] ?? {}),
      assignedBy: AssignedUser.fromJson(json['assignedBy'] ?? {}),
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toIso8601String()),
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      progress: json['progress'] ?? 0,
      tags: json['tags'] ?? [],
      days: List<Day>.from(
        (json['days'] ?? []).map((x) => Day.fromJson(x)),
      ),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
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
      'days': days.map((x) => x.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
  }
}

class Day {
  final DateTime date;
  final List<SubTask> subTasks;

  Day({
    required this.date,
    required this.subTasks,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      subTasks: List<SubTask>.from(
        (json['subTasks'] ?? []).map((x) => SubTask.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'subTasks': subTasks.map((x) => x.toJson()).toList(),
    };
  }
}

class SubTask {
  final String id;
  final String description;
  final int hoursSpent;
  final String remarks;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubTask({
    required this.id,
    required this.description,
    required this.hoursSpent,
    required this.remarks,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      id: json['_id'] ?? '',
      description: json['description'] ?? '',
      hoursSpent: json['hoursSpent'] ?? 0,
      remarks: json['remarks'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'description': description,
      'hoursSpent': hoursSpent,
      'remarks': remarks,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
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

class AssignedUser {
  final String id;
  final String name;
  final String? email;

  AssignedUser({
    required this.id,
    required this.name,
    this.email,
  });

  factory AssignedUser.fromJson(Map<String, dynamic> json) {
    return AssignedUser(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
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

// Helper class to parse the entire API response
class DashboardResponse {
  final bool success;
  final DashboardStats data;

  DashboardResponse({
    required this.success,
    required this.data,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      success: json['success'] ?? false,
      data: DashboardStats.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
    };
  }
}