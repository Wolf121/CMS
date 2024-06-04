import 'dart:convert';
import 'package:dha_resident_app/view/screens/dashboard/bottomNavBar.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dha_resident_app/model/shared_pref_session.dart/share_preferences_session.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';

class PetListWidget extends StatefulWidget {
  final String uid;
  final String petImage;
  final String petName;
  final String petStatus;
  final String petGender;
  final String petVaccinDob;
  final String petType;
  final String petDescp;
  final int petRequestDelete;
  // final functionPet;

  const PetListWidget({
    required this.petImage,
    required this.petName,
    required this.petVaccinDob,
    required this.petStatus,
    required this.petType,
    required this.petDescp,
    required this.petGender,
    required this.uid,
    required this.petRequestDelete,
    // required this.functionPet,
  });

  @override
  State<PetListWidget> createState() => _PetListWidgetState();
}

class _PetListWidgetState extends State<PetListWidget> {
  int user_id = 0;

  @override
  void initState() {
    super.initState();

    loadSessionData();
    // refresh();
  }

  Future refresh() async {
    setState(() {
      // widget.functionPet();
    });
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
    final apiUrl = 'http://110.93.244.74/api/pet/deleteRequest';

    // Retrieve the authentication token from shared preferences
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('token');
    final Map<String, dynamic> data = {
      'uid': widget.uid.toString(),
      'remarks': "I want to remove.",
      'request_by': user_id.toString(),
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
    // DateTime time = new DateTime.now();
    // DateTime now = DateTime.now(); // 30/09/2021 15:54:30
    // DateTime date = new DateTime(time.year, time.month, time.day);
    // final String currentTime = now.toString();

    String petDate = "";

    try {
      DateTime originalDateTime = DateTime.parse(widget.petVaccinDob);

      // Step 2: Format the DateTime object into a string with the desired format
      petDate = DateFormat('dd-MM-yyyy').format(originalDateTime);
    } catch (e) {
      print("pet Date Format $e");
    }

    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Column(
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(roundBtn)),
            child: Container(
              // margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(roundBtn)),
                border: Border.all(width: 1.5, color: drakGreyColor),
              ),
              padding: EdgeInsets.only(
                  top: scHeight / 20,
                  bottom: scHeight / 60,
                  left: 40,
                  right: 40),
              width: scWidth,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -70,
                    // left: scWidth / ,
                    child: CircleAvatar(
                      backgroundColor: redAlert,
                      radius: 28.0,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: InstaImageViewer(
                            child: Image.network(
                              widget.petImage,
                              fit: BoxFit.cover,
                              height: scHeight,
                              width: scWidth,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.pets,
                                  size: 40,
                                  color: appcolor,
                                );
                              },
                            ),
                          )),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                color: blackColor, //color of divider
                                width: 2,
                                padding: EdgeInsets.symmetric(vertical: 25),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                padding: EdgeInsets.zero,
                                height: 8,
                                width: 8,
                                // or ClipRRect if you need to clip the content
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green, // inner circle color
                                ),
                              ),
                              Container(
                                color: blackColor, //color of divider
                                width: 2,
                                padding: EdgeInsets.symmetric(vertical: 25),
                              ),
                            ],
                          ),
                          Container(
                            height: scHeight / 7,
                            margin: EdgeInsets.only(left: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      textAlign: TextAlign.start,
                                      "Name:",
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
                                      "Gender:",
                                      style: TextStyle(
                                        fontSize: exSmFontSize,
                                        fontWeight: FontWeight.w500,
                                        color: appcolor,
                                      ),
                                    ),
                                    Text(
                                      textAlign: TextAlign.start,
                                      "Vaccination Date:",
                                      style: TextStyle(
                                        fontSize: exSmFontSize,
                                        fontWeight: FontWeight.w500,
                                        color: appcolor,
                                      ),
                                    ),
                                    Text(
                                      textAlign: TextAlign.start,
                                      "Type:",
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
                                  ],
                                ),
                                Container(
                                  width: scWidth / 3,
                                  // margin: EdgeInsets.only(left: scWidth / 7),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        textAlign: TextAlign.start,
                                        widget.petName,
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
                                        widget.petStatus,
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
                                        widget.petGender,
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
                                        petDate,
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
                                        widget.petType,
                                        style: TextStyle(
                                          fontSize: exSmFontSize,
                                          fontWeight: FontWeight.w600,
                                          color: appcolor,
                                        ),
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        textAlign: TextAlign.start,
                                        widget.petDescp,
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
                          )
                        ],
                      ),
                      if (widget.petRequestDelete ==
                          0) //if staff is 0 the delete btn show
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: GestureDetector(
                            onTap: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.noHeader,
                                animType: AnimType.bottomSlide,
                                title: 'Remove Pet',
                                desc:
                                    'Do you really want to remove "${widget.petName}" from your pet(s)?',
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
                                fontWeight: FontWeight.bold,
                                color: lightappcolor),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
