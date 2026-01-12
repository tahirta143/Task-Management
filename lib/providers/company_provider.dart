import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/company_model.dart';

class CompanyProvider with ChangeNotifier {
  List<Company> _companies = [];
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  List<Company> get companies => _companies;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;
  int get companyCount => _companies.length;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchCompanies() async {
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
        Uri.parse('https://task-management-backend-bn2k.vercel.app/api/companies'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final companyResponse = CompanyListResponse.fromJson(data);
        _companies = companyResponse.companies;
        _error = null;
      } else {
        _error = 'Failed to load companies: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createCompany({
    required String name,
    required String description,
    required String address,
    required String phone,
    required String email,
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

      final response = await http.post(
        Uri.parse('https://task-management-backend-bn2k.vercel.app/api/companies'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'address': address,
          'phone': phone,
          'email': email,
        }),
      );

      if (response.statusCode == 201) {
        _successMessage = 'Company created successfully';
        await fetchCompanies(); // Refresh list
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        _error = errorData['message'] ?? 'Failed to create company';
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

  Future<bool> updateCompany({
    required String id,
    required String name,
    required String description,
    required String address,
    required String phone,
    required String email,
    required bool isActive,
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
        Uri.parse('https://task-management-backend-bn2k.vercel.app/api/companies/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'address': address,
          'phone': phone,
          'email': email,
          'isActive': isActive,
        }),
      );

      if (response.statusCode == 200) {
        _successMessage = 'Company updated successfully';
        await fetchCompanies(); // Refresh list
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        _error = errorData['message'] ?? 'Failed to update company';
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

  Future<bool> deleteCompany(String id) async {
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
        Uri.parse('https://task-management-backend-bn2k.vercel.app/api/companies/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _companies.removeWhere((company) => company.id == id);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to delete company';
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

  Future<void> toggleCompanyStatus(String id, bool currentStatus) async {
    final company = _companies.firstWhere((c) => c.id == id);
    await updateCompany(
      id: id,
      name: company.name,
      description: company.description,
      address: company.address,
      phone: company.phone,
      email: company.email,
      isActive: !currentStatus,
    );
  }

  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }

  void clearCompanies() {
    _companies = [];
    notifyListeners();
  }
}