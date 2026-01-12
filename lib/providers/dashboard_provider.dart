import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/dashboard_model.dart';


class DashboardProvider with ChangeNotifier {
  DashboardStats? _dashboardStats;
  bool _isLoading = false;
  String? _error;

  DashboardStats? get dashboardStats => _dashboardStats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDashboardData(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://task-management-backend-bn2k.vercel.app/api/dashboard/stats'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _dashboardStats = DashboardStats.fromJson(data['data']);
        _error = null;
      } else {
        _error = 'Failed to load dashboard data';
      }
    } catch (e) {
      _error = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void refreshData(String token) {
    fetchDashboardData(token);
  }
}