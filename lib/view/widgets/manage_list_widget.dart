import 'dart:convert';
import 'package:dha_resident_app/model/shared_pref_session.dart/share_preferences_session.dart';
import 'package:dha_resident_app/view/screens/dashboard/bottomNavBar.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';

class ManageListWidget extends StatefulWidget {
  final String staffuid;
  final String staffImage;
  final String staffFCnicImg;
  final String staffBCnicImg;
  final String staffName;
  final String staffFatherName;
  final String staffStatus;
  final String staffCnic;
  final String staffDob;
  final String staffGender;
  final String staffShift;
  final String staffDescp;
  final String staffmobile;
  final String staffLandline;
  final String staffPosition;
  final int staffRequestDelete;

  bool Loading;
  ManageListWidget({
    required this.staffuid,
    required this.staffImage,
    required this.staffFCnicImg,
    required this.staffBCnicImg,
    required this.staffName,
    required this.staffFatherName,
    required this.staffStatus,
    required this.staffCnic,
    required this.staffDob,
    required this.staffGender,
    required this.staffShift,
    required this.staffDescp,
    required this.staffmobile,
    required this.staffLandline,
    required this.staffPosition,
    required this.staffRequestDelete,
    required this.Loading,
  });

  @override
  State<ManageListWidget> createState() => _ManageListWidgetState();
}

class _ManageListWidgetState extends State<ManageListWidget> {
  int user_id = 0;

  @override
  void initState() {
    super.initState();
    loadSessionData();
  }

  Future<void> loadSessionData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getInt('user_id') ?? 0;
    });
  }

  //
  Future<void> RequestToDelete() async {
    // Define the API endpoint
    final apiUrl = 'http://110.93.244.74/api/staff/deleteRequest';

    // Retrieve the authentication token from shared preferences
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('token');
    final Map<String, dynamic> data = {
      'uid': widget.staffuid.toString(),
      'remarks': "I want to remove.",
      'request_by': user_id.toString()
    };
    final jsonData = jsonEncode(data);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final message = responseData['message'];
        funToast(message, Colors.green);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavBar(),
          ),
          (route) => false,
        );
        print('Response Message: $message');
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;

    String staffDate = "";

    try {
      DateTime originalDateTime = DateTime.parse(widget.staffDob);

      // Step 2: Format the DateTime object into a string with the desired format
      staffDate = DateFormat('dd-MM-yyyy').format(originalDateTime);
    } catch (e) {
      print("pet Date Format $e");
    }

    _showCustomDialog() {
      showGeneralDialog(
        context: context,
        pageBuilder: (ctx, a1, a2) {
          return Container();
        },
        transitionBuilder: (ctx, a1, a2, child) {
          var curve = Curves.easeInOut.transform(a1.value);
          return Transform.scale(
            scale: curve,
            child: AlertDialog(
              titlePadding: EdgeInsets.all(0),
              title: Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    color: appcolor,
                    image: DecorationImage(
                        opacity: 0.2,
                        alignment: Alignment.bottomCenter,
                        image: AssetImage(
                          "asserts/images/building.png",
                        ))),
                padding: EdgeInsets.all(5),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                ),
              ),
              content: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 5, bottom: 10),
                        width: scWidth / 3.5,
                        height: scHeight / 12,
                        child: InstaImageViewer(
                          child: Image.network(
                            widget.staffFCnicImg,
                            // fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                  'asserts/images/cnicfornt.png');
                            },
                          ),
                        ),
                      ),
                      Text(
                        "Front CNIC",
                        style: TextStyle(
                            color: appcolor,
                            fontSize: exSmFontSize,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5, bottom: 10),
                        width: scWidth / 3.5,
                        height: scHeight / 12,
                        child: InstaImageViewer(
                          child: Image.network(
                            // fit: BoxFit.cover,
                            widget.staffBCnicImg,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset('asserts/images/cnicback.png');
                            },
                          ),
                        ),
                      ),
                      Text(
                        "Back CNIC",
                        style: TextStyle(
                            color: appcolor,
                            fontSize: exSmFontSize,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
              actionsPadding: EdgeInsets.all(0),
              actionsAlignment: MainAxisAlignment.center,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      );
    }

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(roundBtn)),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(roundBtn)),
                  border: Border.all(width: 1.5, color: drakGreyColor)),
              padding:
                  EdgeInsets.symmetric(vertical: scHeight / 60, horizontal: 13),
              width: scWidth,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: scWidth / 3.8,
                            height: scHeight / 9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: dfColor,
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: InstaImageViewer(
                                  child: Image.network(
                                    widget.staffImage,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return widget.staffGender == 'Male'
                                          ? Icon(
                                              Icons.person,
                                              size: 90,
                                              color: appcolor,
                                            )
                                          : Icon(
                                              Icons.person_2,
                                              size: 90,
                                              color: appcolor,
                                            );
                                    },
                                  ),
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              widget.staffName,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: appcolor,
                              ),
                            ),
                          ),
                          Material(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(roundBtn)),
                            child: Container(
                              alignment: Alignment.center,
                              width: scWidth / 3.1,
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(roundBtn)),
                                  border: Border.all(
                                      width: 1.5, color: drakGreyColor)),
                              child: Text(
                                widget.staffPosition,
                                style: TextStyle(color: appcolor),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _showCustomDialog();
                            },
                            child: Icon(
                              Icons.more_horiz,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: scHeight / 4.5,
                        margin: EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  textAlign: TextAlign.start,
                                  "Father:",
                                  style: TextStyle(
                                    fontSize: exSmFontSize,
                                    fontWeight: FontWeight.w500,
                                    color: appcolor,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  textAlign: TextAlign.start,
                                  "Status:",
                                  style: TextStyle(
                                    fontSize: exSmFontSize,
                                    fontWeight: FontWeight.w500,
                                    color: appcolor,
                                  ),
                                ),
                                Text(
                                  textAlign: TextAlign.start,
                                  "CNIC:",
                                  style: TextStyle(
                                    fontSize: exSmFontSize,
                                    fontWeight: FontWeight.w500,
                                    color: appcolor,
                                  ),
                                ),
                                Text(
                                  textAlign: TextAlign.start,
                                  "D-O-B:",
                                  style: TextStyle(
                                    fontSize: exSmFontSize,
                                    fontWeight: FontWeight.w500,
                                    color: appcolor,
                                  ),
                                ),
                                Text(
                                  textAlign: TextAlign.start,
                                  "Gender:",
                                  style: TextStyle(
                                    fontSize: exSmFontSize,
                                    fontWeight: FontWeight.w500,
                                    color: appcolor,
                                  ),
                                ),
                                Text(
                                  textAlign: TextAlign.start,
                                  "Shift:",
                                  style: TextStyle(
                                    fontSize: exSmFontSize,
                                    fontWeight: FontWeight.w500,
                                    color: appcolor,
                                  ),
                                ),
                                Text(
                                  textAlign: TextAlign.start,
                                  "Descp:",
                                  style: TextStyle(
                                    fontSize: exSmFontSize,
                                    fontWeight: FontWeight.w500,
                                    color: appcolor,
                                  ),
                                ),
                                Text(
                                  textAlign: TextAlign.start,
                                  "Mobile:",
                                  style: TextStyle(
                                    fontSize: exSmFontSize,
                                    fontWeight: FontWeight.w500,
                                    color: appcolor,
                                  ),
                                ),
                                Text(
                                  "Landline:",
                                  style: TextStyle(
                                    fontSize: exSmFontSize,
                                    fontWeight: FontWeight.w500,
                                    color: appcolor,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            Container(
                              width: scWidth / 3.5,
                              margin: EdgeInsets.only(left: scWidth / 30),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    textAlign: TextAlign.start,
                                    widget.staffFatherName,
                                    style: TextStyle(
                                      fontSize: exSmFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: appcolor,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    textAlign: TextAlign.start,
                                    widget.staffStatus,
                                    style: TextStyle(
                                      fontSize: exSmFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: appcolor,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    textAlign: TextAlign.start,
                                    widget.staffCnic,
                                    style: TextStyle(
                                      fontSize: exSmFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: appcolor,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    textAlign: TextAlign.start,
                                    staffDate,
                                    style: TextStyle(
                                      fontSize: exSmFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: appcolor,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    textAlign: TextAlign.start,
                                    widget.staffGender,
                                    style: TextStyle(
                                      fontSize: exSmFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: appcolor,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    textAlign: TextAlign.start,
                                    widget.staffShift,
                                    style: TextStyle(
                                      fontSize: exSmFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: appcolor,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    textAlign: TextAlign.start,
                                    widget.staffDescp,
                                    style: TextStyle(
                                      fontSize: exSmFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: appcolor,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    textAlign: TextAlign.start,
                                    widget.staffmobile,
                                    style: TextStyle(
                                      fontSize: exSmFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: appcolor,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    widget.staffLandline,
                                    style: TextStyle(
                                      fontSize: exSmFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: appcolor,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (widget.staffRequestDelete ==
                      0) //if staff is 0 the delete btn show
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        onTap: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.noHeader,
                            animType: AnimType.bottomSlide,
                            title: 'Remove Staff',
                            desc:
                                'Do you really want to remove "${widget.staffName}" from your staff(s)?',
                            btnCancel: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: appcolor),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: dfColor),
                              ),
                            ),
                            btnOk: ElevatedButton(
                              onPressed: () async {
                                RequestToDelete();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: Text(
                                "Remove",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: dfColor),
                              ),
                            ),
                          ).show();
                        },
                        child: Container(
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 14,
                            child: Icon(
                              Icons.delete,
                              color: dfColor,
                              size: scWidth / 20,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        "Removal Inprogress",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: lightappcolor),
                      ),
                    )
                ],
              ),
            ),
          ),

          // verification btn
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 5),
          //   decoration: BoxDecoration(
          //       gradient: lgBlue,
          //       borderRadius: BorderRadius.circular(roundBtn)),
          //   width: scWidth,
          //   child: ElevatedButton(
          //     onPressed: () {},
          //     child: Text(
          //       'Remove',
          //       style: TextStyle(color: btnTextColor),
          //     ),
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.transparent,
          //       padding: EdgeInsets.symmetric(vertical: 12),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(roundBtn),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
