import 'dart:convert';
import 'package:dha_resident_app/view/widgets/custom_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:dha_resident_app/constant.dart';
import 'package:dha_resident_app/view/screens/reset/reset_next_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";

  //email validation

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Your E-mail / Consumer ID';
    } else if (RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      return null; // Return null if it's a valid email
    } else if (!RegExp(r'^[0-9]{1,25}$').hasMatch(value)) {
      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        return 'Please Enter a valid E-mail / Consumer ID';
      } else {
        return 'Please Enter 25 digit Consumer ID';
      }
    }
    return null;
  }

//  this is register
  Future<void> resetUser() async {
    ;

    final String apiUrl = 'http://110.93.244.74/api/reset_password';

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
                    phoneNo: responseData['data_array']['phoneDB'] ?? "",
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
                                        "Enter Your Registered E-mail OR Consumer ID To Reset Your Password",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 15),
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
                                      labelText: 'E-mail / Consumer ID',
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
                                      // if (value!.isEmpty) {
                                      //   return 'Please Enter Your E-mail / Consumer ID';
                                      // }
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
                                  margin: EdgeInsets.only(top: 10, bottom: 20),
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

                                ///-----------
                                // Container(
                                //   // color: Colors.amber,
                                //   margin: EdgeInsets.only(
                                //     top: 10,
                                //   ),
                                //   width: scWidth,
                                //   child: Column(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.center,
                                //     children: [
                                //       Icon(
                                //         Icons.error,
                                //         color: Colors.red,
                                //         size: smFontSize,
                                //       ),
                                //       Container(
                                //         alignment: Alignment.center,
                                //         child: RichText(
                                //           textAlign: TextAlign.center,
                                //           text: TextSpan(
                                //             text: "Password Hint\n",
                                //             style: TextStyle(
                                //                 color: blackColor,
                                //                 fontWeight: FontWeight.bold,
                                //                 fontSize: exSmFontSize),
                                //             children: [
                                //               TextSpan(
                                //                   text:
                                //                       "Password must be minimum 8 Characters, it should also contain atleast 1 Capital Letter and 1 Alphanumeric Character",
                                //                   style: TextStyle(
                                //                       color: blackColor,
                                //                       fontWeight:
                                //                           FontWeight.w400,
                                //                       fontSize: exSmFontSize))
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
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
