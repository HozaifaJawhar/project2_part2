import 'package:ammerha_management/core/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _isLoading = false;
  String? _errorMessage;
  String? _token;

  // Getters for UI to access the state
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get token => _token;

  // Method to save the token in storage
  Future<void> _saveToken(String token) async {
    _token = token;
    await _storage.write(key: 'auth_token', value: token);
  }

  // Main login method
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final receivedToken = await _authService.login(
        email: email,
        password: password,
      );
      await _saveToken(receivedToken);
      _isLoading = false;
      notifyListeners();
      return true;
    } on Exception catch (e) {
      if (e.toString().contains('The selected username is invalid.')) {
        _errorMessage = "البريد الإلكتروني أو كلمة المرور خاطئة";
      } else if (e.toString().contains('auth.wrong_credentials')) {
        _errorMessage = "البريد الإلكتروني أو كلمة المرور خاطئة";
      } else {
        _errorMessage = "حدث خطأ غير متوقع. الرجاء المحاولة مرة أخرى";
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Function to attempt to automatically log_in when the application is opened
  Future<void> tryAutoLogin() async {
    final storedToken = await _storage.read(key: 'auth_token');
    if (storedToken != null) {
      _token = storedToken;
      notifyListeners();
    }
  }

  // Method to sighn_out
  Future<void> logout() async {
    _token = null;
    await _storage.delete(key: 'auth_token');
    notifyListeners();
  }
}
