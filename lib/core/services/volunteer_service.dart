import 'package:ammerha_management/config/constants/url.dart';
import 'package:ammerha_management/core/helper/api.dart';
import 'package:ammerha_management/core/models/new_volunteer.dart';

class VolunteerService {
  final Api api;
  final String? token;

  VolunteerService({required this.api, required this.token});

  Future<List<NewVolunteer>> fetchPendingVolunteers({int active = 0}) async {
    final url = '${AppString.baseUrl}/dashboard/users/all?active=$active';
    final resp = await api.get(url: url, token: token);

    final List dataList = (resp is List)
        ? resp
        : (resp?['data'] is List ? resp['data'] : const []);

    return dataList.map<NewVolunteer>((e) => NewVolunteer.fromJson(e)).toList();
  }

  Future<List<NewVolunteer>> fetchActiveVolunteers({int active = 1}) async {
    final url = '${AppString.baseUrl}/dashboard/users/all?active=$active';
    final resp = await api.get(url: url, token: token);

    final List dataList = (resp is List)
        ? resp
        : (resp?['data'] is List ? resp['data'] : const []);

    return dataList.map<NewVolunteer>((e) => NewVolunteer.fromJson(e)).toList();
  }

  // activate user
  Future<void> updateUser({
    required int id,
    required int active,
    int? points,
  }) async {
    final url = '${AppString.baseUrl}/dashboard/users/update/$id';
    final body = <String, String>{
      'active': active.toString(),
      if (points != null) 'points': points.toString(),
    };

    await api.put(url: url, body: body, token: token);
  }

  // delete volunteer
  Future<void> deleteUser({required int id}) async {
    final url = '${AppString.baseUrl}/dashboard/users/delete/$id';
    await api.delete(url: url, token: token);
  }
}
