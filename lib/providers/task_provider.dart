// providers/task_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  // Filters
  String _searchQuery = '';
  String _filterStatus = 'All';
  String _filterPriority = 'All';
  String _filterCompany = 'All';

  List<Task> get tasks => _filteredTasks;
  List<Task> get allTasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;
  int get taskCount => _filteredTasks.length;

  String get searchQuery => _searchQuery;
  String get filterStatus => _filterStatus;
  String get filterPriority => _filterPriority;
  String get filterCompany => _filterCompany;

  List<String> get statusOptions => ['All', 'pending', 'in-progress', 'completed'];
  List<String> get priorityOptions => ['All', 'low', 'medium', 'high'];

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) {
        _error = 'Not authenticated';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await http.get(
        Uri.parse('https://task-management-backend-bn2k.vercel.app/api/tasks'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final taskResponse = TaskListResponse.fromJson(data);
        _tasks = taskResponse.tasks;
        _applyFilters();
        _error = null;
      } else {
        _error = 'Failed to load tasks: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<bool> createTask({
  //   required String title,
  //   required String description,
  //   required String companyId,
  //   required String assignedToId,
  //   required DateTime startDate,
  //   required DateTime endDate,
  //   required String priority,
  //   required List<String> tags,
  //   required List<SubTask> subTasks,
  // }) async {
  //   _isLoading = true;
  //   _error = null;
  //   _successMessage = null;
  //   notifyListeners();
  //
  //   try {
  //     final token = await _getToken();
  //     if (token == null) {
  //       _error = 'Not authenticated';
  //       _isLoading = false;
  //       notifyListeners();
  //       return false;
  //     }
  //
  //     final response = await http.post(
  //       Uri.parse('https://task-management-backend-bn2k.vercel.app/api/tasks'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({
  //         'title': title,
  //         'description': description,
  //         'company': companyId,
  //         'assignedTo': assignedToId,
  //         'startDate': startDate.toIso8601String(),
  //         'endDate': endDate.toIso8601String(),
  //         'priority': priority,
  //         'tags': tags,
  //         'subTasks': subTasks.map((task) => task.toJson()).toList(),
  //       }),
  //     );
  //
  //     if (response.statusCode == 201) {
  //       _successMessage = 'Task created successfully';
  //       await fetchTasks(); // Refresh list
  //       _isLoading = false;
  //       notifyListeners();
  //       return true;
  //     } else {
  //       final errorData = jsonDecode(response.body);
  //       _error = errorData['message'] ?? 'Failed to create task';
  //       _isLoading = false;
  //       notifyListeners();
  //       return false;
  //     }
  //   } catch (e) {
  //     _error = 'Error: ${e.toString()}';
  //     _isLoading = false;
  //     notifyListeners();
  //     return false;
  //   }
  // }
  Future<bool> createTask({
    required String title,
    required String description,
    required String companyId,
    required String assignedToId,
    required DateTime startDate,
    required DateTime endDate,
    required String priority,
    required List<String> tags,
    required List<SubTask> subTasks,
  }) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) {
        _error = 'Not authenticated';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Debug print all input values
      print('=== CREATE TASK DEBUG INFO ===');
      print('Title: $title');
      print('Description: $description');
      print('Company ID: $companyId');
      print('Assigned To ID: $assignedToId');
      print('Start Date: ${startDate.toIso8601String()}');
      print('End Date: ${endDate.toIso8601String()}');
      print('Priority: $priority');
      print('Tags: $tags');
      print('SubTasks count: ${subTasks.length}');
      for (int i = 0; i < subTasks.length; i++) {
        print('  SubTask ${i + 1}:');
        print('    Date: ${subTasks[i].date.toIso8601String()}');
        print('    Description: ${subTasks[i].description}');
        print('    Status: ${subTasks[i].status}');
        print('    Hours Spent: ${subTasks[i].hoursSpent}');
        print('    Remarks: ${subTasks[i].remarks}');
      }

      // Prepare request body
      final requestBody = {
        'title': title,
        'description': description,
        'company': companyId,
        'assignedTo': assignedToId,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'priority': priority,
        'tags': tags,
        'subTasks': subTasks.map((task) => task.toJson()).toList(),
      };

      print('Request Body:');
      print(jsonEncode(requestBody));

      final response = await http.post(
        Uri.parse('https://task-management-backend-bn2k.vercel.app/api/tasks'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      // Debug print response
      print('=== RESPONSE DEBUG INFO ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('Response Headers: ${response.headers}');

      if (response.statusCode == 201) {
        try {
          final responseData = jsonDecode(response.body);
          print('Success Response Data: $responseData');
          _successMessage = 'Task created successfully';
          await fetchTasks(); // Refresh list
          _isLoading = false;
          notifyListeners();
          return true;
        } catch (e) {
          print('Error parsing success response: $e');
          _successMessage = 'Task created successfully';
          await fetchTasks(); // Refresh list
          _isLoading = false;
          notifyListeners();
          return true;
        }
      } else {
        print('Error Status Code: ${response.statusCode}');
        try {
          final errorData = jsonDecode(response.body);
          print('Error Response Data: $errorData');
          _error = errorData['message'] ?? 'Failed to create task';
        } catch (e) {
          print('Error parsing error response: $e');
          _error = 'Failed to create task: ${response.statusCode}';
        }
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e, stackTrace) {
      print('=== EXCEPTION DEBUG INFO ===');
      print('Exception: $e');
      print('Stack Trace: $stackTrace');
      _error = 'Error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTask({
    required String id,
    required String title,
    required String description,
    required String companyId,
    required String assignedToId,
    required DateTime startDate,
    required DateTime endDate,
    required String priority,
    required String status,
    required int progress,
    required List<String> tags,
    required List<SubTask> subTasks,
  }) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) {
        _error = 'Not authenticated';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final response = await http.put(
        Uri.parse('https://task-management-backend-bn2k.vercel.app/api/tasks/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'company': companyId,
          'assignedTo': assignedToId,
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
          'priority': priority,
          'status': status,
          'progress': progress,
          'tags': tags,
          'subTasks': subTasks.map((task) => task.toJson()).toList(),
        }),
      );

      if (response.statusCode == 200) {
        _successMessage = 'Task updated successfully';
        await fetchTasks(); // Refresh list
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        _error = errorData['message'] ?? 'Failed to update task';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTask(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) {
        _error = 'Not authenticated';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final response = await http.delete(
        Uri.parse('https://task-management-backend-bn2k.vercel.app/api/tasks/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _tasks.removeWhere((task) => task.id == id);
        _applyFilters();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to delete task';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Filter methods
  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  void setFilterStatus(String status) {
    _filterStatus = status;
    _applyFilters();
    notifyListeners();
  }

  void setFilterPriority(String priority) {
    _filterPriority = priority;
    _applyFilters();
    notifyListeners();
  }

  void setFilterCompany(String company) {
    _filterCompany = company;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredTasks = _tasks.where((task) {
      // Apply search filter
      bool searchMatches = _searchQuery.isEmpty ||
          task.title.toLowerCase().contains(_searchQuery) ||
          task.description.toLowerCase().contains(_searchQuery) ||
          task.assignedTo.name.toLowerCase().contains(_searchQuery);

      // Apply status filter
      bool statusMatches = _filterStatus == 'All' || task.status == _filterStatus;

      // Apply priority filter
      bool priorityMatches = _filterPriority == 'All' || task.priority == _filterPriority;

      // Apply company filter
      bool companyMatches = _filterCompany == 'All' || task.company.name == _filterCompany;

      return searchMatches && statusMatches && priorityMatches && companyMatches;
    }).toList();
  }

  void clearFilters() {
    _searchQuery = '';
    _filterStatus = 'All';
    _filterPriority = 'All';
    _filterCompany = 'All';
    _applyFilters();
    notifyListeners();
  }

  List<String> get uniqueCompanies {
    final companies = _tasks.map((task) => task.company.name).toSet().toList();
    companies.insert(0, 'All');
    return companies;
  }

  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }
}