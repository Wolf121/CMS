import 'dart:convert';

import 'package:dha_resident_app/model/apis/api_client.dart';
import 'package:dha_resident_app/model/repository/auth_repo.dart';
import 'package:dha_resident_app/model/response/response_model.dart';
import 'package:dha_resident_app/model/shared_pref_session.dart/share_preferences_session.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo = AuthRepo(apiClient: ApiClient());
  bool isLoading = false;
  AuthController() {}

  @override
  void onInit() {
    super.onInit();
    // initDB();
  }

  Future<ResponseModel> login(String username, String password) async {
    isLoading = true;
    update();

    final response = await authRepo.login(username, password);
    ResponseModel responseModel;

    if (response.statusCode == 200) {
      print("Response LogIn :" + response.body.toString());

      final jsonResponse = json.decode(response.body);
      final data = jsonResponse['data_array'];

      // final jsonResponse = jsonDecode(response.body);
      final status = jsonResponse['success'];

      // final jsonResponse = LogInModel.fromJson(response.body);
      // final status = jsonResponse.status;
      // final longtoken = jsonResponse.accessToken;
      // print(longtoken);

      if (status == 1) {
        final sessionData = {
          'token': data['token'],
          'shorttoken': data['short_token'],
          'name': data['name'],
          'name_str': data['name_str'],
          'designation': data['designation'],
          'uid': data['uid'],
          'uid_str': data['uid_str'],
          'username': data['username'],
          'username_str': data['username_str'],
          'usertype': data['usertype'],
        };

        saveSessionData(sessionData);
        funToast(jsonResponse['message'], Colors.green);

        // print("Hello $userEmail");
        print("session data saved!");
        responseModel = ResponseModel(true, response.body['message']);
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } else {
      print('Unexpected response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      responseModel = ResponseModel(false, response.statusText.toString());
    }
    isLoading = false;
    update();
    return responseModel;
  }
}
