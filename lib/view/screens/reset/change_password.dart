import 'package:dha_resident_app/model/shared_pref_session.dart/share_preferences_session.dart';
import 'package:dha_resident_app/view/screens/login/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'dart:io' show Platform;
import '../../../constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../anim/animated_checkmark_dialog.dart';

class ChangePassword extends StatefulWidget {
  static const routeName = '/changepass';
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  String _oldpassword = '';
  String _newpassword = '';
  String _renewpassword = '';
  bool _showPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    print("Reset Password Class Is Executing");
  }

  void JustPrintTheShitOutOFEverything() {
    print("This is Old Password : $_oldpassword");
    print("This is New Password : $_newpassword");
    print("This is Confirm Password : $_renewpassword");
  }

  // Reset Password
  Future<void> resetPassword(
      String oldPassword, String newPassword, String renewPassword) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      _isLoading = false;
      // Handle the case where the token is not available.
      return;
    }

    final Uri apiUrl = Uri.parse('http://110.93.244.74/api/updatepassword');
    final Map<String, dynamic> requestData = {
      'old_password': oldPassword,
      'password': newPassword,
      'confirm_password': renewPassword,
    };

    final http.Response response = await http.post(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Set content type to JSON
      },
      body: json.encode(requestData), // Convert the request data to JSON string
    );
    final Map<String, dynamic> responseBody = json.decode(response.body);
    final int? success = responseBody['success'];

    if (response.statusCode == 200 && success == 1) {
      _isLoading = false;
      // Password updated successfully.
      print('Password updated successfully' + response.body);
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final String message = responseBody['message'];
      print('Response message: $message');
      showAnimatedCheckmarkDialog(context, message + ".", appcolor);
      await Future.delayed(Duration(seconds: 3));
      logout();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LogIn()));
    } else {
      _isLoading = false;
      // Handle the API error response.
      print('Failed to update password. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final String message = responseBody['message'];
      print('Response message: $message');
      //  showAnimatedCheckmarkDialog(context, message + ".", Colors.redAccent);

      if (TargetPlatform.iOS == defaultTargetPlatform) {
        funToast(message, appcolor);
      } else if (TargetPlatform.android == defaultTargetPlatform) {
        final snackBar = SnackBar(
          content: Text(message),
          duration: Duration(seconds: 5), // Adjust duration as needed
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  // TEMP Logout Fuction
  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all data stored in SharedPreferences
    // You can also clear specific keys if needed: prefs.remove('token');
  }

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Section 1: Non-scrollable content
            OverlayLoaderWithAppIcon(
              isLoading: _isLoading,
              appIcon: Image.asset(
                "asserts/icons/icon.png",
                width: 40,
              ),
              child: Container(
                child: Stack(
                  children: [
                    Positioned(
                      left: 15,
                      // top: Platform.isAndroid ? 40 : 50,
                      top: Platform.isAndroid ? 10 : 12,
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: lightappcolor,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_outlined,
                            color: dfColor,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: Platform.isAndroid
                          ? EdgeInsets.only(top: 0)
                          : EdgeInsets.only(top: 0),
                      // margin: Platform.isAndroid
                      //     ? EdgeInsets.only(top: 30)
                      //     : EdgeInsets.only(top: 46),
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        'asserts/images/frame.png',
                        width: 199,
                        height: 196,
                      ),
                    ),
                    Container(
                      margin: Platform.isAndroid
                          ? EdgeInsets.only(top: 120)
                          : EdgeInsets.only(top: 130),
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        'asserts/images/reset.png',
                        width: scWidth / 3.5,
                        // height: scHeight / 5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Section 2: Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: 25,
                            right: 25,
                            top: 25,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   "Old Password",
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                child: TextFormField(
                                  autofocus: false,
                                  style: TextStyle(
                                      fontSize: dfFontSize,
                                      color: Colors.black87),
                                  decoration: InputDecoration(
                                    prefixIconColor: blackColor,
                                    suffixIconColor: blackColor,
                                    labelStyle: TextStyle(color: blackColor),
                                    labelText: 'Old Password',
                                    prefixIcon: Icon(
                                      Icons.lock_outlined,
                                      size: dfIconSize,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: dfColor,
                                    contentPadding: const EdgeInsets.only(
                                        left: 5.0,
                                        bottom: marginLR,
                                        top: marginLR),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: blackColor),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _showPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _showPassword = !_showPassword;
                                        });
                                      },
                                    ),
                                  ),
                                  obscureText:
                                      !_showPassword, // Toggle visibility
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your old password';
                                    }
                                    if (value.length < 8) {
                                      return 'Password must be at least 8 characters long';
                                    }
                                    if (value.length < 8) {
                                      return 'Password must be at least 8 characters long';
                                    }

                                    // Check for at least one capital letter
                                    if (!value.contains(RegExp(r'[A-Z]'))) {
                                      return 'Password must contain at least one capital letter';
                                    }

                                    // Check for at least one alphanumeric character
                                    if (!value.contains(RegExp(r'[0-9]'))) {
                                      return 'Password must contain at least one alphanumeric character';
                                    }

                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _oldpassword = value.trim();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        ///////////////////
                        Container(
                          margin: EdgeInsets.only(
                            left: 25,
                            right: 25,
                            top: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   "New Password",
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                child: TextFormField(
                                  autofocus: false,
                                  style: TextStyle(
                                      fontSize: dfFontSize,
                                      color: Colors.black87),
                                  decoration: InputDecoration(
                                    labelText: 'New Password',
                                    prefixIconColor: blackColor,
                                    suffixIconColor: blackColor,
                                    labelStyle: TextStyle(color: blackColor),
                                    prefixIcon: Icon(
                                      Icons.lock_outlined,
                                      size: dfIconSize,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: dfColor,
                                    contentPadding: const EdgeInsets.only(
                                        left: 5.0,
                                        bottom: marginLR,
                                        top: marginLR),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: blackColor),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _showNewPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _showNewPassword = !_showNewPassword;
                                        });
                                      },
                                    ),
                                  ),
                                  obscureText:
                                      !_showNewPassword, // Toggle visibility
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter new password';
                                    }
                                    if (value.length < 8) {
                                      return 'Password must be at least 8 characters long';
                                    }
                                    if (value.length < 8) {
                                      return 'Password must be at least 8 characters long';
                                    }

                                    // Check for at least one capital letter
                                    if (!value.contains(RegExp(r'[A-Z]'))) {
                                      return 'Password must contain at least one capital letter';
                                    }

                                    // Check for at least one alphanumeric character
                                    if (!value.contains(RegExp(r'[0-9]'))) {
                                      return 'Password must contain at least one alphanumeric character';
                                    }

                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _newpassword = value.trim();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        //////////////////
                        Container(
                          margin: EdgeInsets.only(left: 25, right: 25, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   "Confirm Password",
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                child: TextFormField(
                                  autofocus: false,
                                  style: TextStyle(
                                      fontSize: dfFontSize,
                                      color: Colors.black87),
                                  decoration: InputDecoration(
                                    prefixIconColor: blackColor,
                                    suffixIconColor: blackColor,
                                    labelStyle: TextStyle(color: blackColor),
                                    labelText: 'Confirm Password',
                                    prefixIcon: Icon(
                                      Icons.lock_outlined,
                                      size: dfIconSize,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: dfColor,
                                    contentPadding: const EdgeInsets.only(
                                        left: 5.0,
                                        bottom: marginLR,
                                        top: marginLR),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: blackColor),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _showConfirmPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _showConfirmPassword =
                                              !_showConfirmPassword;
                                        });
                                      },
                                    ),
                                  ),
                                  obscureText:
                                      !_showConfirmPassword, // Toggle visibility
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please confirm your password';
                                    }
                                    if (_newpassword != value) {
                                      return 'Confirm password did not match';
                                    }
                                    if (value.length < 8) {
                                      return 'Password must be at least 8 characters long';
                                    }

                                    // Check for at least one capital letter
                                    if (!value.contains(RegExp(r'[A-Z]'))) {
                                      return 'Password must contain at least one capital letter';
                                    }

                                    // Check for at least one alphanumeric character
                                    if (!value.contains(RegExp(r'[0-9]'))) {
                                      return 'Password must contain at least one alphanumeric character';
                                    }

                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _renewpassword = value.trim();
                                    });
                                  },
                                ),
                              ),
                              ////////////////////

                              Container(
                                margin: EdgeInsets.only(
                                  top: 10,
                                ),
                                decoration: BoxDecoration(
                                    gradient: lgBlue,
                                    borderRadius:
                                        BorderRadius.circular(roundBtn)),
                                width: scWidth,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _isLoading = true;
                                    if (_formKey.currentState!.validate()) {
                                      JustPrintTheShitOutOFEverything();
                                      resetPassword(_oldpassword, _newpassword,
                                          _renewpassword);
                                    }
                                  },
                                  child: Text(
                                    'Reset Password',
                                    style: TextStyle(color: btnTextColor),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(roundBtn),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
