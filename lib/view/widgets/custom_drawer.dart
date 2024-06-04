import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dha_resident_app/anim/animated_checkmark_dialog.dart';
import 'package:dha_resident_app/constant.dart';
import 'package:dha_resident_app/model/shared_pref_session.dart/share_preferences_session.dart';
import 'package:dha_resident_app/view/screens/complaint/new_complaint.dart';
import 'package:dha_resident_app/view/screens/complaint/track_complaint.dart';
import 'package:dha_resident_app/view/screens/contacts/official_contacts.dart';
import 'package:dha_resident_app/view/screens/dashboard/bottomNavBar.dart';
import 'package:dha_resident_app/view/screens/mosque/announcements.dart';
import 'package:dha_resident_app/view/screens/mosque/mosque_timings.dart';
import 'package:dha_resident_app/view/screens/pet/add_pet.dart';
import 'package:dha_resident_app/view/screens/pet/manage_pet.dart';
import 'package:dha_resident_app/view/screens/reset/change_password.dart';
import 'package:dha_resident_app/view/screens/reset/delete_account.dart';
import 'package:dha_resident_app/view/screens/sos/sos_history.dart';
import 'package:dha_resident_app/view/screens/staff/add_staff.dart';
import 'package:dha_resident_app/view/screens/staff/manage_staff.dart';
import 'package:dha_resident_app/view/screens/website/view_pay_bill.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import 'dart:io' show Platform;

import '../screens/login/login.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isLoading = false;
  String logName = "";
  String consumerId = "";

  @override
  void initState() {
    super.initState();
    loadSessionData();
  }

  Future<void> loadSessionData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      logName = prefs.getString('logedUser') ?? "";

      consumerId = prefs.getString('usernameStr') ?? 'N/A';
    });
  }

  _launchURLBrowser() async {
    print("Website Call 2");
    // final Uri url = Uri(scheme: 'https', host: 'www.dhai-r.com.pk', path: '/');
    var url = Uri.parse("https://www.dhai-r.com.pk/");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURLBrowser1() async {
    const url = "https://www.dhai-r.com.pk/";
    try {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  // _launchURLBrowser() async {
  //   print("Website Call IOs");

  //   // Replace the URL with a different one to test
  //   var url = Uri.parse("https://www.dhai-r.com.pk/");

  //   try {
  //     if (await canLaunchUrl(url)) {
  //       // Use different launch mode if needed (e.g., LaunchMode.external)
  //       await launchUrl(url, mode: LaunchMode.inAppWebView);
  //     } else {
  //       print('Could not launch $url');
  //       funToast('Could not launch $url', Colors.red);
  //     }
  //   } catch (e) {
  //     print('Error launching URL: $e');
  //   }
  // }

  Future<void> _openWebsite() async {
    print("Website Call Android");
    const String url = "https://www.dhai-r.com.pk/";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    // You can also clear any other session-related data if needed
  }

//---------------GeoLoc Fuction
  Future<void> updateHomeLocation() async {
    try {
      // Get current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Get token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      // Replace the following with your actual API endpoint
      String apiUrl = 'http://110.93.244.74/api/addPrimaryLocation';

      // Data to be sent in the request
      Map<String, dynamic> data = {
        'lat': position.latitude,
        'lng': position.longitude,
        'location_id': 1,
      };

      // Headers for the request
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Send POST request
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(data),
      );

      // Print server response
      print('Server Response: ${response.body}');

      final jsonResponse = jsonDecode(response.body);

      final message = jsonResponse['message'];

      // Handle the response as needed (e.g., show success message)
      if (response.statusCode == 200) {
        print("The home Location is : $data");
        setState(() {
          _isLoading = false;
        });

        prefs.setDouble(
            'primary_lat', double.parse(position.latitude.toString() ?? '0.0'));
        prefs.setDouble('primary_lng',
            double.parse(position.longitude.toString() ?? '0.0'));

        print('Location updated successfully!');
        showAnimatedCheckmarkDialog(context, message, appcolor);
        await Future.delayed(Duration(seconds: 2));

        // _showCustomDialog(context, "Success", message);
        // Add your logic for handling a successful update
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Location update failed. Status Code: ${response.statusCode}');
        // Add your logic for handling a failed update
        funToast("Some thing went worng", Colors.red);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error updating location: $e');
      funToast("No Internet Connection!", Colors.red);
      // Add your error handling logic here
    }
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
                  Icons.location_on_outlined,
                  color: appcolor,
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
                style: TextStyle(color: appcolor, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context); // close the dialog only
                    });
                  },
                  child: Text('Cancel'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: appcolor),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context); // close the dialog only
                      _isLoading = true;
                      print("Location Updating!");
                      updateHomeLocation();
                    });
                  },
                  child: Text('Update'),
                ),
              ],
            ),
          ],
        ),
      ),
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: Platform.isAndroid
          ? EdgeInsets.symmetric(vertical: 20.0)
          : EdgeInsets.symmetric(vertical: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 50.0,
                  child: Image.asset("asserts/icons/icon.png"),
                ),
                Container(
                  child: Text(
                    "DHA Islamabad",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: dfColor),
                  ),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
          Container(
            // alignment: Alignment.center,
            // color: Colors.amber,
            padding: EdgeInsets.only(right: 30, left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "CID: $consumerId",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: drakGreyColor, fontWeight: FontWeight.w500),
                ),
                Text(
                  "$logName",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: drakGreyColor, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: greyColor,
                    thickness: 0,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomNavBar()));
                    },
                    leading: Image.asset(
                      "asserts/images/01.png",
                      color: dfColor,
                      width: dfIconSize,
                    ),
                    title: const Text(
                      "Home",
                      style: TextStyle(
                          color: dfColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    textColor: dfColor,
                    dense: true,
                  ),
                  Divider(
                    color: greyColor,
                    thickness: 0,
                  ),
                  Text(
                    "SOS",
                    style: TextStyle(
                        color: drakGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SosHistory()));
                    },
                    leading: Image.asset(
                      "asserts/images/02.png",
                      color: dfColor,
                      width: dfIconSize,
                    ),
                    title: const Text(
                      "SOS History",
                      style: TextStyle(
                          fontSize: dfFontSize, fontWeight: FontWeight.w500),
                    ),
                    textColor: dfColor,
                    dense: true,
                  ),
                  Divider(
                    color: greyColor,
                    thickness: 0,
                  ),
                  Text(
                    "Official Contacts",
                    style: TextStyle(
                        color: drakGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OfficialContacts()));
                    },
                    leading: Image.asset(
                      "asserts/images/contact.png",
                      color: dfColor,
                      width: dfIconSize,
                    ),
                    title: const Text(
                      "Official Contacts",
                      style: TextStyle(
                          fontSize: dfFontSize, fontWeight: FontWeight.w500),
                    ),
                    textColor: Colors.white,
                    dense: true,

                    // padding: EdgeInsets.zero,
                  ),
                  Divider(
                    color: greyColor,
                    thickness: 0,
                  ),
                  Text(
                    "Complaint",
                    style: TextStyle(
                        color: drakGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewComplaint()));
                    },
                    leading: Image.asset(
                      "asserts/images/complaint1.png",
                      color: dfColor,
                      width: dfIconSize,
                    ),
                    title: const Text(
                      "New Complaint",
                      style: TextStyle(
                          fontSize: dfFontSize, fontWeight: FontWeight.w500),
                    ),
                    textColor: dfColor,
                    dense: true,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrackComplaints()));
                    },
                    leading: Image.asset(
                      "asserts/images/04.png",
                      color: dfColor,
                      width: dfIconSize,
                    ),
                    title: const Text(
                      "Track Complaint",
                      style: TextStyle(
                          fontSize: dfFontSize, fontWeight: FontWeight.w500),
                    ),
                    textColor: dfColor,
                    dense: true,
                  ),
                  Divider(
                    color: greyColor,
                    thickness: 0,
                  ),
                  Text(
                    "Staff",
                    style: TextStyle(
                        color: drakGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddStaff()));
                    },
                    leading: Image.asset(
                      "asserts/images/05.png",
                      color: dfColor,
                      width: dfIconSize,
                    ),
                    title: const Text(
                      "Add Staff",
                      style: TextStyle(
                          fontSize: dfFontSize, fontWeight: FontWeight.w500),
                    ),
                    textColor: dfColor,
                    dense: true,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManageStaff()));
                    },
                    leading: Image.asset(
                      "asserts/images/06.png",
                      color: dfColor,
                      width: dfIconSize,
                    ),
                    title: const Text(
                      "Staff List",
                      style: TextStyle(
                          fontSize: dfFontSize, fontWeight: FontWeight.w500),
                    ),
                    textColor: dfColor,
                    dense: true,
                  ),
                  Divider(
                    color: greyColor,
                    thickness: 0,
                  ),
                  Text(
                    "Pet",
                    style: TextStyle(
                        color: drakGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddPet()));
                    },
                    leading: Image.asset(
                      "asserts/images/07.png",
                      color: dfColor,
                      width: dfIconSize,
                    ),
                    title: const Text(
                      "Add Pet",
                      style: TextStyle(
                          fontSize: dfFontSize, fontWeight: FontWeight.w500),
                    ),
                    textColor: dfColor,
                    dense: true,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ManagePet()));
                    },
                    leading: Image.asset(
                      "asserts/images/08.png",
                      color: dfColor,
                      width: dfIconSize,
                    ),
                    title: const Text(
                      "Pet List",
                      style: TextStyle(
                          fontSize: dfFontSize, fontWeight: FontWeight.w500),
                    ),
                    textColor: dfColor,
                    dense: true,
                  ),
                  Divider(
                    color: greyColor,
                    thickness: 0,
                  ),
                  Text(
                    "Bills",
                    style: TextStyle(
                        color: drakGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  //Pending task

                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewPayBill()));
                    },
                    leading: Image.asset(
                      "asserts/images/12.png",
                      color: dfColor,
                      width: dfIconSize,
                    ),
                    title: const Text(
                      "View Utility Bill",
                      style: TextStyle(
                          fontSize: dfFontSize, fontWeight: FontWeight.w500),
                    ),
                    textColor: dfColor,
                    dense: true,
                  ),
                  Divider(
                    color: greyColor,
                    thickness: 0,
                  ),
                  Text(
                    "Others",
                    style: TextStyle(
                        color: drakGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MosqueTimings()));
                    },
                    leading: Image.asset(
                      "asserts/images/09.png",
                      color: dfColor,
                      width: dfIconSize,
                    ),
                    title: const Text(
                      "Masjid Timings",
                      style: TextStyle(
                          fontSize: dfFontSize, fontWeight: FontWeight.w500),
                    ),
                    textColor: dfColor,
                    dense: true,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Announcements()));
                    },
                    leading: Image.asset(
                      "asserts/images/10.png",
                      color: dfColor,
                      width: dfIconSize,
                    ),
                    title: const Text(
                      "Announcements",
                      style: TextStyle(
                          fontSize: dfFontSize, fontWeight: FontWeight.w500),
                    ),
                    textColor: dfColor,
                    dense: true,
                  ),
                  ListTile(
                    onTap: () {
                      if (Platform.isAndroid) {
                        //_launchURLBrowser();
                        _launchURLBrowser1();
                      } else if (Platform.isIOS) {
                        _launchURLBrowser();
                      }
                    },
                    leading: Image.asset(
                      "asserts/images/domain.png",
                      color: dfColor,
                      width: dfIconSize,
                    ),
                    title: const Text(
                      "Visit Website",
                      style: TextStyle(
                          fontSize: dfFontSize, fontWeight: FontWeight.w500),
                    ),
                    textColor: dfColor,
                    dense: true,
                  ),

                  Divider(
                    color: greyColor,
                    thickness: 0,
                  ),

                  Text(
                    "Settings",
                    style: TextStyle(
                        color: drakGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  ListTile(
                    onTap: () {
                      _showCustomDialog(context, "Update Your Home Location",
                          "This location should be your Home's location. Please use this feature when you are present at your home to help get the most accurate data. This location will be utilized when you use the SOS feature; This will allow DHA to help generate an accurate and fast response to resolve your issue.");
                    },
                    leading: Icon(
                      Icons.location_on,
                      color: dfColor,
                    ),
                    title: const Text(
                      "Update Location",
                      style: TextStyle(
                          fontSize: dfFontSize, fontWeight: FontWeight.w500),
                    ),
                    textColor: dfColor,
                    dense: true,
                  ),

                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePassword()));
                    },
                    leading: Image.asset(
                      "asserts/images/13.png",
                      color: dfColor,
                      width: dfIconSize,
                    ),
                    title: const Text(
                      "Change Password",
                      style: TextStyle(
                          fontSize: dfFontSize, fontWeight: FontWeight.w500),
                    ),
                    textColor: dfColor,
                    dense: true,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeleteAccount()));
                    },
                    leading: Icon(
                      Icons.delete_outline_outlined,
                      color: dfColor,
                    ),
                    title: const Text(
                      "Delete Account",
                      style: TextStyle(
                          fontSize: dfFontSize, fontWeight: FontWeight.w500),
                    ),
                    textColor: dfColor,
                    dense: true,
                  ),

                  Divider(
                    color: greyColor,
                    thickness: 0,
                  ),
                  Text(
                    "Logout",
                    style: TextStyle(
                        color: drakGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  ListTile(
                    onTap: () async {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.noHeader,
                        animType: AnimType.bottomSlide,
                        title: 'Logout',
                        desc: 'Are you sure you want to logout?',
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
                            //  await

                            await logout();

                            final route = MaterialPageRoute(
                                builder: (context) => LogIn());

                            Navigator.pushAndRemoveUntil(
                                context, route, (route) => false);
                          },
                          icon: Image.asset(
                            'asserts/icons/checked.png',
                            width: 40,
                          ),
                          color: Colors.green,
                        ),
                      ).show();
                    },
                    leading: const Icon(
                      Icons.logout,
                      size: dfIconSize,
                      color: greyColor,
                    ),
                    title: const Text(
                      "Logout",
                      style: TextStyle(
                          fontSize: dfFontSize, fontWeight: FontWeight.w700),
                    ),
                    textColor: dfColor,
                    dense: true,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
