import 'dart:async';
import 'package:ammerha_management/core/models/event.dart';
import 'package:ammerha_management/core/services/events_service.dart';
import 'package:flutter/material.dart';

class EndedEventsProvider extends ChangeNotifier {
  final EventsService _service;
  EndedEventsProvider(this._service);

  List<Event> _events = [];
  List<Event> get events => _events;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void>? sheetOperationFuture;

  Future<void> fetchEvents({String? token, bool force = false}) async {
    if (_events.isNotEmpty && !force) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _events = await _service.getEndedEvents(token: token);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh({String? token}) async {
    await fetchEvents(token: token, force: true);
  }

  /// يرجع مسار الملف الذي تم تنزيله (لازم String)
  Future<String> downloadTemplate(int eventId) async {
    try {
      final filePath = await _service.downloadRatingTemplate(eventId: eventId);
      return filePath;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadReport(int eventId, String filePath) async {
    final completer = Completer<void>();
    sheetOperationFuture = completer.future;
    try {
      await _service.uploadRatingReport(eventId: eventId, filePath: filePath);
      completer.complete();
    } catch (e) {
      completer.completeError(e);
      rethrow;
    }
  }
}
