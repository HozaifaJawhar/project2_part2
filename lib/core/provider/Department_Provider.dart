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

  Future<void> fetchDepartments() async {
    _departments = await _departmentService.fetchDepartments();
    notifyListeners();
  }

  Future<void> addDepartment(String name, String? description) async {
    try {
      Department newDept = await _departmentService.createDepartment(
        name,
        description,
      );
      _departments.add(newDept);
      notifyListeners();
    } catch (e) {
      print("خطأ بإنشاء قسم: $e");
    }
  }

  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;

  Future<bool> deleteSection({required int id, required String? token}) async {
    _isDeleting = true;
    notifyListeners();

    try {
      final response = await _departmentService.deleteSection(
        id: id,
        token: token,
      );

      // جلب الأقسام بعد الحذف لتحديث القائمة
      await fetchDepartments();
      return true; // الحذف نجح
    } catch (e) {
      print("❌ Error while deleting section: $e");
      return false; // فشل الحذف
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  Future<bool> updateDepartment({
    required int id,
    required String name,
    required String? description,
    required String token,
  }) async {
    _isUpdating = true;
    notifyListeners();

    try {
      Department updatedDept = await _departmentService.updateDepartment(
        id: id,
        name: name,
        description: description,
        token: token,
      );

      // عدل العنصر في الليست
      final index = _departments.indexWhere((dept) => dept.id == id);
      if (index != -1) {
        _departments[index] = updatedDept;
      }

      notifyListeners();
      return true;
    } catch (e) {
      print("❌ Error while updating section: $e");
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }
}
