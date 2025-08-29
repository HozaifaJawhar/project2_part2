import 'package:ammerha_management/config/constants/url.dart';
import 'package:ammerha_management/core/helper/api.dart';

class AuthService {
  final Api _api = Api();

  Future<String> login({
    required String email,
    required String password,
  }) async {
    final data = await _api.post(
      url: '${AppString.baseUrl}/auth/admin/login',
      body: {'username': email, 'password': password},
      token: null,
    );
    if (data != null && data['data'] != null && data['data']['token'] != null) {
      return data['data']['token'];
    } else {
      throw Exception(data['message'] ?? 'Failed to login');
    }
  }
}
