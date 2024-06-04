import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

void saveSessionData(Map<String, dynamic> jsonData) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isLoggedIn', true);
  prefs.setString('useremail', jsonData['useremail'] ?? "");
  prefs.setString('token', jsonData['token'] ?? "");
  prefs.setString('shortToken', jsonData['short_token'] ?? 'N/A');
  prefs.setString('name', jsonData['name'] ?? 'N/A');
  prefs.setString('logedUser', jsonData['name_str'] ?? 'N/A');
  prefs.setString('designation', jsonData['designation'] ?? 'N/A');
  prefs.setString('uid', jsonData['uid'] ?? 'N/A');

  prefs.setString('phase', jsonData['phase'] ?? 'N/A');
  prefs.setString('sector', jsonData['sector'] ?? 'N/A');
  prefs.setString('plot', jsonData['plot'] ?? 'N/A');
  prefs.setString('street', jsonData['street'] ?? 'N/A');

  prefs.setString('uidStr', jsonData['uid_str'] ?? 'N/A');
  prefs.setString('username', jsonData['username'] ?? 'N/A');
  prefs.setString('usernameStr', jsonData['username_str'] ?? 'N/A');
  prefs.setInt('usertype', jsonData['usertype'] ?? 'N/A');

  prefs.setDouble(
      'primary_lat', double.parse(jsonData['primary_lat'].toString() ?? '0.0'));
  prefs.setDouble(
      'primary_lng', double.parse(jsonData['primary_lng'].toString() ?? '0.0'));
  prefs.setString('consumerid', jsonData['consumerid'] ?? '0');
  prefs.setInt('user_id', int.parse(jsonData['user_id'].toString() ?? '0'));

  print("Token Login : ${jsonData['consumerid']}");
}

void logout() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isLoggedIn', false);
  // prefs.setBool('isDashboard', false);
}

void funToast(String ToastMessage, Color custcolor) {
  Fluttertoast.showToast(
      msg: ToastMessage,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: custcolor,
      textColor: Colors.white,
      fontSize: 16.0);
}
