// models/report_model.dart
import 'package:flutter/material.dart';

class TaskReport {
  final Period period;
  final ReportSummary summary;
  final List<TaskDetail> detailed;
  final List<UserReport> userReports;
  final List<ChartData> chartData;

  TaskReport({
    required this.period,
    required this.summary,
    required this.detailed,
    required this.userReports,
    required this.chartData,
  });

  factory TaskReport.fromJson(Map<String, dynamic> json) {
    // Parse period - FIXED: Use cast with type check
    final periodJson = json['period'] is Map ? Map<String, dynamic>.from(json['period'] as Map) : <String, dynamic>{};
    final period = Period.fromJson(periodJson);

    // Parse summary - FIXED: Use cast with type check
    final summaryJson = json['summary'] is Map ? Map<String, dynamic>.from(json['summary'] as Map) : <String, dynamic>{};
    final summary = ReportSummary.fromJson(summaryJson);

    // Parse detailed tasks
    final List<TaskDetail> detailed = [];
    if (json['detailed'] is List) {
      final detailedList = json['detailed'] as List;
      for (var item in detailedList) {
        if (item is Map) {
          try {
            detailed.add(TaskDetail.fromJson(Map<String, dynamic>.from(item)));
          } catch (e) {
            print('Error parsing task detail: $e');
          }
        }
      }
    }

    // Parse user reports
    final List<UserReport> userReports = [];
    if (json['userReports'] is List) {
      final userReportsList = json['userReports'] as List;
      for (var item in userReportsList) {
        if (item is Map) {
          try {
            userReports.add(UserReport.fromJson(Map<String, dynamic>.from(item)));
          } catch (e) {
            print('Error parsing user report: $e');
          }
        }
      }
    }

    // Parse chart data
    final List<ChartData> chartData = [];
    if (json['chartData'] is List) {
      final chartDataList = json['chartData'] as List;
      for (var item in chartDataList) {
        if (item is Map) {
          try {
            chartData.add(ChartData.fromJson(Map<String, dynamic>.from(item)));
          } catch (e) {
            print('Error parsing chart data: $e');
          }
        }
      }
    }

    return TaskReport(
      period: period,
      summary: summary,
      detailed: detailed,
      userReports: userReports,
      chartData: chartData,
    );
  }
}

class Period {
  final String month;
  final String year;
  final DateTime startDate;
  final DateTime endDate;

  Period({
    required this.month,
    required this.year,
    required this.startDate,
    required this.endDate,
  });

  factory Period.fromJson(Map<String, dynamic> json) {
    try {
      return Period(
        month: json['month']?.toString() ?? '',
        year: json['year']?.toString() ?? '',
        startDate: DateTime.parse(json['startDate']?.toString() ?? DateTime.now().toIso8601String()),
        endDate: DateTime.parse(json['endDate']?.toString() ?? DateTime.now().toIso8601String()),
      );
    } catch (e) {
      print('Error parsing Period: $e');
      return Period(
        month: '1',
        year: '2026',
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 31),
      );
    }
  }

  String get formattedPeriod => '${_getMonthName(month)} $year';

  String _getMonthName(String month) {
    try {
      final months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      final index = int.tryParse(month) ?? 1;
      return months[index - 1];
    } catch (e) {
      return 'January';
    }
  }
}

class ReportSummary {
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final int inProgressTasks;
  final int totalHours;
  final double avgProgress;
  final double completionRate;

  ReportSummary({
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.inProgressTasks,
    required this.totalHours,
    required this.avgProgress,
    required this.completionRate,
  });

  factory ReportSummary.fromJson(Map<String, dynamic> json) {
    try {
      return ReportSummary(
        totalTasks: _parseInt(json['totalTasks']),
        completedTasks: _parseInt(json['completedTasks']),
        pendingTasks: _parseInt(json['pendingTasks']),
        inProgressTasks: _parseInt(json['inProgressTasks']),
        totalHours: _parseInt(json['totalHours']),
        avgProgress: _parseDouble(json['avgProgress']),
        completionRate: _parseDouble(json['completionRate']),
      );
    } catch (e) {
      print('Error parsing ReportSummary: $e');
      return ReportSummary(
        totalTasks: 0,
        completedTasks: 0,
        pendingTasks: 0,
        inProgressTasks: 0,
        totalHours: 0,
        avgProgress: 0.0,
        completionRate: 0.0,
      );
    }
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

class TaskDetail {
  final String taskId;
  final String title;
  final String assignedTo;
  final String assignedToEmail;
  final String assignedToRole;
  final String company;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String priority;
  final int progress;
  final int totalHours;
  final int completedSubtasks;
  final int totalSubtasks;
  final DateTime createdAt;

  TaskDetail({
    required this.taskId,
    required this.title,
    required this.assignedTo,
    required this.assignedToEmail,
    required this.assignedToRole,
    required this.company,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.priority,
    required this.progress,
    required this.totalHours,
    required this.completedSubtasks,
    required this.totalSubtasks,
    required this.createdAt,
  });

  factory TaskDetail.fromJson(Map<String, dynamic> json) {
    try {
      // Parse assignedTo object - FIXED: Use safe casting
      Map<String, dynamic> assignedToObj = {};
      if (json['assignedTo'] is Map) {
        assignedToObj = Map<String, dynamic>.from(json['assignedTo'] as Map);
      }

      // Parse company object - FIXED: Use safe casting
      Map<String, dynamic> companyObj = {};
      if (json['company'] is Map) {
        companyObj = Map<String, dynamic>.from(json['company'] as Map);
      }

      return TaskDetail(
        taskId: json['taskId']?.toString() ?? json['_id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        assignedTo: assignedToObj['name']?.toString() ?? '',
        assignedToEmail: assignedToObj['email']?.toString() ?? '',
        assignedToRole: assignedToObj['role']?.toString() ?? '',
        company: companyObj['name']?.toString() ?? '',
        startDate: DateTime.parse(json['startDate']?.toString() ?? DateTime.now().toIso8601String()),
        endDate: DateTime.parse(json['endDate']?.toString() ?? DateTime.now().toIso8601String()),
        status: json['status']?.toString() ?? 'pending',
        priority: json['priority']?.toString() ?? 'medium',
        progress: ReportSummary._parseInt(json['progress']),
        totalHours: ReportSummary._parseInt(json['totalHours']),
        completedSubtasks: ReportSummary._parseInt(json['completedSubtasks']),
        totalSubtasks: ReportSummary._parseInt(json['totalSubtasks']),
        createdAt: DateTime.parse(json['createdAt']?.toString() ?? DateTime.now().toIso8601String()),
      );
    } catch (e) {
      print('Error parsing TaskDetail: $e');
      print('JSON that caused error: $json');
      return TaskDetail(
        taskId: '',
        title: 'Error parsing task',
        assignedTo: '',
        assignedToEmail: '',
        assignedToRole: '',
        company: '',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        status: 'pending',
        priority: 'medium',
        progress: 0,
        totalHours: 0,
        completedSubtasks: 0,
        totalSubtasks: 0,
        createdAt: DateTime.now(),
      );
    }
  }

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in-progress':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  Color get priorityColor {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  String get statusText {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Completed';
      case 'in-progress':
        return 'In Progress';
      default:
        return 'Pending';
    }
  }

  String get priorityText {
    switch (priority.toLowerCase()) {
      case 'high':
        return 'High';
      case 'medium':
        return 'Medium';
      default:
        return 'Low';
    }
  }

  double get subtaskCompletionRate {
    return totalSubtasks > 0 ? (completedSubtasks / totalSubtasks * 100) : 0;
  }
}

class UserReport {
  final String name;
  final String email;
  final int totalTasks;
  final int completedTasks;
  final int totalHours;
  final double avgProgress;

  UserReport({
    required this.name,
    required this.email,
    required this.totalTasks,
    required this.completedTasks,
    required this.totalHours,
    required this.avgProgress,
  });

  factory UserReport.fromJson(Map<String, dynamic> json) {
    try {
      return UserReport(
        name: json['name']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        totalTasks: ReportSummary._parseInt(json['totalTasks']),
        completedTasks: ReportSummary._parseInt(json['completedTasks']),
        totalHours: ReportSummary._parseInt(json['totalHours']),
        avgProgress: ReportSummary._parseDouble(json['avgProgress']),
      );
    } catch (e) {
      print('Error parsing UserReport: $e');
      print('JSON that caused error: $json');
      return UserReport(
        name: 'Error',
        email: '',
        totalTasks: 0,
        completedTasks: 0,
        totalHours: 0,
        avgProgress: 0.0,
      );
    }
  }

  double get completionRate {
    return totalTasks > 0 ? (completedTasks / totalTasks * 100) : 0;
  }

  double get avgHoursPerTask {
    return totalTasks > 0 ? (totalHours / totalTasks) : 0;
  }
}

class ChartData {
  final String name;
  final int value;
  final String color;

  ChartData({
    required this.name,
    required this.value,
    required this.color,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    try {
      return ChartData(
        name: json['name']?.toString() ?? '',
        value: ReportSummary._parseInt(json['value']),
        color: json['color']?.toString() ?? '#000000',
      );
    } catch (e) {
      print('Error parsing ChartData: $e');
      return ChartData(
        name: 'Error',
        value: 0,
        color: '#000000',
      );
    }
  }

  Color get colorValue {
    try {
      String colorStr = color;
      if (colorStr.startsWith('#')) {
        colorStr = '0xFF${colorStr.substring(1)}';
      }
      return Color(int.parse(colorStr));
    } catch (e) {
      return Colors.black;
    }
  }
}