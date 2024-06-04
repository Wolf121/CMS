import 'dart:async';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dha_resident_app/model/shared_pref_session.dart/share_pref_api_function.dart';
import 'package:dha_resident_app/view/screens/complaint/new_complaint.dart';
import 'package:dha_resident_app/view_model/dialog_aleart.dart';
import 'package:dha_resident_app/view_model/fetch_model/fetch_pages_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String message1 = "";
  late int status1 = 0;
  late Map<String, dynamic> data1 = {};
  late String longtoken1 = "";
  late String shorttoken1 = "";
  late String name1 = "";
  late String logedUser1 = "";
  late String designation1 = "";
  late String uid1 = "";
  late String uid_str1 = "";
  late String usern1 = "";
  late String username_str1 = "";
  late int usertype1 = 0;

  //SOS variales

  String lat = '0.0';
  String lng = '0.0';
  String source = '';
  int typeId = 0;
  String deviceTime = '';
  String requestTime = '';
  bool _isLoading = false;

  List<PagesModel> fetchPagesModel = [];
  List<PagesModel> allPagesModel = [];

  double homeLatitude = 0;
  double homeLongitude = 0;

  void initState() {
    super.initState();
    _isLoading = true;
    getPagesFromSharedPreferences();
    loadSessionData(); // Load data from SharedPreferences
    storeApiData();
    getLocation();
    fetchPages();
    if (defaultTargetPlatform == TargetPlatform.android) {
      source = 'Android';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      source = 'IOs';
    }
    deviceTime = getDeviceTime();
    requestTime = getDeviceTime();
    getStaffTypeData();
    loadLocationData();
  }

  Future<void> loadLocationData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      homeLatitude = prefs.getDouble('primary_lat') ?? 0.0;

      homeLongitude = prefs.getDouble('primary_lng') ?? 0.0;
    });
  }

  Future<void> storeApiData() async {
    await storePagesApi();
    await ChartComplaitApi();
  }

//deviceTime
  String getDeviceTime() {
    DateTime now = DateTime.now();
    String formattedTime = "${now.hour}:${now.minute}:${now.second}";
    return formattedTime;
  }

  Future<void> loadSessionData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // message1 = prefs.getString('message') ?? "";
      // status1 = prefs.getInt('status') ?? 0;
      data1 = jsonDecode(prefs.getString('data') ?? '{}');
      longtoken1 = prefs.getString('longtoken') ?? "";
      shorttoken1 = prefs.getString('shorttoken') ?? "";
      name1 = prefs.getString('name') ?? "";
      logedUser1 = prefs.getString('logedUser') ?? "";
      designation1 = prefs.getString('designation') ?? "";
      uid1 = prefs.getString('uid') ?? "";
      uid_str1 = prefs.getString('uid_str') ?? "";
      usern1 = prefs.getString('usern') ?? "";
      username_str1 = prefs.getString('username_str') ?? "";
      usertype1 = prefs.getInt('usertype') ?? 0;
    });
  }

  Future<void> customDialog4(String titletext, String DecText) async {
    print(titletext);
    String converTedHtml = Html(data: titletext).toString();
    print(converTedHtml);
    print(DecText);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Improper Use Policy",
              style: TextStyle(color: Colors.red),
            ),
          ),

          contentPadding: EdgeInsets.symmetric(
              vertical: 10.0, horizontal: 24.0), // Adjust padding here
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: SingleChildScrollView(
              child: Html(data: DecText),
            ),
          ),
          actions: <Widget>[
            Center(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Image.asset(
                  'asserts/icons/checked.png',
                  width: 40,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

//------------new dialog
  Future<void> uploadSOSData(
      {required int typeId,
      required String latitude,
      required String longitude,
      required String location_id}) async {
    print("This is lat: " + lat.toString());
    print("This is lng: " + lng.toString());
    print("This is Source: " + source.toString());
    print("This is TYPE: " + typeId.toString());
    print("This is dtime: " + deviceTime.toString());
    print("This is rtime: " + requestTime.toString());
    // Retrieve the token from SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      print("Token NOT fOUND!");
      return;
    }
    print("This is lat: " + lat.toString());
    print("This is lng: " + lng.toString());
    print("This is Source: " + source.toString());
    print("This is TYPE: " + typeId.toString());
    print("This is dtime: " + deviceTime.toString());
    print("This is rtime: " + requestTime.toString());

    // Define the API URL
    final Uri apiUrl = Uri.parse('http://110.93.244.74/api/sos/sos_store');

    // Prepare the request data
    final Map<String, dynamic> requestData = {
      'lat': latitude,
      'lng': longitude,
      'source': source,
      'type_id': typeId,
      'device_time': deviceTime,
      'request_time': requestTime,
      'location_id ': location_id,
    };

    // Send the POST request with the token in the headers
    final http.Response response = await http.post(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Set content type to JSON
      },
      body: json.encode(requestData), // Convert the request data to JSON string
    );

    if (response.statusCode == 200) {
      print("The location id is: $location_id");
      // SOS data uploaded successfully.
      print('SOS data uploaded successfully: ${response.body}');
      funToast("SOS Send Successfully!", Colors.green, ToastGravity.BOTTOM);

      if (typeId == 1) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.noHeader,
          animType: AnimType.bottomSlide,
          title: 'Call Security?',
          desc: 'Tapping The Dial Button Will Call Security.',
          btnCancel: IconButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            icon: Image.asset(
              'asserts/icons/cross.png',
              width: 40,
            ),
            color: Colors.red,
          ),
          btnOk: IconButton(
            onPressed: () async {
              FlutterPhoneDirectCaller.callNumber("080034247");
            },
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.green,
              child: Icon(
                Icons.phone,
                color: dfColor,
              ),
            ),
            color: Colors.green,
          ),
        ).show();
      }
    } else {
      // Handle the API error response.
      print('Failed to upload SOS data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> getLocation() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        lat = '${position.latitude}';
        lng = '${position.longitude}';
      });
    } catch (e) {
      print("Error while getting location: $e");
    }
  }

  //Dialog Aleart
  Future<List<PagesDialog>> fetchPages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

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

  /////-------Getting Staff Data

  Future<void> getStaffTypeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the token from SharedPreferences with a default value
    String? token = prefs.getString('token') ?? '';

    // API URL
    final apiUrl = 'http://110.93.244.74/api/staff/staff_category';

    // Create headers with the token
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      // Make an HTTP GET request to the API
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        // Parse the response JSON
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Check if the "success" key is 1 to ensure a successful response
        if (responseData['success'] == 1) {
          final List<dynamic> data = responseData['data_array'];
          print(data);

          // Store the data in SharedPreferences as 'staffType'
          await prefs.setString('staffType', json.encode(data));
        } else {
          // Handle the API error
          print('API request failed with message: ${responseData['message']}');
        }
      } else {
        // Handle the API error
        print('API request failed with status ${response.statusCode}');
      }
    } catch (error) {
      // Handle any network or parsing errors
      print('Error: $error');
    }
  }

//Toast
  void funToast(String ToastMessage, Color custcolor, ToastGravity gravity) {
    Fluttertoast.showToast(
        msg: ToastMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        backgroundColor: custcolor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

//--------shared pages data
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

  ////--------
  void showCustomDialog(BuildContext context, {required int typeId}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Choose a Location!",
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              mainAxis: Axis.vertical,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(10),
                            backgroundColor: appcolor,
                            elevation: 0),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          uploadSOSData(
                            typeId: typeId,
                            latitude: lat,
                            longitude: lng,
                            location_id: 2.toString(),
                          );
                        },
                        icon: Icon(Icons.location_on_outlined),
                        label: Text(
                          "Current Location",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              homeLatitude == null ? lightappcolor : appcolor,
                          elevation: 0,
                          padding: EdgeInsets.all(10),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          uploadSOSData(
                              typeId: typeId,
                              latitude: homeLatitude.toString(),
                              longitude: homeLongitude.toString(),
                              location_id: 1.toString());
                        },
                        icon: Icon(Icons.home),
                        label: Text(
                          "Home's Location",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ////////---------- Panic

  bool isSOSPressed = false;
  double sosProgress = 0.0;

  void onPanicPressed() {
    setState(() {
      isSOSPressed = true;
      sosProgress = 0.0;
    });

    Timer.periodic(Duration(milliseconds: 200), (Timer t) {
      if (mounted)
        setState(() {
          sosProgress += 0.1;

          if (sosProgress >= 1.0) {
            print("SOS Panic");
            showCustomDialog(context, typeId: 1);
            t.cancel();
            isSOSPressed = false;
          }
        });
    });
  }

  ////////---------- Fire

  bool isFirePressed = false;
  double fireProgress = 0.0;

  void onFirePressed() {
    setState(() {
      isFirePressed = true;
      fireProgress = 0.0;
    });

    Timer.periodic(Duration(milliseconds: 200), (Timer t) {
      if (mounted)
        setState(() {
          fireProgress += 0.1;

          if (fireProgress >= 1.0) {
            print("SOS Fire");
            showCustomDialog(
              context,
              typeId: 2,
            );
            t.cancel();
            isFirePressed = false;
          }
        });
    });
  }

  ////////---------- MEDICAL

  bool isMedicalPressed = false;
  double medicalProgress = 0.0;

  void onMedicalPressed() {
    setState(() {
      isMedicalPressed = true;
      medicalProgress = 0.0;
    });

    Timer.periodic(Duration(milliseconds: 200), (Timer t) {
      if (mounted)
        setState(() {
          medicalProgress += 0.1;

          if (medicalProgress >= 1.0) {
            print("SOS Medical");
            showCustomDialog(
              context,
              typeId: 3,
            );
            t.cancel();
            isMedicalPressed = false;
          }
        });
    });
  }

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
  ////////---------- AMULANCE

  bool isAmbulancePressed = false;
  double ambulanceProgress = 0.0;

  void onAmbulancePressed() {
    setState(() {
      isAmbulancePressed = true;
      ambulanceProgress = 0.0;
    });

    Timer.periodic(Duration(milliseconds: 200), (Timer t) {
      if (mounted)
        setState(() {
          ambulanceProgress += 0.1;

          if (ambulanceProgress >= 1.0) {
            print("SOS Ambulance");
            showCustomDialog(
              context,
              typeId: 5,
            );
            t.cancel();
            isAmbulancePressed = false;
          }
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    return Container(
      margin:
          EdgeInsets.only(left: marginLR, right: marginLR, top: scHeight / 90),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Hide work for future Pending Task

            ///////////////

            Container(
              height: scHeight / (5 * 7),
              child: AnimatedTextKit(
                pause: Duration(seconds: 1),
                repeatForever: true,
                animatedTexts: [
                  TypewriterAnimatedText('COMPLAINT MANAGEMENT SYSTEM',
                      speed: Duration(milliseconds: 50),
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: appcolor)),
                  TyperAnimatedText('SOLUTION TO MAKE THINGS EASIER',
                      speed: Duration(milliseconds: 50),
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: exSmFontSize,
                          color: lightappcolor)),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: scHeight / 22),
              child: Row(
                children: [
                  // SizedBox(
                  //     height:
                  //         100), // Add space above Panic without a visible box
                  Material(
                    elevation: smElevation,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: scWidth / 2.2,
                      height: scHeight / 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 0.5, color: drakGreyColor),
                      ),
                      child: GestureDetector(
                        onLongPress: () {
                          onPanicPressed();
                        },
                        onTap: () {
                          funToast("Hold the button for 2 seconds!",
                              Colors.blueAccent, ToastGravity.BOTTOM);
                        },
                        onTapUp: (_) {
                          setState(() {
                            isSOSPressed = false;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(seconds: 2),
                          curve: Curves.linear,
                          decoration: BoxDecoration(
                            color: ligappcolor,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isSOSPressed ? Colors.blueAccent : dfColor,
                              width: 4.0,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // clipBehavior: Clip.none,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: lightappcolor,
                                      radius: scWidth / 10,
                                      child: Image.asset(
                                        "asserts/images/policeman.png",
                                        width: scWidth / 7,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "PANIC",
                                      style: TextStyle(
                                        fontSize: lgFontSize,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
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
                  Spacer(),
                  Material(
                    elevation: smElevation,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: scWidth / 2.2,
                      height: scHeight / 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 0.5, color: drakGreyColor),
                      ),
                      child: GestureDetector(
                        onLongPress: () {
                          onFirePressed();
                        },
                        onTap: () {
                          funToast("Hold the button for 2 seconds!",
                              Colors.orangeAccent, ToastGravity.BOTTOM);
                        },
                        onTapUp: (_) {
                          setState(() {
                            isFirePressed = false;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(seconds: 2),
                          curve: Curves.linear,
                          decoration: BoxDecoration(
                            color: redlert,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color:
                                  isFirePressed ? Colors.orangeAccent : dfColor,
                              width: 4.0,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // clipBehavior: Clip.none,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: redAlert,
                                      radius: scWidth / 10,
                                      child: Image.asset(
                                        "asserts/images/flame.png",
                                        width: scWidth / 7,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "FIRE",
                                      style: TextStyle(
                                        fontSize: lgFontSize,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
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

            ////////////------- Medical & Ambulance
            // Container(
            //   margin: EdgeInsets.only(top: 40),
            //   child: Row(
            //     children: [
            //       Material(
            //         elevation: smElevation,
            //         borderRadius: BorderRadius.circular(20),
            //         child: Container(
            //           width: scWidth / 2.2,
            //           decoration: BoxDecoration(
            //               border: Border.all(width: 0.5, color: drakGreyColor),
            //               color: Colors.transparent,
            //               borderRadius: BorderRadius.circular(15)),
            //           child: GestureDetector(
            //             onLongPress: () {
            //               onMedicalPressed();
            //             },
            //             onTap: () {
            //               funToast("Hold the button for 2 seconds!", Colors.red,
            //                   ToastGravity.BOTTOM);
            //             },
            //             onTapUp: (_) {
            //               setState(() {
            //                 isMedicalPressed = false;
            //               });
            //             },
            //             child: AnimatedContainer(
            //               duration: Duration(seconds: 2), // 2 seconds
            //               curve: Curves.linear,
            //               decoration: BoxDecoration(
            //                 color: dfColor,
            //                 borderRadius: BorderRadius.circular(15),
            //                 border: Border.all(
            //                   color: isMedicalPressed ? Colors.red : dfColor,
            //                   width: 4.0,
            //                 ),
            //               ),
            //               child: Stack(
            //                 alignment: Alignment.center,
            //                 clipBehavior: Clip.none,
            //                 children: [
            //                   isMedicalPressed == true
            //                       ? Shimmer.fromColors(
            //                           baseColor: Colors.grey[300]!,
            //                           highlightColor: Colors.grey[100]!,
            //                           period: Duration(seconds: 2),
            //                           child: Container(
            //                             alignment: Alignment.center,
            //                             padding: EdgeInsets.only(
            //                                 top: 45, bottom: 10),
            //                             child: Text(
            //                               "MEDICAL",
            //                               style: TextStyle(
            //                                 fontSize:
            //                                     lgFontSize, // Adjust as needed
            //                                 fontWeight: FontWeight.w400,
            //                                 color: Colors.black,
            //                               ),
            //                             ),
            //                           ),
            //                         )
            //                       : Container(
            //                           alignment: Alignment.center,
            //                           padding:
            //                               EdgeInsets.only(top: 50, bottom: 10),
            //                           child: Text(
            //                             "MEDICAL",
            //                             style: TextStyle(
            //                               fontSize:
            //                                   lgFontSize, // Adjust as needed
            //                               fontWeight: FontWeight.w400,
            //                               color: Colors.black,
            //                             ),
            //                           ),
            //                         ),
            //                   // Positioned(
            //                   //   top: 3,
            //                   //   left: 3,
            //                   //   child: Text("0"),
            //                   // ),
            //                   Positioned(
            //                     top: -20,
            //                     child: CircleAvatar(
            //                       backgroundColor:
            //                           lightappcolor, // Adjust as needed
            //                       radius: 30.0,
            //                       child: Image.asset(
            //                         "asserts/images/medical.png", // Adjust the path
            //                         width: 40,
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //       Spacer(),
            //       Material(
            //         elevation: smElevation,
            //         borderRadius: BorderRadius.circular(15),
            //         child: Container(
            //           width: scWidth / 2.2,
            //           decoration: BoxDecoration(
            //               border: Border.all(width: 0.5, color: drakGreyColor),
            //               color: Colors.transparent,
            //               borderRadius: BorderRadius.circular(15)),
            //           child: GestureDetector(
            //             onLongPress: () {
            //               onAmbulancePressed();
            //             },
            //             onTap: () {
            //               funToast("Hold the button for 2 seconds!",
            //                   Colors.lightBlue, ToastGravity.BOTTOM);
            //             },
            //             onTapUp: (_) {
            //               setState(() {
            //                 isAmbulancePressed = false;
            //               });
            //             },
            //             child: AnimatedContainer(
            //               duration: Duration(seconds: 2), // 2 seconds
            //               curve: Curves.linear,
            //               decoration: BoxDecoration(
            //                 color: dfColor,
            //                 borderRadius: BorderRadius.circular(15),
            //                 border: Border.all(
            //                   color: isAmbulancePressed
            //                       ? Colors.lightBlue
            //                       : dfColor,
            //                   width: 4.0,
            //                 ),
            //               ),
            //               child: Stack(
            //                 alignment: Alignment.center,
            //                 clipBehavior: Clip.none,
            //                 children: [
            //                   isAmbulancePressed == true
            //                       ? Shimmer.fromColors(
            //                           baseColor: Colors.grey[300]!,
            //                           highlightColor: Colors.grey[100]!,
            //                           period: Duration(seconds: 2),
            //                           child: Container(
            //                             alignment: Alignment.center,
            //                             padding: EdgeInsets.only(
            //                                 top: 45, bottom: 10),
            //                             child: Text(
            //                               "AMBULANCE",
            //                               style: TextStyle(
            //                                 fontSize:
            //                                     lgFontSize, // Adjust as needed
            //                                 fontWeight: FontWeight.w400,
            //                                 color: Colors.black,
            //                               ),
            //                             ),
            //                           ),
            //                         )
            //                       : Container(
            //                           alignment: Alignment.center,
            //                           padding:
            //                               EdgeInsets.only(top: 50, bottom: 10),
            //                           child: Text(
            //                             "AMBULANCE",
            //                             style: TextStyle(
            //                               fontSize:
            //                                   lgFontSize, // Adjust as needed
            //                               fontWeight: FontWeight.w400,
            //                               color: Colors.black,
            //                             ),
            //                           ),
            //                         ),
            //                   // Positioned(
            //                   //   top: 3,
            //                   //   left: 3,
            //                   //   child: Text("0"),
            //                   // ),
            //                   Positioned(
            //                     top: -20,
            //                     child: CircleAvatar(
            //                       backgroundColor: redAlert, // Adjust as needed
            //                       radius: 30.0,
            //                       child: Image.asset(
            //                         "asserts/images/ambulance.png", // Adjust the path
            //                         width: 40,
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            //////////

            Container(
              margin: EdgeInsets.only(top: 40),
              width: scWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 0.5, color: drakGreyColor),
              ),
              child: ElevatedButton(
                onPressed: () {
                  //Navigation To New Complains
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewComplaint()));
                },
                style: ElevatedButton.styleFrom(
                  elevation: smElevation,
                  backgroundColor: dfColor,
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 55, bottom: 10),
                        child: Text(
                          "COMPLAINT",
                          style: TextStyle(
                              fontSize: lgFontSize,
                              // height: 1,
                              fontWeight: FontWeight.w400,
                              color: blackColor),
                        ),
                      ),
                      // Positioned(
                      //   top: 3,
                      //   left: 3,
                      //   child: Text("0"),
                      // ),
                      Positioned(
                        top: -20,
                        // left: 60,
                        child: CircleAvatar(
                          backgroundColor: yellowAlert,
                          radius: 30.0,
                          child: Image.asset(
                            "asserts/images/alert.png",
                            width: 40,
                          ),
                        ),
                      )
                    ]),
              ),
            ),

            ///////////////
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 0,
                ),
                decoration: BoxDecoration(
                    color: appcolor,
                    gradient: lgBlue,
                    border: Border.all(width: 0.5, color: appcolor),
                    borderRadius: BorderRadius.circular(35)),
                child: ElevatedButton(
                  onPressed: () {
                    // AwesomeDialog(
                    //   context: context,
                    //   dialogType: DialogType.noHeader,
                    //   descTextStyle: TextStyle(fontWeight: FontWeight.w400),
                    //   animType: AnimType.bottomSlide,
                    //   title: allPagesModel[5]
                    //       .title
                    //       .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' '),
                    //   desc: allPagesModel[5]
                    //       .description
                    //       .replaceAll('<br/>', '')
                    //       .replaceAll('<strong>', '')
                    //       .replaceAll('&nbsp;', '')
                    //       .replaceAll('</strong>', '')
                    //       .replaceAll('alertRs', 'alert Rs')
                    //       .replaceAll('alertsRs', 'alert \nRs'),
                    //   btnOk: IconButton(
                    //     onPressed: () async {
                    //       Navigator.pop(context); // Close the dialog
                    //     },
                    //     icon: Image.asset(
                    //       'asserts/icons/checked.png',
                    //       width: 40,
                    //     ),
                    //     color: Colors.green,
                    //   ),
                    // ).show();
                    // _showCustomDialog(scWidth, scHeight, context,
                    //     allPagesModel[5].title, allPagesModel[5].description);
                    customDialog4(
                        allPagesModel[5].title, allPagesModel[5].description);
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: smElevation + smElevation,
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: scWidth,
                        margin: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Read",
                              style: TextStyle(
                                fontSize: 30,
                                height: 1,
                                fontWeight: FontWeight.bold,
                                color: dfColor,
                              ),
                            ),
                            Text(
                              "Improper Use Policy",
                              style: TextStyle(
                                  fontSize: 18,
                                  height: 1,
                                  fontWeight: FontWeight.w300,
                                  color: dfColor),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: -1,
                        top: -35,
                        child: CircleAvatar(
                            backgroundColor: greyColor,
                            radius: 64.0,
                            child: Image.asset(
                              "asserts/images/read.png",
                              fit: BoxFit.cover,
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),

            ////////////
          ],
        ),
      ),
    );
  }
}

//------------dialog improper
class CustomDialogTerm extends StatelessWidget {
  final String title;
  final String description;

  CustomDialogTerm({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 0),
      width: scWidth / 1.1,
      height: scHeight / 1.1, // Set the desired width here
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: scWidth / 22, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 0),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: scHeight / 1.4, // Set the maximum height here
            ),
            child: SingleChildScrollView(
              child: Html(data: description), // Render HTML content
            ),
          ),
          SizedBox(height: 0),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Disagree'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: appcolor),
                  onPressed: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => SignUp()));
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
