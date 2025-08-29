import 'package:ammerha_management/core/services/auth_services.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  String? _token;

  // Getters for UI to access the state
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get token => _token;

  // Main login method
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _token = await _authService.login(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } on Exception catch (e) {
      if (e.toString().contains('message')) {
        _errorMessage = "البريد الإلكتروني أو كلمة المرور خاطئة";
      } else {
        _errorMessage = "حدث خطأ غير متوقع. الرجاء المحاولة مرة أخرى";
      }

      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
