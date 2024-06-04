import 'package:dha_resident_app/view/screens/login/login.dart';
import 'package:dha_resident_app/view/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../anim/animated_checkmark_dialog.dart';

class ResetVerfPassword extends StatefulWidget {
  final String uid;
  ResetVerfPassword({required this.uid});

  @override
  State<ResetVerfPassword> createState() => _ResetVerfPasswordState();
}

class _ResetVerfPasswordState extends State<ResetVerfPassword> {
  final _formKey = GlobalKey<FormState>();
  String _oldpassword = '';
  String _newpassword = '';
  String _renewpassword = '';
  bool _showPassword = false;
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

  Future<void> resetUser() async {
    final String apiUrl = 'http://110.93.244.74/api/setNewpassword';

    final Map<String, dynamic> requestBody = {
      'uid': widget.uid,
      'password': _newpassword,
      'confirm_password': _renewpassword,
    };

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final String jsonBody = jsonEncode(requestBody);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        // Handle the response data here, e.g., show a success message

        if (responseData['success'] == 1) {
          print("Forgot next screen : ${responseData}");

          showAnimatedCheckmarkDialog(
              context, responseData['message'], appcolor);
          _isLoading = false;
          await Future.delayed(Duration(seconds: 1));

          final route = MaterialPageRoute(builder: (context) => LogIn());

          Navigator.pushAndRemoveUntil(context, route, (route) => false);
        } else {
          // funToast(responseData['message'], Colors.redAccent);
          print(responseData['message']);
        }
      } else {
        // Handle the error response
        print('Failed to reset next. Please try again later. ${response.body}');
        funToast(
            "Reset Password Next, Please try again later!", Colors.redAccent);
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      print('An error occurred: $e');
      funToast("Reset Password Next $e", Colors.redAccent);
    }
  }

  void funToast(String ToastMessage, Color custcolor) {
    Fluttertoast.showToast(
        msg: ToastMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: custcolor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: greyColor,
          title: Text(
            "Reset Password",
            style: TextStyle(
              color: appcolor,
              fontSize: lgFontSize,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: appcolor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: marginLR),
              child: CircleAvatar(
                backgroundColor: lightappcolor,
                radius: 18.0,
                child: IconButton(
                  icon: Icon(
                    Icons.question_mark,
                    size: lgFontSize,
                    color: dfColor,
                  ),
                  onPressed: () {
                    CustomDialog(context);
                  },
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Section 1: Non-scrollable content

            Container(
              width: scWidth,
              child: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Image.asset(
                    "asserts/icons/icon.png",
                    width: scWidth / 4,
                    height: scHeight / 5,
                  )),
            ),

            Text(
              "Reset Password",
              style: TextStyle(
                color: appcolor,
                fontSize: exLgFontSize,
                fontWeight: FontWeight.bold,
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
                                    prefixIconColor: blackColor,
                                    suffixIconColor: blackColor,
                                    labelStyle: TextStyle(color: blackColor),
                                    labelText: 'New Password',
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
                                      return 'Enter Your New Password';
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
                                      return 'Enter Your Confirm Password';
                                    }
                                    if (_newpassword != value) {
                                      return 'Confirm Password Did Not Match';
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
                                      // print("New Pas: " + _newpassword);
                                      // print("Confrim Pass: " + _renewpassword);

                                      resetUser();
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

                              ///-----------
                              Container(
                                // color: Colors.amber,
                                margin: EdgeInsets.only(top: 10, bottom: 20),
                                width: scWidth,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: smFontSize,
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          text: "Password Hint\n",
                                          style: TextStyle(
                                              color: blackColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: exSmFontSize),
                                          children: [
                                            TextSpan(
                                                text:
                                                    "Password must be minimum 8 Characters, it should also contain atleast 1 Capital Letter and 1 Alphanumeric Character",
                                                style: TextStyle(
                                                    color: blackColor,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: exSmFontSize))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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
