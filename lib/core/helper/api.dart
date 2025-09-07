import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api {
  Future<dynamic> get({required String url, @required String? token}) async {
    Map<String, String> headers = {'Accept': 'application/json'};
    print('miiiiiiisssssssaaaaaaaaannnnnnnnnnnnnn');
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }
    try {
      http.Response response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 30));
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'GET $url failed [${response.statusCode}]: ${response.body}',
        );
      }
    } on TimeoutException {
      throw Exception('GET $url timed out');
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post({
    required String url,
    @required dynamic body,
    @required String? token,
  }) async {
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }
    http.Response response = await http.post(
      Uri.parse(url),
      body: body,
      headers: headers,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.statusCode);
      var data = jsonDecode(response.body);
      print('///$data///');
      return data;
    } else {
      var errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to execute request');
    }
  }

  Future postFiles({
    required String url,
    required String filePath,
    required String key,
    @required String? token,
  }) async {
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.headers.addAll({'Authorization': 'Bearer $token'});
    request.files.add(await http.MultipartFile.fromPath(key, filePath));
    final response = await request.send();
    var jsonResponse = await http.Response.fromStream(response);
    if (jsonResponse.statusCode == 200 || jsonResponse.statusCode == 201) {
      print(response.statusCode);
      var js = jsonDecode(jsonResponse.body);
      print('///$js///');
    } else {
      throw Exception(
        'there is a problem with status code ${response.statusCode} with body ${jsonDecode(jsonResponse.body)}',
      );
    }
  }

  // ✅ New: Generic multipart accepts fields + more than one file (we use it to create the news with cover_image[file])
  Future<dynamic> postMultipart({
    required String url,
    Map<String, String>? fields,
    // files: key = field name in API, value = active local path
    Map<String, String>? files,
    @required String? token,
  }) async {
    final req = http.MultipartRequest('POST', Uri.parse(url));
    req.headers.addAll({'Accept': 'application/json'});
    if (token != null) {
      req.headers['Authorization'] = 'Bearer $token';
    }
    if (fields != null && fields.isNotEmpty) {
      req.fields.addAll(fields);
    }
    if (files != null && files.isNotEmpty) {
      for (final entry in files.entries) {
        req.files.add(
          await http.MultipartFile.fromPath(entry.key, entry.value),
        );
      }
    }
    final streamed = await req.send();
    final resp = await http.Response.fromStream(streamed);
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return resp.body.isNotEmpty ? jsonDecode(resp.body) : null;
    } else {
      throw Exception(
        'POST multipart failed [${resp.statusCode}]: ${resp.body}',
      );
    }
  }

  Future<dynamic> put({
    required String url,
    @required dynamic body,
    @required String? token,
  }) async {
    Map<String, String> headers = {};
    headers.addAll({
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
    });
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    http.Response response = await http.put(
      Uri.parse(url),
      body: body,
      headers: headers,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body.isEmpty) return null;
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(
        'there is a problem with status code ${response.statusCode} with body ${jsonDecode(response.body)}',
      );
      // when you throw respose.body it will show if there something required in the body of the api...
    }
  }

  Future<dynamic> delete({required String url, @required String? token}) async {
    Map<String, String> headers = {'Accept': 'application/json'};

    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    http.Response response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('data deleted correctly with statrus code ${response.statusCode}');
      var data = jsonDecode(response.body);
      return data;
    } else {
      var errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to delete resource');
    }
  }
}
