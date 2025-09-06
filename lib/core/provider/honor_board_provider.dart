// lib/core/providers/honor_board_provider.dart
import 'package:flutter/foundation.dart';
import 'package:ammerha_management/core/models/new_volunteer.dart';
import 'package:ammerha_management/core/services/volunteer_service.dart';

class HonorItem {
  final NewVolunteer user;
  final int position; // الترتيب 1..N
  HonorItem({required this.user, required this.position});
}

class HonorBoardProvider extends ChangeNotifier {
  final VolunteerService service;
  HonorBoardProvider({required this.service});

  List<HonorItem> _items = [];
  bool _loading = false;
  String? _error;

  List<HonorItem> get items => _items;
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final volunteers = await service.fetchHonorBoard();
      // After sorting in descending order of points, we generate the order 1..N
      _items = List.generate(
        volunteers.length,
        (i) => HonorItem(user: volunteers[i], position: i + 1),
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => load();

  List<HonorItem> topThree() => _items.take(3).toList();
  List<HonorItem> others() => _items.length > 3 ? _items.sublist(3) : const [];
}
