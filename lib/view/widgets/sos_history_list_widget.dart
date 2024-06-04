import 'dart:io';

import 'package:dha_resident_app/view/widgets/sos_history_list.dart';
import 'package:dha_resident_app/view_model/utils/custom_date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constant.dart';

class SosListWidget1 extends StatelessWidget {
  final String sosDay;
  final String sosRefNo;
  final String sosComplainStatus;
  final String sosType;
  final String sosCreatedTime;
  final Color colorComplait;

  final String sosStatus;
  final String sosComment;
  const SosListWidget1({
    required this.sosRefNo,
    required this.sosDay,
    required this.sosComplainStatus,
    required this.sosType,
    required this.sosCreatedTime,
    required this.colorComplait,
    required this.sosStatus,
    required this.sosComment,
  });
  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;

    String sosDate = "";

    try {
      DateTime originalDateTime = DateTime.parse(sosCreatedTime);

      // Step 2: Format the DateTime object into a string with the desired format
      sosDate = DateFormat('dd-MM-yyyy').format(originalDateTime);
    } catch (e) {
      print("SOS Date Format $e");
    }

    return Container(
      margin: EdgeInsets.only(top: 10, left: marginLR, right: marginLR),
      // padding: EdgeInsets.symmetric(vertical: 5),
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.all(Radius.circular(roundBtn)),
      //     border: Border.all(width: 1.5, color: drakGreyColor)),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SOSHistoryList(
                        userRef: sosRefNo,
                        sosStatus: sosStatus,
                        sosTime: sosCreatedTime,
                        sosComment: sosComment,
                        index: 1,
                      )));
        },
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(0),
            backgroundColor: Colors.transparent,
            elevation: 0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(roundBtn)),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(roundBtn)),
                border: Border.all(width: 1.5, color: drakGreyColor)),
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Column(children: [
              Container(
                alignment: Alignment.center,
                //  padding: EdgeInsets.only(top: 0, bottom: marginLR),
                child: Text(
                  sosDay,
                  style: TextStyle(
                    fontSize: lgFontSize,
                    fontWeight: FontWeight.w400,
                    color: appcolor,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: scWidth / 2.6),
                child: Divider(
                  color: appcolor,
                  thickness: 1,
                ),
              ),
              Container(
                alignment: Alignment.center,
                // padding: EdgeInsets.only(top: marginLR + 45, bottom: marginLR - 5),
                child: Column(
                  children: [
                    Text(
                      "Ref#: " + sosRefNo,
                      style: TextStyle(
                          fontSize: exSmFontSize,
                          fontWeight: FontWeight.w400,
                          color: appcolor),
                    ),
                    Divider(
                      color: drakGreyColor,
                      thickness: 1.5,
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    IntrinsicHeight(
                      child: Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                // margin: EdgeInsets.only(left: 10),
                                // alignment: Alignment.bottomLeft,
                                // height: 40,
                                child: Text(
                                  textAlign: TextAlign.start,
                                  "Type: " + sosType,
                                  style: TextStyle(
                                    fontSize: exSmFontSize,
                                    fontWeight: FontWeight.w400,
                                    color: appcolor,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  "Created At: " + sosDate,
                                  style: TextStyle(
                                    fontSize: exSmFontSize,
                                    fontWeight: FontWeight.w400,
                                    color: appcolor,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      // color: Colors.amber,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            color: appcolor, //color of divider
                            width: 2,
                            height: scHeight / 35, //width space of divider
                            //Spacing at the bottom of divider.
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            height: 5,
                            width: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green, // inner circle color
                            ),
                          ),
                          Container(
                            color: appcolor, //color of divider
                            width: 2, //width space of divider
                            height: scHeight / 35,
                          ),
                        ],
                      ),
                    ),
                    IntrinsicHeight(
                      child: Container(
                        child: Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            alignment: Alignment.bottomLeft,
                            child: Row(
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
                                  sosComplainStatus,
                                  style: TextStyle(
                                    fontSize: dfFontSize,
                                    fontWeight: FontWeight.w400,
                                    color: colorComplait,
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
            ]),
          ),
        ),
      ),
    );
  }
}

class SosListWidget extends StatelessWidget {
  final String sosDay;
  final String sosRefNo;
  final String sosComplainStatus;
  final String sosType;
  final String sosCreatedTime;
  final String sosCreatedAt;
  final Color colorComplait;
  final int index;
  final String sosStatus;
  final String sosComment;
  const SosListWidget({
    required this.sosRefNo,
    required this.sosDay,
    required this.sosComplainStatus,
    required this.sosType,
    required this.sosCreatedTime,
    required this.colorComplait,
    required this.sosStatus,
    required this.sosComment,
    required this.sosCreatedAt,
    required this.index,
  });

  String calculateDayOfWeek(String dateString) {
    try {
      String dateWithNewFormat = dateString.substring(8, 10) +
          '-' +
          dateString.substring(5, 7) +
          '-' +
          dateString.substring(0, 4);
      var inputFormat = DateFormat('dd-MM-yyyy');
      List<String> components = dateWithNewFormat.split('-');
      String newDateString =
          components[1] + '-' + components[0] + '-' + components[2];
      DateTime date1 = inputFormat.parse(newDateString);
      String dateTimeF = DateFormat('E').format(date1);
      print("Actual Day:" + dateTimeF);
      return dateTimeF;
    } catch (e) {
      print("Error parsing date: $e");
      return ''; // Return an empty string or handle error accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;

    String sosDate = "";
    String dateTimeF = "";

    try {
      print(
          "Check Current Date parse: ${CustomDateFormat().parseCustomDate(sosCreatedTime)} ");
      print("Check Current Date: $sosCreatedTime ");
      DateTime originalDateTime = DateTime.parse(sosCreatedTime);

      // Step 2: Format the DateTime object into a string with the desired format
      // sosDate = DateFormat('dd-MM-yyyy').format(originalDateTime);
      sosDate = DateFormat('dd-MM-yyyy hh:mm:ss')
          .format(CustomDateFormat().parseCustomDate(sosCreatedTime));

      // DateTime dateTimeF = parseCustomDate(widget.trackTime);

      dateTimeF = DateFormat('E').format(originalDateTime);

      dateTimeF = calculateDayOfWeek(sosCreatedTime.toString());
    } catch (e) {
      print("SOS Date Format $e");
    }

    return Container(
        margin: EdgeInsets.only(top: 10, left: marginLR, right: marginLR),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: EdgeInsets.all(0),
              backgroundColor: Colors.transparent),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SOSHistoryList(
                  userRef: sosRefNo,
                  sosStatus: sosStatus,
                  sosTime: sosCreatedTime,
                  sosComment: sosComment,
                  index: index,
                ),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                elevation: 2,
                color: colorComplait,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(roundBtn)),
                child: Container(
                  // margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(roundBtn)),
                      border: Border.all(width: 1.5, color: drakGreyColor)),
                  padding: EdgeInsets.symmetric(vertical: scHeight / 28),
                  width: Platform.isAndroid ? scWidth / 4.3 : scWidth / 3.9,
                  child: Container(
                    width: scWidth,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                            dateTimeF.toUpperCase(),
                            // dateTime.day.toString(),
                            style: TextStyle(
                              fontSize: scWidth / 17,
                              fontWeight: FontWeight.bold,
                              color: sosStatus.isNotEmpty ? dfColor : appcolor,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Divider(
                            color: sosStatus.isNotEmpty ? dfColor : appcolor,
                            thickness: 1,
                          ),
                        ),
                        Container(
                          // alignment: Alignment.center,
                          child: Text(
                            sosDate,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color:
                                    sosStatus.isNotEmpty ? dfColor : appcolor),
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
                  padding: EdgeInsets.symmetric(
                      vertical: scHeight / 60, horizontal: 12),
                  // width: scWidth / 1.55,
                  child: Row(
                    children: [
                      Column(
                        children: [
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
                                "Ref#: " + sosRefNo,
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
                                  sosStatus,
                                  style: TextStyle(
                                    fontSize: dfFontSize,
                                    fontWeight: FontWeight.w600,
                                    color: colorComplait,
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
                                "Type: " + sosType,
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
                                textAlign: TextAlign.start,
                                "Created " + sosCreatedAt,
                                style: TextStyle(
                                  fontSize: exSmFontSize,
                                  fontWeight: FontWeight.w400,
                                  color: appcolor,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
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
        ));
  }
}
