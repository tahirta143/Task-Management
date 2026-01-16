import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../ApiLink.dart';
import '../models/password_change_model.dart';

class PasswordProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;

  Future<PasswordChangeResponse> changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
  }) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final request = PasswordChangeRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      final response = await http.put(
        Uri.parse('${Apilink.api}/users/change-password'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      print('Change Password Response Status: ${response.statusCode}');
      print('Change Password Response Body: ${response.body}');

      final data = jsonDecode(response.body);
      final passwordResponse = PasswordChangeResponse.fromJson(data);

      if (response.statusCode == 200 && passwordResponse.success) {
        _successMessage = passwordResponse.message;
        _error = null;
      } else {
        _error = passwordResponse.message;
        _successMessage = null;
      }

      _isLoading = false;
      notifyListeners();
      return passwordResponse;

    } catch (e) {
      _error = 'Network error: ${e.toString()}';
      _successMessage = null;
      _isLoading = false;
      notifyListeners();

      return PasswordChangeResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }
// Add these methods to your PasswordProvider class
  void setError(String error) {
    _error = error;
    _successMessage = null;
    notifyListeners();
  }

  void setSuccessMessage(String message) {
    _successMessage = message;
    _error = null;
    notifyListeners();
  }
  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }
}