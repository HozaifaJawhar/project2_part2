import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api {
  Future<dynamic> get({required String url, @required String? token}) async {
    Map<String, String> headers = {};
    print('miiiiiiisssssssaaaaaaaaannnnnnnnnnnnnn');
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }
    http.Response response = await http.get(Uri.parse(url), headers: headers);

    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404 ||
        response.statusCode == 400 ||
        response.statusCode == 500 ||
        response.statusCode == 401 ||
        response.statusCode == 403) {
      return jsonDecode(response.body);
    } else {
      throw Exception('there is a problem with status code ${response.body}');
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
    }
    // else if (response.statusCode == 403) {
    //   print(response.statusCode);
    //   var data = jsonDecode(response.body);
    //   print('///$data///');
    //   return data;
    // }
    // else if (response.statusCode == 400 ||
    //     response.statusCode == 500 ||
    //     response.statusCode == 401) {
    //   print(response.statusCode);
    //   var data = jsonDecode(response.body);
    //   print('///$data///');
    //   return data;
    //}
    else {
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

  Future<dynamic> put({
    required String url,
    @required dynamic body,
    @required String? token,
  }) async {
    Map<String, String> headers = {};
    headers.addAll({'Content-Type': 'application/json'});
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    http.Response response = await http.put(
      Uri.parse(url),
      body: body,
      headers: headers,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
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
      var data = jsonDecode(response.body);
      return data;
    } else {
      var errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to delete resource');
    }
  }
}
