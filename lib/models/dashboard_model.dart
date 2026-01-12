class DashboardStats {
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final int inProgressTasks;
  final int delayedTasks;
  final int teamMembers;
  final int activeCompanies;
  final double productivity;
  final List<ChartData> chartData;
  final List<RecentActivity> recentActivities;
  final List<RecentTask> recentTasks;
  final Summary summary;

  DashboardStats({
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.inProgressTasks,
    required this.delayedTasks,
    required this.teamMembers,
    required this.activeCompanies,
    required this.productivity,
    required this.chartData,
    required this.recentActivities,
    required this.recentTasks,
    required this.summary,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalTasks: json['totalTasks'] ?? 0,
      completedTasks: json['completedTasks'] ?? 0,
      pendingTasks: json['pendingTasks'] ?? 0,
      inProgressTasks: json['inProgressTasks'] ?? 0,
      delayedTasks: json['delayedTasks'] ?? 0,
      teamMembers: json['teamMembers'] ?? 0,
      activeCompanies: json['activeCompanies'] ?? 0,
      productivity: json['productivity']?.toDouble() ?? 0.0,
      chartData: List<ChartData>.from(
        (json['chartData'] ?? []).map((x) => ChartData.fromJson(x)),
      ),
      recentActivities: List<RecentActivity>.from(
        (json['recentActivities'] ?? []).map((x) => RecentActivity.fromJson(x)),
      ),
      recentTasks: List<RecentTask>.from(
        (json['recentTasks'] ?? []).map((x) => RecentTask.fromJson(x)),
      ),
      summary: Summary.fromJson(json['summary'] ?? {}),
    );
  }
}

class ChartData {
  final String name;
  final int completed;
  final int pending;
  final int inProgress;
  final int delayed;

  ChartData({
    required this.name,
    required this.completed,
    required this.pending,
    required this.inProgress,
    required this.delayed,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      name: json['name'] ?? '',
      completed: json['completed'] ?? 0,
      pending: json['pending'] ?? 0,
      inProgress: json['inProgress'] ?? 0,
      delayed: json['delayed'] ?? 0,
    );
  }
}

class RecentActivity {
  final String id;
  final String type;
  final String user;
  final String? task;
  final String? target;
  final String description;
  final DateTime timestamp;

  RecentActivity({
    required this.id,
    required this.type,
    required this.user,
    this.task,
    this.target,
    required this.description,
    required this.timestamp,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      user: json['user'] ?? '',
      task: json['task'],
      target: json['target'],
      description: json['description'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
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
  final List<SubTask> subTasks;
  final DateTime createdAt;

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
    required this.subTasks,
    required this.createdAt,
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
      subTasks: List<SubTask>.from(
        (json['subTasks'] ?? []).map((x) => SubTask.fromJson(x)),
      ),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class Company {
  final String id;
  final String name;

  Company({required this.id, required this.name});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class AssignedUser {
  final String id;
  final String name;
  final String email;

  AssignedUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory AssignedUser.fromJson(Map<String, dynamic> json) {
    return AssignedUser(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
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
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      hoursSpent: json['hoursSpent'] ?? 0,
      remarks: json['remarks'] ?? '',
    );
  }
}

class Summary {
  final int total;
  final int completed;
  final int pending;
  final int inProgress;
  final int delayed;
  final int completionRate;

  Summary({
    required this.total,
    required this.completed,
    required this.pending,
    required this.inProgress,
    required this.delayed,
    required this.completionRate,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      total: json['total'] ?? 0,
      completed: json['completed'] ?? 0,
      pending: json['pending'] ?? 0,
      inProgress: json['inProgress'] ?? 0,
      delayed: json['delayed'] ?? 0,
      completionRate: json['completionRate'] ?? 0,
    );
  }
}