import 'dart:convert';

import 'package:ammerha_management/config/constants/url.dart';
import 'package:ammerha_management/core/helper/api.dart';
import 'package:ammerha_management/core/models/create_event_input.dart';
import 'package:ammerha_management/core/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EventsService {
  final Api _api;
  final String custumUrl;
  EventsService(this._api, this.custumUrl);

  Future<List<Event>> getEvents({String? token}) async {
    final url = '${AppString.baseUrl}$custumUrl';
    final res = await _api.get(url: url, token: token);

    if (res is Map<String, dynamic> && res['data'] is List) {
      final list = (res['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map<Event>((e) => Event.fromJson(e))
          .toList();
      return list;
    }

    throw Exception('Unexpected response format while fetching events');
  }

  // create event
  Future<Map<String, dynamic>> createEvent({
    required String token,
    required CreateEventInput input,
  }) async {
    final url = Uri.parse('${AppString.baseUrl}/dashboard/events/create');

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    final formattedDate = DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(input.dateTime);

    request.fields.addAll({
      'name': input.name,
      'description': input.description,
      'date': formattedDate,
      'min_hours': input.minHours.toString(),
      'max_hours': input.maxHours.toString(),
      'location': input.location,
      'volunteers_count': input.volunteersCount.toString(),
      'department_id': input.departmentId.toString(),
    });

    request.files.add(
      await http.MultipartFile.fromPath(
        'cover_image[file]',
        input.coverImagePath,
      ),
    );

    http.StreamedResponse streamed = await request.send().timeout(
      const Duration(seconds: 30),
    );
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      return data is Map<String, dynamic> ? data : {'raw': data};
    } else {
      throw Exception(
        'POST $url failed [${response.statusCode}]: ${response.body}',
      );
    }
  }

  // delete event
  Future<void> deleteEvent({
    required String token,
    required int eventId,
  }) async {
    final url = '${AppString.baseUrl}/dashboard/events/delete/$eventId';
    await _api.delete(url: url, token: token);
  }
}
