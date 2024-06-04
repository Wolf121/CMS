import 'dart:convert';

import 'package:dha_resident_app/view/screens/complaint/track_complaint.dart';
import 'package:dha_resident_app/view/widgets/color_widget.dart';
import 'package:dha_resident_app/view_model/chart_model/chart_model.dart';
import 'package:dha_resident_app/view_model/complaint_state_model/complaint_state_model.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../constant.dart';
import '../../complaint/new_complaint.dart';

class Complaint extends StatefulWidget {
  const Complaint({super.key});

  @override
  State<Complaint> createState() => _ComplaintState();
}

class _ComplaintState extends State<Complaint> {
  bool _isLoading = false;

  List<Map<String, dynamic>> complaintStat = [];

  List<ChartDataArray> fetchChartModel = [];
  List<ChartDataArray> allChartModel = [];

  var submitted;
  var open;
  var inProcess;
  var pending;
  var resolved;
  var closed;
  var reopen;
  var cancel;
  var tedForward;
  var cancelNotAtHome;
  var total;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;

    //
    storeApiData();
    //

    // fetchComplaintStatus();
  }

  Future<void> storeApiData() async {
    await getChartComplaintFromSharedPreferences();
  }

  // Function to retrieve status from SharedPreferences and populate the list
  Future<void> getChartComplaintFromSharedPreferences() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? dashboardChatDataSerialzed =
          prefs.getString('chartComplaitModel');

      if (dashboardChatDataSerialzed != null &&
          dashboardChatDataSerialzed.isNotEmpty) {
        final List<dynamic> dataArray = jsonDecode(dashboardChatDataSerialzed);

        fetchChartModel =
            dataArray.map((json) => ChartDataArray.fromJson(json)).toList();

        // Update the lists if needed

        List<ChartDataArray> updatedDashboardList = [];

        fetchChartModel.forEach((status) {
          updatedDashboardList.add(status);
        });

        setState(() {
          allChartModel = updatedDashboardList; // Update the status list
          print("Total Complaint data: ${allChartModel.length}");
        });
      } else {
        print('No Complaint data found in SharedPreferences.');
      }
    } catch (e) {
      print('Error retrieving Complaint data from SharedPreferences: $e');
    }
  }

  Future<ComplaintStatus> fetchComplaintStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(
        Uri.parse('http://110.93.244.74/api/dashboard/dashboard_list/general'),
        headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      // final complaintArray = responseData['data_array'] as List<dynamic>;

      // setState(() {
      //   complaintStat = complaintArray.cast<Map<String, dynamic>>();
      // });

      return ComplaintStatus.fromJson(responseData);
    } else {
      throw Container(
        margin: EdgeInsets.symmetric(horizontal: marginLR),
        alignment: Alignment.center,
        child: Text(
          'Couldn\'t Fetch The Chart Data At This Moment.\nPlease Try Again Later!',
          style: TextStyle(fontSize: dfFontSize),
        ),
      );
    }
  }

  getComplaintData() {
    for (int i = 0; i < complaintStat.length; i++) {
      final code = complaintStat[i]['code'];
      print(complaintStat[i]['total']);
      switch (code) {
        case 'submitted':
          submitted = code;
          print(submitted);
          break;
        case 'in process':
          inProcess = code;
          print(inProcess);
          break;
        case 'pending':
          pending = code;
          print(pending);
          break;
        case 'resolved':
          resolved = code;
          print(resolved);
          break;
        case 'closed':
          closed = code;
          print(closed);
          break;
        case 'reopen':
          reopen = code;
          print(reopen);
          break;
        case 'cancel':
          cancel = code;
          print(cancel);
          break;
        case 'tes-forwarded':
          tedForward = code;
          print(tedForward);
          break;
        case 'cancel/not at home':
          cancelNotAtHome = code;
          print(cancelNotAtHome);
          break;
        case 'total':
          total = code;
          print(total);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;

    Map<String, double> dataMap = {'Submitted': 0.0};

    var colorList = <Color>[];

    // for (int i = (allChartModel.length - allChartModel.length);
    //     i < allChartModel.length;
    //     i++) {
    //   print('index $i');

    //   if (allChartModel[i].code == 'submitted') {
    //     submitted = allChartModel[i].total.toDouble();
    //     dataMap.addAll({allChartModel[i].name.toString(): submitted});
    //     colorList.add(HexColor.fromHex(allChartModel[i].color.toString()));
    //   } else if (allChartModel[i].code == 'in process') {
    //     inProcess = allChartModel[i].total.toDouble();
    //     dataMap.addAll({allChartModel[i].name.toString(): inProcess});
    //     colorList.add(HexColor.fromHex(allChartModel[i].color.toString()));
    //   } else if (allChartModel[i].code == 'pending') {
    //     pending = allChartModel[i].total.toDouble();
    //     dataMap.addAll({allChartModel[i].name.toString(): pending});
    //     colorList.add(HexColor.fromHex(allChartModel[i].color.toString()));
    //   } else if (allChartModel[i].code == 'resolved') {
    //     resolved = allChartModel[i].total.toDouble();
    //     dataMap.addAll({allChartModel[i].name.toString(): resolved});
    //     colorList.add(HexColor.fromHex(allChartModel[i].color.toString()));
    //   } else if (allChartModel[i].code == 'closed') {
    //     closed = allChartModel[i].total.toDouble();
    //     dataMap.addAll({allChartModel[i].name.toString(): closed});
    //     colorList.add(HexColor.fromHex(allChartModel[i].color.toString()));
    //   } else if (allChartModel[i].code == 'reopen') {
    //     reopen = allChartModel[i].total.toDouble();
    //     dataMap.addAll({allChartModel[i].name.toString(): reopen});
    //     colorList.add(HexColor.fromHex(allChartModel[i].color.toString()));
    //   } else if (allChartModel[i].code == 'cancel') {
    //     cancel = allChartModel[i].total.toDouble();
    //     dataMap.addAll({allChartModel[i].name.toString(): cancel});
    //     colorList.add(HexColor.fromHex(allChartModel[i].color.toString()));
    //   } else if (allChartModel[i].code == 'total') {
    //     total = allChartModel[i].total.toDouble();
    //   }

    //   // };

    //   // colorList = <Color>[
    //   //   if (allChartModel[i].code == 'submitted')
    //   //     HexColor.fromHex(allChartModel[i].color.toString()),
    //   //   if (allChartModel[i].code == 'in process')
    //   //     HexColor.fromHex(allChartModel[i].color.toString()),
    //   //   if (allChartModel[i].code == 'pending')
    //   //     HexColor.fromHex(allChartModel[i].color.toString()),
    //   //   if (allChartModel[i].code == 'resolved')
    //   //     HexColor.fromHex(allChartModel[i].color.toString()),
    //   //   if (allChartModel[i].code == 'closed')
    //   //     HexColor.fromHex(allChartModel[i].color.toString()),
    //   //   if (allChartModel[i].code == 'reopen')
    //   //     HexColor.fromHex(allChartModel[i].color.toString()),
    //   //   if (allChartModel[i].code == 'cancel')
    //   //     HexColor.fromHex(allChartModel[i].color.toString()),
    //   // ];

    //   print('Map Data : ${dataMap}');
    //   print('Color List: ${colorList}');
    //   print('Total: ${total}');
    // }

    // submitted = allChartModel[0].total.toDouble();
    // inProcess = allChartModel[2].total.toDouble();
    // pending = allChartModel[3].total.toDouble();
    // resolved = allChartModel[4].total.toDouble();
    // closed = allChartModel[5].total.toDouble();
    // reopen = allChartModel[6].total.toDouble();
    // cancel = allChartModel[7].total.toDouble();

    // Map<String, double> dataMap = {
    //   allChartModel[0].name.toString(): submitted,
    //   allChartModel[2].name.toString(): inProcess,
    //   allChartModel[3].name.toString(): pending ?? 0,
    //   allChartModel[4].name.toString(): resolved,
    //   allChartModel[5].name.toString(): closed ?? 0,
    //   allChartModel[6].name.toString(): reopen ?? 0,
    //   allChartModel[7].name.toString(): cancel,
    // };

    // var colorList = <Color>[
    //   HexColor.fromHex(allChartModel[0].color.toString()),
    //   HexColor.fromHex(allChartModel[1].color.toString()),
    //   HexColor.fromHex(allChartModel[3].color.toString()),
    //   HexColor.fromHex(allChartModel[4].color.toString()),
    //   HexColor.fromHex(allChartModel[5].color.toString()),
    //   HexColor.fromHex(allChartModel[6].color.toString()),
    //   HexColor.fromHex(allChartModel[7].color.toString()),
    // ];

//////////----------------------------

    // Use allChartModel to display the data in your widget
    return Container(
      margin: EdgeInsets.only(left: marginLR, right: marginLR, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Complaint's Statistics",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w500, color: dfGreyColor),
          ),
          // Text(
          //   "Statistics",
          //   style: TextStyle(
          //       fontSize: 28,
          //       fontWeight: FontWeight.bold,
          //       color: Colors.black45),
          // ),

          ////////////////////////////////pie chart ///////////////////////////////////
          ///
          Expanded(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                //
                if (allChartModel[i].code == 'submitted') {
                  submitted = allChartModel[i].total.toDouble();
                  dataMap.addAll({allChartModel[i].name.toString(): submitted});
                  colorList
                      .add(HexColor.fromHex(allChartModel[i].color.toString()));
                } else if (allChartModel[i].code == 'in process') {
                  inProcess = allChartModel[i].total.toDouble();
                  dataMap.addAll({allChartModel[i].name.toString(): inProcess});
                  colorList
                      .add(HexColor.fromHex(allChartModel[i].color.toString()));
                } else if (allChartModel[i].code == 'pending') {
                  pending = allChartModel[i].total.toDouble();
                  dataMap.addAll({allChartModel[i].name.toString(): pending});
                  colorList
                      .add(HexColor.fromHex(allChartModel[i].color.toString()));
                } else if (allChartModel[i].code == 'resolved') {
                  resolved = allChartModel[i].total.toDouble();
                  dataMap.addAll({allChartModel[i].name.toString(): resolved});
                  colorList
                      .add(HexColor.fromHex(allChartModel[i].color.toString()));
                } else if (allChartModel[i].code == 'closed') {
                  closed = allChartModel[i].total.toDouble();
                  dataMap.addAll({allChartModel[i].name.toString(): closed});
                  colorList
                      .add(HexColor.fromHex(allChartModel[i].color.toString()));
                } else if (allChartModel[i].code == 'reopen') {
                  reopen = allChartModel[i].total.toDouble();
                  dataMap.addAll({allChartModel[i].name.toString(): reopen});
                  colorList
                      .add(HexColor.fromHex(allChartModel[i].color.toString()));
                } else if (allChartModel[i].code == 'cancel') {
                  cancel = allChartModel[i].total.toDouble();
                  dataMap.addAll({allChartModel[i].name.toString(): cancel});
                  colorList
                      .add(HexColor.fromHex(allChartModel[i].color.toString()));
                } else if (allChartModel[i].code == 'total') {
                  total = allChartModel[i].total.toDouble();
                }

                print('Map Data : ${dataMap}');
                print('Color List: ${colorList}');
                print('Total: ${total}');

                ///////

                return allChartModel[i].code == 'total'
                    ? Container(
                        margin: EdgeInsets.symmetric(vertical: 35),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PieChart(
                              dataMap: dataMap,
                              animationDuration: Duration(milliseconds: 800),
                              chartLegendSpacing: 30,
                              chartRadius:
                                  MediaQuery.of(context).size.width / 1.9,
                              colorList: colorList,
                              initialAngleInDegree: 220,
                              chartType: ChartType.ring,
                              ringStrokeWidth: 55,
                              //   centerText: "Complaint",
                              legendOptions: LegendOptions(
                                showLegendsInRow: true,
                                legendPosition: LegendPosition.bottom,
                                showLegends: true,
                                //  legendShape: _BoxShape.circle,
                                legendTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              chartValuesOptions: ChartValuesOptions(
                                showChartValueBackground: true,
                                showChartValues: true,
                                showChartValuesInPercentage: false,
                                showChartValuesOutside: true,
                                decimalPlaces: 0,
                              ),

                              // centerText: // textAlign: TextAlign.center,
                              //     "Total Complaints: \n" +
                              //         allChartModel[9].total
                              //             .toString(),
                              // // gradientList: ---To add gradient colors---
                              // // emptyColorGradient: ---Empty Color gradient---
                              // centerTextStyle: TextStyle(
                              //     backgroundColor: Colors.white,
                              //     color: Colors.grey),
                            ),
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 75, top: 0),
                                child: Text(
                                  // textAlign: TextAlign.center,

                                  "Total Complaints:\n " +
                                      total.toInt().toString(),

                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: dfFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: dfGreyColor),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container();
              },
              itemCount: allChartModel.length,
            ),
          ),

          //-------------------------///////-------------//////----------

          // FutureBuilder<ComplaintStatus>(
          //     future: fetchComplaintStatus(),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return Container(
          //             height: scHeight / 2.25,
          //             alignment: Alignment.center,
          //             child: CircularProgressIndicator());
          //       } else if (snapshot.hasError) {
          //         // return Center(child: Text('Error: ${snapshot.error}'));
          //         return Container(
          //           height: scHeight / 2.25,
          //           alignment: Alignment.center,
          //           child: Text(
          //             'Please Check your Internet Connection !!!',
          //             style: TextStyle(color: appcolor),
          //           ),
          //         );
          //       } else {
          //         final complaintStatus = snapshot.data;

          //         submitted = allChartModel[0].total.toDouble();

          //         inProcess = allChartModel[2].total.toDouble();
          //         pending = allChartModel[3].total.toDouble();
          //         resolved = allChartModel[4].total.toDouble();
          //         closed = allChartModel[5].total.toDouble();
          //         reopen = allChartModel[6].total.toDouble();
          //         cancel = allChartModel[7].total.toDouble();

          //         Map<String, double> dataMap = {
          //           allChartModel[0].name.toString(): submitted,
          //           allChartModel[2].name.toString(): inProcess,
          //           allChartModel[4].name.toString(): resolved,
          //           allChartModel[3].name.toString(): pending ?? 0,
          //           allChartModel[5].name.toString(): closed ?? 0,
          //           allChartModel[6].name.toString(): reopen ?? 0,
          //           allChartModel[7].name.toString(): cancel,
          //         };

          //         final colorList = <Color>[
          //           HexColor.fromHex(allChartModel[0].color.toString()),
          //           HexColor.fromHex(allChartModel[1].color.toString()),
          //           HexColor.fromHex(allChartModel[3].color.toString()),
          //           HexColor.fromHex(allChartModel[4].color.toString()),
          //           HexColor.fromHex(allChartModel[5].color.toString()),
          //           HexColor.fromHex(allChartModel[6].color.toString()),
          //           HexColor.fromHex(allChartModel[7].color.toString()),
          //         ];

          //         return Container(
          //           margin: EdgeInsets.symmetric(vertical: 35),
          //           child: Stack(
          //             alignment: Alignment.center,
          //             children: [
          //               PieChart(
          //                 dataMap: dataMap,
          //                 animationDuration: Duration(milliseconds: 800),
          //                 chartLegendSpacing: 30,
          //                 chartRadius:
          //                     MediaQuery.of(context).size.width / 1.9,
          //                 colorList: colorList,
          //                 initialAngleInDegree: 220,
          //                 chartType: ChartType.ring,
          //                 ringStrokeWidth: 55,
          //                 //   centerText: "Complaint",
          //                 legendOptions: LegendOptions(
          //                   showLegendsInRow: true,
          //                   legendPosition: LegendPosition.bottom,
          //                   showLegends: true,
          //                   //  legendShape: _BoxShape.circle,
          //                   legendTextStyle: TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),

          //                 chartValuesOptions: ChartValuesOptions(
          //                   showChartValueBackground: true,
          //                   showChartValues: true,
          //                   showChartValuesInPercentage: false,
          //                   showChartValuesOutside: true,
          //                   decimalPlaces: 0,
          //                 ),

          //                 // centerText: // textAlign: TextAlign.center,
          //                 //     "Total Complaints: \n" +
          //                 //         allChartModel[9].total
          //                 //             .toString(),
          //                 // // gradientList: ---To add gradient colors---
          //                 // // emptyColorGradient: ---Empty Color gradient---
          //                 // centerTextStyle: TextStyle(
          //                 //     backgroundColor: Colors.white,
          //                 //     color: Colors.grey),
          //               ),
          //               Center(
          //                 child: Container(
          //                   margin: EdgeInsets.only(bottom: 75, top: 0),
          //                   child: Text(
          //                     // textAlign: TextAlign.center,

          //                     "Total Complaints:\n " +
          //                         allChartModel[10].total.toString(),
          //                     textAlign: TextAlign.center,
          //                     style: TextStyle(
          //                         fontSize: dfFontSize,
          //                         fontWeight: FontWeight.w500,
          //                         color: dfGreyColor),
          //                   ),
          //                 ),
          //               )
          //             ],
          //           ),
          //         );
          //       }
          //     }),

          //--------------------------//////---------------/////-----------
          // Text(
          //   // textAlign: TextAlign.center,
          //   "Total Complaints: " +
          //       allChartModel[9].total.toString(),
          //   style: TextStyle(
          //       fontSize: lgFontSize,
          //       fontWeight: FontWeight.w500,
          //       color: dfGreyColor),
          // ),

          ///////////////////////

          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                Container(
                  width: scWidth / 2.3,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15)),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewComplaint()));
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 8,
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
                            padding: EdgeInsets.only(top: 60, bottom: 20),
                            child: Text(
                              "New \nComplaint",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: smFontSize,
                                  // height: 1,
                                  fontWeight: FontWeight.w400,
                                  color: blackColor),
                            ),
                          ),
                          Positioned(
                            top: -20,
                            // left: 60,
                            child: CircleAvatar(
                                backgroundColor: redAlert,
                                radius: 30.0,
                                child: Image.asset(
                                  "asserts/images/newcomplaint.png",
                                  width: 30,
                                )),
                          )
                        ]),
                  ),
                ),
                Spacer(),
                Container(
                  width: scWidth / 2.3,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrackComplaints()));
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 8,
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
                            padding: EdgeInsets.only(top: 60, bottom: 20),
                            child: Text(
                              "Track \nComplaint",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: smFontSize,
                                  // height: 1,
                                  fontWeight: FontWeight.w400,
                                  color: blackColor),
                            ),
                          ),
                          Positioned(
                            top: -20,
                            // left: 60,
                            child: CircleAvatar(
                              backgroundColor: redAlert,
                              radius: 30.0,
                              child: Container(
                                  child: Image.asset(
                                "asserts/images/trackcomplaint.png",
                                width: 30,
                              )),
                            ),
                          )
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
