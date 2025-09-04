import 'package:ammerha_management/core/models/create_event_input.dart';
import 'package:ammerha_management/core/models/event.dart';
import 'package:ammerha_management/core/services/events_service.dart';
import 'package:flutter/foundation.dart';

class EventsProvider extends ChangeNotifier {
  final EventsService _service;

  EventsProvider(this._service);

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

  // Create Event
  bool _isCreating = false;
  bool get isCreating => _isCreating;

  String? _createError;
  String? get createError => _createError;

  Future<bool> createEvent({
    required String token,
    required CreateEventInput input,
  }) async {
    _isCreating = true;
    _createError = null;
    notifyListeners();

    try {
      final res = await _service.createEvent(token: token, input: input);
      _isCreating = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isCreating = false;
      _createError = e.toString();
      notifyListeners();
      return false;
    }
  }

  // delete event
  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;
  String? _deleteError;
  String? get deleteError => _deleteError;

  Future<bool> deleteEvent({
    required String token,
    required int eventId,
    bool optimistic = true,
  }) async {
    _isDeleting = true;
    _deleteError = null;
    notifyListeners();

    // Optimistic delete (optional): Remove it locally before the network
    Event? backup;
    int removeIndex = -1;
    if (optimistic) {
      removeIndex = _events.indexWhere((e) => e.id == eventId);
      if (removeIndex != -1) {
        backup = _events[removeIndex];
        _events.removeAt(removeIndex);
        notifyListeners();
      }
    }
    try {
      await _service.deleteEvent(token: token, eventId: eventId);
      _isDeleting = false;
      notifyListeners();
      return true;
    } catch (e) {
      // Undo if we deleted locally
      if (optimistic && backup != null && removeIndex != -1) {
        _events.insert(removeIndex, backup);
      }
      _isDeleting = false;
      _deleteError = e.toString();
      notifyListeners();
      return false;
    }
  }
}
