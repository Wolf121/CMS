import 'dart:convert';
import 'dart:io';

import 'package:dha_resident_app/model/response/error_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as Http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient extends GetxService {
  String appBaseUrl =
      // "http://110.93.244.74";
      "http://110.93.244.74";

  //http://110.93.244.74/api/login
  static final String noInternetMessage = 'Connection to API server failed!';
  final int timeoutInSeconds = 30;

  ApiClient();

  Future<Response> getData(
    String uri,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('access_token') ?? '';

      debugPrint('====> API Call: $uri');
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };
      Http.Response _response = await Http.get(
        Uri.parse(appBaseUrl + uri),
        headers: headers,
      ).timeout(Duration(seconds: timeoutInSeconds));
      print("Api Client Responce:" + _response.toString());
      return handleResponse(_response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(
    String uri,
    dynamic body,
  ) async {
    try {
      debugPrint('====> API Call: ${appBaseUrl + '/api/login'}');
      debugPrint('====> API Body: $body');
      Http.Response _response = await Http.post(
        Uri.parse(appBaseUrl + uri),
        body: body,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> puttData(
    String uri,
    dynamic body,
  ) async {
    try {
      debugPrint('====> API Call: ${appBaseUrl + uri}');
      debugPrint('====> API Body: $body');
      Http.Response _response = await Http.put(
        Uri.parse(appBaseUrl + uri),
        body: body,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      print("=======e:$e=======");
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postMultipartData(
    String uri,
    Map<String, String> body,
    List<MultipartBody> multipartBody,
  ) async {
    try {
      debugPrint('====> API Call: $uri');
      debugPrint('====> API Body: $body');
      Http.MultipartRequest _request =
          Http.MultipartRequest('POST', Uri.parse(appBaseUrl + uri));
      for (MultipartBody multipart in multipartBody) {
        File _file = File(multipart.file.path);
        _request.files.add(Http.MultipartFile(
          multipart.key,
          _file.readAsBytes().asStream(),
          _file.lengthSync(),
          filename: _file.path.split('/').last,
        ));
      }
      _request.fields.addAll(body);
      Http.Response _response =
          await Http.Response.fromStream(await _request.send());
      return handleResponse(_response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Response handleResponse(Http.Response response, String uri) {
    dynamic _body;
    try {
      _body = jsonDecode(response.body);
    } catch (e) {}
    Response _response = Response(
      body: _body != null ? _body : response.body,
      bodyString: response.body.toString(),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
    if (_response.statusCode != 200 &&
        _response.body != null &&
        _response.body is! String) {
      if (_response.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse _errorResponse = ErrorResponse.fromJson(_response.body);
        _response = Response(
            statusCode: _response.statusCode,
            body: _response.body,
            statusText: _errorResponse.errors[0].message);
      } else if (_response.body.toString().startsWith('{message')) {
        _response = Response(
            statusCode: _response.statusCode,
            body: _response.body,
            statusText: _response.body['message']);
      }
    } else if (_response.statusCode != 200 && _response.body == null) {
      _response = Response(statusCode: 0, statusText: noInternetMessage);
    }
    debugPrint(
        '====> API Response: [${_response.statusCode}] $uri\n${_response.body}');
    return _response;
  }
}

class MultipartBody {
  String key;
  XFile file;

  MultipartBody(this.key, this.file);
}
