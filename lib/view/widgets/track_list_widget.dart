import 'dart:convert';

import 'package:dha_resident_app/view/widgets/complaint_detail_widget.dart';
import 'package:dha_resident_app/view_model/utils/custom_date_format.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;
import '../../constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TrackListWidget extends StatefulWidget {
  final String userId;
  final String trackDay;
  final String trackTime;
  final String trackRefNo;
  final String trackComplainStatus;
  final String category;
  final String subCategory;
  final String complaintUser;
  final String mobileNo;
  final String phNo;
  final Color colorComplait;
  final String feedback;
  final fetchComplaintListDetailModel;

  const TrackListWidget({
    required this.userId,
    required this.trackRefNo,
    required this.trackDay,
    required this.trackTime,
    required this.trackComplainStatus,
    required this.category,
    required this.subCategory,
    required this.colorComplait,
    required this.complaintUser,
    required this.mobileNo,
    required this.phNo,
    required this.feedback,
    required this.fetchComplaintListDetailModel,
  });

  @override
  State<TrackListWidget> createState() => _TrackListWidgetState();
}

class _TrackListWidgetState extends State<TrackListWidget> {
  @override
  Widget build(BuildContext context) {
    String complaintStatus = "Re-open";
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    String comment = '';
    String trackDate = '';
    TextEditingController comntController = TextEditingController();
    // DateTime time = new DateTime.now();
    // DateTime now = DateTime.now(); // 30/09/2021 15:54:30
    // DateTime date = new DateTime(time.year, time.month, time.day);
    // final String currentTime = now.toString();

    ////

    ////////////  This Function Shows this Date Format 2023-18-09 17:27:49

    DateTime parseCustomDate(String dateStr) {
      List<String> dateTimeParts = dateStr.split(' ');

      List<String> dateParts = dateTimeParts[0].split('-');
      int year = int.parse(dateParts[0]); // year
      int day = int.parse(dateParts[1]); // day
      int month = int.parse(dateParts[2]); // month

      List<String> timeParts = dateTimeParts[1].split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      int second = int.parse(timeParts[2]);

      DateTime dateTime = DateTime(year, month, day);

      print(year);
      print(month);
      print(day);
      print(hour);
      print(minute);
      print(second);

      return dateTime;
    }

    DateTime dateTimeF = parseCustomDate(widget.trackTime);

    String dateFormat = DateFormat('E').format(dateTimeF);

    print("Final: " + dateFormat);

    try {
      DateTime originalDateTime = DateTime.parse(widget.trackTime);

      // Step 2: Format the DateTime object into a string with the desired format
      trackDate = DateFormat('dd-MM-yyyy hh:mm:ss')
          .format(CustomDateFormat().parseCustomDate(widget.trackTime));
    } catch (e) {
      print("SOS Date Format $e");
    }

//////
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

    ///------Reopening Complaint---------///

    Future<void> ReopenComplaint(String uid, String comment) async {
      // Define the API endpoint
      final apiUrl = 'http://110.93.244.74/api/complaint/complaint_reopen';

      // Retrieve the authentication token from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token');
      final Map<String, dynamic> data = {
        'uid': uid,
        'comment': comment,
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
          print('Response Message: $message');
        } else {
          print('Request failed with status: ${response.statusCode}');
          print('Error message: ${response.body}');
        }
      } catch (error) {
        print('Error: $error');
      }
    }

////-------------///
    ///Custom Dialog
    _showCustomDialog(String uid, context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.all(0),
            title: Container(
              decoration: BoxDecoration(
                  color: appcolor,
                  image: DecorationImage(
                      opacity: 0.2,
                      alignment: Alignment.bottomCenter,
                      image: AssetImage(
                        "asserts/images/building.png",
                      ))),
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'asserts/icons/icon.png',
                    width: scWidth / 7,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'DHA',
                            style: TextStyle(
                                color: dfColor,
                                fontSize: dfFontSize,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' Islamabad',
                            style:
                                TextStyle(color: dfColor, fontSize: dfFontSize),
                          ),
                        ],
                      ),
                      Text(
                        'Defence Housing Authority',
                        style:
                            TextStyle(color: dfColor, fontSize: exSmFontSize),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            content: Container(
              height: scHeight / 2.9,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child: Image.asset(
                        "asserts/images/reopen.jpg",
                        width: scWidth / 2,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        '⦿ Write a reason to re-open complaint',
                        style: TextStyle(
                            color: appcolor,
                            fontWeight: FontWeight.w500,
                            fontSize: exSmFontSize),
                      ),
                    ),
                    TextFormField(
                      controller: comntController,
                      textInputAction: TextInputAction.next,
                      autofocus: false,
                      minLines: 1,
                      maxLength: 500,
                      maxLines: 5,
                      style: TextStyle(fontSize: 19.0, color: blackColor),
                      decoration: InputDecoration(
                        hintText: "Please write your reason here...",
                        hintStyle: TextStyle(color: blackColor, fontSize: 12),
                        filled: true,
                        fillColor: greyColor,
                        contentPadding: const EdgeInsets.only(
                            left: 16.0, bottom: 30.0, top: 30.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please write your reason';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        comment = comntController.text;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actionsPadding: EdgeInsets.all(0),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        gradient: lgBlue,
                        borderRadius: BorderRadius.circular(roundBtn)),
                    width: scWidth / 3,
                    child: ElevatedButton(
                      onPressed: () {
                        if (comntController.text == '') {
                          funToast("Please State Your Reason First!", appcolor);
                        } else {
                          print(uid);
                          print(comment);
                          ReopenComplaint(uid, comment).then((_) {
                            comntController.text = '';
                            setState(() {
                              // Update the state after the operation is completed
                              widget.fetchComplaintListDetailModel;
                            });
                          });

                          Navigator.of(context).pop(); // Close the dialog
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            color: btnTextColor, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(roundBtn),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Image.asset(
                        "asserts/images/building.png",
                        color: Colors.grey.shade300,
                      )),
                ],
              ),
            ],
          );
        },
      );
    }

    ////////////

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.all(0),
          backgroundColor: Colors.transparent),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CompalintDetailWidget(
                      userId: widget.userId,
                    )));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Card(
            elevation: 2,
            color: widget.colorComplait,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(roundBtn)),
            child: Container(
              // margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(roundBtn)),
                  border: Border.all(width: 1.5, color: drakGreyColor)),
              padding: EdgeInsets.symmetric(vertical: scHeight / 24.5),
              width: Platform.isAndroid ? scWidth / 4.3 : scWidth / 3.9,
              child: Container(
                width: scWidth,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        dateFormat.toUpperCase(),
                        // dateTime.day.toString(),
                        style: TextStyle(
                          fontSize: scWidth / 17,
                          fontWeight: FontWeight.bold,
                          color:
                              complaintStatus.isNotEmpty ? dfColor : appcolor,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        color: complaintStatus.isNotEmpty ? dfColor : appcolor,
                        thickness: 1,
                      ),
                    ),
                    Container(
                      // alignment: Alignment.center,
                      child: Text(
                        trackDate,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: complaintStatus.isNotEmpty
                                ? dfColor
                                : appcolor),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(roundBtn)),
            child: Container(
              // margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(roundBtn)),
                  border: Border.all(width: 1.5, color: drakGreyColor)),
              padding:
                  EdgeInsets.symmetric(vertical: scHeight / 60, horizontal: 12),
              // width: scWidth / 1.55,
              child: Row(
                children: [
                  Column(
                    children: [
                      widget.feedback == ""
                          ? widget.trackComplainStatus == 'Resolved'
                              ? ElevatedButton(
                                  onPressed: () {
                                    funToast(
                                        "Looking forward to your Feedback !",
                                        appcolor);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.only(bottom: 5),
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    minimumSize: Size(0, 0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: scWidth / 28,
                                  ))
                              : Container()
                          : Container(),
                      Container(
                        color: blackColor, //color of divider
                        width: 2,
                        padding: EdgeInsets.symmetric(vertical: 18),
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
                        padding: EdgeInsets.symmetric(vertical: 18),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: scWidth / 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: scWidth / 2,
                          child: Text(
                            textAlign: TextAlign.start,
                            "Ref#: " + widget.trackRefNo,
                            style: TextStyle(
                              fontSize: dfFontSize,
                              fontWeight: FontWeight.w600,
                              color: appcolor,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              textAlign: TextAlign.start,
                              "Status: ",
                              style: TextStyle(
                                fontSize: dfFontSize,
                                fontWeight: FontWeight.w400,
                                color: appcolor,
                              ),
                            ),
                            Text(
                              textAlign: TextAlign.start,
                              widget.trackComplainStatus,
                              style: TextStyle(
                                fontSize: dfFontSize,
                                fontWeight: FontWeight.w600,
                                color: widget.colorComplait,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                        ),
                        Container(
                          width: scWidth / 2,
                          child: Text(
                            textAlign: TextAlign.start,
                            "Category: " + widget.category,
                            style: TextStyle(
                              fontSize: exSmFontSize,
                              fontWeight: FontWeight.w400,
                              color: appcolor,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          width: scWidth / 2,
                          child: Text(
                            "Sub Cate: " + widget.subCategory,
                            style: TextStyle(
                              fontSize: exSmFontSize,
                              fontWeight: FontWeight.w400,
                              color: appcolor,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        (widget.trackComplainStatus == 'Resolved') ||
                                (widget.trackComplainStatus == 'Closed')
                            ? Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 5),
                                // padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    gradient: lgBlue,
                                    borderRadius: BorderRadius.circular(5)),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showCustomDialog(widget.userId, context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      padding: EdgeInsets.all(4),
                                      minimumSize: Size(0, 0),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      elevation: 0),
                                  child: Text(
                                    "Re-Open Complaint",
                                    style: TextStyle(color: dfColor),
                                  ),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.symmetric(vertical: 12.5),
                              ),
                        // trackComplainStatus != 'Submitted'
                        //     ? Container(
                        //         child: ElevatedButton(
                        //             onPressed: () {},
                        //             child: Text(
                        //               "Re-Open Complaint",
                        //               style: TextStyle(color: dfColor),
                        //             )),
                        //       )
                        //     : Container()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
