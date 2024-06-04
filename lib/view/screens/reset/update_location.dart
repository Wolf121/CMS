import 'dart:convert';
import 'package:dha_resident_app/view/widgets/custom_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:dha_resident_app/constant.dart';
import 'package:dha_resident_app/view/screens/reset/reset_next_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeleteAccount extends StatefulWidget {
  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";

  //email validation
  String? validateEmail(String value) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

    if (value.isEmpty) {
      return 'Please enter your email';
    } else if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

//  this is register
  Future<void> deleteAccount() async {
    ;

    final String apiUrl = 'http://110.93.244.74/api/deleteUserAccount';

    final Map<String, dynamic> requestBody = {
      'email': _email,
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

          final route = MaterialPageRoute(
              builder: (context) => ResetNextScreen(
                    id: responseData['data_array']['uid'] ?? "",
                    msno: responseData['data_array']['msno'] ?? "",
                    phoneNo: responseData['data_array']['phone'] ?? "",
                    digitCode: responseData['data_array']['msno'] ?? "",
                  ));

          Navigator.push(context, route);
        } else {
          funToast(responseData['message'], Colors.redAccent);
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
        body: Container(
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
                                        "Enter Your Consumer ID To Detele Your Account",
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
                                        fontSize: 18.0, color: Colors.black87),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: drakGreyColor,
                                      contentPadding: const EdgeInsets.all(8.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please Enter Your E-mail / Consumer ID';
                                      }
                                      return validateEmail(value);
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        _email = value.trim();
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
                                      if (_formKey.currentState!.validate()) {
                                        deleteAccount();
                                      }
                                    },
                                    child: Text(
                                      'Delete Account',
                                      style: TextStyle(color: btnTextColor),
                                    ),
                                    style: ElevatedButton.styleFrom(
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
