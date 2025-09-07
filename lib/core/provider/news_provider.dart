import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:ammerha_management/core/models/news_item.dart';
import 'package:ammerha_management/core/services/news_service.dart';

class NewsProvider extends ChangeNotifier {
  NewsProvider({required NewsService service}) : _service = service;

  final NewsService _service;

  List<NewsItem> _items = [];
  List<NewsItem> get items => _items;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Future<void> load() async {
    _setLoading(true);
    _error = null;
    try {
      _items = await _service.fetchNews();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refresh() => load();

  Future<NewsItem?> add({
    required String title,
    required String body,
    File? imageFile,
  }) async {
    _error = null;
    try {
      final created = await _service.createNews(
        title: title,
        body: body,
        imageFile: imageFile,
      );
      _items = [created, ..._items];
      notifyListeners();
      return created;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> removeById(String id) async {
    _error = null;
    try {
      await _service.deleteOne(id);
      _items = _items.where((n) => n.id != id).toList();
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}
