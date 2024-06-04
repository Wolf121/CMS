import 'dart:convert';
import 'package:dha_resident_app/view/widgets/custom_dialog.dart';
import 'package:http/http.dart' as http;

import 'package:dha_resident_app/constant.dart';
import 'package:dha_resident_app/view/screens/reset/reset_verf_password.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetNextScreen extends StatefulWidget {
  final String id;
  final String msno;
  final String phoneNo;
  final String digitCode;
  ResetNextScreen({
    required this.id,
    required this.msno,
    required this.digitCode,
    required this.phoneNo,
  });

  @override
  State<ResetNextScreen> createState() => _ResetNextScreenState();
}

class _ResetNextScreenState extends State<ResetNextScreen> {
  final _formKey = GlobalKey<FormState>();
  String digitCde = "";

  Future<void> resetUser() async {
    final String apiUrl = 'http://110.93.244.74/api/verifyotp';

    final Map<String, dynamic> requestBody = {
      'uid': widget.id,
      'digitcode': digitCde
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
              builder: (context) => ResetVerfPassword(
                    uid: responseData['data_array']['uid'] ?? "",
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

    String transformPhoneNumber(String phoneNumber) {
      if (phoneNumber.length == 11) {
        // Assuming the phone number format is XXXXXXXXXX (11 digits)
        // You may need to adjust this based on the actual format of your phone numbers
        String maskedPart = '******';
        String lastFourDigits = phoneNumber.substring(7);
        return "$maskedPart$lastFourDigits";
      } else {
        // Handle invalid phone number length
        return phoneNumber;
      }
    }

    String phoneString = widget.phoneNo;
    String transformedNumber = transformPhoneNumber(phoneString);

    print("Original phone number: $phoneString");
    print("Transformed phone number: $transformedNumber");

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: greyColor,
          title: Text(
            "Verification Code",
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
                "MS No #",
                style: TextStyle(
                  color: appcolor,
                  fontSize: exLgFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.msno,
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
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            text:
                                                'A text message with a verification code was just sent to ',
                                            style: TextStyle(color: appcolor),
                                            children: [
                                              TextSpan(
                                                text:
                                                    '${transformedNumber.replaceAllMapped(
                                                  RegExp(r'\d(?=\d{4})'),
                                                  (Match m) => '*',
                                                )}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: appcolor),
                                              )
                                            ]),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: TextFormField(
                                    autofocus: false,
                                    maxLength: 4,
                                    style: TextStyle(
                                        fontSize: dfFontSize,
                                        color: Colors.black87),
                                    decoration: InputDecoration(
                                      prefixIconColor: blackColor,
                                      suffixIconColor: blackColor,
                                      labelStyle: TextStyle(color: blackColor),
                                      labelText: 'Verification Code',
                                      prefixIcon: Icon(
                                        Icons.verified_outlined,
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
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please Enter Your Verification Code';
                                      }

                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        digitCde = value.trim();
                                      });
                                    },
                                  ),
                                ),
                                ////////////////////

                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  // height: scHeight / 12,
                                  width: scWidth / 1,
                                  child: Container(
                                    // color: Colors.amber,
                                    width: scWidth,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: dfFontSize,
                                        ),
                                        Text(
                                          " If you did not receive an OTP, call 1092 (Dial 4)",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13.5),
                                          // softWrap: true,
                                          // overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ///////////////////

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
                                        resetUser();
                                      }
                                    },
                                    child: Text(
                                      'Next',
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
