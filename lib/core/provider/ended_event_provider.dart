import 'package:ammerha_management/core/models/event.dart';
import 'package:ammerha_management/core/services/events_service.dart';
import 'package:flutter/foundation.dart';

class EndedEventProvider extends ChangeNotifier {
  final EventsService _service;

  EndedEventProvider(this._service);

  List<Event> _events = [];
  List<Event> get events => _events;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchEvents({String? token, bool force = false}) async {
    // If you have old data and want to prevent a new request without force
    if (_events.isNotEmpty && !force) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _events = await _service.getEvents(token: token);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh({String? token}) async {
    _error = null;
    try {
      _events = await _service.getEvents(token: token);
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }
}
