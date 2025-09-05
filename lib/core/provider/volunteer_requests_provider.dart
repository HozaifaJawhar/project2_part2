import 'package:ammerha_management/core/services/volunteer_service.dart';
import 'package:flutter/foundation.dart';
import 'package:ammerha_management/core/models/new_volunteer.dart';

class VolunteerRequestsProvider extends ChangeNotifier {
  final VolunteerService service;

  VolunteerRequestsProvider({required this.service});

  List<NewVolunteer> _items = [];
  String _search = '';
  bool _loading = false;
  String? _error;

  List<NewVolunteer> get items {
    if (_search.trim().isEmpty) return _items;
    final q = _search.trim().toLowerCase();
    return _items.where((v) {
      return (v.name).toLowerCase().contains(q) ||
          (v.email ?? '').toLowerCase().contains(q) ||
          (v.phone ?? '').toLowerCase().contains(q) ||
          (v.departmentName ?? '').toLowerCase().contains(q);
    }).toList();
  }

  bool get isLoading => _loading;
  String? get error => _error;
  String get search => _search;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _items = await service.fetchPendingVolunteers(active: 0);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => load();

  void setSearch(String value) {
    _search = value;
    notifyListeners();
  }

  void clear() {
    _items = [];
    _search = '';
    _error = null;
    _loading = false;
    notifyListeners();
  }

  // activate volunteer
  Future<void> approveVolunteer(int id, {int? points}) async {
    try {
      await service.updateUser(id: id, active: 1, points: points);
      await load(); // Update the list after acceptance
    } catch (e) {
      rethrow;
    }
  }
}
