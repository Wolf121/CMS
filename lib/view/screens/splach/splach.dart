import 'dart:async';

import 'package:dha_resident_app/model/shared_pref_session.dart/share_pref_api_function.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

import '../../../constant.dart';
import '../dashboard/bottomNavBar.dart';
import '../login/login.dart';
import 'package:connectivity/connectivity.dart';

class Splach extends StatefulWidget {
  const Splach({super.key});

  @override
  State<Splach> createState() => _SplachState();
}

class _SplachState extends State<Splach> {
  @override
  void initState() {
    super.initState();
    checkNetworkConnectivity(context);
    // checkForUpdates();
    Timer(const Duration(seconds: 5), () => checkSessionStatus());
    //storePagesApi();
    ChartComplaitApi();
  }

  Future<void> checkSessionStatus() async {
    if (await isUserLoggedIn()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => UpgradeAlert(
                upgrader: Upgrader(
                  // showIgnore: false,
                  // showLater: false,
                  // showReleaseNotes: false,
                  // canDismissDialog: false,
                  durationUntilAlertAgain: const Duration(seconds: 1),
                ),
                child: BottomNavBar())),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => UpgradeAlert(
                upgrader: Upgrader(
                  // showIgnore: false,
                  // showLater: false,
                  // showReleaseNotes: false,
                  // canDismissDialog: false,
                  durationUntilAlertAgain: const Duration(seconds: 1),
                ),
                child: LogIn())),
      );
    }
  }

  Future<bool> checkNetworkConnectivity(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No network connectivity, show default dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: <Widget>[
                Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
                SizedBox(width: 8), // Adjust as needed
                Flexible(
                  child: Text(
                    'No Internet Connection',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16.0, // Adjust the font size here
                    ),
                  ),
                ),
              ],
            ),
            content:
                Text('Please check your internet connection and try again.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false; // No network
    }
    return true; // Network is available
  }

  Future<bool> isUserLoggedIn() async {
    // Check if session data or tokens exist
    // For example, if using shared_preferences or secure_storage:
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Return true if the user is logged in, false otherwise
    return isLoggedIn;
  }

  // Future<void> checkForUpdates() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   String currentVersion = packageInfo.version;

  //   // Replace 'your_latest_version' with the actual latest version of your app
  //   String latestVersion = 'your_latest_version';

  //   if (currentVersion != latestVersion) {
  //     // App is not up to date, prompt the user to update
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Update Required'),
  //           content: Text(
  //               'A new version of the app is available. Please update to continue using the app.'),
  //           actions: <Widget>[
  //             TextButton(
  //               child: Text('Update Now'),
  //               onPressed: () {
  //                 // Replace 'your_store_url' with the actual URL of your app on the store
  //                 launch('your_store_url');
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          // Adjust the height as needed
          color: appcolor, // Container background color
          child: Container(
            margin: EdgeInsets.symmetric(vertical: marginLR),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'asserts/icons/icon.png',
                  width: 220,
                  height: 220,
                ),
                Text(
                  "Version 2.0.3",
                  style: TextStyle(
                      color: dfColor,
                      fontSize: exXSmFontSize,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "Complaint Management System",
                  style: TextStyle(
                      color: dfColor,
                      fontSize: smFontSize,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "DHA Islamabad",
                  style: TextStyle(
                    color: dfColor,
                    fontSize: smFontSize,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
