import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taskflow_app/ApiLink.dart';
import '../models/dashboard_model.dart';

class DashboardProvider with ChangeNotifier {
  DashboardStats? _dashboardStats;
  bool _isLoading = false;
  bool _isInitialLoading = false;
  String? _error;

  DashboardStats? get dashboardStats => _dashboardStats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // NEW: Getter to check if we should show shimmer
  bool get shouldShowShimmer => _isInitialLoading && _dashboardStats == null;


  Future<void> fetchDashboardData(String token) async {
    // Only set loading state and notify if we're not already loading
    if (_dashboardStats == null) {
      _isInitialLoading = true;
    }  _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('${Apilink.api}/dashboard/stats'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Print the raw response for debugging
      print('Dashboard API Response:');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _dashboardStats = DashboardStats.fromJson(data['data']);
        _error = null;
        _isInitialLoading = false;
        // Print the parsed dashboard stats
        print('\n=== Dashboard Stats Data ===');
        print('TASKS:');
        print('  Total: ${_dashboardStats?.tasks.total}');
        print('  Completed: ${_dashboardStats?.tasks.completed}');
        print('  Pending: ${_dashboardStats?.tasks.pending}');
        print('  In Progress: ${_dashboardStats?.tasks.inProgress}');
        print('  Delayed: ${_dashboardStats?.tasks.delayed}');

        print('\nSUBTASKS:');
        print('  Total: ${_dashboardStats?.subtasks.total}');
        print('  Completed: ${_dashboardStats?.subtasks.completed}');
        print('  Pending: ${_dashboardStats?.subtasks.pending}');
        print('  In Progress: ${_dashboardStats?.subtasks.inProgress}');
        print('  Delayed: ${_dashboardStats?.subtasks.delayed}');

        print('\nSUMMARY:');
        print('  Total Work: ${_dashboardStats?.summary.totalWork}');
        print('  Completed Work: ${_dashboardStats?.summary.completedWork}');
        print('  Productivity: ${_dashboardStats?.summary.productivity}%');

        print('\nRECENT TASKS: ${_dashboardStats?.recentTasks.length} items');
        for (var i = 0; i < (_dashboardStats?.recentTasks.length ?? 0); i++) {
          final task = _dashboardStats!.recentTasks[i];
          print('  Task ${i + 1}: ${task.title}');
          print('    Status: ${task.status}');
          print('    Company: ${task.company.name}');
          print('    Assigned To: ${task.assignedTo.name}');
          print('    Progress: ${task.progress}%');
        }

        print('============================\n');

      } else {
        _error = 'Failed to load dashboard data: ${response.statusCode}';
        print('Error: $_error');
        _isInitialLoading = false;
      }
    } catch (e) {
      _error = 'Error: ${e.toString()}';
      print('Exception: $_error');
      _isInitialLoading = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Make refreshData return Future<void> to match the async pattern
  Future<void> refreshData(String token) async {
    await fetchDashboardData(token);
  }
  void clearData() {
    _dashboardStats = null;
    _isLoading = false;
    _isInitialLoading = false;
    _error = null;
    notifyListeners();
  }
  // Helper method to print stats
  void printDashboardStats() {
    if (_dashboardStats != null) {
      print('\n=== Current Dashboard Stats ===');
      print('TASKS:');
      print('  Total: ${_dashboardStats!.tasks.total}');
      print('  Completed: ${_dashboardStats!.tasks.completed}');
      print('  Pending: ${_dashboardStats!.tasks.pending}');
      print('  In Progress: ${_dashboardStats!.tasks.inProgress}');
      print('  Delayed: ${_dashboardStats!.tasks.delayed}');

      print('\nSUBTASKS:');
      print('  Total: ${_dashboardStats!.subtasks.total}');
      print('  Completed: ${_dashboardStats!.subtasks.completed}');
      print('  Pending: ${_dashboardStats!.subtasks.pending}');
      print('  In Progress: ${_dashboardStats!.subtasks.inProgress}');
      print('  Delayed: ${_dashboardStats!.subtasks.delayed}');

      print('\nSUMMARY:');
      print('  Total Work: ${_dashboardStats!.summary.totalWork}');
      print('  Completed Work: ${_dashboardStats!.summary.completedWork}');
      print('  Productivity: ${_dashboardStats!.summary.productivity}%');

      print('===============================\n');
    } else {
      print('Dashboard stats are null');
    }
  }
}