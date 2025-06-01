import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_model.dart';

class AuthService {
  // API Endpoint
  static const String baseUrl = 'http://192.168.158.61:8080/v1/api';

  // SharedPreferences Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';

  // Login API isteği
  Future<AuthResponse> login(String telephone, String password) async {
    try {
      final deviceInfo = await getDeviceInfo();
      final ipAddress = await getIpAddress();

      final request = AuthRequest(
        telephone: telephone,
        password: password,
        ipAddress: ipAddress,
        deviceInfo: deviceInfo,
      );

      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final authResponse = AuthResponse.fromJson(data);

        if (authResponse.success && authResponse.token != null) {
          // Token ve kullanıcı bilgilerini kaydet
          await saveAuthData(authResponse);
        }

        return authResponse;
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        return AuthResponse.error(
          errorData['message'] ?? 'Giriş başarısız. Lütfen tekrar deneyin.',
        );
      }
    } catch (e) {
      return AuthResponse.error('Bağlantı hatası: $e');
    }
  }

  // Kayıt API isteği
  Future<ResponseMessage> register(
    String firstName,
    String lastName,
    String telephone,
    String password,
  ) async {
    try {
      final requestBody = {
        'firstName': firstName,
        'lastName': lastName,
        'telephone': telephone,
        'password': password,
      };

      final response = await http
          .post(
            Uri.parse('$baseUrl/user/sign-up'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return ResponseMessage.fromJson(data);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        return ResponseMessage.error(
          errorData['message'] ?? 'Kayıt başarısız. Lütfen tekrar deneyin.',
        );
      }
    } catch (e) {
      return ResponseMessage.error('Bağlantı hatası: $e');
    }
  }

  // Cihaz bilgisini al
  Future<String> getDeviceInfo() async {
    // Gerçek bir uygulamada device_info_plus paketi kullanılarak
    // gerçek cihaz bilgisi alınabilir
    try {
      return 'Flutter App on ${Platform.operatingSystem}';
    } catch (e) {
      return 'Unknown Device';
    }
  }

  // IP adresini al
  Future<String> getIpAddress() async {
    try {
      // Gerçek uygulamada harici bir servis kullanılabilir
      // Şimdilik sabit bir değer dönüyoruz
      return '192.168.1.100';
    } catch (e) {
      return '0.0.0.0';
    }
  }

  // Token ve kullanıcı bilgilerini kaydet
  Future<void> saveAuthData(AuthResponse authResponse) async {
    final prefs = await SharedPreferences.getInstance();

    if (authResponse.token != null) {
      await prefs.setString(tokenKey, authResponse.token!);
    }

    if (authResponse.refreshToken != null) {
      await prefs.setString(refreshTokenKey, authResponse.refreshToken!);
    }

    if (authResponse.user != null) {
      final userData = jsonEncode({
        'id': authResponse.user!.id,
        'firstName': authResponse.user!.firstName,
        'lastName': authResponse.user!.lastName,
        'telephone': authResponse.user!.telephone,
        'email': authResponse.user!.email,
      });

      await prefs.setString(userKey, userData);
    }
  }

  // Token bilgisini al
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // Kullanıcı bilgisini al
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(userKey);

    if (userData != null) {
      final Map<String, dynamic> userMap = jsonDecode(userData);
      return User.fromJson(userMap);
    }

    return null;
  }

  // Oturum kontrolü
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Çıkış yap
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove(refreshTokenKey);
    await prefs.remove(userKey);
  }
}
