class PasswordChangeRequest {
  final String currentPassword;
  final String newPassword;

  PasswordChangeRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
  }
}

class PasswordChangeResponse {
  final bool success;
  final String message;

  PasswordChangeResponse({
    required this.success,
    required this.message,
  });

  factory PasswordChangeResponse.fromJson(Map<String, dynamic> json) {
    return PasswordChangeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}