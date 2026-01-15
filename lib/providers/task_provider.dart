// //
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:taskflow_app/models/dashboard_model.dart' hide SubTask;
// // import '../ApiLink.dart';
// // import '../models/task_model.dart';
// //
// // class TaskProvider with ChangeNotifier {
// //   List<Task> _tasks = [];
// //   List<Task> _filteredTasks = [];
// //   bool _isLoading = false;
// //   String? _error;
// //   String? _successMessage;
// //
// //   // Filters
// //   String _searchQuery = '';
// //   String _filterStatus = 'All';
// //   String _filterPriority = 'All';
// //   String _filterCompany = 'All';
// //
// //   List<Task> get tasks => _filteredTasks;
// //   List<Task> get allTasks => _tasks;
// //   bool get isLoading => _isLoading;
// //   String? get error => _error;
// //   String? get successMessage => _successMessage;
// //   int get taskCount => _filteredTasks.length;
// //
// //   String get searchQuery => _searchQuery;
// //   String get filterStatus => _filterStatus;
// //   String get filterPriority => _filterPriority;
// //   String get filterCompany => _filterCompany;
// //
// //   List<String> get statusOptions => ['All', 'pending', 'in-progress', 'completed'];
// //   List<String> get priorityOptions => ['All', 'low', 'medium', 'high'];
// //
// //   // Get task by ID
// //   Task? getTaskById(String taskId) {
// //     return _tasks.firstWhere((task) => task.id == taskId, orElse: () => Task.empty());
// //   }
// //
// //   Future<String?> _getToken() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     return prefs.getString('token');
// //   }
// //
// //   Future<String?> _getUserId() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     return prefs.getString('userId');
// //   }
// //
// //   Future<String?> _getUserRole() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     return prefs.getString('role');
// //   }
// //
// //   Future<void> fetchTasks() async {
// //     _isLoading = true;
// //     _error = null;
// //     notifyListeners();
// //
// //     try {
// //       final token = await _getToken();
// //       print('=== FETCH TASKS DEBUG ===');
// //       print('Token: ${token != null ? "Exists" : "Null"}');
// //
// //       if (token == null) {
// //         _error = 'Not authenticated';
// //         _isLoading = false;
// //         notifyListeners();
// //         return;
// //       }
// //
// //       // Get user role and company ID
// //       final prefs = await SharedPreferences.getInstance();
// //       final role = prefs.getString('role');
// //       final companyId = prefs.getString('companyId');
// //
// //       print('User Role: $role');
// //       print('Company ID: $companyId');
// //
// //       // Build URL based on user role
// //       String url = '${Apilink.api}/tasks';
// //
// //       // If user is manager, fetch only their company's tasks
// //       if (role == 'manager' && companyId != null) {
// //         url += '?company=$companyId';
// //         print('Fetching tasks for manager, company: $companyId');
// //       }
// //       // If user is admin, fetch all tasks
// //       else if (role == 'admin') {
// //         print('Fetching all tasks for admin');
// //       }
// //       // If user is staff, fetch their assigned tasks
// //       else if (role == 'staff') {
// //         final userId = prefs.getString('userId');
// //         if (userId != null) {
// //           url += '?assignedTo=$userId';
// //           print('Fetching tasks for staff, user ID: $userId');
// //         }
// //       }
// //
// //       print('Final URL: $url');
// //
// //       final response = await http.get(
// //         Uri.parse(url),
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //       );
// //
// //       print('Response Status: ${response.statusCode}');
// //       print('Response Body: ${response.body.length > 200 ? response.body.substring(0, 200) + "..." : response.body}');
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         final taskResponse = TaskListResponse.fromJson(data);
// //         _tasks = taskResponse.tasks;
// //         _applyFilters();
// //         _error = null;
// //
// //         print('Successfully loaded ${_tasks.length} tasks');
// //       } else if (response.statusCode == 401) {
// //         _error = 'Authentication failed. Please login again.';
// //         print('Token might be invalid or expired');
// //       } else if (response.statusCode == 403) {
// //         _error = 'You don\'t have permission to view these tasks';
// //         print('Permission denied for this user role');
// //       } else {
// //         _error = 'Failed to load tasks: ${response.statusCode}';
// //       }
// //     } catch (e) {
// //       _error = 'Error: ${e.toString()}';
// //       print('Exception: $e');
// //     } finally {
// //       _isLoading = false;
// //       notifyListeners();
// //     }
// //   }
// //
// //   // Fetch single task by ID
// //   Future<Task?> fetchTaskById(String taskId) async {
// //     _isLoading = true;
// //     notifyListeners();
// //
// //     try {
// //       final token = await _getToken();
// //       if (token == null) {
// //         _error = 'Not authenticated';
// //         _isLoading = false;
// //         notifyListeners();
// //         return null;
// //       }
// //
// //       print('=== FETCH TASK BY ID DEBUG ===');
// //       print('Task ID: $taskId');
// //
// //       final response = await http.get(
// //         Uri.parse('${Apilink.api}/tasks/$taskId'),
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //       );
// //
// //       print('Response Status: ${response.statusCode}');
// //       print('Response Body: ${response.body}');
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         final task = Task.fromJson(data['data']);
// //
// //         // Update the task in the local list
// //         final index = _tasks.indexWhere((t) => t.id == taskId);
// //         if (index != -1) {
// //           _tasks[index] = task;
// //         } else {
// //           _tasks.add(task);
// //         }
// //
// //         _applyFilters();
// //         _error = null;
// //         _isLoading = false;
// //         notifyListeners();
// //         return task;
// //       } else {
// //         _error = 'Failed to load task details: ${response.statusCode}';
// //         _isLoading = false;
// //         notifyListeners();
// //         return null;
// //       }
// //     } catch (e) {
// //       _error = 'Error: ${e.toString()}';
// //       _isLoading = false;
// //       notifyListeners();
// //       return null;
// //     }
// //   }
// //
// //   Future<bool> createTask({
// //     required String title,
// //     required String description,
// //     required String companyId,
// //     required String assignedToId,
// //     required DateTime startDate,
// //     required DateTime endDate,
// //     required String priority,
// //     required List<String> tags,
// //     required List<SubTask> subTasks,
// //   }) async {
// //     _isLoading = true;
// //     _error = null;
// //     _successMessage = null;
// //     notifyListeners();
// //
// //     try {
// //       final token = await _getToken();
// //       if (token == null) {
// //         _error = 'Not authenticated';
// //         _isLoading = false;
// //         notifyListeners();
// //         return false;
// //       }
// //
// //       print('=== CREATE TASK DEBUG INFO ===');
// //       print('Title: $title');
// //       print('Description: $description');
// //       print('Company ID: $companyId');
// //       print('Assigned To ID: $assignedToId');
// //       print('Start Date: ${startDate.toIso8601String()}');
// //       print('End Date: ${endDate.toIso8601String()}');
// //       print('Priority: $priority');
// //       print('Tags: $tags');
// //       print('SubTasks count: ${subTasks.length}');
// //
// //       // Prepare request body
// //       final requestBody = {
// //         'title': title,
// //         'description': description,
// //         'company': companyId,
// //         'assignedTo': assignedToId,
// //         'startDate': startDate.toIso8601String(),
// //         'endDate': endDate.toIso8601String(),
// //         'priority': priority,
// //         'tags': tags,
// //         'subTasks': subTasks.map((task) => task.toJson()).toList(),
// //       };
// //
// //       print('Request Body:');
// //       print(jsonEncode(requestBody));
// //
// //       final response = await http.post(
// //         Uri.parse('${Apilink.api}/tasks'),
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //         body: jsonEncode(requestBody),
// //       );
// //
// //       print('=== RESPONSE DEBUG INFO ===');
// //       print('Status Code: ${response.statusCode}');
// //       print('Response Body: ${response.body}');
// //
// //       if (response.statusCode == 201) {
// //         try {
// //           final responseData = jsonDecode(response.body);
// //           print('Success Response Data: $responseData');
// //           _successMessage = 'Task created successfully';
// //           await fetchTasks(); // Refresh list
// //           _isLoading = false;
// //           notifyListeners();
// //           return true;
// //         } catch (e) {
// //           print('Error parsing success response: $e');
// //           _successMessage = 'Task created successfully';
// //           await fetchTasks();
// //           _isLoading = false;
// //           notifyListeners();
// //           return true;
// //         }
// //       } else {
// //         print('Error Status Code: ${response.statusCode}');
// //         try {
// //           final errorData = jsonDecode(response.body);
// //           print('Error Response Data: $errorData');
// //           _error = errorData['message'] ?? 'Failed to create task';
// //         } catch (e) {
// //           print('Error parsing error response: $e');
// //           _error = 'Failed to create task: ${response.statusCode}';
// //         }
// //         _isLoading = false;
// //         notifyListeners();
// //         return false;
// //       }
// //     } catch (e, stackTrace) {
// //       print('=== EXCEPTION DEBUG INFO ===');
// //       print('Exception: $e');
// //       print('Stack Trace: $stackTrace');
// //       _error = 'Error: ${e.toString()}';
// //       _isLoading = false;
// //       notifyListeners();
// //       return false;
// //     }
// //   }
// //
// //   Future<bool> updateTask({
// //     required String id,
// //     required String title,
// //     required String description,
// //     required String companyId,
// //     required String assignedToId,
// //     required DateTime startDate,
// //     required DateTime endDate,
// //     required String priority,
// //     required String status,
// //     required int progress,
// //     required List<String> tags,
// //     required List<SubTask> subTasks, required  days,
// //   }) async {
// //     _isLoading = true;
// //     _error = null;
// //     _successMessage = null;
// //     notifyListeners();
// //
// //     try {
// //       final token = await _getToken();
// //       if (token == null) {
// //         _error = 'Not authenticated';
// //         _isLoading = false;
// //         notifyListeners();
// //         return false;
// //       }
// //
// //       final response = await http.put(
// //         Uri.parse('${Apilink.api}/tasks/$id'),
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //         body: jsonEncode({
// //           'title': title,
// //           'description': description,
// //           'company': companyId,
// //           'assignedTo': assignedToId,
// //           'startDate': startDate.toIso8601String(),
// //           'endDate': endDate.toIso8601String(),
// //           'priority': priority,
// //           'status': status,
// //           'progress': progress,
// //           'tags': tags,
// //           'subTasks': subTasks.map((task) => task.toJson()).toList(),
// //         }),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         _successMessage = 'Task updated successfully';
// //         await fetchTasks(); // Refresh list
// //         _isLoading = false;
// //         notifyListeners();
// //         return true;
// //       } else {
// //         final errorData = jsonDecode(response.body);
// //         _error = errorData['message'] ?? 'Failed to update task';
// //         _isLoading = false;
// //         notifyListeners();
// //         return false;
// //       }
// //     } catch (e) {
// //       _error = 'Error: ${e.toString()}';
// //       _isLoading = false;
// //       notifyListeners();
// //       return false;
// //     }
// //   }
// //
// //   Future<bool> deleteTask(String id) async {
// //     _isLoading = true;
// //     _error = null;
// //     notifyListeners();
// //
// //     try {
// //       final token = await _getToken();
// //       if (token == null) {
// //         _error = 'Not authenticated';
// //         _isLoading = false;
// //         notifyListeners();
// //         return false;
// //       }
// //
// //       final response = await http.delete(
// //         Uri.parse('${Apilink.api}/tasks/$id'),
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //       );
// //
// //       if (response.statusCode == 200) {
// //         _tasks.removeWhere((task) => task.id == id);
// //         _applyFilters();
// //         _isLoading = false;
// //         notifyListeners();
// //         return true;
// //       } else {
// //         _error = 'Failed to delete task';
// //         _isLoading = false;
// //         notifyListeners();
// //         return false;
// //       }
// //     } catch (e) {
// //       _error = 'Error: ${e.toString()}';
// //       _isLoading = false;
// //       notifyListeners();
// //       return false;
// //     }
// //   }
// //
// //   // SUBTASK METHODS
// //   // In your TaskProvider class, add these methods:
// //
// //   // In TaskProvider class, update these methods:
// //
// //   Future<bool> addSubTask({
// //     required String taskId,
// //     required SubTask subTask,
// //   }) async {
// //     try {
// //       print('=== ADDING SUBTASK DEBUG ===');
// //       print('Task ID: $taskId');
// //       print('SubTask: ${subTask.toJson()}');
// //
// //       final token = await _getToken();
// //       if (token == null) {
// //         print('No token found');
// //         return false;
// //       }
// //
// //       // Use your Apilink instead of hardcoded URL
// //       final response = await http.post(
// //         Uri.parse('${Apilink.api}/tasks/$taskId/subtasks'),
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //         body: jsonEncode(subTask.toJson()),
// //       );
// //
// //       print('Response Status: ${response.statusCode}');
// //       print('Response Body: ${response.body}');
// //
// //       if (response.statusCode == 200 || response.statusCode == 201) {
// //         final data = jsonDecode(response.body);
// //
// //         if (data['success'] == true) {
// //           // Find and update the task in local list
// //           final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
// //           if (taskIndex != -1) {
// //             final currentTask = _tasks[taskIndex];
// //             final updatedSubTasks = [...currentTask.subTasks, subTask];
// //             final completedCount = updatedSubTasks.where((st) => st.status == 'completed').length;
// //
// //             _tasks[taskIndex] = currentTask.copyWith(
// //               subTasks: updatedSubTasks,
// //               completedSubtasks: completedCount,
// //               totalSubtasks: updatedSubTasks.length,
// //             );
// //
// //             print('Task updated locally. New subtask count: ${_tasks[taskIndex].subTasks.length}');
// //             notifyListeners();
// //             return true;
// //           } else {
// //             print('Task not found in local list');
// //           }
// //         }
// //       }
// //       return false;
// //     } catch (e) {
// //       print('Error adding subtask: $e');
// //       return false;
// //     }
// //   }
// //
// //   Future<bool> updateSubTask({
// //     required String taskId,
// //     required String subTaskId,
// //     required SubTask subTask,
// //   }) async {
// //     try {
// //       final token = await _getToken();
// //       if (token == null) return false;
// //
// //       final response = await http.put(
// //         Uri.parse('${Apilink.api}/tasks/$taskId/subtasks/$subTaskId'),
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //         body: jsonEncode(subTask.toJson()),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //
// //         if (data['success'] == true) {
// //           // Find and update the task in local list
// //           final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
// //           if (taskIndex != -1) {
// //             final currentTask = _tasks[taskIndex];
// //             final updatedSubTasks = currentTask.subTasks.map((st) =>
// //             st.id == subTaskId ? subTask : st).toList();
// //             final completedCount = updatedSubTasks.where((st) => st.status == 'completed').length;
// //
// //             _tasks[taskIndex] = currentTask.copyWith(
// //               subTasks: updatedSubTasks,
// //               completedSubtasks: completedCount,
// //               totalSubtasks: updatedSubTasks.length,
// //             );
// //
// //             notifyListeners();
// //           }
// //           return true;
// //         }
// //       }
// //       return false;
// //     } catch (e) {
// //       print('Error updating subtask: $e');
// //       return false;
// //     }
// //   }
// //
// //   Future<bool> deleteSubTask({
// //     required String taskId,
// //     required String subTaskId,
// //   }) async {
// //     try {
// //       final token = await _getToken();
// //       if (token == null) return false;
// //
// //       final response = await http.delete(
// //         Uri.parse('${Apilink.api}/tasks/$taskId/subtasks/$subTaskId'),
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //
// //         if (data['success'] == true) {
// //           // Find and update the task in local list
// //           final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
// //           if (taskIndex != -1) {
// //             final currentTask = _tasks[taskIndex];
// //             final updatedSubTasks = currentTask.subTasks.where((st) =>
// //             st.id != subTaskId).toList();
// //             final completedCount = updatedSubTasks.where((st) => st.status == 'completed').length;
// //
// //             _tasks[taskIndex] = currentTask.copyWith(
// //               subTasks: updatedSubTasks,
// //               completedSubtasks: completedCount,
// //               totalSubtasks: updatedSubTasks.length,
// //             );
// //
// //             notifyListeners();
// //           }
// //           return true;
// //         }
// //       }
// //       return false;
// //     } catch (e) {
// //       print('Error deleting subtask: $e');
// //       return false;
// //     }
// //   }
// //   // Filter methods
// //   void setSearchQuery(String query) {
// //     _searchQuery = query.toLowerCase();
// //     _applyFilters();
// //     notifyListeners();
// //   }
// //
// //   void setFilterStatus(String status) {
// //     _filterStatus = status;
// //     _applyFilters();
// //     notifyListeners();
// //   }
// //
// //   void setFilterPriority(String priority) {
// //     _filterPriority = priority;
// //     _applyFilters();
// //     notifyListeners();
// //   }
// //
// //   void setFilterCompany(String company) {
// //     _filterCompany = company;
// //     _applyFilters();
// //     notifyListeners();
// //   }
// //
// //   void _applyFilters() {
// //     _filteredTasks = _tasks.where((task) {
// //       // Apply search filter
// //       bool searchMatches = _searchQuery.isEmpty ||
// //           task.title.toLowerCase().contains(_searchQuery) ||
// //           task.description.toLowerCase().contains(_searchQuery) ||
// //           task.assignedTo.name.toLowerCase().contains(_searchQuery);
// //
// //       // Apply status filter
// //       bool statusMatches = _filterStatus == 'All' || task.status == _filterStatus;
// //
// //       // Apply priority filter
// //       bool priorityMatches = _filterPriority == 'All' || task.priority == _filterPriority;
// //
// //       // Apply company filter
// //       bool companyMatches = _filterCompany == 'All' || task.company.name == _filterCompany;
// //
// //       return searchMatches && statusMatches && priorityMatches && companyMatches;
// //     }).toList();
// //   }
// //
// //   void clearFilters() {
// //     _searchQuery = '';
// //     _filterStatus = 'All';
// //     _filterPriority = 'All';
// //     _filterCompany = 'All';
// //     _applyFilters();
// //     notifyListeners();
// //   }
// //
// //   List<String> get uniqueCompanies {
// //     final companies = _tasks.map((task) => task.company.name).toSet().toList();
// //     companies.insert(0, 'All');
// //     return companies;
// //   }
// //
// //   void clearMessages() {
// //     _error = null;
// //     _successMessage = null;
// //     notifyListeners();
// //   }
// //
// //   // Helper method to check if user can modify subtask
// //   bool canUserModifySubTask(String taskId, String userId, String userRole) {
// //     final task = getTaskById(taskId);
// //     if (task == null) return false;
// //
// //     final isAssignedStaff = task.assignedTo.id == userId;
// //     final isManager = userRole == 'manager';
// //
// //     return isAssignedStaff || isManager;
// //   }
// //
// //   // Helper method to check if user can delete subtask
// //   bool canUserDeleteSubTask(String taskId, String userId) {
// //     final task = getTaskById(taskId);
// //     if (task == null) return false;
// //
// //     return task.assignedTo.id == userId;
// //   }
// // }
//
//
// // providers/task_provider.dart
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/task_model.dart';
//
// class TaskProvider with ChangeNotifier {
//   List<Task> _tasks = [];
//   List<Task> _filteredTasks = [];
//   bool _isLoading = false;
//   String? _error;
//   String? _successMessage;
//
//   // Filters
//   String _searchQuery = '';
//   String _filterStatus = 'All';
//   String _filterPriority = 'All';
//   String _filterCompany = 'All';
//
//   List<Task> get tasks => _filteredTasks;
//   List<Task> get allTasks => _tasks;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   String? get successMessage => _successMessage;
//   int get taskCount => _filteredTasks.length;
//
//   String get searchQuery => _searchQuery;
//   String get filterStatus => _filterStatus;
//   String get filterPriority => _filterPriority;
//   String get filterCompany => _filterCompany;
//
//   List<String> get statusOptions => ['All', 'pending', 'in-progress', 'completed'];
//   List<String> get priorityOptions => ['All', 'low', 'medium', 'high'];
//
//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }
//
//   // Future<void> fetchTasks({bool forceRefresh = false}) async {
//   //   // Only clear cache if forceRefresh is true and not already loading
//   //   if (forceRefresh && !_isLoading) {
//   //     _tasks.clear();
//   //     _filteredTasks.clear();
//   //     notifyListeners(); // Notify UI that data is being cleared
//   //   }
//   //
//   //   _isLoading = true;
//   //   _error = null;
//   //   notifyListeners();
//   //
//   //   try {
//   //     final token = await _getToken();
//   //     print('=== FETCH TASKS DEBUG ===');
//   //     print('Token: ${token != null ? "Exists" : "Null"}');
//   //     print('Force Refresh: $forceRefresh');
//   //
//   //     if (token == null) {
//   //       _error = 'Not authenticated';
//   //       _isLoading = false;
//   //       notifyListeners();
//   //       return;
//   //     }
//   //
//   //     // Get user role and company ID
//   //     final prefs = await SharedPreferences.getInstance();
//   //     final role = prefs.getString('role');
//   //     final companyId = prefs.getString('companyId');
//   //
//   //     print('User Role: $role');
//   //     print('Company ID: $companyId');
//   //
//   //     // Build URL based on user role
//   //     String url = 'https://task-management-backend-bn2k.vercel.app/api/tasks';
//   //
//   //     // Add timestamp parameter to prevent caching if forceRefresh is true
//   //     if (forceRefresh) {
//   //       final timestamp = DateTime.now().millisecondsSinceEpoch;
//   //       url += url.contains('?') ? '&t=$timestamp' : '?t=$timestamp';
//   //     }
//   //
//   //     // If user is manager, fetch only their company's tasks
//   //     if (role == 'manager' && companyId != null) {
//   //       url += url.contains('?') ? '&company=$companyId' : '?company=$companyId';
//   //       print('Fetching tasks for manager, company: $companyId');
//   //     }
//   //     // If user is admin, fetch all tasks
//   //     else if (role == 'admin') {
//   //       print('Fetching all tasks for admin');
//   //     }
//   //     // If user is staff, fetch their assigned tasks
//   //     else if (role == 'staff') {
//   //       final userId = prefs.getString('userId');
//   //       if (userId != null) {
//   //         url += url.contains('?') ? '&assignedTo=$userId' : '?assignedTo=$userId';
//   //         print('Fetching tasks for staff, user ID: $userId');
//   //       }
//   //     }
//   //
//   //     print('Final URL: $url');
//   //
//   //     final response = await http.get(
//   //       Uri.parse(url),
//   //       headers: {
//   //         'Authorization': 'Bearer $token',
//   //         'Content-Type': 'application/json',
//   //         if (forceRefresh) 'Cache-Control': 'no-cache',
//   //       },
//   //     );
//   //
//   //     print('Response Status: ${response.statusCode}');
//   //     print('Response Body: ${response.body.length > 200 ? response.body.substring(0, 200) + "..." : response.body}');
//   //
//   //     if (response.statusCode == 200) {
//   //       final data = jsonDecode(response.body);
//   //       final taskResponse = TaskListResponse.fromJson(data);
//   //       _tasks = taskResponse.tasks;
//   //       _applyFilters();
//   //       _error = null;
//   //
//   //       print('Successfully loaded ${_tasks.length} tasks');
//   //     } else if (response.statusCode == 401) {
//   //       _error = 'Authentication failed. Please login again.';
//   //       print('Token might be invalid or expired');
//   //     } else if (response.statusCode == 403) {
//   //       _error = 'You don\'t have permission to view these tasks';
//   //       print('Permission denied for this user role');
//   //     } else {
//   //       _error = 'Failed to load tasks: ${response.statusCode}';
//   //     }
//   //   } catch (e) {
//   //     _error = 'Error: ${e.toString()}';
//   //     print('Exception: $e');
//   //   } finally {
//   //     _isLoading = false;
//   //     notifyListeners();
//   //   }
//   // }
//   Future<void> fetchTasks({bool forceRefresh = false}) async {
//     // Only clear cache if forceRefresh is true and not already loading
//     if (forceRefresh && !_isLoading) {
//       _tasks.clear();
//       _filteredTasks.clear();
//       notifyListeners(); // Notify UI that data is being cleared
//     }
//
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       final token = await _getToken();
//       print('=== FETCH TASKS DEBUG ===');
//       print('Token: ${token != null ? "Exists" : "Null"}');
//       print('Force Refresh: $forceRefresh');
//
//       if (token == null) {
//         _error = 'Not authenticated';
//         _isLoading = false;
//         notifyListeners();
//         return;
//       }
//
//       // Get user role and company ID
//       final prefs = await SharedPreferences.getInstance();
//       final role = prefs.getString('role');
//       final companyId = prefs.getString('companyId');
//
//       print('User Role: $role');
//       print('Company ID: $companyId');
//
//       // Build URL based on user role
//       String url = 'https://task-management-backend-bn2k.vercel.app/api/tasks';
//
//       // Add timestamp parameter to prevent caching if forceRefresh is true
//       if (forceRefresh) {
//         final timestamp = DateTime.now().millisecondsSinceEpoch;
//         url += url.contains('?') ? '&t=$timestamp' : '?t=$timestamp';
//       }
//
//       // If user is manager, fetch only their company's tasks
//       if (role == 'manager' && companyId != null) {
//         url += url.contains('?') ? '&company=$companyId' : '?company=$companyId';
//         print('Fetching tasks for manager, company: $companyId');
//       }
//       // If user is admin, fetch all tasks
//       else if (role == 'admin') {
//         print('Fetching all tasks for admin');
//       }
//       // If user is staff, fetch their assigned tasks
//       else if (role == 'staff') {
//         final userId = prefs.getString('userId');
//         if (userId != null) {
//           url += url.contains('?') ? '&assignedTo=$userId' : '?assignedTo=$userId';
//           print('Fetching tasks for staff, user ID: $userId');
//         }
//       }
//
//       print('Final URL: $url');
//
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//           if (forceRefresh) 'Cache-Control': 'no-cache',
//         },
//       );
//
//       print('Response Status: ${response.statusCode}');
//       print('Response Body: ${response.body.length > 200 ? response.body.substring(0, 200) + "..." : response.body}');
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final taskResponse = TaskListResponse.fromJson(data);
//
//         // **CRITICAL FIX: Update the tasks list**
//         _tasks = taskResponse.tasks;
//         _applyFilters();
//         _error = null;
//
//         print('Successfully loaded ${_tasks.length} tasks');
//
//         // **IMPORTANT: Notify listeners after updating data**
//         notifyListeners(); // <-- ADD THIS LINE
//
//       } else if (response.statusCode == 401) {
//         _error = 'Authentication failed. Please login again.';
//         print('Token might be invalid or expired');
//       } else if (response.statusCode == 403) {
//         _error = 'You don\'t have permission to view these tasks';
//         print('Permission denied for this user role');
//       } else {
//         _error = 'Failed to load tasks: ${response.statusCode}';
//       }
//     } catch (e) {
//       _error = 'Error: ${e.toString()}';
//       print('Exception: $e');
//     } finally {
//       _isLoading = false;
//       notifyListeners(); // This notifies loading is done
//     }
//   }
//   Future<bool> createTask({
//     required String title,
//     required String description,
//     required String companyId,
//     required String assignedToId,
//     required DateTime startDate,
//     required DateTime endDate,
//     required String priority,
//     required List<String> tags,
//     required List<DayEntry> days,
//   }) async {
//     _isLoading = true;
//     _error = null;
//     _successMessage = null;
//     notifyListeners();
//
//     try {
//       final token = await _getToken();
//       if (token == null) {
//         _error = 'Not authenticated';
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//
//       // Debug print all input values
//       print('=== CREATE TASK DEBUG INFO ===');
//       print('Title: $title');
//       print('Description: $description');
//       print('Company ID: $companyId');
//       print('Assigned To ID: $assignedToId');
//       print('Start Date: ${startDate.toIso8601String()}');
//       print('End Date: ${endDate.toIso8601String()}');
//       print('Priority: $priority');
//       print('Tags: $tags');
//       print('Days count: ${days.length}');
//       for (int i = 0; i < days.length; i++) {
//         print('  Day ${i + 1}:');
//         print('    Date: ${days[i].date.toIso8601String()}');
//         print('    SubTasks count: ${days[i].subTasks.length}');
//         for (int j = 0; j < days[i].subTasks.length; j++) {
//           final subtask = days[i].subTasks[j];
//           print('      SubTask ${j + 1}:');
//           print('        Description: ${subtask.description}');
//           print('        Status: ${subtask.status}');
//           print('        Hours Spent: ${subtask.hoursSpent}');
//           print('        Remarks: ${subtask.remarks}');
//         }
//       }
//
//       // Prepare request body
//       final requestBody = {
//         'title': title,
//         'description': description,
//         'company': companyId,
//         'assignedTo': assignedToId,
//         'startDate': startDate.toIso8601String(),
//         'endDate': endDate.toIso8601String(),
//         'priority': priority,
//         'tags': tags,
//         'days': days.map((day) => day.toJson()).toList(),
//       };
//
//       print('Request Body:');
//       print(jsonEncode(requestBody));
//
//       final response = await http.post(
//         Uri.parse('https://task-management-backend-bn2k.vercel.app/api/tasks'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(requestBody),
//       );
//
//       // Debug print response
//       print('=== RESPONSE DEBUG INFO ===');
//       print('Status Code: ${response.statusCode}');
//       print('Response Body: ${response.body}');
//       print('Response Headers: ${response.headers}');
//
//       if (response.statusCode == 201) {
//         try {
//           final responseData = jsonDecode(response.body);
//           print('Success Response Data: $responseData');
//           _successMessage = 'Task created successfully';
//           await fetchTasks(); // Refresh list
//           _isLoading = false;
//           notifyListeners();
//           return true;
//         } catch (e) {
//           print('Error parsing success response: $e');
//           _successMessage = 'Task created successfully';
//           await fetchTasks(); // Refresh list
//           _isLoading = false;
//           notifyListeners();
//           return true;
//         }
//       } else {
//         print('Error Status Code: ${response.statusCode}');
//         try {
//           final errorData = jsonDecode(response.body);
//           print('Error Response Data: $errorData');
//           _error = errorData['message'] ?? 'Failed to create task';
//         } catch (e) {
//           print('Error parsing error response: $e');
//           _error = 'Failed to create task: ${response.statusCode}';
//         }
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//     } catch (e, stackTrace) {
//       print('=== EXCEPTION DEBUG INFO ===');
//       print('Exception: $e');
//       print('Stack Trace: $stackTrace');
//       _error = 'Error: ${e.toString()}';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   Future<bool> updateTask({
//     required String id,
//     required String title,
//     required String description,
//     required String companyId,
//     required String assignedToId,
//     required DateTime startDate,
//     required DateTime endDate,
//     required String priority,
//     required String status,
//     required int progress,
//     required List<String> tags,
//     required List<DayEntry> days,
//   }) async {
//     _isLoading = true;
//     _error = null;
//     _successMessage = null;
//     notifyListeners();
//
//     try {
//       final token = await _getToken();
//       if (token == null) {
//         _error = 'Not authenticated';
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//
//       final response = await http.put(
//         Uri.parse('https://task-management-backend-bn2k.vercel.app/api/tasks/$id'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'title': title,
//           'description': description,
//           'company': companyId,
//           'assignedTo': assignedToId,
//           'startDate': startDate.toIso8601String(),
//           'endDate': endDate.toIso8601String(),
//           'priority': priority,
//           'status': status,
//           'progress': progress,
//           'tags': tags,
//           'days': days.map((day) => day.toJson()).toList(),
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         _successMessage = 'Task updated successfully';
//         await fetchTasks(); // Refresh list
//         _isLoading = false;
//         notifyListeners();
//         return true;
//       } else {
//         final errorData = jsonDecode(response.body);
//         _error = errorData['message'] ?? 'Failed to update task';
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       _error = 'Error: ${e.toString()}';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // In task_provider.dart, update the deleteTask method
//   Future<bool> deleteTask(String id) async {
//     print('=== DELETE TASK STARTED ===');
//     print('Task ID to delete: $id');
//     print('Current tasks count: ${_tasks.length}');
//
//     // Store the task to be deleted
//     final taskToDelete = _tasks.firstWhere(
//           (task) => task.id == id,
//       orElse: () => Task(
//         id: '',
//         title: 'Unknown Task',
//         description: '',
//         company: Company(id: '', name: ''),
//         assignedTo: User(id: '', name: '', email: '', role: ''),
//         assignedBy: User(id: '', name: '', email: '', role: ''),
//         startDate: DateTime.now(),
//         endDate: DateTime.now(),
//         priority: 'medium',
//         status: 'pending',
//         progress: 0,
//         tags: [],
//         days: [],
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//         version: 0,
//       ),
//     );
//
//     // Set loading to true BEFORE making the API call
//     _isLoading = true;
//     _error = null;
//     _successMessage = null;
//     notifyListeners(); // Notify UI to show loading state
//
//     try {
//       final token = await _getToken();
//       if (token == null) {
//         _error = 'Not authenticated';
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//
//       final response = await http.delete(
//         Uri.parse('https://task-management-backend-bn2k.vercel.app/api/tasks/$id'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );
//
//       print('=== DELETE RESPONSE ===');
//       print('Status: ${response.statusCode}');
//       print('Body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         // IMPORTANT: Create new lists instead of modifying in place
//         _tasks = _tasks.where((task) => task.id != id).toList();
//         _filteredTasks = _filteredTasks.where((task) => task.id != id).toList();
//
//         _successMessage = 'Task "${taskToDelete.title}" deleted successfully';
//         _isLoading = false;
//         print('Task deleted successfully. Remaining tasks: ${_tasks.length}');
//         notifyListeners(); // Notify UI that loading is done and data changed
//         return true;
//       } else {
//         final errorData = jsonDecode(response.body);
//         _error = errorData['message'] ?? 'Failed to delete task';
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       _error = 'Error: ${e.toString()}';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//   // Add sub-task to a specific day entry
//   Future<bool> addSubTask({
//     required String taskId,
//     required String date,
//     required String description,
//     required String status,
//     required int hoursSpent,
//     required String remarks,
//   }) async {
//     _isLoading = true;
//     _error = null;
//     _successMessage = null;
//     notifyListeners();
//
//     try {
//       final token = await _getToken();
//       if (token == null) {
//         _error = 'Not authenticated';
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//
//       print('=== ADD SUBTASK DEBUG INFO ===');
//       print('Task ID: $taskId');
//       print('Date: $date');
//       print('Description: $description');
//       print('Status: $status');
//       print('Hours Spent: $hoursSpent');
//       print('Remarks: $remarks');
//
//       // Prepare request body based on your curl example
//       final requestBody = {
//         'date': date,
//         'description': description,
//         'status': status,
//         'hoursSpent': hoursSpent,
//         'remarks': remarks,
//       };
//
//       print('Request Body:');
//       print(jsonEncode(requestBody));
//
//       final response = await http.post(
//         Uri.parse('https://task-management-backend-bn2k.vercel.app/api/tasks/$taskId/subtaskDays'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(requestBody),
//       );
//
//       print('=== RESPONSE DEBUG INFO ===');
//       print('Status Code: ${response.statusCode}');
//       print('Response Body: ${response.body}');
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         _successMessage = 'Sub-task added successfully';
//
//         // Refresh the task to get updated data
//         await fetchTasks();
//
//         _isLoading = false;
//         notifyListeners();
//         return true;
//       } else {
//         final errorData = jsonDecode(response.body);
//         _error = errorData['message'] ?? 'Failed to add sub-task';
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       print('Exception: $e');
//       _error = 'Error: ${e.toString()}';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//
//   // Update an existing sub-task
//   Future<bool> updateSubTask({
//     required String taskId,
//     required String subTaskId,
//     required String date,
//     required String description,
//     required String status,
//     required int hoursSpent,
//     required String remarks,
//   }) async {
//     _isLoading = true;
//     _error = null;
//     _successMessage = null;
//     notifyListeners();
//
//     try {
//       final token = await _getToken();
//       if (token == null) {
//         _error = 'Not authenticated';
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//
//       print('=== UPDATE SUBTASK DEBUG INFO ===');
//       print('Task ID: $taskId');
//       print('SubTask ID: $subTaskId');
//       print('Date: $date');
//       print('Description: $description');
//       print('Status: $status');
//       print('Hours Spent: $hoursSpent');
//       print('Remarks: $remarks');
//
//       // Call API to update subtask
//       final requestBody = {
//         'date': date,
//         'description': description,
//         'status': status,
//         'hoursSpent': hoursSpent,
//         'remarks': remarks,
//       };
//
//       // **USE THE CORRECT API ENDPOINT FOR UPDATING**
//       final response = await http.put(
//         Uri.parse('https://task-management-backend-bn2k.vercel.app/api/tasks/$taskId/subtaskDays/$subTaskId'), // Check this endpoint
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(requestBody),
//       );
//
//       print('Response Status: ${response.statusCode}');
//       print('Response Body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         _successMessage = 'Sub-task updated successfully';
//
//         // **CRITICAL: Update local task**
//         await _updateLocalTaskAfterSubTaskChange(taskId);
//
//         _isLoading = false;
//         notifyListeners();
//         return true;
//       } else {
//         final errorData = jsonDecode(response.body);
//         _error = errorData['message'] ?? 'Failed to update sub-task';
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       print('Exception: $e');
//       _error = 'Error: ${e.toString()}';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//   // Delete a sub-task
//   Future<bool> deleteSubTask({
//     required String taskId,
//     required String subTaskId,
//   }) async {
//     _isLoading = true;
//     _error = null;
//     _successMessage = null;
//     notifyListeners();
//
//     try {
//       final token = await _getToken();
//       if (token == null) {
//         _error = 'Not authenticated';
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//
//       // Find the task
//       final task = _tasks.firstWhere((t) => t.id == taskId);
//
//       // Find which day contains this subtask
//       DayEntry? targetDay;
//       int subTaskIndex = -1;
//
//       for (final day in task.days) {
//         final index = day.subTasks.indexWhere((st) => st.id == subTaskId);
//         if (index != -1) {
//           targetDay = day;
//           subTaskIndex = index;
//           break;
//         }
//       }
//
//       if (targetDay == null || subTaskIndex == -1) {
//         _error = 'Sub-task not found';
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//
//       // Create updated days list without the subtask
//       final updatedDays = task.days.map((day) {
//         if (day.date == targetDay!.date) {
//           final updatedSubTasks = List<SubTask>.from(day.subTasks);
//           updatedSubTasks.removeAt(subTaskIndex);
//           return DayEntry(
//             date: day.date,
//             subTasks: updatedSubTasks,
//           );
//         }
//         return day;
//       }).toList();
//
//       // Update the entire task
//       return await updateTask(
//         id: taskId,
//         title: task.title,
//         description: task.description,
//         companyId: task.company.id,
//         assignedToId: task.assignedTo.id,
//         startDate: task.startDate,
//         endDate: task.endDate,
//         priority: task.priority,
//         status: task.status,
//         progress: task.progress,
//         tags: task.tags,
//         days: updatedDays,
//       );
//     } catch (e) {
//       print('Exception: $e');
//       _error = 'Error: ${e.toString()}';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // Helper method to find or create a day entry
//   DayEntry? findDayEntry(String taskId, DateTime date) {
//     try {
//       final task = _tasks.firstWhere((t) => t.id == taskId);
//       final formattedDate = DateTime(date.year, date.month, date.day);
//
//       return task.days.firstWhere(
//             (day) =>
//         DateTime(day.date.year, day.date.month, day.date.day) == formattedDate,
//         orElse: () => DayEntry(date: date, subTasks: []),
//       );
//     } catch (e) {
//       return null;
//     }
//   }
//
//   // Filter methods
//   void setSearchQuery(String query) {
//     _searchQuery = query.toLowerCase();
//     _applyFilters();
//     notifyListeners();
//   }
//
//   void setFilterStatus(String status) {
//     _filterStatus = status;
//     _applyFilters();
//     notifyListeners();
//   }
//
//   void setFilterPriority(String priority) {
//     _filterPriority = priority;
//     _applyFilters();
//     notifyListeners();
//   }
//
//   void setFilterCompany(String company) {
//     _filterCompany = company;
//     _applyFilters();
//     notifyListeners();
//   }
//
//   void _applyFilters() {
//     _filteredTasks = _tasks.where((task) {
//       // Apply search filter
//       bool searchMatches = _searchQuery.isEmpty ||
//           task.title.toLowerCase().contains(_searchQuery) ||
//           task.description.toLowerCase().contains(_searchQuery) ||
//           task.assignedTo.name.toLowerCase().contains(_searchQuery) ||
//           task.company.name.toLowerCase().contains(_searchQuery);
//
//       // Apply status filter
//       bool statusMatches = _filterStatus == 'All' || task.status == _filterStatus;
//
//       // Apply priority filter
//       bool priorityMatches = _filterPriority == 'All' || task.priority == _filterPriority;
//
//       // Apply company filter
//       bool companyMatches = _filterCompany == 'All' || task.company.name == _filterCompany;
//
//       return searchMatches && statusMatches && priorityMatches && companyMatches;
//     }).toList();
//   }
//
//   void clearFilters() {
//     _searchQuery = '';
//     _filterStatus = 'All';
//     _filterPriority = 'All';
//     _filterCompany = 'All';
//     _applyFilters();
//     notifyListeners();
//   }
//
//   List<String> get uniqueCompanies {
//     final companies = _tasks.map((task) => task.company.name).toSet().toList();
//     companies.insert(0, 'All');
//     return companies;
//   }
//
//   void clearMessages() {
//     _error = null;
//     _successMessage = null;
//     notifyListeners();
//   }
//
//   // Helper method to get task by ID
//   Task? getTaskById(String id) {
//     try {
//       return _tasks.firstWhere((task) => task.id == id);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   // Helper method to calculate task statistics
//   Map<String, int> getTaskStatistics() {
//     final pending = _tasks.where((t) => t.status == 'pending').length;
//     final inProgress = _tasks.where((t) => t.status == 'in-progress').length;
//     final completed = _tasks.where((t) => t.status == 'completed').length;
//
//     return {
//       'pending': pending,
//       'inProgress': inProgress,
//       'completed': completed,
//       'total': _tasks.length,
//     };
//   }
// }
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

  // Get task by ID from local list
  Task? getTaskById(String taskId) {
    try {
      return _tasks.firstWhere((task) => task.id == taskId);
    } catch (e) {
      return null;
    }
  }

  // Update task in local list
  void _updateTaskInLocalList(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      _applyFilters();
      notifyListeners();
    }
  }

  Future<void> fetchTasks({bool forceRefresh = false}) async {
    if (forceRefresh && !_isLoading) {
      _tasks.clear();
      _filteredTasks.clear();
      notifyListeners();
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _getToken();
      print('=== FETCH TASKS DEBUG ===');
      print('Token: ${token != null ? "Exists" : "Null"}');
      print('Force Refresh: $forceRefresh');

      if (token == null) {
        _error = 'Not authenticated';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final role = prefs.getString('role');
      final companyId = prefs.getString('companyId');

      print('User Role: $role');
      print('Company ID: $companyId');

      String url = 'https://task-management-backend-bn2k.vercel.app/api/tasks';

      if (forceRefresh) {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        url += url.contains('?') ? '&t=$timestamp' : '?t=$timestamp';
      }

      if (role == 'manager' && companyId != null) {
        url += url.contains('?') ? '&company=$companyId' : '?company=$companyId';
      } else if (role == 'staff') {
        final userId = prefs.getString('userId');
        if (userId != null) {
          url += url.contains('?') ? '&assignedTo=$userId' : '?assignedTo=$userId';
        }
      }

      print('Final URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          if (forceRefresh) 'Cache-Control': 'no-cache',
        },
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body length: ${response.body.length}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final taskResponse = TaskListResponse.fromJson(data);

        // CRITICAL: Update tasks and notify
        _tasks = taskResponse.tasks;
        _applyFilters();
        _error = null;

        print('Successfully loaded ${_tasks.length} tasks');

        // NOTIFY LISTENERS HERE
        notifyListeners();

      } else if (response.statusCode == 401) {
        _error = 'Authentication failed. Please login again.';
      } else if (response.statusCode == 403) {
        _error = 'You don\'t have permission to view these tasks';
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

  // Fetch single task by ID and update local list
  Future<Task?> fetchTaskById(String taskId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return null;
      }

      final response = await http.get(
        Uri.parse('https://task-management-backend-bn2k.vercel.app/api/tasks/$taskId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final task = Task.fromJson(data['data']);

        // Update in local list
        _updateTaskInLocalList(task);

        return task;
      }
      return null;
    } catch (e) {
      print('Error fetching task by ID: $e');
      return null;
    }
  }

  // Add sub-task (FIXED VERSION)
  Future<bool> addSubTask({
    required String taskId,
    required String date,
    required String description,
    required String status,
    required int hoursSpent,
    required String remarks,
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

      print('=== ADD SUBTASK ===');
      print('Task ID: $taskId');
      print('Date: $date');
      print('Description: $description');

      final requestBody = {
        'date': date,
        'description': description,
        'status': status,
        'hoursSpent': hoursSpent,
        'remarks': remarks,
      };

      final response = await http.post(
        Uri.parse('https://task-management-backend-bn2k.vercel.app/api/tasks/$taskId/subtaskDays'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _successMessage = 'Sub-task added successfully';

        // CRITICAL: Fetch updated task data
        await fetchTaskById(taskId);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        _error = errorData['message'] ?? 'Failed to add sub-task';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      _error = 'Error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update sub-task (FIXED VERSION)
  Future<bool> updateSubTask({
    required String taskId,
    required String subTaskId,
    required String date,
    required String description,
    required String status,
    required int hoursSpent,
    required String remarks,
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

      print('=== UPDATE SUBTASK ===');
      print('Task ID: $taskId');
      print('SubTask ID: $subTaskId');
      print('Description: $description');

      // First, let's try to find what endpoint to use
      // Based on your API structure, try this endpoint
      final requestBody = {
        'date': date,
        'description': description,
        'status': status,
        'hoursSpent': hoursSpent,
        'remarks': remarks,
      };

      // Try PUT request to update subtask
      final response = await http.put(
        Uri.parse('https://task-management-backend-bn2k.vercel.app/api/tasks/$taskId/subtasks/$subTaskId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        _successMessage = 'Sub-task updated successfully';

        // CRITICAL: Fetch updated task data
        await fetchTaskById(taskId);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        // If the above endpoint doesn't work, try updating the entire task
        final task = getTaskById(taskId);
        if (task != null) {
          // This is a fallback - update the entire task
          return await updateTask(
            id: taskId,
            title: task.title,
            description: task.description,
            companyId: task.company.id,
            assignedToId: task.assignedTo.id,
            startDate: task.startDate,
            endDate: task.endDate,
            priority: task.priority,
            status: task.status,
            progress: task.progress,
            tags: task.tags,
            days: task.days, // Days will contain the updated subtask
          );
        }

        final errorData = jsonDecode(response.body);
        _error = errorData['message'] ?? 'Failed to update sub-task';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      _error = 'Error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete sub-task (FIXED VERSION)
  Future<bool> deleteSubTask({
    required String taskId,
    required String subTaskId,
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

      print('=== DELETE SUBTASK ===');
      print('Task ID: $taskId');
      print('SubTask ID: $subTaskId');

      // Try DELETE request
      final response = await http.delete(
        Uri.parse('https://task-management-backend-bn2k.vercel.app/api/tasks/$taskId/subtasks/$subTaskId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        _successMessage = 'Sub-task deleted successfully';

        // CRITICAL: Fetch updated task data
        await fetchTaskById(taskId);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        // Fallback: If DELETE endpoint doesn't work, update the entire task
        final task = getTaskById(taskId);
        if (task != null) {
          // Find and remove the subtask from days
          final updatedDays = task.days.map((day) {
            final updatedSubTasks = day.subTasks.where((st) => st.id != subTaskId).toList();
            return DayEntry(
              date: day.date,
              subTasks: updatedSubTasks,
            );
          }).toList();

          return await updateTask(
            id: taskId,
            title: task.title,
            description: task.description,
            companyId: task.company.id,
            assignedToId: task.assignedTo.id,
            startDate: task.startDate,
            endDate: task.endDate,
            priority: task.priority,
            status: task.status,
            progress: task.progress,
            tags: task.tags,
            days: updatedDays,
          );
        }

        final errorData = jsonDecode(response.body);
        _error = errorData['message'] ?? 'Failed to delete sub-task';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      _error = 'Error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update task (already exists, keep as is)
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
    required List<DayEntry> days,
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
          'days': days.map((day) => day.toJson()).toList(),
        }),
      );

      if (response.statusCode == 200) {
        _successMessage = 'Task updated successfully';
        await fetchTasks(forceRefresh: true); // Force refresh all tasks
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

  // Create task (already exists, keep as is)
  Future<bool> createTask({
    required String title,
    required String description,
    required String companyId,
    required String assignedToId,
    required DateTime startDate,
    required DateTime endDate,
    required String priority,
    required List<String> tags,
    required List<DayEntry> days,
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

      final requestBody = {
        'title': title,
        'description': description,
        'company': companyId,
        'assignedTo': assignedToId,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'priority': priority,
        'tags': tags,
        'days': days.map((day) => day.toJson()).toList(),
      };

      final response = await http.post(
        Uri.parse('https://task-management-backend-bn2k.vercel.app/api/tasks'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        _successMessage = 'Task created successfully';
        await fetchTasks(forceRefresh: true);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        _error = errorData['message'] ?? 'Failed to create task';
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

  // Delete task (already exists, keep as is)
  Future<bool> deleteTask(String id) async {
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
        _successMessage = 'Task deleted successfully';
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        _error = errorData['message'] ?? 'Failed to delete task';
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

  // Filter methods (keep as is)
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
      bool searchMatches = _searchQuery.isEmpty ||
          task.title.toLowerCase().contains(_searchQuery) ||
          task.description.toLowerCase().contains(_searchQuery) ||
          task.assignedTo.name.toLowerCase().contains(_searchQuery) ||
          task.company.name.toLowerCase().contains(_searchQuery);

      bool statusMatches = _filterStatus == 'All' || task.status == _filterStatus;
      bool priorityMatches = _filterPriority == 'All' || task.priority == _filterPriority;
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

  Map<String, int> getTaskStatistics() {
    final pending = _tasks.where((t) => t.status == 'pending').length;
    final inProgress = _tasks.where((t) => t.status == 'in-progress').length;
    final completed = _tasks.where((t) => t.status == 'completed').length;

    return {
      'pending': pending,
      'inProgress': inProgress,
      'completed': completed,
      'total': _tasks.length,
    };
  }
}