import 'dart:io' show Platform;
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dha_resident_app/constant.dart';
import 'package:dha_resident_app/model/shared_pref_session.dart/share_pref_api_function.dart';
import 'package:dha_resident_app/view/screens/login/login.dart';
import 'package:dha_resident_app/view/screens/staff/add_staff.dart';
import 'package:dha_resident_app/view_model/fetch_model/fetch_pages_model.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../anim/animated_checkmark_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

import '../../../view_model/dialog_aleart.dart';

class SignUp extends StatefulWidget {
  static const routeName = '/login';

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _cnic = '';
  TextEditingController _cnicController = TextEditingController();
  String _cosumerId = '';
  String? _mobileNo;
  String? _phoneError;
  String _password = '';
  String _repassword = '';
  bool _showPassword = false;
  bool _reshowPassword = false;
  bool isChecked = true;
  String _source = '';
  String _Iso2code = 'PK';
  String _dialCode = '+92';
  final _formKey1 = GlobalKey<FormState>();
  var fetchData;

  List<PagesModel> fetchPagesModel = [];
  List<PagesModel> allPagesModel = [];

  // Function to show the custom dialog
  void _showCustomDialog(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),

        width: scWidth / 1.05,
        height: scHeight / 1.25, // Set the desired width here
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Text(
                allPagesModel[1]
                    .title
                    .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' '),
                style: TextStyle(
                    fontSize: scWidth / 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 5),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: scHeight / 1.2, // Set the maximum height here
              ),
              child: SingleChildScrollView(
                child: Text(
                  allPagesModel[1]
                      .description
                      .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' '),
                  style: TextStyle(fontSize: scWidth / 30),
                ),
              ),
            ),
            // SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      setState(() {
                        isChecked = false;

                        Navigator.pop(context); // close the dialog only
                      });
                    },
                    child: Text('Disagree'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: appcolor),
                    onPressed: () {
                      setState(() {
                        isChecked = true;
                        Navigator.pop(context); // close the dialog only
                      });
                    },
                    child: Text('Agree'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )..show();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    storeApiData();
    getPagesFromSharedPreferences();
    //

    bool isPlatformAndroid() {
      return Platform.isAndroid;
    }

    bool isPlatformiOS() {
      return Platform.isIOS;
    }

    if (isPlatformiOS()) {
      _source = "IOs";
    } else if (isPlatformAndroid()) {
      _source = "Android";
    }
  }

  Future<void> storeApiData() async {
    await storePagesApi();
  }

  // Function to retrieve status from SharedPreferences and populate the list
  Future<void> getPagesFromSharedPreferences() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? dashboardChatDataSerialzed =
          prefs.getString('fetchPagesModel');

      if (dashboardChatDataSerialzed != null &&
          dashboardChatDataSerialzed.isNotEmpty) {
        final List<dynamic> dataArray = jsonDecode(dashboardChatDataSerialzed);

        fetchPagesModel =
            dataArray.map((json) => PagesModel.fromJson(json)).toList();

        // Update the lists if needed

        List<PagesModel> updatedDashboardList = [];

        fetchPagesModel.forEach((status) {
          updatedDashboardList.add(status);
        });

        setState(() {
          allPagesModel = updatedDashboardList; // Update the status list
          print("Total Pages data: ${allPagesModel.length}");
        });
      } else {
        print('No Dashboard data found in SharedPreferences.');
      }
    } catch (e) {
      print('Error retrieving Dashboard data from SharedPreferences: $e');
    }
  }

  void JustPrintingTheShitOutOfEverything() {
    print('This is Mobile Number$_mobileNo');
    print('This is CNIC$_cnic');
    print('This Is Email $_email');
    print("Thid is iso2code $_Iso2code");
    print("This Is Dial Code : $_dialCode");
    print('This is Consumer ID $_cosumerId');

    print('This is Password $_password');
    print('This is Confirm Password $_repassword');
  }

  void validatePhoneNumber() {
    if (_mobileNo == null || _mobileNo!.isEmpty) {
      // Phone number is empty, set error message
      setState(() {
        _phoneError = 'Please enter a mobile number';
      });
    } else {
      // Clear any previous error message
      setState(() {
        _phoneError = null;
      });
    }
  }

  //Dialog Aleart
  Future<List<PagesDialog>> fetchPages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('longToken') ?? '';

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(Uri.parse('http://110.93.244.74/api/pages'),
        headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data_array'];
      return data.map((json) => PagesDialog.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

// --  number fixer
  String modifyPhoneNumber(String phone) {
    // Check if the phone number starts with "+92"
    if (phone.startsWith('+92')) {
      // Remove "+92" from the beginning
      phone = phone.substring(3);
      // Add '0' in front of the remaining digits
      phone = '0$phone';
    }
    return phone;
  }

//this is register
  Future<void> registerUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //final String token = prefs.getString('longToken') ?? '';

    final String apiUrl = 'http://110.93.244.74/api/register';

    final Map<String, dynamic> requestBody = {
      'phone': modifyPhoneNumber(_mobileNo.toString()),
      'cnic': _cnic,
      'email': _email,
      'iso2code': _Iso2code,
      'dialcode': _dialCode,
      'consumerid': _cosumerId,
      'password': _password,
      'confirm_password': _repassword,
      'source': _source,
      // 'device_token': token,
    };
    print("asdhjkajsd" + requestBody.toString());
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
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      int status = responseData['success'];
      if (response.statusCode == 200 && status == 1) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        String message = responseData['message'];
        // Handle the response data here, e.g., show a success message
        print(responseData);

        // Store the responseData in SharedPreferences if needed
        await prefs.setString(
            'registrationResponseData', jsonEncode(responseData));
        showAnimatedCheckmarkDialog(context, message, Colors.green);
        await Future.delayed(Duration(seconds: 1));

        final route = MaterialPageRoute(builder: (context) => LogIn());

        Navigator.pushAndRemoveUntil(context, route, (route) => false);
      } else {
        // Handle the error response
        print(
            'Failed to register user. Please try again later. ${response.body}');
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        String message = responseData['message'];
        funToast(message, Colors.redAccent);
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      print('An error occurred: $e');
      funToast("Registration failed $e", Colors.redAccent);
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

  //email validation
  String? validateEmail(String value) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

    if (value.isEmpty) {
      return 'Please Enter Your email';
    } else if (!emailRegExp.hasMatch(value)) {
      return 'Please Enter a valid email address';
    }
    return null;
  }

  // password validation

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Your Password';
    } else if (value.length < 8) {
      return 'Password Must Be Atleast 8 Characters';
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password Must Contain At Least 1 Capital Alphabet';
    } else if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password Must Contain Atleast 1 Digit';
    }
    // else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
    //   return 'Password Must Contain Atleast One Special Character.';
    // }
    return null; // Return null if the password is valid
  }

  // CNIC Validation

  String? validateAndFormatCNIC(String value) {
    // Remove any non-digit characters
    final cleanedValue = value.replaceAll(RegExp(r'[^\d]'), '');

    // Check if the cleaned CNIC has a length of 13 digits
    if (cleanedValue.length != 13) {
      return 'Please Enter a 13-digit CNIC number';
    }

    // Format the CNIC with dashes
    final formattedValue =
        '${cleanedValue.substring(0, 5)}-${cleanedValue.substring(5, 12)}-${cleanedValue.substring(12)}';

    // Set the formatted CNIC to the controller
    _cnicController.value = TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );

    return null;
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
            Container(
              margin: EdgeInsets.only(bottom: 15, left: 15),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 0,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: lightappcolor,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_outlined,
                          color: dfColor,
                        ),
                        onPressed: () {
                          final route =
                              MaterialPageRoute(builder: (context) => LogIn());

                          Navigator.pushAndRemoveUntil(
                              context, route, (route) => false);
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: Platform.isAndroid
                        ? EdgeInsets.only(top: 0)
                        : EdgeInsets.only(top: 0),
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      'asserts/images/frame.png',
                      width: 199,
                      height: 196,
                    ),
                  ),
                  Container(
                    margin: Platform.isAndroid
                        ? EdgeInsets.only(top: scHeight / 12)
                        : EdgeInsets.only(top: scHeight / 14),
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'asserts/icons/icon.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                ],
              ),
            ),
            // Section 2: Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 25, right: 25, top: 10, bottom: 10),
                    child: Column(
                      children: [
                        Container(
                          // margin: Platform.isAndroid
                          //     ? EdgeInsets.only(top: scHeight / 3.5)
                          //     : EdgeInsets.only(top: scHeight / 4),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "DHA ",
                                    style: TextStyle(
                                        color: appcolor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Islamabad",
                                    style: TextStyle(
                                        color: blackColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(
                                "Defence Housing Authority",
                                style: TextStyle(
                                  color: appcolor,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),

                        ///--------------------Email
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   "E-mail",
                              //   style: TextStyle(
                              //     // height: 2,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              Container(
                                margin:
                                    EdgeInsets.only(top: marginLR + marginLR),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  autofocus: false,
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.black87),
                                  decoration: InputDecoration(
                                    prefixIconColor: blackColor,
                                    suffixIconColor: blackColor,
                                    labelStyle: TextStyle(color: blackColor),
                                    labelText: 'E-mail',
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
                                      borderSide: BorderSide(color: blackColor),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please Enter Your E-mail';
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
                            ],
                          ),
                        ),

                        ///--------------------CNIC
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   "CNIC",
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
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
                                    labelText: 'CNIC',
                                    prefixIcon: Icon(
                                      Icons.person,
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
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [CNICInputFormatter()],
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please Enter Your CNIC';
                                    } else if (value.length < 13) {
                                      return 'Please Enter a 13 Digit CNIC No';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    _cnic = value.replaceAll('-', '');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        ///--------------------Consumer ID

                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   "Consumer ID",
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                child: TextFormField(
                                  // maxLength: ,
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
                                      borderSide: BorderSide(color: blackColor),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(14)
                                  ],
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please Enter Your Consumer ID';
                                    }
                                    if (value.length != 14) {
                                      return 'Please Enter correct Consumer ID';
                                    }

                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _cosumerId = value.trim();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        ///--------------------Mobile No

                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                child: TextField(
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    FixedLengthInputFormatter(
                                        11), // Limit input to exactly 11 characters
                                    PhoneNumberFormatter(), // Apply PhoneNumberFormatter
                                  ],
                                  maxLength:
                                      11, // Set maximum length to 11 characters
                                  decoration: InputDecoration(
                                    prefixIconColor: blackColor,
                                    suffixIconColor: blackColor,
                                    labelStyle: TextStyle(color: blackColor),
                                    labelText: 'Mobile Number',
                                    hintText: '03xxxxxxxxx', // Add hint text
                                    prefixIcon: Icon(
                                      Icons.phone,
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
                                      top: marginLR,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: blackColor),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    // Display error message under the field
                                    errorText: _phoneError,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value.isEmpty) {
                                        _mobileNo = null; // Reset _mobileNo
                                        _phoneError =
                                            'Please enter a mobile number';
                                      } else {
                                        if (value.length < 11) {
                                          _mobileNo =
                                              null; // Reset _mobileNo if the length is less than 11
                                          _phoneError =
                                              'Mobile number must be 11 digits';
                                        } else if (value.length == 11 &&
                                            !value.startsWith('03')) {
                                          _mobileNo =
                                              null; // Reset _mobileNo if not starting with '03'
                                          _phoneError =
                                              'Mobile number must start with 03';
                                        } else {
                                          _phoneError =
                                              null; // Clear any previous error
                                          _mobileNo = modifyPhoneNumber(value);
                                        }
                                      }
                                    });
                                    print(_mobileNo);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        ///--------------------Password
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   "Password",
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

                                    // Add the inputFormatter to disallow spaces
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(
                                          RegExp(r'\s')), // Disallow spaces
                                    ],
                                    decoration: InputDecoration(
                                      prefixIconColor: blackColor,
                                      suffixIconColor: blackColor,
                                      labelStyle: TextStyle(color: blackColor),
                                      labelText: 'Password',
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
                                        borderSide:
                                            BorderSide(color: blackColor),
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
                                    validator: validatePassword,
                                    onChanged: (value) {
                                      setState(() {
                                        // Remove leading and trailing spaces
                                        _password = value.trim();
                                      });
                                    },
                                  ),
                                ),
                              ]),
                        ),

                        ///--------------------Confirm Password
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
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
                                  textInputAction: TextInputAction.done,
                                  autofocus: false,
                                  style: TextStyle(
                                      fontSize: dfFontSize,
                                      color: Colors.black87),

                                  // Add the inputFormatter to disallow spaces
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'\s')), // Disallow spaces
                                  ],
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
                                        _reshowPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _reshowPassword = !_reshowPassword;
                                        });
                                      },
                                    ),
                                  ),

                                  obscureText:
                                      !_reshowPassword, // Toggle visibility

                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please Enter Your Password';
                                    }
                                    if (value != _password) {
                                      return 'Your Password fields do not match';
                                    }

                                    return null;
                                  },

                                  onChanged: (value) {
                                    setState(() {
                                      _repassword = value.trim();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        ///--------------------Term & Condition Check

                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 25,
                                    height: 25,
                                    child: Checkbox(
                                      checkColor: greyColor,
                                      fillColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.disabled)) {
                                          return drakGreyColor;
                                        }
                                        return appcolor;
                                      }),
                                      value: isChecked,
                                      onChanged: (bool? value) {
                                        _showCustomDialog(context);
                                      },
                                    ),
                                  ),
                                  Text(
                                    "Accept Terms and Conditions?",
                                    style: TextStyle(
                                      height: 1,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        ///--------------------Sign Up Btn

                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                      if (_mobileNo == null ||
                                          _mobileNo!.isEmpty) {
                                        funToast(
                                            "Please Enter A Valid Phone Number",
                                            Colors.red);
                                      } else {
                                        if (isChecked == true) {
                                          JustPrintingTheShitOutOfEverything();
                                          registerUser();
                                          // funToast("Success!", Colors.green);
                                        } else if (isChecked == false) {
                                          funToast(
                                              "Please read terms and conditions!",
                                              Colors.redAccent);
                                        }
                                      }
                                    } else {
                                      // Form validation failed, show error message
                                      funToast(
                                          "Please Fill In All The Fields Correctly!",
                                          Colors.red);
                                    }
                                  },
                                  child: Text(
                                    'Sign Up',
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

                        ///--------------------Already Text

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          child: Column(children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account? ",
                                    style: TextStyle(
                                        color: blackColor,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      final route = MaterialPageRoute(
                                          builder: (context) => LogIn());

                                      Navigator.pushAndRemoveUntil(
                                          context, route, (route) => false);
                                    },
                                    style: ButtonStyle(
                                      padding: MaterialStatePropertyAll(
                                          EdgeInsets.zero),
                                      minimumSize:
                                          MaterialStatePropertyAll(Size(10, 0)),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      // padding: EdgeInsets.zero,
                                      // minimumSize: Size(10, 0),
                                      // tapTargetSize: MaterialTapTargetSize
                                      //     .shrinkWrap,
                                    ),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          color: appcolor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ]),
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

class CustomDialogTerm extends StatefulWidget {
  final String title;
  final String description;
  bool isChecked;

  CustomDialogTerm({
    required this.title,
    required this.description,
    required this.isChecked,
  });

  @override
  State<CustomDialogTerm> createState() => _CustomDialogTermState();
}

class _CustomDialogTermState extends State<CustomDialogTerm> {
  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),

      width: scWidth / 1.4,
      height: scHeight / 1.8, // Set the desired width here
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: scHeight / 2.7, // Set the maximum height here
            ),
            child: SingleChildScrollView(
              child: Text(
                widget.description,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  // bool? value
                  //   isChecked = value!;
                  widget.isChecked = false;

                  Navigator.pop(context); // close the dialog only

                  // // bool? value
                  // //   isChecked = value!;
                  // isChecked = false;
                  // Navigator.pop(
                  //     context); // close the dialog only
                },
                child: Text('Disagree'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  // bool? value
                  //   isChecked = value!;
                  widget.isChecked = true;
                  Navigator.pop(context); // close the dialog only
                },
                child: Text('Agree'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//new one
// class PhoneNumberFormatter extends TextInputFormatter {
//   PhoneNumberFormatter();

//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue,
//     TextEditingValue newValue,
//   ) {
//     // Check if the new value is empty
//     if (newValue.text.isEmpty) {
//       // If empty, return the old value to prevent emptying the field
//       return oldValue;
//     }

//     // Allow only 10 digits to be entered
//     final text = newValue.text;
//     if (text.length > 10) {
//       // If more than 10 digits, truncate the input
//       final truncatedText = text.substring(0, 10);
//       return TextEditingValue(
//         text: truncatedText,
//         selection: TextSelection.collapsed(offset: truncatedText.length),
//       );
//     }

//     // Your existing formatting logic goes here
//     // For example, adding parentheses and spaces for phone number format
//     var newText = text;
//     if (newText.length == 1) newText = "($newText";
//     if (newText.length == 4) newText = "$newText) ";
//     if (newText.length == 9) newText = "$newText ";

//     // Return the modified text value
//     return TextEditingValue(
//       text: newText,
//       selection: newValue.selection,
//     );
//   }
// }

//old one
class PhoneNumberFormatter extends TextInputFormatter {
  PhoneNumberFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Check if text is being deleted (backspace)
    if (oldValue.text.length > newValue.text.length) {
      return newValue; // Return the new value without modification
    }

    var newText = newValue.text;

    // Apply formatting rules
    if (newText.length == 1) {
      newText = "(${newText}"; // Add opening parenthesis
    } else if (newText.length == 5) {
      newText =
          "${newText.substring(0, 4)}) ${newText.substring(4)}"; // Add closing parenthesis and space
    } else if (newText.length == 10) {
      newText =
          "${newText.substring(0, 9)} ${newText.substring(9)}"; // Add space after area code
    }

    // Limit the length of the text to 14 characters (including formatting characters)
    if (newText.length > 14) {
      newText = newText.substring(0, 14);
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class FixedLengthInputFormatter extends TextInputFormatter {
  final int maxLength;

  FixedLengthInputFormatter(this.maxLength);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length <= maxLength) {
      return newValue;
    } else {
      // Truncate the input to the maximum length if it exceeds it
      return TextEditingValue(
        text: newValue.text.substring(0, maxLength),
        selection: TextSelection.collapsed(offset: maxLength),
      );
    }
  }
}
