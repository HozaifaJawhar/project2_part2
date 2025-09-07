import 'dart:io';
import 'package:ammerha_management/config/constants/url.dart';
import 'package:ammerha_management/core/models/news_item.dart';
import 'package:ammerha_management/core/helper/api.dart';

class NewsService {
  NewsService({required this.api, required this.token});

  final Api api;
  final String? token;

  // GET
  Future<List<NewsItem>> fetchNews() async {
    final res = await api.get(
      url: '${AppString.baseUrl}/dashboard/posts/all',
      token: token,
    );
    final List data = (res is Map && res['data'] is List)
        ? res['data'] as List
        : const [];
    return data
        .map((e) => NewsItem.fromApi(e as Map<String, dynamic>))
        .toList();
  }

  /// POST /dashboard/posts/create (multipart)
  /// fields: title, body, file key: cover_image[file]
  Future<NewsItem> createNews({
    required String title,
    required String body,
    File? imageFile,
  }) async {
    final res = await api.postMultipart(
      url: '${AppString.baseUrl}/dashboard/posts/create',
      token: token,
      fields: {'title': title, 'body': body},
      files: imageFile != null ? {'cover_image[file]': imageFile.path} : null,
    );

    final map = (res is Map && res['data'] is Map)
        ? res['data'] as Map<String, dynamic>
        : res as Map<String, dynamic>;
    return NewsItem.fromApi(map);
  }

  /// DELETE /dashboard/posts/delete/{idsCSV}
  Future<void> deleteByIds(List<String> ids) async {
    final csv = ids.join(',');
    await api.delete(
      url: '${AppString.baseUrl}/dashboard/posts/delete/$csv',
      token: token,
    );
  }

  Future<void> deleteOne(String id) => deleteByIds([id]);
}
