import 'dart:convert';
import 'package:ammerha_management/config/constants/url.dart';
import 'package:ammerha_management/core/models/departmentClass.dart';
import 'package:ammerha_management/core/helper/api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DepartmentService {
  final Api _api = Api();
  final _storage = const FlutterSecureStorage();

  Future<List<Department>> fetchDepartments() async {
    final token = await _storage.read(key: 'auth_token');

    final responseData = await _api.get(
      url: '${AppString.baseUrl}/dashboard/departments/all',
      token: token,
    );

    print("جبت الأقسام: $responseData");

    if (responseData.containsKey('data') && responseData['data'] is List) {
      final List<dynamic> data = responseData['data'];
      return data.map((e) => Department.fromJson(e)).toList();
    } else {
      throw Exception("الرد غير متوقع: $responseData");
    }
  }

  Future<Department> createDepartment(String name, String? description) async {
    final token = await _storage.read(key: 'auth_token');

    final body = {"name": name, "description": description};

    final responseData = await _api.post(
      url: '${AppString.baseUrl}/dashboard/departments/create',
      token: token,
      body: body,
    );

    if (responseData.containsKey('data')) {
      return Department.fromJson(responseData['data']);
    } else {
      throw Exception("فشل إنشاء القسم: $responseData");
    }
  }

  Future<dynamic> deleteSection({
    required int id,
    required String? token,
  }) async {
    final token = await _storage.read(key: 'auth_token');
    final url = '${AppString.baseUrl}/dashboard/departments/delete/$id';

    return await _api.delete(url: url, token: token);
  }

  Future<dynamic> updateDepartment({
    required int id,
    required String name,
    required String? description,
    required String token,
  }) async {
    final url = '${AppString.baseUrl}/dashboard/departments/update/$id';

    final body = jsonEncode({"name": name, "description": description});

    final response = await _api.put(url: url, body: body, token: token);

    return Department.fromJson(response['data']);
  }
}
