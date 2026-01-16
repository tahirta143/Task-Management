// providers/user_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  List<User> _filteredUsers = [];
  bool _isLoading = false;
  String? _error;
  String _filterRole = 'All';
  String _searchQuery = '';

  List<User> get users => _filteredUsers;
  List<User> get allUsers => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get filterRole => _filterRole;
  String get searchQuery => _searchQuery;

  List<String> get roleOptions => ['All', 'admin', 'manager', 'staff'];

  Future<void> fetchUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.get(
        Uri.parse('https://task-management-backend-bn2k.vercel.app/api/users'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final usersList = List<Map<String, dynamic>>.from(data['users']);
          _users = usersList.map((user) => User.fromJson(user)).toList();
          _applyFilters();
        } else {
          throw Exception('Failed to fetch users');
        }
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilterRole(String role) {
    _filterRole = role;
    _applyFilters();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredUsers = _users.where((user) {
      // Apply role filter
      bool roleMatches = _filterRole == 'All' || user.role == _filterRole;

      // Apply search filter
      bool searchMatches = _searchQuery.isEmpty ||
          user.name.toLowerCase().contains(_searchQuery) ||
          user.email.toLowerCase().contains(_searchQuery) ||
          (user.number?.toLowerCase() ?? '').contains(_searchQuery) ||
          user.company!.name.toLowerCase().contains(_searchQuery) ?? false;

      return roleMatches && searchMatches;
    }).toList();
  }

  void clearFilters() {
    _filterRole = 'All';
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }
  // Add these methods to your existing UserProvider class

  Future<bool> createUser({
    required String name,
    required String email,
    required String number,
    required String role,
    String? password,
    String? companyID,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final Map<String, dynamic> requestBody = {
        'name': name,
        'email': email,
        'number': number,
        'role': role,
        'isActive': true,
      };

      // IMPORTANT CHANGE: Add password for both manager and staff roles
      // When password is provided, include it in the request
      if (password != null && password.isNotEmpty) {
        requestBody['password'] = password;
      } else if (role == 'manager' || role == 'staff') {
        // For manager and staff roles, password is required
        // If not provided, let the backend handle it or show error
        // You can uncomment the line below to require password
        // throw Exception('Password is required for $role role');
      }

      // Add companyID if provided (for admin)
      if (companyID != null && companyID.isNotEmpty) {
        requestBody['company'] = companyID; // Changed from 'companyID' to 'company'
      }

      print('Creating user with request body: $requestBody');

      final response = await http.post(
        Uri.parse('https://task-management-backend-bn2k.vercel.app/api/users'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        // Refresh the user list
        await fetchUsers();
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to create user');
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateUser({
    required String id,
    required String name,
    required String email,
    required String number,
    required String role,
    required bool isActive,
    String? companyID,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final Map<String, dynamic> requestBody = {
        'name': name,
        'email': email,
        'number': number,
        'role': role,
        'isActive': isActive,
      };

      // Add companyID if provided (for admin)
      if (companyID != null && companyID.isNotEmpty) {
        requestBody['companyID'] = companyID;
        print(requestBody);
      }

      final response = await http.put(
        Uri.parse('https://task-management-backend-bn2k.vercel.app/api/users/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),

      );

      if (response.statusCode == 200) {
        await fetchUsers();
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update user');
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteUser(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.delete(
        Uri.parse('https://task-management-backend-bn2k.vercel.app/api/users/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Delete API Response - Status: ${response.statusCode}');
      print('Delete API Response - Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Remove the user from the main list
        final initialCount = _users.length;
        _users.removeWhere((user) => user.id == id);
        print('Removed user $id from _users list. Before: $initialCount, After: ${_users.length}');

        // IMPORTANT: Re-apply filters to update _filteredUsers
        _applyFilters();

        print('Filters applied. Filtered users count: ${_filteredUsers.length}');

        return true;
      } else {
        final data = jsonDecode(response.body);
        final errorMessage = data['message'] ?? 'Failed to delete user (Status: ${response.statusCode})';
        print('Delete failed: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      _error = e.toString();
      print('Delete error caught: $_error');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
      print('Delete operation completed. isLoading: $_isLoading');
    }
  }
}