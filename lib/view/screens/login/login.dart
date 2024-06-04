import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dha_resident_app/model/controller/auth_controller.dart';
import 'package:dha_resident_app/model/shared_pref_session.dart/share_pref_api_function.dart';
import 'package:dha_resident_app/view/screens/reset/reset_password.dart';
import 'package:dha_resident_app/view/screens/signup/signup.dart';
import 'package:dha_resident_app/view/widgets/custom_dialog.dart';
import 'package:dha_resident_app/view/widgets/custom_snackbar.dart';
import 'package:dha_resident_app/view_model/dialog_aleart.dart';
import 'package:dha_resident_app/view_model/fetch_model/fetch_pages_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import '../../../constant.dart';
import 'dart:convert';
import '../dashboard/bottomNavBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart';

class LogIn extends StatefulWidget {
  static const routeName = '/login';
  @override
  State<LogIn> createState() => _LogInState();
}

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void run(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }
}

class _LogInState extends State<LogIn> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _showPassword = false;
  final logger = Logger();
  var fetchData;
  bool errorLod = false;
  late Debouncer _debouncer;

  List<PagesModel> fetchPagesModel = [];
  List<PagesModel> allPagesModel = [];

  //Check Internet connectivity
  Future<bool> isInternetConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> checkInternet() async {
    errorLod = await isInternetConnect();
    //print("Error Network errorLod);
  }

  void initState() {
    super.initState();
    _debouncer = Debouncer(delay: Duration(seconds: 2));

    storeApiData();

    getPagesFromSharedPreferences();
  }

  Future<void> storeApiData() async {
    await storePagesApi();
    // await ChartComplaitApi();
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

// Function to show the custom dialog
  void _showCustomDialog(
    double scWidth,
    double scHeight,
    BuildContext context,
    String title,
    String description,
  ) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      //  padding: EdgeInsets.all(0),
      //  bodyHeaderDistance: 75.0,
      body: Container(
        width: scWidth / 1.1,
        height: Platform.isAndroid
            ? scHeight / 1.2
            : scHeight / 1.25, // Set the desired hight here
        child: CustomDialogTerm(
          title: title,
          description: description,
        ),
      ), // Use your custom dialog content widget
    )..show();
  }

//For Dialog for Error
  void _showErrorDialog(
      BuildContext context, String title, String description) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide,
      title: title,
      desc: description,
      btnOk: IconButton(
        onPressed: () async {
          Navigator.of(context).pop();
        },
        icon: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: appcolor),
          onPressed: () {
            setState(() {
              Navigator.pop(context); // close the dialog only
            });
          },
          child: Text('Ok'),
        ),
        color: Colors.green,
      ),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
//colored Toast function
    void funToast(String ToastMessage, Color custcolor) {
      Fluttertoast.showToast(
          msg: ToastMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: custcolor,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    //Redirection Member Portal
    _launchURLBrowser() async {
      var url = Uri.parse("https://www.dhai-r.com.pk/");
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.inAppWebView);
      } else {
        throw 'Could not launch $url';
      }
    }

    // _launchURLBrowser() async {
    //   print("Website Call 2");
    //   // final Uri url = Uri(scheme: 'https', host: 'www.dhai-r.com.pk', path: '/');
    //   var url = Uri.parse("https://www.dhai-r.com.pk/");
    //   if (await canLaunchUrl(url)) {
    //     await launchUrl(url, mode: LaunchMode.externalApplication);
    //   } else {
    //     throw 'Could not launch $url';
    //   }
    // }

    _launchURLBrowser1() async {
      const url = "https://member.dhai-r.com.pk/";
      try {
        await launch(url, forceSafariVC: false, forceWebView: false);
      } catch (e) {
        print('Error launching URL: $e');
      }
    }

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
      prefs.setInt('plot', int.parse(jsonData['plot'].toString() ?? '0'));
      prefs.setString('street', jsonData['street'] ?? 'N/A');

      prefs.setString('uidStr', jsonData['uid_str'] ?? 'N/A');
      prefs.setString('username', jsonData['username'] ?? 'N/A');
      prefs.setString('usernameStr', jsonData['username_str'] ?? 'N/A');
      prefs.setInt('usertype', int.parse(jsonData['usertype'] ?? '0'));

      prefs.setDouble('primary_lat',
          double.parse(jsonData['primary_lat'].toString() ?? '0.0'));
      prefs.setDouble('primary_lng',
          double.parse(jsonData['primary_lng'].toString() ?? '0.0'));
      prefs.setInt('user_id', int.parse(jsonData['user_id'].toString() ?? '0'));
      prefs.setString('consumerid', jsonData['consumerid'] ?? '0');

      print("Token Login  Consumer ID : ${jsonData['consumerid']}");
    }

    Future<void> loginwith(String username, String password) async {
      const maxRetries = 3; // Adjust the maximum number of retries as needed
      int retry = 0;

      while (retry < maxRetries) {
        try {
          final response = await http.post(
            Uri.parse('http://110.93.244.74/api/login'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'username': username,
              'password': password,
            }),
          );

          // Check if the login was successful (status code 200)
          if (response.statusCode == 200 || response.statusCode == 429) {
            final jsonResponse = jsonDecode(response.body);
            final status = jsonResponse['success'];
            final message = jsonResponse['message'];
            final data = jsonResponse['data_array'];

            final address = data['address'];

            // If login was successful, save session data
            if (status == 1) {
              setState(() {
                _isLoading = false;
              });

              final sessionData = {
                'useremail': username,
                'token': data['token'],
                'name_str': data['name_str'],
                'desrttoken': data['short_token'],
                'name': data['name'],
                'namignation': data['designation'],
                'uid': data['uid'],
                'uid_str': data['uid_str'],
                'username': data['username'],
                'username_str': data['username_str'],
                'usertype': data['usertype'].toString(),
                'primary_lat': data['primary_lat'],
                'primary_lng': data['primary_lng'],
                'consumerid': data['consumerid'],
                'user_id': data['user_id'],
                'phase': address['phase'],
                'sector': address['sector'],
                'plot': address['plot'],
                'street': address['street'],
              };

              saveSessionData(sessionData);
              funToast(message, Colors.green);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNavBar(),
                ),
              );
              return; // Return after successful login
            } else if (status == 0) {
              setState(() {
                _isLoading = false;
              });
              _showErrorDialog(
                  context, "Info!", message.replaceAll('. ', '!\n'));
              return; // Return after unsuccessful login
            }
          } else {
            // Handle other non-429 HTTP error responses
            if (response.statusCode == 429) {
              // Implement logic to handle rate limiting, e.g., retry after a delay
              await Future.delayed(Duration(seconds: 5));
              retry++; // Increment retry count
              continue; // Retry the login request
            } else {
              setState(() {
                _isLoading = false;
              });
              print(
                  'HTTP Error: ${response.reasonPhrase} +${response.statusCode} ');
              funToast('No Internet Connection! ', Colors.red);
              return; // Return after handling other errors
            }
          }
        } catch (error) {
          setState(() {
            _isLoading = false;
          });

          // Handle error that occurred during login
          print('Error: $error');
          funToast('Error $error. Please try again.', Colors.red);
          return; // Return after handling login error
        }
      }

      // If maximum retries reached, handle accordingly
      print('Maximum retries reached');
      // Add your logic for handling maximum retries here
    }

/////-----------
    Future<http.Response> login(String username, String password) async {
      const maxRetries = 3; // Adjust the maximum number of retries as needed
      int retry = 0;
      // while (retry < maxRetries) {
      try {
        final response = await http.post(
          Uri.parse('http://110.93.244.74/api/login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'username': username,
            'password': password,
          }),
        );
        // Check if the login was successful (status code 200)
        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          final status = jsonResponse['success'];
          final data = jsonResponse['data_array'];
          final longtoken = data['token'];
          // If login was successful, save session data
          if (status == 1) {
            logger.i("Login successful! Session data saved!");
          }
          return response;
        } else {
          // Handle other non-429 HTTP error responses
          logger.e('Unexpected response status code: ${response.statusCode}');
          logger.e('Response body: ${response.body}');
          throw Exception('Error occurred during login');
        }
      } catch (error) {
        // Handle other errors that might occur during the request
        logger.e('Error occurred during login: $error');
        // Rethrow the error to be caught by the calling code
        throw error;
      }
      // }
      // If max retries reached, return the last response
      // return http.Response('Max retries reached', 429);
    }

// Save session data using shared preferences

    Future<http.Response> loginAnd(String username, String password) async {
      // Create a map of data to send in the request body
      Map<String, String> data = {
        'username': username,
        'password': password,
      };

      // Send a post request to the API endpoint with the data
      var response = await http.post(
        Uri.parse('http://110.93.244.74/api/login'),
        body: data,
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // If successful, parse the JSON response
        final jsonResponse = jsonDecode(response.body);
        final status = jsonResponse['success'];

        // If login was successful, save session data
        if (status == 1) {}

        // Print the response body
        print(response.body);
        return response;
      } else {
        // If not successful, print the error message
        print('Login failed: ${response.reasonPhrase}');
        return response;
      }
    }

//More Android Login Logic
    void AndroidLogin(String mail, String pass) {
      loginAnd(mail, pass).then((response) {
        final jsonResponse = jsonDecode(response.body);
        final status = jsonResponse['success'];
        final message = jsonResponse['message'];

        if (status == 1) {
          setState(() {
            _isLoading = false;
          });
          // Successful login
          final data = jsonResponse["data_array"];
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

          // Show a success toast message
          funToast(message, Colors.green);

          // Navigate to the main content screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBar(),
            ),
          );
        } else if (status == 0) {
          setState(() {
            _isLoading = false;
          });
          // Failed login
          // funToast(message, Colors.redAccent);
          _showErrorDialog(context, "Info", message);
        } else {
          setState(() {
            _isLoading = false;
          });
          // Handle HTTP error response
          print('HTTP Error: ${response.reasonPhrase}');

          funToast(message, Colors.red);
        }
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        // Handle any errors that occurred during the login process
        print('Login error: $error');
        funToast("LogIn Error : $error", Colors.red);
      });
    }

    //more IOs Login Logic
    void IOsLogin(String mail, String pass) {
      login(mail, pass).then((response) {
        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          final status = jsonResponse['success'];
          final message = jsonResponse['message'];

          if (status == 1) {
            setState(() {
              _isLoading = false;
            });
            final data = jsonResponse['data_array'];

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

            funToast(message, Colors.green);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavBar(),
              ),
            );
          } else if (status == 0) {
            setState(() {
              _isLoading = false;
            });
            // funToast("Invalid Email OR Password. Try Again OR Call 1092!",
            //     Colors.redAccent);

            // funToast(message, Colors.redAccent);
            _showErrorDialog(context, "Info", message);
          }
        } else {
          setState(() {
            _isLoading = false;
          });
          // Handle HTTP error response
          print('HTTP Error: ${response.reasonPhrase}');

          funToast('${response.statusCode}', Colors.red);
        }
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        // Handle error that occurred during login
        print('Login error: $error');

        funToast('An error occurred. Please try again.', Colors.red);
      });
    }

//---------------Check LogIn 429 Error

    Future<http.Response> loginWithRetry(String mail, String pass) async {
      const maxRetries = 1; // Adjust the maximum number of retries as needed
      int retry = 0;

      // while (retry < maxRetries) {
      try {
        final response = await login(mail, pass);

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          final status = jsonResponse['success'];
          final message = jsonResponse['message'];

          if (status == 1) {
            setState(() {
              _isLoading = false;
            });
            final data = jsonResponse['data_array'];

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

            funToast(message, Colors.green);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavBar(),
              ),
            );
            return response; // Return the response if successful
          } else if (status == 0) {
            setState(() {
              _isLoading = false;
            });
            _showErrorDialog(context, "Info", message);
          }
        }
        // else if (response.statusCode == 429) {
        //   final retryAfter = response.headers['retry-after'];
        //   if (retryAfter != null) {
        //     // Parse the retry-after value and wait
        //     final waitTime = int.parse(retryAfter);
        //     await Future.delayed(Duration(seconds: waitTime));
        //   } else {
        //     // If no retry-after header, use exponential backoff
        //     await Future.delayed(Duration(seconds: 2 ^ retry));
        //   }

        //   retry++;
        // }
        else {
          // Handle other HTTP error responses
          setState(() {
            _isLoading = false;
          });
          print('HTTP Error: ${response.reasonPhrase}');
          funToast('No Internet Connection!', Colors.red);
          return response; // Return the response for other HTTP errors
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        // Handle error that occurred during login
        print('Login error: $error');
        funToast('An error occurred. Please try again.', Colors.red);
        return http.Response(
            'An error occurred', 500); // Return an error response
      }
      // }

      // If max retries reached, return the last response
      return http.Response('Max retries reached', 429);
    }

//------------------LogIn

    Future<void> loginUser(String email, String password) async {
      final String apiUrl = 'http://110.93.244.74/api/login';

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'username': email,
            'password': password,
          }),
        );

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          final status = jsonResponse['success'];
          final message = jsonResponse['message'];

          if (status == 1) {
            setState(() {
              _isLoading = false;
            });
            final data = jsonResponse['data_array'];

            //To ave address;
            final address = data['address'];

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
              'phase': address['phase'],
              'sector': address['sector'],
              'plot': address['plot'],
              'street': address['street'],
            };

            saveSessionData(sessionData);

            funToast(message, Colors.green);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavBar(),
              ),
            );
            // return response; // Return the response if successful
          } else if (status == 0) {
            setState(() {
              _isLoading = false;
            });
            _showErrorDialog(context, "Info", message);
          }

          // Successful login, handle the response
          print('Login successful: ${response.body}');
        } else {
          // Handle login failure
          print('Login failed: ${response.statusCode}');
        }
      } catch (error) {
        // Handle network errors or other exceptions
        print('Login error: $error');
      }
    }

//-------------LogIn----------

    void _login(AuthController authController, _email, _password) async {
      if (_email.isEmpty) {
        showCustomSnackBar('enter email address'.tr);
      } else if (!GetUtils.isEmail(_email)) {
        showCustomSnackBar('enter a valid email address'.tr);
      } else if (_password.isEmpty) {
        showCustomSnackBar('enter password'.tr);
      }
      // else if (_password.length < 9) {
      //   showCustomSnackBar('password_should_be '.tr);
      // }
      else {
        authController.login(_email, _password).then((status) async {
          if (status.isSuccess) {
            debugPrint(
                "=======status${status.isSuccess}:${status.message}=======");
            Get.offAll(
              () => BottomNavBar(),
              // arguments: 'login',
            );
          } else {
            debugPrint(
                "=======status${status.isSuccess}:${status.message}=======");
            showCustomSnackBar(status.message);
          }
        });
      }
    }

    Future<void> loginew(String username, String password) async {
      try {
        final response = await http.post(
          Uri.parse('http://110.93.244.74/api/login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'username': username,
            'password': password,
          }),
        );

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          final status = jsonResponse['success'];

          if (status == 1) {
            print('Login successful!');
            // You might want to save session data or perform other actions here
          } else {
            print('Login failed. Status: $status');
          }
        } else {
          print('Unexpected response status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (error) {
        print('Error occurred during login: $error');
        // Handle other errors that might occur during the request
      }
    }

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

    // String? validateEmail(String value) {
    //   if (value == null || value.isEmpty) {
    //     // Check if it's a 15-digit number
    //     if (RegExp(r'^\d{15}$').hasMatch(value)) {
    //       return null; // Return null if it's a 15-digit number
    //     } else {
    //       return 'Please Enter a valid E-mail / Consumer ID (15 digit)';
    //     }
    //   } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
    //       .hasMatch(value)) {
    //     return 'Please Enter Your E-mail / Consumer ID';
    //   }
    //   return null; // Return null if the email is valid
    // }

    String? validatePassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please Enter Your Password.';
      } else if (value.length < 8) {
        return 'Password Must Be Atleast 8 Characters.';
      } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
        return 'Password Must Contain Atleast One Uppercase Letter.';
      } else if (!RegExp(r'\d').hasMatch(value)) {
        return 'Password Must Contain Atleast One Number.';
      } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
        return 'Password Must Contain Atleast One Special Character.';
      }
      return null; // Return null if the password is valid
    }

    Future<List<PagesDialog>> fetchPages() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? '';

      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };

//Old Url:  65.109.233.187

      final response = await http.get(
        Uri.parse('http://110.93.244.74/api/pages'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data_array'];
        return data.map((json) => PagesDialog.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    }

    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;

    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (_) {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor:
                Colors.transparent, // Make the status bar transparent
          ));
          return OverlayLoaderWithAppIcon(
            overlayBackgroundColor: appcolor,
            isLoading: _isLoading,
            appIcon: Center(child: CircularProgressIndicator()),
            child: SafeArea(
              child: Scaffold(
                extendBodyBehindAppBar: true,
                body: Column(
                  children: [
                    // Section 1: Non-scrollable content
                    Container(
                      child: Stack(
                        children: [
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
                                ? EdgeInsets.only(top: scHeight / 8)
                                : EdgeInsets.only(top: scHeight / 10),
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
                            margin: EdgeInsets.only(bottom: 10),
                            child: Column(
                              children: [
                                Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 25,
                                    right: 25,
                                    top: 25,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Text(
                                      //   "E-mail / Consumer ID ",
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
                                            labelStyle:
                                                TextStyle(color: blackColor),
                                            labelText: 'E-mail / Consumer ID',
                                            prefixIcon: Icon(
                                              Icons.email_outlined,
                                              size: dfIconSize,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            filled: true,
                                            fillColor: dfColor,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 5.0,
                                                    bottom: marginLR,
                                                    top: marginLR),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: blackColor),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          keyboardType: TextInputType.text,
                                          validator: validateEmail,
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
                                //////////////////
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 25, right: 25, top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          decoration: InputDecoration(
                                            prefixIconColor: blackColor,
                                            suffixIconColor: blackColor,
                                            labelStyle:
                                                TextStyle(color: blackColor),
                                            labelText: 'Password',
                                            prefixIcon: Icon(
                                              Icons.lock_outlined,
                                              size: dfIconSize,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            filled: true,
                                            fillColor: dfColor,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 5.0,
                                                    bottom: marginLR,
                                                    top: marginLR),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: blackColor),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _showPassword
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _showPassword =
                                                      !_showPassword;
                                                });
                                              },
                                            ),
                                          ),
                                          obscureText:
                                              !_showPassword, // Toggle visibility
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please Enter Your Password.';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              _password = value.trim();
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                          top: 10,
                                        ),
                                        decoration: BoxDecoration(
                                            gradient: lgBlue,
                                            borderRadius: BorderRadius.circular(
                                                roundBtn)),
                                        width: scWidth,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            setState(() {});
                                            if (_formKey.currentState!
                                                .validate()) {
                                              print(
                                                  'Email: $_email, Password: $_password');
                                              _isLoading = true;

                                              // Use the run method to debounce the login request
                                              _debouncer.run(() async {
                                                await loginwith(
                                                    _email, _password);
                                              });
                                            }
                                          },
                                          child: Text(
                                            'Log In',
                                            style:
                                                TextStyle(color: btnTextColor),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      roundBtn),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 8),
                                        alignment: Alignment.center,
                                        child: Text("or"),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 8),
                                        alignment: Alignment.center,
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ResetPassword()));
                                          },
                                          style: ButtonStyle(
                                            padding: MaterialStatePropertyAll(
                                                EdgeInsets.zero),
                                            minimumSize:
                                                MaterialStatePropertyAll(
                                                    Size(10, 0)),
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                            // padding: EdgeInsets.zero,
                                            // minimumSize: Size(10, 0),
                                            // tapTargetSize: MaterialTapTargetSize
                                            //     .shrinkWrap,
                                          ),
                                          child: Text(
                                            "Forgot Password?",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                /////////////////
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 25),
                                  child: Column(children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Don't have an account? ",
                                            style: TextStyle(
                                                color: blackColor,
                                                fontWeight: FontWeight.w400),
                                          ),

                                          TextButton(
                                            onPressed: () {
                                              _showCustomDialog(
                                                scWidth,
                                                scHeight,
                                                context,
                                                allPagesModel[0].title,
                                                allPagesModel[0].description,
                                              );
                                            },
                                            style: ButtonStyle(
                                              padding: MaterialStatePropertyAll(
                                                  EdgeInsets.zero),
                                              minimumSize:
                                                  MaterialStatePropertyAll(
                                                      Size(10, 0)),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              // padding: EdgeInsets.zero,
                                              // minimumSize: Size(10, 0),
                                              // tapTargetSize: MaterialTapTargetSize
                                              //     .shrinkWrap,
                                            ),
                                            child: Text(
                                              "Sign Up",
                                              style: TextStyle(
                                                  color: appcolor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),

                                          // FutureBuilder<List<PagesDialog>>(
                                          //     future: fetchPages(),
                                          //     builder: (context, snapshot) {
                                          //       if (snapshot.connectionState ==
                                          //           ConnectionState.waiting) {
                                          //         return Text(
                                          //           "Sign Up",
                                          //           style: TextStyle(
                                          //               color: appcolor,
                                          //               fontWeight:
                                          //                   FontWeight.bold),
                                          //         );
                                          //       } else if (snapshot.hasError) {
                                          //         return Center(
                                          //             child: InkWell(
                                          //           onTap: () {
                                          //             funToast(
                                          //                 "No Internet Connection!",
                                          //                 Colors.red);
                                          //           },
                                          //           child: Text(
                                          //             "Sign Up",
                                          //             style: TextStyle(
                                          //                 color: appcolor,
                                          //                 fontWeight:
                                          //                     FontWeight.bold),
                                          //           ),
                                          //         ));
                                          //       } else {
                                          //         fetchData = snapshot.data;
                                          //         //    final htmlTitle = fetchData![5].title;
                                          //         //     final fetchData = snapshot.data;
                                          //         return TextButton(
                                          //           onPressed: () {
                                          //             _showCustomDialog(
                                          //                 context,
                                          //                 allPagesModel[0]
                                          //                     .title
                                          //                     .replaceAll(
                                          //                         RegExp(
                                          //                             r'<[^>]*>|&[^;]+;'),
                                          //                         ' '),
                                          //                 allPagesModel[0]
                                          //                     .description
                                          //                     .replaceAll(
                                          //                         RegExp(
                                          //                             r'<[^>]*>|&[^;]+;'),
                                          //                         ' '));
                                          //           },
                                          //           style: TextButton.styleFrom(
                                          //             padding: EdgeInsets.zero,
                                          //             minimumSize: Size(10, 0),
                                          //             tapTargetSize:
                                          //                 MaterialTapTargetSize
                                          //                     .shrinkWrap,
                                          //           ),
                                          //           child: Text(
                                          //             "Sign Up",
                                          //             style: TextStyle(
                                          //                 color: appcolor,
                                          //                 fontWeight:
                                          //                     FontWeight.bold),
                                          //           ),
                                          //         );
                                          //       }
                                          //     }),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 0,
                                      ),
                                      decoration: BoxDecoration(
                                          gradient: lgBlue,
                                          borderRadius:
                                              BorderRadius.circular(roundBtn)),
                                      width: scWidth,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          customDialog5(context);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'For Any Query Please Call ',
                                              style: TextStyle(
                                                  color: btnTextColor),
                                            ),
                                            Text(
                                              '1092',
                                              style: TextStyle(
                                                  color: btnTextColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(roundBtn),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 12),
                                      alignment: Alignment.center,
                                      child: Column(
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.error,
                                                color: Colors.red,
                                                size: exSmFontSize,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "This app is only for present residents of DHAI-R.",
                                                  style: TextStyle(
                                                    color: blackColor,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: exSmFontSize,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.error,
                                                color: Colors.red,
                                                size: exSmFontSize,
                                              ),
                                              Text(
                                                "               Same credentials can be used for",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: blackColor,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  _launchURLBrowser1();
                                                },
                                                style: ButtonStyle(
                                                  padding:
                                                      MaterialStatePropertyAll(
                                                          EdgeInsets.zero),
                                                  minimumSize:
                                                      MaterialStatePropertyAll(
                                                          Size(10, 0)),
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  // padding: EdgeInsets.zero,
                                                  // minimumSize: Size(10, 0),
                                                  // tapTargetSize: MaterialTapTargetSize
                                                  //     .shrinkWrap,
                                                ),
                                                child: Container(
                                                  child: Text(
                                                    "DHAI-R Member Portal",
                                                    style: TextStyle(
                                                        color: appcolor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    softWrap: true,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                " (Only Members)",
                                                style: TextStyle(
                                                    color: blackColor,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
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
            ),
          );
        });
  }
}
//---------- current iteration
// class CustomDialogTerm extends StatelessWidget {
//   final String title;
//   final String description;

//   CustomDialogTerm({
//     required this.title,
//     required this.description,
//   });

//   @override
//   Widget build(BuildContext context) {
//     double scWidth = MediaQuery.of(context).size.width;
//     double scHeight = MediaQuery.of(context).size.height;

//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//       margin: EdgeInsets.symmetric(vertical: 0),
//       width: scWidth / 1.1,
//       height: scHeight / 1.1, // Set the desired width here
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Container(
//             margin: EdgeInsets.only(bottom: 10),
//             child: Text(
//               title,
//               style: TextStyle(
//                   fontSize: scWidth / 22, fontWeight: FontWeight.bold),
//             ),
//           ),
//           SizedBox(height: 0),
//           ConstrainedBox(
//             constraints: BoxConstraints(
//               maxHeight: scHeight / 1.4, // Set the maximum height here
//             ),
//             child: SingleChildScrollView(
//               child: Html(data: description), // Render HTML content
//             ),
//           ),
//           SizedBox(height: 0),
//           Container(
//             margin: EdgeInsets.only(top: 5),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.white,
//                       backgroundColor: Colors.red),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('Disagree'),
//                 ),
//                 SizedBox(width: 20),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.white, backgroundColor: appcolor),
//                   onPressed: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => SignUp()));
//                   },
//                   child: Text('Agree'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
///--------- second iteration
// class CustomDialogTerm extends StatelessWidget {
//   final String title;
//   final String description;

//   CustomDialogTerm({
//     required this.title,
//     required this.description,
//   });

//   String _removeHtmlTags(String htmlString) {
//     RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
//     return htmlString.replaceAll(exp, '');
//   }

//   @override
//   Widget build(BuildContext context) {
//     double scWidth = MediaQuery.of(context).size.width;
//     double scHeight = MediaQuery.of(context).size.height;

//     // Remove HTML tags from the title
//     String cleanTitle = _removeHtmlTags(title);

//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//       margin: EdgeInsets.symmetric(vertical: 0),
//       width: scWidth / 1.1,
//       height: scHeight / 1.1, // Set the desired width here
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           Center(
//             child: Container(
//               margin: EdgeInsets.only(bottom: 10),
//               child: Text(
//                 cleanTitle,
//                 style: TextStyle(
//                   fontSize: scWidth / 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center, // Center align the text
//               ),
//             ),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Html(data: description), // Render HTML content
//             ),
//           ),
//           SizedBox(height: 10), // Adjust as needed
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.red,
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('Disagree'),
//               ),
//               SizedBox(width: 20),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: appcolor,
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => SignUp()),
//                   );
//                 },
//                 child: Text('Agree'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

class CustomDialogTerm extends StatelessWidget {
  final String title;
  final String description;

  CustomDialogTerm({
    required this.title,
    required this.description,
  });

  String _removeHtmlTags(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;

    // Remove HTML tags from the title
    String cleanTitle = _removeHtmlTags(title);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 0),
      width: scWidth / 1.1,
      height: scHeight / 1.1, // Set the desired width here
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                cleanTitle,
                style: TextStyle(
                  fontSize: scWidth / 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Center align the text
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Html(data: description), // Render HTML content
            ),
          ),
          SizedBox(height: 10), // Adjust as needed
          Padding(
            padding: const EdgeInsets.only(
                bottom: 10), // Add padding to move buttons up
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Disagree'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: appcolor,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                  child: Text('Agree'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
