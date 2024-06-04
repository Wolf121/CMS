import 'dart:async';

import 'package:dha_resident_app/model/apis/api_client.dart';
import 'package:get/get.dart';

class AuthRepo {
  final ApiClient apiClient;
  AuthRepo({
    required this.apiClient,
  });

  Future<Response> login(String username, String password) async {
    return await apiClient
        .postData('/api/login', {"username": username, "password": password});
  }
}
