import 'dart:convert';
import 'package:dha_resident_app/view/widgets/color_widget.dart';
import 'package:http/http.dart' as http;
import 'package:dha_resident_app/constant.dart';
import 'package:dha_resident_app/view/widgets/custom_app_bar.dart';
import 'package:dha_resident_app/view_model/sos_history/sos_history_model.dart';
import 'package:dha_resident_app/view_model/utils/custom_date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SOSHistoryList extends StatefulWidget {
  final String userRef;
  final String sosStatus;
  final String sosTime;
  final String sosComment;
  final int index;
  const SOSHistoryList({
    super.key,
    required this.userRef,
    required this.sosStatus,
    required this.sosTime,
    required this.sosComment,
    required this.index,
  });

  @override
  State<SOSHistoryList> createState() => _SOSHistoryListState();
}

class _SOSHistoryListState extends State<SOSHistoryList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSosListModel();
  }

  // getting data from api
  Future<SosListModel> fetchSosListModel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    print("Token :${token}");

    if (token.isEmpty) {
      print("No Token found");
    }
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(
        Uri.parse('http://110.93.244.74/api/sos/sos_list'),
        headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      // final complaintArray = responseData['data_array'] as List<dynamic>;

      // setState(() {
      //   complaintStat = complaintArray.cast<Map<String, dynamic>>();
      // });
      return SosListModel.fromJson(responseData);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    String sosDate = "";

    try {
      DateTime originalDateTime = DateTime.parse(widget.sosTime);

      // Step 2: Format the DateTime object into a string with the desired format
      sosDate = DateFormat('dd-MM-yyyy hh:mm a')
          .format(CustomDateFormat().parseCustomDate(widget.sosTime));
    } catch (e) {
      print("SOS Date Format $e");
    }

    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: greyColor,
      appBar: CustomAppBar(),
      body: Container(
        color: greyColor,
        // margin: EdgeInsets.symmetric(horizontal: marginLR),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  width: scWidth,
                  // padding: EdgeInsets.symmetric(vertical: 5),
                  child: Stack(
                    children: [
                      Image.asset(
                        "asserts/images/dhaoffice.jpg",
                        width: scWidth,
                        // height: scHeight / 3,
                      ),
                      Positioned(
                          bottom: marginLR,
                          left: marginLR,
                          child: Text(
                            widget.userRef,
                            style: TextStyle(
                                color: dfColor,
                                fontSize: exLgFontSize,
                                fontWeight: FontWeight.w700),
                          )),
                    ],
                  )),
              FutureBuilder<SosListModel>(
                  future: fetchSosListModel(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        alignment: Alignment.center,
                        height: scHeight / 1.5,
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Container(
                          margin: EdgeInsets.symmetric(horizontal: marginLR),
                          alignment: Alignment.center,
                          height: scHeight / 1.5,
                          child: Text(
                            'Couldn\'t Fetch The SOS History At This Moment.\nPlease Try Again Later!',
                            style: TextStyle(
                              fontSize: dfFontSize,
                            ),
                          ));
                    } else {
                      int i = 0;
                      final sosListData = snapshot.data;

                      for (int j = 0;
                          j <
                              sosListData!
                                  .dataArray[widget.index].actions.length;
                          j++) {
                        i = j;

                        print(
                            "print index in Action: ${sosListData.dataArray[widget.index].actions[i].createdAt}");
                        print("print index in Action: $i");
                      }

                      return ActionList(
                        statusName: widget.sosStatus,
                        createdDate: sosDate,
                        commment: widget.sosComment,
                        firstIndex: widget.index,
                        secondIndex: i,
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionList extends StatefulWidget {
  const ActionList({
    super.key,
    required this.statusName,
    required this.createdDate,
    required this.commment,
    required this.firstIndex,
    required this.secondIndex,
  });

  final String statusName;
  final String createdDate;
  final String commment;
  final int firstIndex;
  final int secondIndex;

  @override
  State<ActionList> createState() => _ActionListState();
}

class _ActionListState extends State<ActionList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSosListModel();
  }

  // getting data from api
  Future<SosListModel> fetchSosListModel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    print("Token :${token}");

    if (token.isEmpty) {
      print("No Token found");
    }
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(
        Uri.parse('http://110.93.244.74/api/sos/sos_list'),
        headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      // final complaintArray = responseData['data_array'] as List<dynamic>;

      // setState(() {
      //   complaintStat = complaintArray.cast<Map<String, dynamic>>();
      // });
      return SosListModel.fromJson(responseData);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    return FutureBuilder<SosListModel>(
        future: fetchSosListModel(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              alignment: Alignment.center,
              height: scHeight / 1.5,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Container(
                margin: EdgeInsets.symmetric(horizontal: marginLR),
                alignment: Alignment.center,
                height: scHeight / 1.5,
                child: Text(
                  'Couldn\'t Fetch The SOS History At This Moment.\nPlease Try Again Later!',
                  style: TextStyle(
                    fontSize: dfFontSize,
                  ),
                ));
          } else {
            int i = 0;
            final sosListData = snapshot.data;

            for (int j = 0;
                j <
                    sosListData!.dataArray[widget.firstIndex]
                        .actions[widget.secondIndex].comments.length;
                j++) {
              i = j;
              print(
                  "print index in Comments: ${sosListData.dataArray[widget.firstIndex].actions[widget.secondIndex].comments[i].comment}}");
              print("print index in Comments: $i");
            }

            String sosDate = "";

            try {
              DateTime originalDateTime = DateTime.parse(sosListData
                  .dataArray[widget.firstIndex]
                  .actions[widget.secondIndex]
                  .createdAt);

              // Step 2: Format the DateTime object into a string with the desired format

              sosDate =
                  DateFormat('dd-MM-yyyy hh:mm:ss').format(originalDateTime);

              print("date format SOS : $sosDate");
            } catch (e) {
              print("SOS Date Format $e");
            }

            return Container(
              margin: EdgeInsets.only(
                  top: marginLR,
                  bottom: marginLR,
                  left: marginLR + marginLR,
                  right: marginLR),
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 1),
                        padding: EdgeInsets.zero,
                        height: 10,
                        width: 10,
                        // or ClipRRect if you need to clip the content
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: appcolor, // inner circle color
                        ),
                      ),
                      Container(
                        color: appcolor, //color of divider
                        width: 1,
                        padding: EdgeInsets.symmetric(vertical: 18),
                      ),
                    ],
                  ),
                  Container(
                    // color: Colors.amber,
                    width: scWidth / 1.19,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                widget.statusName,
                                style: TextStyle(
                                    color: dfColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: HexColor.fromHex(sosListData
                                      .dataArray[widget.firstIndex].color),
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            Container(
                              child: Text(
                                widget.secondIndex == 0
                                    ? widget.createdDate
                                    : sosDate,
                              ),
                            )
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Divider(
                              height: marginLR,
                              color: appcolor,
                            )),
                        Container(
                          margin: EdgeInsets.only(left: marginLR),
                          child: Row(children: [
                            Icon(
                              Icons.subdirectory_arrow_right_outlined,
                              color: appcolor,
                            ),
                            Text(
                              widget.secondIndex == 0
                                  ? "No Comments"
                                  : sosListData
                                      .dataArray[widget.firstIndex]
                                      .actions[widget.secondIndex]
                                      .comments[i]
                                      .comment,
                              style: TextStyle(
                                  fontSize: dfFontSize,
                                  fontWeight: FontWeight.w500),
                            )
                          ]),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        });
  }
}
