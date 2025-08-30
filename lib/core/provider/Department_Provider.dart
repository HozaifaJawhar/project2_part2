import 'package:ammerha_management/core/models/departmentClass.dart';
import 'package:ammerha_management/core/services/Department_Service.dart';
import 'package:flutter/material.dart';

class DepartmentProvider with ChangeNotifier {
  final DepartmentService _departmentService = DepartmentService();

  List<Department> _departments = [];
  bool _isLoading = false;
  String? _error;

  List<Department> get departments => _departments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getDepartments() async {
    _isLoading = true;
    notifyListeners();

    try {
      _departments = await _departmentService.fetchDepartments();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
