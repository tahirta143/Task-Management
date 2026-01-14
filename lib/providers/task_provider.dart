
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskflow_app/models/dashboard_model.dart' hide SubTask;
import '../ApiLink.dart';
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

  // Get task by ID
  Task? getTaskById(String taskId) {
    return _tasks.firstWhere((task) => task.id == taskId, orElse: () => Task.empty());
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<String?> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  Future<void> fetchTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _getToken();
      print('=== FETCH TASKS DEBUG ===');
      print('Token: ${token != null ? "Exists" : "Null"}');

      if (token == null) {
        _error = 'Not authenticated';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Get user role and company ID
      final prefs = await SharedPreferences.getInstance();
      final role = prefs.getString('role');
      final companyId = prefs.getString('companyId');

      print('User Role: $role');
      print('Company ID: $companyId');

      // Build URL based on user role
      String url = '${Apilink.api}/tasks';

      // If user is manager, fetch only their company's tasks
      if (role == 'manager' && companyId != null) {
        url += '?company=$companyId';
        print('Fetching tasks for manager, company: $companyId');
      }
      // If user is admin, fetch all tasks
      else if (role == 'admin') {
        print('Fetching all tasks for admin');
      }
      // If user is staff, fetch their assigned tasks
      else if (role == 'staff') {
        final userId = prefs.getString('userId');
        if (userId != null) {
          url += '?assignedTo=$userId';
          print('Fetching tasks for staff, user ID: $userId');
        }
      }

      print('Final URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body.length > 200 ? response.body.substring(0, 200) + "..." : response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final taskResponse = TaskListResponse.fromJson(data);
        _tasks = taskResponse.tasks;
        _applyFilters();
        _error = null;

        print('Successfully loaded ${_tasks.length} tasks');
      } else if (response.statusCode == 401) {
        _error = 'Authentication failed. Please login again.';
        print('Token might be invalid or expired');
      } else if (response.statusCode == 403) {
        _error = 'You don\'t have permission to view these tasks';
        print('Permission denied for this user role');
      } else {
        _error = 'Failed to load tasks: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error: ${e.toString()}';
      print('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch single task by ID
  Future<Task?> fetchTaskById(String taskId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) {
        _error = 'Not authenticated';
        _isLoading = false;
        notifyListeners();
        return null;
      }

      print('=== FETCH TASK BY ID DEBUG ===');
      print('Task ID: $taskId');

      final response = await http.get(
        Uri.parse('${Apilink.api}/tasks/$taskId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final task = Task.fromJson(data['data']);

        // Update the task in the local list
        final index = _tasks.indexWhere((t) => t.id == taskId);
        if (index != -1) {
          _tasks[index] = task;
        } else {
          _tasks.add(task);
        }

        _applyFilters();
        _error = null;
        _isLoading = false;
        notifyListeners();
        return task;
      } else {
        _error = 'Failed to load task details: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _error = 'Error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

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
        Uri.parse('${Apilink.api}/tasks'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('=== RESPONSE DEBUG INFO ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

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
          await fetchTasks();
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
    required List<SubTask> subTasks, required  days,
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
        Uri.parse('${Apilink.api}/tasks/$id'),
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
        Uri.parse('${Apilink.api}/tasks/$id'),
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

  // SUBTASK METHODS
  // In your TaskProvider class, add these methods:

  // In TaskProvider class, update these methods:

  Future<bool> addSubTask({
    required String taskId,
    required SubTask subTask,
  }) async {
    try {
      print('=== ADDING SUBTASK DEBUG ===');
      print('Task ID: $taskId');
      print('SubTask: ${subTask.toJson()}');

      final token = await _getToken();
      if (token == null) {
        print('No token found');
        return false;
      }

      // Use your Apilink instead of hardcoded URL
      final response = await http.post(
        Uri.parse('${Apilink.api}/tasks/$taskId/subtasks'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(subTask.toJson()),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          // Find and update the task in local list
          final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
          if (taskIndex != -1) {
            final currentTask = _tasks[taskIndex];
            final updatedSubTasks = [...currentTask.subTasks, subTask];
            final completedCount = updatedSubTasks.where((st) => st.status == 'completed').length;

            _tasks[taskIndex] = currentTask.copyWith(
              subTasks: updatedSubTasks,
              completedSubtasks: completedCount,
              totalSubtasks: updatedSubTasks.length,
            );

            print('Task updated locally. New subtask count: ${_tasks[taskIndex].subTasks.length}');
            notifyListeners();
            return true;
          } else {
            print('Task not found in local list');
          }
        }
      }
      return false;
    } catch (e) {
      print('Error adding subtask: $e');
      return false;
    }
  }

  Future<bool> updateSubTask({
    required String taskId,
    required String subTaskId,
    required SubTask subTask,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.put(
        Uri.parse('${Apilink.api}/tasks/$taskId/subtasks/$subTaskId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(subTask.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          // Find and update the task in local list
          final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
          if (taskIndex != -1) {
            final currentTask = _tasks[taskIndex];
            final updatedSubTasks = currentTask.subTasks.map((st) =>
            st.id == subTaskId ? subTask : st).toList();
            final completedCount = updatedSubTasks.where((st) => st.status == 'completed').length;

            _tasks[taskIndex] = currentTask.copyWith(
              subTasks: updatedSubTasks,
              completedSubtasks: completedCount,
              totalSubtasks: updatedSubTasks.length,
            );

            notifyListeners();
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error updating subtask: $e');
      return false;
    }
  }

  Future<bool> deleteSubTask({
    required String taskId,
    required String subTaskId,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.delete(
        Uri.parse('${Apilink.api}/tasks/$taskId/subtasks/$subTaskId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          // Find and update the task in local list
          final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
          if (taskIndex != -1) {
            final currentTask = _tasks[taskIndex];
            final updatedSubTasks = currentTask.subTasks.where((st) =>
            st.id != subTaskId).toList();
            final completedCount = updatedSubTasks.where((st) => st.status == 'completed').length;

            _tasks[taskIndex] = currentTask.copyWith(
              subTasks: updatedSubTasks,
              completedSubtasks: completedCount,
              totalSubtasks: updatedSubTasks.length,
            );

            notifyListeners();
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error deleting subtask: $e');
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

  // Helper method to check if user can modify subtask
  bool canUserModifySubTask(String taskId, String userId, String userRole) {
    final task = getTaskById(taskId);
    if (task == null) return false;

    final isAssignedStaff = task.assignedTo.id == userId;
    final isManager = userRole == 'manager';

    return isAssignedStaff || isManager;
  }

  // Helper method to check if user can delete subtask
  bool canUserDeleteSubTask(String taskId, String userId) {
    final task = getTaskById(taskId);
    if (task == null) return false;

    return task.assignedTo.id == userId;
  }
}