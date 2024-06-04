import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dha_resident_app/anim/animated_checkmark_dialog.dart';
import 'package:dha_resident_app/view/screens/login/login.dart';
import 'package:dha_resident_app/view/widgets/custom_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:dha_resident_app/constant.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteAccount extends StatefulWidget {
  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final _formKey = GlobalKey<FormState>();
  String consumerid = "";
  bool _isLoading = false;
  late SharedPreferences prefs;
  String? conID;
  //email validation
  String? validateConsumerId(String value) {
    if (value.isEmpty) {
      return 'Please enter your consumer id';
    }
    return null;
  }

  void _showCustomDialog(
    BuildContext context,
    String title,
    String description,
  ) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),

        width: scWidth / 1.05,
        // height: scHeight / 1.8, // Set the desired width here
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
                Text(
                  '$title',
                  style:
                      TextStyle(color: appcolor, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(height: 5),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: scHeight / 2.1, // Set the maximum height here
              ),
              child: Text(
                "$description",
                textAlign: TextAlign.center,
                style: TextStyle(color: appcolor, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: appcolor),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context); // close the dialog only
                    });
                  },
                  child: Text('Cancel'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context); // close the dialog only
                      _isLoading = true;
                      deleteAccount();
                      print("deleteed user!");
                    });
                  },
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    )..show();
  }

  Future<void> removeSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Clear all data stored in SharedPreferences
    await prefs.clear();

    // Alternatively, you can remove a specific key
    // prefs.remove('yourKey');

    print('Session removed from SharedPreferences');
  }

//  this is register
  Future<void> deleteAccount() async {
    final String apiUrl = 'http://110.93.244.74/api/deleteUserAccount';

    final Map<String, dynamic> requestBody = {
      'consumerid': consumerid,
    };

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? authToken = prefs.getString('token');
    if (authToken == null) {
      print('Authentication token not available.');
      return;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    final String jsonBody = jsonEncode(requestBody);
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Handle the response data here, e.g., show a success message

        if (responseData['success'] == 1) {
          print("Forgot next screen : ${responseData}");
          setState(() {
            _isLoading = false;
          });
          showAnimatedCheckmarkDialog(
              context, responseData['message'], appcolor);
          await Future.delayed(Duration(seconds: 1));
          removeSession();
          final route = MaterialPageRoute(builder: (context) => LogIn());

          Navigator.pushAndRemoveUntil(context, route, (route) => false);
        } else {
          setState(() {
            _isLoading = false;
          });
          funToast(responseData['message'], Colors.redAccent);
        }
      } else {
        // Handle the error response
        setState(() {
          _isLoading = false;
        });
        print(
            'Failed to delete . Please try again later. ${response.statusCode}');
        funToast(responseData['message'], Colors.redAccent);
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      setState(() {
        _isLoading = false;
      });
      print('An error occurred: $e');
      funToast("Internet Connection Failed!", Colors.redAccent);
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
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeSharedPreferences();
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      conID = prefs.getString('consumerid');
    });
    // print("This is consumer id $conID");
  }

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greyColor,
        title: Text(
          "Delete Account",
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
      body: OverlayLoaderWithAppIcon(
        overlayBackgroundColor: Colors.transparent,
        isLoading: _isLoading,
        appIcon: Center(child: CircularProgressIndicator()),
        child: Container(
          child: Column(
            children: [
              // Section 1:
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
                "Delete Account",
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
                            margin:
                                EdgeInsets.only(left: 25, right: 25, top: 80),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: scWidth / 1.2,
                                      child: Text(
                                        "Enter Your Consumer ID To Delete Your Account",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    autofocus: false,
                                    style: TextStyle(
                                        fontSize: dfFontSize,
                                        color: Colors.black87),
                                    decoration: InputDecoration(
                                      prefixIconColor: blackColor,
                                      suffixIconColor: blackColor,
                                      labelStyle: TextStyle(color: blackColor),
                                      labelText: 'Consumer ID',
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
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
                                        borderSide:
                                            BorderSide(color: blackColor),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please Enter Your Consumer ID';
                                      }
                                      return validateConsumerId(value);
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        consumerid = value.trim();
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
                                      color: Colors.red,
                                      // gradient: lgBlue,
                                      borderRadius:
                                          BorderRadius.circular(roundBtn)),
                                  width: scWidth,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        print(conID);
                                        if (consumerid != 0) {
                                          _showCustomDialog(context, "Warning!",
                                              "Are You Sure You Want To Delete Your Account?");
                                        } else {
                                          funToast(
                                              "Please Enter Your Consumer ID Correctly!",
                                              Colors.red);
                                        }
                                      }
                                    },
                                    child: Text(
                                      'Delete Account',
                                      style: TextStyle(color: btnTextColor),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
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
      ),
    );
  }
}
