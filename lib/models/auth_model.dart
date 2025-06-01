class AuthResponse {
  final String? token;
  final String? refreshToken;
  final String? message;
  final bool success;
  final User? user;

  AuthResponse({
    this.token,
    this.refreshToken,
    this.message,
    this.success = false,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      refreshToken: json['refreshToken'],
      message: json['message'],
      success: json['success'] ?? false,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  factory AuthResponse.error(String message) {
    return AuthResponse(message: message, success: false);
  }
}

class User {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? telephone;
  final String? email;

  User({this.id, this.firstName, this.lastName, this.telephone, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      telephone: json['telephone'],
      email: json['email'],
    );
  }

  String get fullName => '$firstName $lastName'.trim();
}

class AuthRequest {
  final String telephone;
  final String password;
  final String ipAddress;
  final String deviceInfo;

  AuthRequest({
    required this.telephone,
    required this.password,
    required this.ipAddress,
    required this.deviceInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'telephone': telephone,
      'password': password,
      'ipAddress': ipAddress,
      'deviceInfo': deviceInfo,
    };
  }
}

class ResponseMessage {
  final String? message;
  final bool success;
  final dynamic data;

  ResponseMessage({this.message, this.success = false, this.data});

  factory ResponseMessage.fromJson(Map<String, dynamic> json) {
    return ResponseMessage(
      message: json['message'],
      success: json['success'] ?? false,
      data: json['data'],
    );
  }

  factory ResponseMessage.error(String message) {
    return ResponseMessage(message: message, success: false);
  }
}
