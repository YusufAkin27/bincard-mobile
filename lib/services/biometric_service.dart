import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Cihazın biyometrik kimlik doğrulama özelliklerini kontrol eder
  Future<bool> isBiometricAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      debugPrint('Biyometrik kontrol hatası: $e');
      return false;
    }
  }

  // Kullanılabilir biyometrik kimlik doğrulama türlerini getirir
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      debugPrint('Biyometrik tür getirme hatası: $e');
      return [];
    }
  }

  // Biyometrik kimlik doğrulama işlemini başlatır
  Future<bool> authenticate({
    required String localizedReason,
    bool biometricOnly = false,
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: biometricOnly,
        ),
      );
    } on PlatformException catch (e) {
      debugPrint('Kimlik doğrulama hatası: $e');
      if (e.code == auth_error.notAvailable) {
        debugPrint('Biyometrik kimlik doğrulama kullanılamıyor');
      } else if (e.code == auth_error.notEnrolled) {
        debugPrint('Biyometrik kayıt yok');
      } else if (e.code == auth_error.passcodeNotSet) {
        debugPrint('Ekran kilidi ayarlanmamış');
      } else if (e.code == auth_error.lockedOut) {
        debugPrint('Çok fazla başarısız deneme');
      } else if (e.code == auth_error.permanentlyLockedOut) {
        debugPrint('Kalıcı olarak kilitlendi');
      } else {
        debugPrint('Bilinmeyen hata: ${e.code}');
      }
      return false;
    }
  }

  // Yüz tanıma özelliği var mı?
  Future<bool> hasFaceID() async {
    final availableBiometrics = await getAvailableBiometrics();
    return availableBiometrics.contains(BiometricType.face);
  }

  // Parmak izi özelliği var mı?
  Future<bool> hasFingerprint() async {
    final availableBiometrics = await getAvailableBiometrics();
    return availableBiometrics.contains(BiometricType.fingerprint) ||
        availableBiometrics.contains(BiometricType.strong);
  }
}
