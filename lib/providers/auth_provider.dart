// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // class AuthProvider with ChangeNotifier {
// //   String? _companyId;
// //
// //   String? get companyId => _companyId;
// //   String? _token;
// //   String? _role;
// //   String? _userId;
// //   String? _userName;
// //   bool _isLoading = false;
// //   String? _error;
// //
// //   String? get token => _token;
// //   String? get role => _role;
// //   String? get userId => _userId;
// //   String? get userName => _userName;
// //   bool get isLoading => _isLoading;
// //   String? get error => _error;
// //   bool get isAuthenticated => _token != null;
// //
// //   // Check if user is admin
// //   bool get isAdmin => _role == 'admin';
// //
// //   // Check if user is manager
// //   bool get isManager => _role == 'manager';
// //
// //   // Check if user is staff
// //   bool get isStaff => _role == 'staff';
// //
// //   AuthProvider() {
// //     _loadStoredData();
// //   }
// //
// //   // Future<void> _loadStoredData() async {
// //   //   final prefs = await SharedPreferences.getInstance();
// //   //   _token = prefs.getString('token');
// //   //   _role = prefs.getString('role');
// //   //   _userId = prefs.getString('userId');
// //   //   _userName = prefs.getString('userName');
// //   //   notifyListeners();
// //   // }
// //   Future<void> _loadStoredData() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     _token = prefs.getString('token');
// //     _role = prefs.getString('role');
// //     _userId = prefs.getString('userId');
// //     _userName = prefs.getString('userName');
// //     _companyId = prefs.getString('companyId');
// //     notifyListeners();
// //   }
// //
//
// //   // Future<bool> login(String email, String password) async {
// //   //   _isLoading = true;
// //   //   _error = null;
// //   //   notifyListeners();
// //   //
// //   //   try {
// //   //     final response = await http.post(
// //   //       Uri.parse('https://task-management-backend-bn2k.vercel.app/api/auth/login'),
// //   //       headers: {'Content-Type': 'application/json'},
// //   //       body: jsonEncode({'email': email, 'password': password}),
// //   //     );
// //   //
// //   //     if (response.statusCode == 200) {
// //   //       final data = jsonDecode(response.body);
// //   //       _token = data['token'];
// //   //       _role = data['user']['role'];
// //   //       _userId = data['user']['_id'];
// //   //       _userName = data['user']['name'];
// //   //       _companyId = data['user']['company']?['_id'];
// //   //
// //   //
// //   //       final prefs = await SharedPreferences.getInstance();
// //   //       await prefs.setString('token', _token!);
// //   //       await prefs.setString('role', _role!);
// //   //       await prefs.setString('userId', _userId!);
// //   //       await prefs.setString('userName', _userName!);
// //   //
// //   //       _isLoading = false;
// //   //       notifyListeners();
// //   //       return true;
// //   //     } else {
// //   //       _error = 'Invalid email or password';
// //   //       _isLoading = false;
// //   //       notifyListeners();
// //   //       return false;
// //   //     }
// //   //   } catch (e) {
// //   //     _error = 'Network error: ${e.toString()}';
// //   //     _isLoading = false;
// //   //     notifyListeners();
// //   //     return false;
// //   //   }
// //   // }
// //   Future<bool> login(String email, String password) async {
// //     _isLoading = true;
// //     _error = null;
// //     notifyListeners();
// //
// //     try {
// //       final response = await http.post(
// //         Uri.parse('https://task-management-backend-bn2k.vercel.app/api/auth/login'),
// //         headers: {'Content-Type': 'application/json'},
// //         body: jsonEncode({'email': email, 'password': password}),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         _token = data['token'];
// //         _role = data['user']['role'];
// //         _userId = data['user']['_id'];
// //         _userName = data['user']['name'];
// //         _companyId = data['user']['company']?['_id'];
// //
// //         final prefs = await SharedPreferences.getInstance();
// //         await prefs.setString('token', _token!);
// //         await prefs.setString('role', _role!);
// //         await prefs.setString('userId', _userId!);
// //         await prefs.setString('userName', _userName!);
// //
// //         // Also store the full user object as JSON
// //         await prefs.setString('user', jsonEncode(data['user']));
// //
// //         // Store company ID if available
// //         if (_companyId != null) {
// //           await prefs.setString('companyId', _companyId!);
// //         }
// //
// //         _isLoading = false;
// //         notifyListeners();
// //         return true;
// //       } else {
// //         _error = 'Invalid email or password';
// //         _isLoading = false;
// //         notifyListeners();
// //         return false;
// //       }
// //     } catch (e) {
// //       _error = 'Network error: ${e.toString()}';
// //       _isLoading = false;
// //       notifyListeners();
// //       return false;
// //     }
// //   }
// //
// //   Future<void> logout() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.clear();
// //
// //     _token = null;
// //     _role = null;
// //     _userId = null;
// //     _userName = null;
// //     _error = null;
// //
// //     notifyListeners();
// //   }
// //
// //   void clearError() {
// //     _error = null;
// //     notifyListeners();
// //   }
// //   // Add this method to your AuthProvider class
// //   Future<bool> addUser({
// //     required String name,
// //     required String email,
// //     required String role,
// //     required String companyId,
// //     String? password,
// //     String? number,
// //     bool isActive = true,
// //   }) async {
// //     _isLoading = true;
// //     _error = null;
// //     notifyListeners();
// //
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       final token = prefs.getString('token');
// //
// //       if (token == null) {
// //         throw Exception('No authentication token found');
// //       }
// //
// //       final Map<String, dynamic> requestBody = {
// //         'name': name,
// //         'email': email,
// //         'role': role,
// //         'company': companyId,
// //         'isActive': isActive,
// //       };
// //
// //       // Add password only if provided (for manager creation)
// //       if (password != null && password.isNotEmpty) {
// //         requestBody['password'] = password;
// //       }
// //
// //       // Add number if provided
// //       if (number != null && number.isNotEmpty) {
// //         requestBody['number'] = int.tryParse(number) ?? 0;
// //       }
// //
// //       print('Add User Request: $requestBody');
// //
// //       final response = await http.post(
// //         Uri.parse('https://task-management-backend-bn2k.vercel.app/api/users'),
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //         body: jsonEncode(requestBody),
// //       );
// //
// //       print('Add User Response Status: ${response.statusCode}');
// //       print('Add User Response Body: ${response.body}');
// //
// //       if (response.statusCode == 201) {
// //         final data = jsonDecode(response.body);
// //         if (data['success']) {
// //           _isLoading = false;
// //           notifyListeners();
// //           return true;
// //         } else {
// //           _error = data['message'] ?? 'Failed to create user';
// //           _isLoading = false;
// //           notifyListeners();
// //           return false;
// //         }
// //       } else {
// //         final data = jsonDecode(response.body);
// //         _error = data['message'] ?? 'Failed to create user. Status: ${response.statusCode}';
// //         _isLoading = false;
// //         notifyListeners();
// //         return false;
// //       }
// //     } catch (e) {
// //       _error = 'Network error: ${e.toString()}';
// //       _isLoading = false;
// //       notifyListeners();
// //       return false;
// //     }
// //   }
// //
// // }
//
//
//
// import 'dart:convert';
// import 'dart:math';
//
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AuthProvider with ChangeNotifier {
//   String? _companyId;
//   String? _token;
//   String? _role;
//   String? _userId;
//   String? _userName;
//   bool _isLoading = false;
//   String? _error;
//
//   String? get companyId => _companyId;
//   String? get token => _token;
//   String? get role => _role;
//   String? get userId => _userId;
//   String? get userName => _userName;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   bool get isAuthenticated => _token != null;
//
//   // Check if user is admin
//   bool get isAdmin => _role == 'admin';
//
//   // Check if user is manager
//   bool get isManager => _role == 'manager';
//
//   // Check if user is staff
//   bool get isStaff => _role == 'staff';
//
//   // Add a getter for the full user object
//   Map<String, dynamic>? get user {
//     if (_userId == null) return null;
//     return {
//       '_id': _userId,
//       'name': _userName,
//       'role': _role,
//       'companyId': _companyId,
//     };
//   }
//
//   AuthProvider() {
//     // Load stored data immediately when provider is created
//     _loadStoredData();
//   }
//
//
//
//   Future<void> _loadStoredData() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       print('=== LOADING STORED DATA ===');
//       print('Token: ${prefs.getString('token')?.substring(0, min(20, prefs.getString('token')?.length ?? 0))}...');
//       print('User ID: ${prefs.getString('userId')}');
//       print('User Name: ${prefs.getString('userName')}');
//       print('Role: ${prefs.getString('role')}');
//       print('Company ID: ${prefs.getString('companyId')}');
//
//       _token = prefs.getString('token');
//       _role = prefs.getString('role');
//       _userId = prefs.getString('userId');
//       _userName = prefs.getString('userName');
//       _companyId = prefs.getString('companyId');
//
//       print('Loaded user: $_userId, role: $_role, company: $_companyId');
//       notifyListeners();
//     } catch (e) {
//       print('Error loading stored data: $e');
//     }
//   }
//
//   // Future<bool> login(String email, String password) async {
//   //   _isLoading = true;
//   //   _error = null;
//   //   notifyListeners();
//   //
//   //   try {
//   //     final response = await http.post(
//   //       Uri.parse('https://task-management-backend-bn2k.vercel.app/api/auth/login'),
//   //       headers: {'Content-Type': 'application/json'},
//   //       body: jsonEncode({'email': email, 'password': password}),
//   //     );
//   //
//   //     if (response.statusCode == 200) {
//   //       final data = jsonDecode(response.body);
//   //       print('=== LOGIN RESPONSE ===');
//   //       print('Full response: $data');
//   //
//   //       _token = data['token'];
//   //       _role = data['user']['role'];
//   //       _userId = data['user']['_id'];
//   //       _userName = data['user']['name'];
//   //       _companyId = data['user']['company']?['_id'];
//   //
//   //       final prefs = await SharedPreferences.getInstance();
//   //       await prefs.setString('token', _token!);
//   //       await prefs.setString('role', _role!);
//   //       await prefs.setString('userId', _userId!);
//   //       await prefs.setString('userName', _userName!);
//   //
//   //       // Also store the full user object as JSON
//   //       await prefs.setString('user', jsonEncode(data['user']));
//   //
//   //       // Store company ID if available
//   //       if (_companyId != null) {
//   //         await prefs.setString('companyId', _companyId!);
//   //       }
//   //
//   //       _isLoading = false;
//   //       notifyListeners();
//   //       return true;
//   //     } else {
//   //       final errorData = jsonDecode(response.body);
//   //       _error = errorData['message'] ?? 'Invalid email or password';
//   //       _isLoading = false;
//   //       notifyListeners();
//   //       return false;
//   //     }
//   //   } catch (e) {
//   //     _error = 'Network error: ${e.toString()}';
//   //     _isLoading = false;
//   //     notifyListeners();
//   //     return false;
//   //   }
//   // }
//   Future<bool> login(String email, String password) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       final response = await http.post(
//         Uri.parse('https://task-management-backend-bn2k.vercel.app/api/auth/login'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'email': email, 'password': password}),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print('=== LOGIN RESPONSE ===');
//         print('Full response: $data');
//
//         _token = data['token'];
//         _role = data['user']['role'];
//         _userId = data['user']['_id'] ?? data['user']['id'];
//         _userName = data['user']['name'];
//
//         // Handle company field - it might not exist for admins
//         final companyField = data['user']['company'];
//         if (companyField != null) {
//           if (companyField is String) {
//             _companyId = companyField;
//           } else if (companyField is Map<String, dynamic>) {
//             _companyId = companyField['_id'];
//           } else {
//             _companyId = null;
//           }
//         } else {
//           _companyId = null;
//         }
//
//         print('=== EXTRACTED VALUES ===');
//         print('User ID: $_userId');
//         print('Role: $_role');
//         print('Company ID: $_companyId');
//         print('Is Admin: ${_role == 'admin'}');
//         print('Is Manager: ${_role == 'manager'}');
//
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('token', _token!);
//         await prefs.setString('role', _role!);
//         await prefs.setString('userId', _userId!);
//         await prefs.setString('userName', _userName!);
//
//         // Store the full user object
//         await prefs.setString('user', jsonEncode(data['user']));
//
//         // Store company ID only if it exists
//         if (_companyId != null) {
//           await prefs.setString('companyId', _companyId!);
//         } else {
//           // Remove company ID if it doesn't exist (for admin)
//           await prefs.remove('companyId');
//         }
//
//         _isLoading = false;
//         notifyListeners();
//         return true;
//       } else {
//         final errorData = jsonDecode(response.body);
//         _error = errorData['message'] ?? 'Invalid email or password';
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       _error = 'Network error: ${e.toString()}';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//
//     _token = null;
//     _role = null;
//     _userId = null;
//     _userName = null;
//     _companyId = null;
//     _error = null;
//
//     notifyListeners();
//   }
//
//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }
//
//   // Debug method
//   Future<void> printStoredData() async {
//     final prefs = await SharedPreferences.getInstance();
//     print('=== CURRENT STORED DATA ===');
//     print('Token exists: ${prefs.getString('token') != null}');
//     print('User ID: ${prefs.getString('userId')}');
//     print('User Name: ${prefs.getString('userName')}');
//     print('Role: ${prefs.getString('role')}');
//     print('Company ID: ${prefs.getString('companyId')}');
//     print('User JSON: ${prefs.getString('user')}');
//   }
//
// }

import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart'; // Import User model

class AuthProvider with ChangeNotifier {
  String? _companyId;
  String? _token;
  String? _role;
  String? _userId;
  String? _userName;
  String? _userEmail; // Add email field
  bool _isLoading = false;
  String? _error;

  String? get companyId => _companyId;
  String? get token => _token;
  String? get role => _role;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail; // Add email getter
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _token != null;

  // Check if user is admin
  bool get isAdmin => _role == 'admin';

  // Check if user is manager
  bool get isManager => _role == 'manager';

  // Check if user is staff
  bool get isStaff => _role == 'staff';

  // Add currentUser getter that returns User object
  User? get currentUser {
    if (_userId == null || _userName == null || _userEmail == null || _role == null) {
      return null;
    }
    return User(
      id: _userId!,
      name: _userName!,
      email: _userEmail!,
      role: _role!,
    );
  }

  AuthProvider() {
    // Load stored data immediately when provider is created
    _loadStoredData();
  }

  Future<void> _loadStoredData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('=== LOADING STORED DATA ===');
      print('Token exists: ${prefs.getString('token') != null}');
      print('User ID: ${prefs.getString('userId')}');
      print('User Name: ${prefs.getString('userName')}');
      print('User Email: ${prefs.getString('userEmail')}');
      print('Role: ${prefs.getString('role')}');
      print('Company ID: ${prefs.getString('companyId')}');

      _token = prefs.getString('token');
      _role = prefs.getString('role');
      _userId = prefs.getString('userId');
      _userName = prefs.getString('userName');
      _userEmail = prefs.getString('userEmail'); // Load email
      _companyId = prefs.getString('companyId');

      print('Loaded user: $_userId, role: $_role, email: $_userEmail, company: $_companyId');
      notifyListeners();
    } catch (e) {
      print('Error loading stored data: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('https://task-management-backend-bn2k.vercel.app/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('=== LOGIN RESPONSE ===');
        print('Full response: $data');

        _token = data['token'];
        _role = data['user']['role'];
        _userId = data['user']['_id'] ?? data['user']['id'];
        _userName = data['user']['name'];
        _userEmail = data['user']['email']; // Save email

        // Handle company field - it might not exist for admins
        final companyField = data['user']['company'];
        if (companyField != null) {
          if (companyField is String) {
            _companyId = companyField;
          } else if (companyField is Map<String, dynamic>) {
            _companyId = companyField['_id'];
          } else {
            _companyId = null;
          }
        } else {
          _companyId = null;
        }

        print('=== EXTRACTED VALUES ===');
        print('User ID: $_userId');
        print('User Name: $_userName');
        print('User Email: $_userEmail');
        print('Role: $_role');
        print('Company ID: $_companyId');
        print('Is Admin: ${_role == 'admin'}');
        print('Is Manager: ${_role == 'manager'}');

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('role', _role!);
        await prefs.setString('userId', _userId!);
        await prefs.setString('userName', _userName!);
        await prefs.setString('userEmail', _userEmail!); // Save email

        // Store the full user object
        await prefs.setString('user', jsonEncode(data['user']));

        // Store company ID only if it exists
        if (_companyId != null) {
          await prefs.setString('companyId', _companyId!);
        } else {
          // Remove company ID if it doesn't exist (for admin)
          await prefs.remove('companyId');
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        _error = errorData['message'] ?? 'Invalid email or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Network error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _token = null;
    _role = null;
    _userId = null;
    _userName = null;
    _userEmail = null; // Clear email
    _companyId = null;
    _error = null;

    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Debug method
  Future<void> printStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    print('=== CURRENT STORED DATA ===');
    print('Token exists: ${prefs.getString('token') != null}');
    print('User ID: ${prefs.getString('userId')}');
    print('User Name: ${prefs.getString('userName')}');
    print('User Email: ${prefs.getString('userEmail')}');
    print('Role: ${prefs.getString('role')}');
    print('Company ID: ${prefs.getString('companyId')}');
    print('User JSON: ${prefs.getString('user')}');
  }

  // Method to add user (keeping your existing method)
  Future<bool> addUser({
    required String name,
    required String email,
    required String role,
    required String companyId,
    String? password,
    String? number,
    bool isActive = true,
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
        'role': role,
        'company': companyId,
        'isActive': isActive,
      };

      // Add password only if provided (for manager creation)
      if (password != null && password.isNotEmpty) {
        requestBody['password'] = password;
      }

      // Add number if provided
      if (number != null && number.isNotEmpty) {
        requestBody['number'] = int.tryParse(number) ?? 0;
      }

      print('Add User Request: $requestBody');

      final response = await http.post(
        Uri.parse('https://task-management-backend-bn2k.vercel.app/api/users'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('Add User Response Status: ${response.statusCode}');
      print('Add User Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _error = data['message'] ?? 'Failed to create user';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        final data = jsonDecode(response.body);
        _error = data['message'] ?? 'Failed to create user. Status: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Network error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Helper method for testing - set mock user
  void setMockUser({String role = 'admin'}) {
    _userId = 'mock-user-id';
    _userName = 'Mock User';
    _userEmail = 'mock@example.com';
    _role = role;
    _companyId = role == 'admin' ? null : 'mock-company-id';
    notifyListeners();
  }
}