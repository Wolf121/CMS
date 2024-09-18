import 'dart:convert';

import 'package:dha_resident_app/constant.dart';
import 'package:dha_resident_app/view/widgets/color_widget.dart';
import 'package:dha_resident_app/view/widgets/complaint_filter_search.dart';
import 'package:dha_resident_app/view/widgets/custom_dialog.dart';
import 'package:dha_resident_app/view_model/complaint_state_model/complaint_list_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../widgets/track_list_widget.dart';

class TrackComplaints extends StatefulWidget {
  @override
  State<TrackComplaints> createState() => _TrackComplaintsState();
}

class _TrackComplaintsState extends State<TrackComplaints> {
  List<Map<String, dynamic>> trackList = [];
  List<Map<String, dynamic>> statusList = [];

  var submitted;
  var inProcess;
  var pending;
  var resolved;
  var closed;
  var reOpen;
  var cancel;
  var tesForwarded;
  String refFil = '';
  String dateFil = '2023-09-28T12:34:56.789Z';
  String catFil = '';
  String subCatFil = '';
  String statusFil = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    // fetchTrackListData();
    fetchComplaintListDetailModel();
    fetchStatusData();

    // loadTrackListFromPrefs();
  }

  // getting data from api and storing in the sharedPref
  Future<void> fetchTrackListData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    Uri apiUrl = Uri.parse('http://110.93.244.74/api/complaint/complaint_list');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(apiUrl, headers: headers);

      if (response.statusCode == 200) {
        _isLoading = false;
        Map<String, dynamic> responseData = json.decode(response.body);
        // prefs.setString('trackListData', json.encode(responseData));

        final trackComplaintArray = responseData['data_array'] as List<dynamic>;

        setState(() {
          trackList = trackComplaintArray.cast<Map<String, dynamic>>();
        });

        print('Complaint  data saved in state.');
      } else {
        _isLoading = false;
        print('Failed to fetch track data: ${response.reasonPhrase}');
      }
    } catch (error) {
      _isLoading = false;
      print('Error fetching track data: $error');
    }
  }

//getting data from api complaint Detail
  Future<ComplaintListDetailModel> fetchComplaintListDetailModel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(
        Uri.parse('http://110.93.244.74/api/complaint/complaint_list'),
        headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      return ComplaintListDetailModel.fromJson(responseData);
    } else {
      throw Text('Failed to load data');
    }
  }

  // getting data from api and storing in the sharedPref
  Future<void> fetchStatusData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    Uri apiUrl = Uri.parse('http://110.93.244.74/api/statuses');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(apiUrl, headers: headers);

      if (response.statusCode == 200) {
        _isLoading = false;
        Map<String, dynamic> responseData = json.decode(response.body);
        // prefs.setString('trackListData', json.encode(responseData));

        final StatusArray = responseData['data_array'] as List<dynamic>;

        setState(() {
          statusList = StatusArray.cast<Map<String, dynamic>>();
        });

        print('Complaint Status saved in state.');
      } else {
        _isLoading = false;
        print('Failed to fetch Status data: ${response.reasonPhrase}');
      }
    } catch (error) {
      _isLoading = false;
      print('Error fetching Status data: $error');
    }
  }

  void SearchComplaint(String newref, String newdate, String newcat,
      String newSubCat, String newStatus) {
    refFil = newref;
    dateFil = newdate;
    catFil = newcat;
    subCatFil = newSubCat;
    statusFil = newStatus;

    setState(() {
      print("Just came: " + refFil);
      print("Just came: " + dateFil);
      print("Just came: " + catFil);
      print("Just came: " + subCatFil);
      print("Just came: " + statusFil);
    });
  }

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

    return dateTime;
  }

  @override
  Widget build(BuildContext context) {
    // This controller will store the value of the search bar
    final TextEditingController _searchController = TextEditingController();
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: dfColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: greyColor,
          title: Text(
            'DHA Islamabad',
            style: TextStyle(
              color: appcolor,
              fontWeight: FontWeight.w700,
              fontSize: lgFontSize,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: appcolor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              // final route =
              //     MaterialPageRoute(builder: (context) => BottomNavBar());
              // Navigator.pushAndRemoveUntil(context, route, (route) => false);
            },
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: marginLR),
              child: CircleAvatar(
                backgroundColor: lightappcolor,
                radius: 18.0,
                child: IconButton(
                  icon: Icon(
                    Icons.question_mark,
                    size: lgFontSize,
                    color: dfColor,
                  ),
                  onPressed: () {
                    CustomDialog(context);
                  },
                ),
              ),
            ),
          ],
        ),
        body: Container(
          color: dfColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                color: appcolor,
                width: scWidth,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  bottom: marginLR,
                ),
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "Complaint List",
                  style: TextStyle(color: dfColor, fontWeight: FontWeight.w700),
                ),
              ),
              ComplaintFilterSearch(
                onSearchComplaint: SearchComplaint,
              ),
              FutureBuilder<ComplaintListDetailModel>(
                  future: fetchComplaintListDetailModel(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        alignment: Alignment.center,
                        // height: scHeight / 1.5,
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Container(
                          alignment: Alignment.center,
                          height: scHeight / 1.5,
                          child: Text(
                            'Couldn\'t Fetch The Complaint List At This Moment.\nPlease Try Again Later!',
                            style: TextStyle(
                              fontSize: smFontSize,
                            ),
                          ));
                    } else {
                      final complaintDetailData = snapshot.data;

                      return Expanded(
                        flex: 11,
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: 5,
                              top: 20,
                              left: marginLR,
                              right: marginLR),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              // final statusName = statusList[index]['name'];
                              // final statusColor = statusList[index]['color'];
                              // final trackSt = trackList[index]['status'];

                              for (int i = 0; i < statusList.length; i++) {
                                var id = statusList[i]['id'] as int;
                                var color = statusList[i]['color'];

                                switch (id) {
                                  case 1:
                                    submitted = color;
                                    break;
                                  case 3:
                                    inProcess = color;
                                    break;
                                  case 4:
                                    pending = color;
                                    break;
                                  case 5:
                                    resolved = color;
                                    break;
                                  case 6:
                                    closed = color;
                                    break;
                                  case 7:
                                    reOpen = color;
                                    break;
                                  case 8:
                                    cancel = color;
                                    break;
                                  case 9:
                                    tesForwarded = color;
                                    break;
                                  default:
                                    // Handle the case where id doesn't match any of the specified cases.
                                    break;
                                }
                              }

                              ///Date Filter
                              // DateTime dateF = DateTime.parse(dateFil);
                              DateTime? dateF;

                              try {
                                dateF = DateTime.parse(dateFil);
                              } catch (e) {
                                print('Error parsing date: $e');
                              }

                              String? dateFormatFil = dateF != null
                                  ? DateFormat("yyyy-dd-MM").format(dateF)
                                  : null;

                              print(
                                  "Date Complaint " + dateFormatFil.toString());

                              ////Api Date
                              final daty = parseCustomDate(
                                  complaintDetailData.dataArray[index].created);
                              String dateFormatApi =
                                  DateFormat("yyyy-dd-MM").format(daty);
                              print("Date Api " + dateFormatApi);

                              print("Refrence No " + refFil);
                              print("Cat Fil " + catFil);
                              print("SubCat Fil " + subCatFil);
                              print("Status " + statusFil);
                              print("Date " + dateFormatApi);

                              if ((complaintDetailData
                                              .dataArray[index].reference)
                                          .toLowerCase() ==
                                      refFil.toLowerCase() &&
                                  (complaintDetailData
                                          .dataArray[index].category) ==
                                      catFil &&
                                  (complaintDetailData
                                          .dataArray[index].subcategory) ==
                                      subCatFil &&
                                  (complaintDetailData
                                          .dataArray[index].status) ==
                                      statusFil &&
                                  dateFormatApi == dateFormatFil) {
                                print("Condition 0");
                                return TrackListWidget(
                                  fetchComplaintListDetailModel:
                                      fetchComplaintListDetailModel(),
                                  feedback: complaintDetailData
                                          .dataArray[index].feedback ??
                                      'N/A',
                                  userId: complaintDetailData
                                          .dataArray[index].uid ??
                                      'N/A',
                                  trackDay: complaintDetailData
                                          .dataArray[index].createdAt ??
                                      'N/A',
                                  trackRefNo: complaintDetailData
                                          .dataArray[index].reference ??
                                      'N/A',
                                  trackTime: complaintDetailData
                                          .dataArray[index].created ??
                                      'N/A',
                                  trackComplainStatus: complaintDetailData
                                          .dataArray[index].status ??
                                      'N/A',
                                  category: complaintDetailData
                                          .dataArray[index].category ??
                                      'N/A',
                                  subCategory: complaintDetailData
                                          .dataArray[index].subcategory ??
                                      'N/A',
                                  complaintUser: complaintDetailData
                                          .dataArray[index].fellowupName ??
                                      'N/A',
                                  mobileNo: complaintDetailData
                                          .dataArray[index].fellowupCell ??
                                      'N/A',
                                  phNo: complaintDetailData
                                          .dataArray[index].fellowupLandline ??
                                      'N/A',
                                  colorComplait: complaintDetailData
                                              .dataArray[index].status ==
                                          "Submitted"
                                      ? HexColor.fromHex(submitted)
                                      : complaintDetailData
                                                  .dataArray[index].status ==
                                              "In Process"
                                          ? HexColor.fromHex(inProcess)
                                          : complaintDetailData.dataArray[index]
                                                      .status ==
                                                  "Closed"
                                              ? HexColor.fromHex(closed)
                                              : complaintDetailData
                                                          .dataArray[index]
                                                          .status ==
                                                      "Pending"
                                                  ? HexColor.fromHex(pending)
                                                  : complaintDetailData
                                                              .dataArray[index]
                                                              .status ==
                                                          "Resolved"
                                                      ? HexColor.fromHex(
                                                          resolved)
                                                      : complaintDetailData
                                                                  .dataArray[
                                                                      index]
                                                                  .status ==
                                                              "Reopen"
                                                          ? HexColor.fromHex(
                                                              reOpen)
                                                          : complaintDetailData
                                                                      .dataArray[
                                                                          index]
                                                                      .status ==
                                                                  "Cancel"
                                                              ? HexColor.fromHex(
                                                                  cancel)
                                                              : HexColor.fromHex(tesForwarded),
                                );
                              } else if ((complaintDetailData
                                          .dataArray[index].reference)
                                      .toLowerCase() ==
                                  refFil.toLowerCase()) {
                                print("Condition 1");

                                return ((catFil.isEmpty ||
                                            (complaintDetailData
                                                    .dataArray[index]
                                                    .category) ==
                                                catFil) &&
                                        (subCatFil.isEmpty ||
                                            (complaintDetailData
                                                    .dataArray[index]
                                                    .subcategory) ==
                                                subCatFil) &&
                                        (statusFil.isEmpty ||
                                            (complaintDetailData
                                                    .dataArray[index].status) ==
                                                statusFil) &&
                                        (dateFormatApi == dateFormatFil))
                                    ? TrackListWidget(
                                        fetchComplaintListDetailModel:
                                            fetchComplaintListDetailModel(),
                                        feedback: complaintDetailData
                                                .dataArray[index].feedback ??
                                            'N/A',
                                        userId: complaintDetailData
                                                .dataArray[index].uid ??
                                            'N/A',
                                        trackDay: complaintDetailData
                                                .dataArray[index].createdAt ??
                                            'N/A',
                                        trackRefNo: complaintDetailData
                                                .dataArray[index].reference ??
                                            'N/A',
                                        trackTime: complaintDetailData
                                                .dataArray[index].created ??
                                            'N/A',
                                        trackComplainStatus: complaintDetailData
                                                .dataArray[index].status ??
                                            'N/A',
                                        category: complaintDetailData
                                                .dataArray[index].category ??
                                            'N/A',
                                        subCategory: complaintDetailData
                                                .dataArray[index].subcategory ??
                                            'N/A',
                                        complaintUser: complaintDetailData
                                                .dataArray[index]
                                                .fellowupName ??
                                            'N/A',
                                        mobileNo: complaintDetailData
                                                .dataArray[index]
                                                .fellowupCell ??
                                            'N/A',
                                        phNo: complaintDetailData
                                                .dataArray[index]
                                                .fellowupLandline ??
                                            'N/A',
                                        colorComplait: complaintDetailData
                                                    .dataArray[index].status ==
                                                "Submitted"
                                            ? HexColor.fromHex(submitted)
                                            : complaintDetailData
                                                        .dataArray[index]
                                                        .status ==
                                                    "In Process"
                                                ? HexColor.fromHex(inProcess)
                                                : complaintDetailData
                                                            .dataArray[index]
                                                            .status ==
                                                        "Closed"
                                                    ? HexColor.fromHex(closed)
                                                    : complaintDetailData
                                                                .dataArray[
                                                                    index]
                                                                .status ==
                                                            "Pending"
                                                        ? HexColor.fromHex(
                                                            pending)
                                                        : complaintDetailData
                                                                    .dataArray[
                                                                        index]
                                                                    .status ==
                                                                "Resolved"
                                                            ? HexColor.fromHex(
                                                                resolved)
                                                            : complaintDetailData
                                                                        .dataArray[
                                                                            index]
                                                                        .status ==
                                                                    "Reopen"
                                                                ? HexColor.fromHex(
                                                                    reOpen)
                                                                : complaintDetailData.dataArray[index].status ==
                                                                        "Cancel"
                                                                    ? HexColor.fromHex(cancel)
                                                                    : HexColor.fromHex(tesForwarded),
                                      )
                                    : Container();
                              } else if ((complaintDetailData
                                      .dataArray[index].category) ==
                                  catFil) {
                                print("Condition 2");

                                return ((refFil.isEmpty ||
                                            (complaintDetailData
                                                        .dataArray[index]
                                                        .reference)
                                                    .toLowerCase() ==
                                                refFil.toLowerCase()) &&
                                        (subCatFil.isEmpty ||
                                            (complaintDetailData
                                                    .dataArray[index]
                                                    .subcategory) ==
                                                subCatFil) &&
                                        (statusFil.isEmpty ||
                                            (complaintDetailData
                                                    .dataArray[index].status) ==
                                                statusFil) &&
                                        (dateFormatApi == dateFormatFil))
                                    ? TrackListWidget(
                                        fetchComplaintListDetailModel:
                                            fetchComplaintListDetailModel(),
                                        feedback: complaintDetailData
                                                .dataArray[index].feedback ??
                                            'N/A',
                                        userId: complaintDetailData
                                                .dataArray[index].uid ??
                                            'N/A',
                                        trackDay: complaintDetailData
                                                .dataArray[index].createdAt ??
                                            'N/A',
                                        trackRefNo: complaintDetailData
                                                .dataArray[index].reference ??
                                            'N/A',
                                        trackTime: complaintDetailData
                                                .dataArray[index].created ??
                                            'N/A',
                                        trackComplainStatus: complaintDetailData
                                                .dataArray[index].status ??
                                            'N/A',
                                        category: complaintDetailData
                                                .dataArray[index].category ??
                                            'N/A',
                                        subCategory: complaintDetailData
                                                .dataArray[index].subcategory ??
                                            'N/A',
                                        complaintUser: complaintDetailData
                                                .dataArray[index]
                                                .fellowupName ??
                                            'N/A',
                                        mobileNo: complaintDetailData
                                                .dataArray[index]
                                                .fellowupCell ??
                                            'N/A',
                                        phNo: complaintDetailData
                                                .dataArray[index]
                                                .fellowupLandline ??
                                            'N/A',
                                        colorComplait: complaintDetailData
                                                    .dataArray[index].status ==
                                                "Submitted"
                                            ? HexColor.fromHex(submitted)
                                            : complaintDetailData
                                                        .dataArray[index]
                                                        .status ==
                                                    "In Process"
                                                ? HexColor.fromHex(inProcess)
                                                : complaintDetailData
                                                            .dataArray[index]
                                                            .status ==
                                                        "Closed"
                                                    ? HexColor.fromHex(closed)
                                                    : complaintDetailData
                                                                .dataArray[
                                                                    index]
                                                                .status ==
                                                            "Pending"
                                                        ? HexColor.fromHex(
                                                            pending)
                                                        : complaintDetailData
                                                                    .dataArray[
                                                                        index]
                                                                    .status ==
                                                                "Resolved"
                                                            ? HexColor.fromHex(
                                                                resolved)
                                                            : complaintDetailData
                                                                        .dataArray[
                                                                            index]
                                                                        .status ==
                                                                    "Reopen"
                                                                ? HexColor.fromHex(
                                                                    reOpen)
                                                                : complaintDetailData.dataArray[index].status ==
                                                                        "Cancel"
                                                                    ? HexColor.fromHex(cancel)
                                                                    : HexColor.fromHex(tesForwarded),
                                      )
                                    : Container();
                              } else if ((complaintDetailData
                                      .dataArray[index].subcategory) ==
                                  subCatFil) {
                                print("Condition 3");

                                return ((refFil.isEmpty ||
                                            (complaintDetailData
                                                        .dataArray[index]
                                                        .reference)
                                                    .toLowerCase() ==
                                                refFil.toLowerCase()) &&
                                        (catFil.isEmpty ||
                                            (complaintDetailData
                                                    .dataArray[index]
                                                    .category) ==
                                                catFil) &&
                                        (statusFil.isEmpty ||
                                            (complaintDetailData
                                                    .dataArray[index].status) ==
                                                statusFil) &&
                                        (dateFormatApi == dateFormatFil))
                                    ? TrackListWidget(
                                        fetchComplaintListDetailModel:
                                            fetchComplaintListDetailModel(),
                                        feedback: complaintDetailData
                                                .dataArray[index].feedback ??
                                            'N/A',
                                        userId: complaintDetailData
                                                .dataArray[index].uid ??
                                            'N/A',
                                        trackDay: complaintDetailData
                                                .dataArray[index].createdAt ??
                                            'N/A',
                                        trackRefNo: complaintDetailData
                                                .dataArray[index].reference ??
                                            'N/A',
                                        trackTime: complaintDetailData
                                                .dataArray[index].created ??
                                            'N/A',
                                        trackComplainStatus: complaintDetailData
                                                .dataArray[index].status ??
                                            'N/A',
                                        category: complaintDetailData
                                                .dataArray[index].category ??
                                            'N/A',
                                        subCategory: complaintDetailData
                                                .dataArray[index].subcategory ??
                                            'N/A',
                                        complaintUser: complaintDetailData
                                                .dataArray[index]
                                                .fellowupName ??
                                            'N/A',
                                        mobileNo: complaintDetailData
                                                .dataArray[index]
                                                .fellowupCell ??
                                            'N/A',
                                        phNo: complaintDetailData
                                                .dataArray[index]
                                                .fellowupLandline ??
                                            'N/A',
                                        colorComplait: complaintDetailData
                                                    .dataArray[index].status ==
                                                "Submitted"
                                            ? HexColor.fromHex(submitted)
                                            : complaintDetailData
                                                        .dataArray[index]
                                                        .status ==
                                                    "In Process"
                                                ? HexColor.fromHex(inProcess)
                                                : complaintDetailData
                                                            .dataArray[index]
                                                            .status ==
                                                        "Closed"
                                                    ? HexColor.fromHex(closed)
                                                    : complaintDetailData
                                                                .dataArray[
                                                                    index]
                                                                .status ==
                                                            "Pending"
                                                        ? HexColor.fromHex(
                                                            pending)
                                                        : complaintDetailData
                                                                    .dataArray[
                                                                        index]
                                                                    .status ==
                                                                "Resolved"
                                                            ? HexColor.fromHex(
                                                                resolved)
                                                            : complaintDetailData
                                                                        .dataArray[
                                                                            index]
                                                                        .status ==
                                                                    "Reopen"
                                                                ? HexColor.fromHex(
                                                                    reOpen)
                                                                : complaintDetailData.dataArray[index].status ==
                                                                        "Cancel"
                                                                    ? HexColor.fromHex(cancel)
                                                                    : HexColor.fromHex(tesForwarded),
                                      )
                                    : Container();
                              } else if ((complaintDetailData
                                      .dataArray[index].status) ==
                                  statusFil) {
                                print("Condition 4");

                                return ((refFil.isEmpty ||
                                            (complaintDetailData
                                                        .dataArray[index]
                                                        .reference)
                                                    .toLowerCase() ==
                                                refFil.toLowerCase()) &&
                                        (catFil.isEmpty ||
                                            (complaintDetailData
                                                    .dataArray[index]
                                                    .category) ==
                                                catFil) &&
                                        (subCatFil.isEmpty ||
                                            (complaintDetailData
                                                    .dataArray[index]
                                                    .subcategory) ==
                                                subCatFil) &&
                                        (dateFormatApi == dateFormatFil))
                                    ? TrackListWidget(
                                        fetchComplaintListDetailModel:
                                            fetchComplaintListDetailModel(),
                                        feedback: complaintDetailData
                                                .dataArray[index].feedback ??
                                            'N/A',
                                        userId: complaintDetailData
                                                .dataArray[index].uid ??
                                            'N/A',
                                        trackDay: complaintDetailData
                                                .dataArray[index].createdAt ??
                                            'N/A',
                                        trackRefNo: complaintDetailData
                                                .dataArray[index].reference ??
                                            'N/A',
                                        trackTime: complaintDetailData
                                                .dataArray[index].created ??
                                            'N/A',
                                        trackComplainStatus: complaintDetailData
                                                .dataArray[index].status ??
                                            'N/A',
                                        category: complaintDetailData
                                                .dataArray[index].category ??
                                            'N/A',
                                        subCategory: complaintDetailData
                                                .dataArray[index].subcategory ??
                                            'N/A',
                                        complaintUser: complaintDetailData
                                                .dataArray[index]
                                                .fellowupName ??
                                            'N/A',
                                        mobileNo: complaintDetailData
                                                .dataArray[index]
                                                .fellowupCell ??
                                            'N/A',
                                        phNo: complaintDetailData
                                                .dataArray[index]
                                                .fellowupLandline ??
                                            'N/A',
                                        colorComplait: complaintDetailData
                                                    .dataArray[index].status ==
                                                "Submitted"
                                            ? HexColor.fromHex(submitted)
                                            : complaintDetailData
                                                        .dataArray[index]
                                                        .status ==
                                                    "In Process"
                                                ? HexColor.fromHex(inProcess)
                                                : complaintDetailData
                                                            .dataArray[index]
                                                            .status ==
                                                        "Closed"
                                                    ? HexColor.fromHex(closed)
                                                    : complaintDetailData
                                                                .dataArray[
                                                                    index]
                                                                .status ==
                                                            "Pending"
                                                        ? HexColor.fromHex(
                                                            pending)
                                                        : complaintDetailData
                                                                    .dataArray[
                                                                        index]
                                                                    .status ==
                                                                "Resolved"
                                                            ? HexColor.fromHex(
                                                                resolved)
                                                            : complaintDetailData
                                                                        .dataArray[
                                                                            index]
                                                                        .status ==
                                                                    "Reopen"
                                                                ? HexColor.fromHex(
                                                                    reOpen)
                                                                : complaintDetailData.dataArray[index].status ==
                                                                        "Cancel"
                                                                    ? HexColor.fromHex(cancel)
                                                                    : HexColor.fromHex(tesForwarded),
                                      )
                                    : Container();
                              } else if (dateFormatFil == dateFormatApi) {
                                print("Condition 5");

                                return ((refFil.isEmpty ||
                                            (complaintDetailData
                                                        .dataArray[index]
                                                        .reference)
                                                    .toLowerCase() ==
                                                refFil.toLowerCase()) &&
                                        (catFil.isEmpty ||
                                            (complaintDetailData
                                                    .dataArray[index]
                                                    .category) ==
                                                catFil) &&
                                        (subCatFil.isEmpty ||
                                            (complaintDetailData
                                                    .dataArray[index]
                                                    .subcategory) ==
                                                subCatFil) &&
                                        (statusFil.isEmpty ||
                                            (complaintDetailData
                                                    .dataArray[index].status) ==
                                                statusFil))
                                    ? TrackListWidget(
                                        fetchComplaintListDetailModel:
                                            fetchComplaintListDetailModel(),
                                        feedback: complaintDetailData
                                                .dataArray[index].feedback ??
                                            'N/A',
                                        userId: complaintDetailData
                                                .dataArray[index].uid ??
                                            'N/A',
                                        trackDay: complaintDetailData
                                                .dataArray[index].createdAt ??
                                            'N/A',
                                        trackRefNo: complaintDetailData
                                                .dataArray[index].reference ??
                                            'N/A',
                                        trackTime: complaintDetailData
                                                .dataArray[index].created ??
                                            'N/A',
                                        trackComplainStatus: complaintDetailData
                                                .dataArray[index].status ??
                                            'N/A',
                                        category: complaintDetailData
                                                .dataArray[index].category ??
                                            'N/A',
                                        subCategory: complaintDetailData
                                                .dataArray[index].subcategory ??
                                            'N/A',
                                        complaintUser: complaintDetailData
                                                .dataArray[index]
                                                .fellowupName ??
                                            'N/A',
                                        mobileNo: complaintDetailData
                                                .dataArray[index]
                                                .fellowupCell ??
                                            'N/A',
                                        phNo: complaintDetailData
                                                .dataArray[index]
                                                .fellowupLandline ??
                                            'N/A',
                                        colorComplait: complaintDetailData
                                                    .dataArray[index].status ==
                                                "Submitted"
                                            ? HexColor.fromHex(submitted)
                                            : complaintDetailData
                                                        .dataArray[index]
                                                        .status ==
                                                    "In Process"
                                                ? HexColor.fromHex(inProcess)
                                                : complaintDetailData
                                                            .dataArray[index]
                                                            .status ==
                                                        "Closed"
                                                    ? HexColor.fromHex(closed)
                                                    : complaintDetailData
                                                                .dataArray[
                                                                    index]
                                                                .status ==
                                                            "Pending"
                                                        ? HexColor.fromHex(
                                                            pending)
                                                        : complaintDetailData
                                                                    .dataArray[
                                                                        index]
                                                                    .status ==
                                                                "Resolved"
                                                            ? HexColor.fromHex(
                                                                resolved)
                                                            : complaintDetailData
                                                                        .dataArray[
                                                                            index]
                                                                        .status ==
                                                                    "Reopen"
                                                                ? HexColor.fromHex(
                                                                    reOpen)
                                                                : complaintDetailData.dataArray[index].status ==
                                                                        "Cancel"
                                                                    ? HexColor.fromHex(cancel)
                                                                    : HexColor.fromHex(tesForwarded),
                                      )
                                    : Container();
                              } else {
                                print('Conditiom else ');
                                print('date val $dateFormatFil');
                                return ((dateFormatFil == "2023-28-09")
                                        ? (refFil != "" ||
                                            catFil != "" ||
                                            subCatFil != "" ||
                                            statusFil != "")
                                        : (refFil != "" ||
                                            catFil != "" ||
                                            subCatFil != "" ||
                                            statusFil != "" ||
                                            (dateFormatFil != "null")))
                                    ? Container()
                                    : TrackListWidget(
                                        fetchComplaintListDetailModel:
                                            fetchComplaintListDetailModel(),
                                        feedback: complaintDetailData
                                                .dataArray[index].feedback ??
                                            'N/A',
                                        userId: complaintDetailData
                                                .dataArray[index].uid ??
                                            'N/A',
                                        trackDay: complaintDetailData
                                                .dataArray[index].createdAt ??
                                            'N/A',
                                        trackRefNo: complaintDetailData
                                                .dataArray[index].reference ??
                                            'N/A',
                                        trackTime: complaintDetailData
                                                .dataArray[index].created ??
                                            'N/A',
                                        trackComplainStatus: complaintDetailData
                                                .dataArray[index].status ??
                                            'N/A',
                                        category: complaintDetailData
                                                .dataArray[index].category ??
                                            'N/A',
                                        subCategory: complaintDetailData
                                                .dataArray[index].subcategory ??
                                            'N/A',
                                        complaintUser: complaintDetailData
                                                .dataArray[index]
                                                .fellowupName ??
                                            'N/A',
                                        mobileNo: complaintDetailData
                                                .dataArray[index]
                                                .fellowupCell ??
                                            'N/A',
                                        phNo: complaintDetailData
                                                .dataArray[index]
                                                .fellowupLandline ??
                                            'N/A',
                                        colorComplait: complaintDetailData
                                                    .dataArray[index].status ==
                                                "Submitted"
                                            ? HexColor.fromHex(
                                                submitted ?? appcolorHex)
                                            : complaintDetailData
                                                        .dataArray[index]
                                                        .status ==
                                                    "In Process"
                                                ? HexColor.fromHex(
                                                    inProcess ?? appcolorHex)
                                                : complaintDetailData
                                                            .dataArray[index]
                                                            .status ==
                                                        "Closed"
                                                    ? HexColor.fromHex(
                                                        closed ?? appcolorHex)
                                                    : complaintDetailData
                                                                .dataArray[
                                                                    index]
                                                                .status ==
                                                            "Pending"
                                                        ? HexColor.fromHex(
                                                            pending ??
                                                                appcolorHex)
                                                        : complaintDetailData
                                                                    .dataArray[index]
                                                                    .status ==
                                                                "Resolved"
                                                            ? HexColor.fromHex(resolved ?? appcolorHex)
                                                            : complaintDetailData.dataArray[index].status == "Reopen"
                                                                ? HexColor.fromHex(reOpen ?? appcolorHex)
                                                                : complaintDetailData.dataArray[index].status == "Cancel"
                                                                    ? HexColor.fromHex(cancel ?? appcolorHex)
                                                                    : HexColor.fromHex(tesForwarded ?? appcolorHex),
                                      );
                              }
                            },
                            itemCount: complaintDetailData!.dataArray.length,
                          ),
                        ),
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
