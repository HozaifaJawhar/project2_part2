import 'dart:convert';

import 'package:ammerha_management/config/constants/url.dart';
import 'package:ammerha_management/core/models/departmentClass.dart';

import 'package:ammerha_management/core/helper/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DepartmentService {
  final Api _api = Api();

  Future<List<Department>> fetchDepartments() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

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
}
