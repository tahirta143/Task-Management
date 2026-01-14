import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/report_model.dart';

class ReportProvider with ChangeNotifier {
  // State variables
  TaskReport? _report;
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  // Filter variables
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  String? _selectedUserId;
  String? _selectedCompanyId;
  String? _selectedStatus;
  String? _selectedPriority;
  String _searchQuery = '';

  // Getters
  TaskReport? get report => _report;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;

  // Filter getters
  int get selectedMonth => _selectedMonth;
  int get selectedYear => _selectedYear;
  String? get selectedUserId => _selectedUserId;
  String? get selectedCompanyId => _selectedCompanyId;
  String? get selectedStatus => _selectedStatus;
  String? get selectedPriority => _selectedPriority;
  String get searchQuery => _searchQuery;

  // Debug method to print report data
  void _debugPrintReport() {
    if (_report != null) {
      print('=== REPORT DATA DEBUG ===');
      print('Period: ${_report!.period.formattedPeriod}');
      print('Summary:');
      print('  Total Tasks: ${_report!.summary.totalTasks}');
      print('  Completed: ${_report!.summary.completedTasks}');
      print('Detailed tasks count: ${_report!.detailed.length}');

      if (_report!.detailed.isNotEmpty) {
        print('Sample tasks:');
        for (int i = 0; i < min(3, _report!.detailed.length); i++) {
          final task = _report!.detailed[i];
          print('  Task ${i + 1}:');
          print('    ID: ${task.taskId}');
          print('    Title: ${task.title}');
          print('    AssignedTo: ${task.assignedTo}');
          print('    Email: ${task.assignedToEmail}');
          print('    Company: ${task.company}');
          print('    Status: ${task.status}');
        }
      }
      print('User reports count: ${_report!.userReports.length}');
      print('Chart data count: ${_report!.chartData.length}');
      print('=== END DEBUG ===');
    }
  }

  int min(int a, int b) => a < b ? a : b;

  // Get filtered data
  List<TaskDetail> get filteredDetailedTasks {
    if (_report == null) return [];

    return _report!.detailed.where((task) {
      bool matchesAll = true;

      // Apply user filter
      if (_selectedUserId != null && _selectedUserId!.isNotEmpty) {
        final userMatch = task.assignedTo.toLowerCase().contains(_selectedUserId!.toLowerCase()) ||
            task.assignedToEmail.toLowerCase().contains(_selectedUserId!.toLowerCase());
        matchesAll = matchesAll && userMatch;
      }

      // Apply company filter
      if (_selectedCompanyId != null && _selectedCompanyId!.isNotEmpty) {
        final companyMatch = task.company.toLowerCase().contains(_selectedCompanyId!.toLowerCase());
        matchesAll = matchesAll && companyMatch;
      }

      // Apply status filter
      if (_selectedStatus != null && _selectedStatus!.isNotEmpty && _selectedStatus != 'All') {
        final statusMatch = task.status.toLowerCase() == _selectedStatus!.toLowerCase();
        matchesAll = matchesAll && statusMatch;
      }

      // Apply priority filter
      if (_selectedPriority != null && _selectedPriority!.isNotEmpty && _selectedPriority != 'All') {
        final priorityMatch = task.priority.toLowerCase() == _selectedPriority!.toLowerCase();
        matchesAll = matchesAll && priorityMatch;
      }

      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        final searchMatch = task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            task.assignedTo.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            task.company.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            task.assignedToEmail.toLowerCase().contains(_searchQuery.toLowerCase());
        matchesAll = matchesAll && searchMatch;
      }

      return matchesAll;
    }).toList();
  }

  List<UserReport> get filteredUserReports {
    if (_report == null) return [];

    return _report!.userReports.where((user) {
      if (_searchQuery.isEmpty) return true;

      return user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.email.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  // Get summary for filtered tasks
  ReportSummary get filteredSummary {
    final filteredTasks = filteredDetailedTasks;

    if (filteredTasks.isEmpty) {
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

    final completedTasks = filteredTasks.where((t) => t.status.toLowerCase() == 'completed').length;
    final pendingTasks = filteredTasks.where((t) => t.status.toLowerCase() == 'pending').length;
    final inProgressTasks = filteredTasks.where((t) => t.status.toLowerCase() == 'in-progress').length;
    final totalHours = filteredTasks.fold(0, (sum, task) => sum + task.totalHours);

    final avgProgress = filteredTasks.isNotEmpty
        ? filteredTasks.fold(0.0, (sum, task) => sum + task.progress) / filteredTasks.length
        : 0.0;

    final completionRate = filteredTasks.isNotEmpty
        ? (completedTasks / filteredTasks.length * 100.0)
        : 0.0;

    return ReportSummary(
      totalTasks: filteredTasks.length,
      completedTasks: completedTasks,
      pendingTasks: pendingTasks,
      inProgressTasks: inProgressTasks,
      totalHours: totalHours,
      avgProgress: avgProgress,
      completionRate: completionRate,
    );
  }

  // Get filtered chart data
  List<ChartData> get filteredChartData {
    final filteredTasks = filteredDetailedTasks;

    final completed = filteredTasks.where((t) => t.status.toLowerCase() == 'completed').length;
    final inProgress = filteredTasks.where((t) => t.status.toLowerCase() == 'in-progress').length;
    final pending = filteredTasks.where((t) => t.status.toLowerCase() == 'pending').length;

    return [
      ChartData(name: 'Completed', value: completed, color: '#4CAF50'),
      ChartData(name: 'In Progress', value: inProgress, color: '#2196F3'),
      ChartData(name: 'Pending', value: pending, color: '#FF9800'),
    ];
  }

  // Get unique values for filters
  List<String> get uniqueCompanies {
    if (_report == null) return [];
    final companies = _report!.detailed
        .map((task) => task.company)
        .where((company) => company != null && company.isNotEmpty)
        .toSet()
        .toList();
    companies.sort();
    return companies;
  }

  List<String> get uniqueUsers {
    if (_report == null) return [];
    final users = _report!.detailed
        .map((task) => task.assignedTo)
        .where((user) => user != null && user.isNotEmpty)
        .toSet()
        .toList();
    users.sort();
    return users;
  }

  List<String> get uniqueStatuses => ['All', 'pending', 'in-progress', 'completed'];
  List<String> get uniquePriorities => ['All', 'low', 'medium', 'high'];

  // Helper method to get token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Fetch report with filters
  Future<void> fetchReport() async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Authentication required. Please login again.');
      }

      // Build query parameters
      final params = <String, String>{
        'month': _selectedMonth.toString(),
        'year': _selectedYear.toString(),
      };

      // Build URL with query parameters
      final uri = Uri.parse('https://task-management-backend-bn2k.vercel.app/api/tasks/reports')
          .replace(queryParameters: params);

      print('Fetching report from: ${uri.toString()}');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body.substring(0, min(500, response.body.length))}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response keys: ${data.keys.toList()}');

        if (data is Map<String, dynamic> && data['success'] == true) {
          if (!data.containsKey('report')) {
            throw Exception('Report data not found in response');
          }

          final reportData = data['report'] as Map<String, dynamic>;
          print('Report data keys: ${reportData.keys.toList()}');

          try {
            _report = TaskReport.fromJson(reportData);
            _successMessage = 'Report loaded successfully';

            // Debug the parsed data
            _debugPrintReport();

          } catch (e) {
            print('✗ Error parsing report: $e');
            print('Stack trace: ${e.toString()}');
            throw Exception('Failed to parse report data: $e');
          }
        } else {
          final errorMessage = data['message']?.toString() ?? 'Invalid response format';
          throw Exception(errorMessage);
        }
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('You don\'t have permission to view reports');
      } else if (response.statusCode == 404) {
        throw Exception('Report not found for the selected period');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _error = e.toString();
      print('Error fetching report: $e');

      // Clear report on error
      _report = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Set filter methods
  void setMonth(int month) {
    _selectedMonth = month;
    notifyListeners();
  }

  void setYear(int year) {
    _selectedYear = year;
    notifyListeners();
  }

  void setUserId(String? userId) {
    _selectedUserId = userId;
    notifyListeners();
  }

  void setCompanyId(String? companyId) {
    _selectedCompanyId = companyId;
    notifyListeners();
  }

  void setStatus(String? status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void setPriority(String? priority) {
    _selectedPriority = priority;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Clear all filters
  void clearFilters() {
    _selectedMonth = DateTime.now().month;
    _selectedYear = DateTime.now().year;
    _selectedUserId = null;
    _selectedCompanyId = null;
    _selectedStatus = null;
    _selectedPriority = null;
    _searchQuery = '';
    notifyListeners();
  }

  // Clear messages
  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }

  // Get years list (current year and previous 5 years)
  List<int> get availableYears {
    final currentYear = DateTime.now().year;
    return List.generate(6, (index) => currentYear - index);
  }

  // Get months list
  List<Map<String, dynamic>> get availableMonths {
    return [
      {'value': 1, 'name': 'January'},
      {'value': 2, 'name': 'February'},
      {'value': 3, 'name': 'March'},
      {'value': 4, 'name': 'April'},
      {'value': 5, 'name': 'May'},
      {'value': 6, 'name': 'June'},
      {'value': 7, 'name': 'July'},
      {'value': 8, 'name': 'August'},
      {'value': 9, 'name': 'September'},
      {'value': 10, 'name': 'October'},
      {'value': 11, 'name': 'November'},
      {'value': 12, 'name': 'December'},
    ];
  }

  // Get current filter description
  String get filterDescription {
    final filters = <String>[];

    if (_selectedUserId != null && _selectedUserId!.isNotEmpty) {
      filters.add('User: $_selectedUserId');
    }
    if (_selectedCompanyId != null && _selectedCompanyId!.isNotEmpty) {
      filters.add('Company: $_selectedCompanyId');
    }
    if (_selectedStatus != null && _selectedStatus!.isNotEmpty && _selectedStatus != 'All') {
      filters.add('Status: $_selectedStatus');
    }
    if (_selectedPriority != null && _selectedPriority!.isNotEmpty && _selectedPriority != 'All') {
      filters.add('Priority: $_selectedPriority');
    }
    if (_searchQuery.isNotEmpty) {
      filters.add('Search: $_searchQuery');
    }

    if (filters.isEmpty) {
      return 'Showing all tasks for ${_report?.period.formattedPeriod ?? 'current period'}';
    }

    return '${filters.join(', ')} - ${_report?.period.formattedPeriod ?? 'current period'}';
  }
}