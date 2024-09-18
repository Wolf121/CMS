import 'package:date_format/date_format.dart';
import 'package:dha_resident_app/constant.dart';
import 'package:dha_resident_app/view/widgets/color_widget.dart';
import 'package:dha_resident_app/view/widgets/custom_app_bar.dart';
import 'package:dha_resident_app/view/widgets/sos_filter_search.dart';
import 'package:dha_resident_app/view_model/sos_history/sos_history_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widgets/sos_history_list_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SosHistory extends StatefulWidget {
  @override
  _SosHistoryState createState() => _SosHistoryState();
}

class SosRecord {
  final int id;
  final String reference;
  final String status;
  final DateTime createdAt;

  SosRecord({
    required this.id,
    required this.reference,
    required this.status,
    required this.createdAt,
  });
}

class _SosHistoryState extends State<SosHistory> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> sosList = [];
  List<Map<String, dynamic>> statusList = [];
  List<Map<String, dynamic>> originalSosList = [];

  var submitted;
  var inProcess;
  var pending;
  var resolved;
  var closed;
  var reOpen;
  var cancel;
  var tesForwarded;
  int j = 0;
  DateTime? dateFilter;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // fetchAndStoreSOSList();
    _isLoading = true;
    fetchStatusData();
    fetchSosListModel();
    ApifetchAndStoreSOSList();
  }

  // Define a function to filter the SOS history
  void filterSosHistory(String referenceNo, DateTime? date, String? type) {
    final filteredSosList = originalSosList.where((sos) {
      final sosReferenceNo = sos['reference'] as String;
      final sosDate = sos['createdAt'] as String;
      final sosType = sos['type'] as String;

      // Check if the reference number, date, and type match the criteria
      final matchesReferenceNo = sosReferenceNo.contains(referenceNo);
      final matchesDate =
          date == null || sosDate == formatDate(date, [yyyy, '-', mm, '-', dd]);
      final matchesType = type == null || sosType == type;

      return matchesReferenceNo && matchesDate && matchesType;
    }).toList();

    setState(() {
      sosList = filteredSosList;
    });
  }

  Future<void> fetchAndStoreSOSList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    final headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('http://110.93.244.74/api/sos/sos_list'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      _isLoading = false;
      final Map<String, dynamic> data = jsonDecode(response.body);
      final sosDataArray = data['data_array'] as List<dynamic>;

      setState(() {
        sosList = sosDataArray.cast<Map<String, dynamic>>();
        originalSosList = sosList; // Store the original list for filtering
      });

      print('SOS List data saved in state.');
    } else {
      _isLoading = false;
      print('API request failed with status: ${response.statusCode}.');
    }
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
      } else {
        _isLoading = false;
        print('Failed to fetch Status data: ${response.reasonPhrase}');
      }
    } catch (error) {
      _isLoading = false;
      print('Error fetching Status data: $error');
    }
  }
  //

  Future<void> ApifetchAndStoreSOSList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(
        Uri.parse('http://110.93.244.74/api/sos/sos_list'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Convert date and time strings to ISO 8601 format
        final sosDataArray =
            (data['data_array'] as List<dynamic>).map((record) {
          final actions = (record['actions'] as List<dynamic>).map((action) {
            final startTime = parseApiDateFormatSos(action['start_time']);
            final endTime = action['end_time'] != null
                ? parseApiDateFormatSos(action['end_time'])
                : null;
            return {
              'id': action['id'],
              'sos_id': action['sos_id'],
              'status_id': action['status_id'],
              'start_time': startTime.toIso8601String(),
              'end_time': endTime != null ? endTime.toIso8601String() : null,
              'uid': action['uid'],
              'created_at':
                  parseApiDateFormatSos(action['created_at']).toIso8601String(),
              'comments': action['comments'],
              'name': action['name'],
            };
          }).toList();

          final createdDate = parseApiDateFormatSos(record['created_at']);

          return {
            'id': record['id'],
            'reference': record['reference'],
            'uid': record['uid'],
            'name': record['name'],
            'status_id': record['status_id'],
            'status': record['status'],
            'color': record['color'],
            'actions': actions,
            'created': record['created'],
            'created_at': createdDate.toIso8601String(),
          };
        }).toList();

        final formattedData = {
          'success': data['success'],
          'message': data['message'],
          'data_array': sosDataArray,
        };

        // Store the data in SharedPreferences
        prefs.setString('sosListData', jsonEncode(formattedData));

        //print('SOS List data saved in SharedPreferences.');

        // You can also return the data or perform other actions here
      } else {
        print('API request failed with status: ${response.statusCode}.');
        // Handle the error or throw an exception if needed
      }
    } catch (error) {
      print('Error fetching and storing SOS List data: $error');
      // Handle the error or throw an exception if needed
    }
  }

  String ref = "";
  String statusFilter = "";
  String typeSelect = "";

  ///filter fuction call
  ///
  Future<void> fetchAndFilterSosRecords({
    DateTime? date,
    String? referenceNo,
    String? status,
    String? type,
  }) async {
    setState(() {});
    ref = referenceNo.toString();
    statusFilter = status.toString();
    typeSelect = type.toString();

    dateFilter = date;

    print("Ref Fun " + ref);
    print("Status Fun " + statusFilter);
    print("Type Fun " + typeSelect);
    print("Date Fun " + dateFilter.toString());

    List<Map<String, dynamic>> filteredRecords = await getSosRecords(
      referenceNo: referenceNo, // Optional: Filter by reference number
      date: date, // Optional: Filter by date
      status: status, // Optional: Filter by status
      type: type, // Optional: Filter by status
    );

    // Process the filteredRecords as needed
  }

  //// filter search
  DateTime parseRelativeDate(String relativeDate) {
    final now = DateTime.now();
    if (relativeDate.toLowerCase().contains('days ago')) {
      final daysAgo = int.parse(relativeDate.split(' ')[0]);
      return now.subtract(Duration(days: daysAgo));
    } else {
      // Handle other relative date formats or return a default value
      return DateTime.now(); // Change this to handle other cases
    }
  }

  Future<List<Map<String, dynamic>>> getSosRecords({
    String? referenceNo,
    DateTime? date, // Change the parameter type to DateTime
    String? status,
    String? type,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('sosListData');

    try {
      Map<String, dynamic> data = json.decode(savedData!);

      // Access the "data_array" key, which contains the list of SOS records.
      List<dynamic> dataArray = data['data_array'];

      List<Map<String, dynamic>> sosRecords = dataArray.where((record) {
        final apiDate = parseApiDateFormatSos(record['created_at']);
        final recordDate = DateTime.parse(apiDate.toLocal().toString());

        return (referenceNo == null ||
                record['reference'] == referenceNo.toUpperCase()) &&
            (status == null || record['status'] == status) &&
            (date == null || isSameDay(recordDate, date));
      }).map((record) {
        final apiDate = parseApiDateFormatSos(record['created_at']);
        return {
          'id': record['id'],
          'reference': record['reference'],
          'status': record['status'],
          'created_at': record['yy:mm:dd'], // Format date as needed
          'name': record['name'], // Type as needed
          // Add other fields you need
        };
      }).toList();

      return sosRecords;
    } catch (error) {
      print('Error parsing SOS data: $error');
      return []; // Return an empty list in case of an error
    }
  }

// Parse the API date format
  // Parse the API date format for SOS records
  DateTime parseApiDateFormatSos(String apiDate) {
    try {
      final dateTime = DateTime.parse(apiDate);
      return dateTime.toLocal(); // Convert to local time
    } catch (e) {
      print('Error parsing API date format: $e');
      return DateTime.now(); // Return current date and time in case of an error
    }
  }

// Check if two DateTime objects represent the same day
  bool isSameDaySos(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  DateTime parseApiDateFormat(String apiDate) {
    return DateFormat("yyyy-MM-dd HH:mm:ss").parse(apiDate);
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
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
    print("This happening here:" + dateTime.toString());
    return dateTime;
  }

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: greyColor,
      appBar: CustomAppBar(),
      body: Container(
        color: greyColor,
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
                "SOS History",
                style: TextStyle(color: dfColor, fontWeight: FontWeight.w700),
              ),
            ),
            SosFilterSearch(
              onFilter: filterSosHistory,
              onFetchAndFilterSosRecords: (DateTime? date, String? referenceNo,
                  String? status, String? type) async {
                await fetchAndFilterSosRecords(
                  date: date,
                  referenceNo: referenceNo,
                  status: status,
                  type: type,
                );
              },
            ),
            FutureBuilder<SosListModel>(
              future: fetchSosListModel(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    alignment: Alignment.center,
                    // height: scHeight / 2.5,
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
                  final sosListData = snapshot.data;

                  return Expanded(
                    flex: 11,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 5, top: 20),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          for (int i = 0; i < statusList.length; i++) {
                            var id = statusList[i]['id'] as int;
                            switch (id) {
                              case 1:
                                submitted = statusList[i]['color'];
                                break;
                              case 3:
                                inProcess = statusList[i]['color'];
                                break;
                              case 4:
                                pending = statusList[i]['color'];
                                break;
                              case 5:
                                resolved = statusList[i]['color'];
                                break;
                              case 6:
                                closed = statusList[i]['color'];
                                break;
                              case 7:
                                reOpen = statusList[i]['color'];
                                break;
                              case 8:
                                cancel = statusList[i]['color'];
                                break;
                              case 9:
                                tesForwarded = statusList[i]['color'];
                                break;
                            }
                          }

                          for (int i = j;
                              i < sosListData.dataArray[index].actions.length;
                              i++) {
                            j = i;
                          }

                          //Date Filter
                          // DateTime dateFil = DateTime.parse(dateFilter);
                          // String dateFormatFil =
                          //     DateFormat("yyyy-dd-MM").format(dateFilter!);

                          String? dateFormatFil = dateFilter != null
                              ? DateFormat("yyyy-dd-MM").format(dateFilter!)
                              : null; // Provide a default value or handle the null case as needed

                          print("Formatted Date: $dateFormatFil");

                          // print("Date Filter " + dateFormatFil);

                          ////Api Date
                          // print("Before Api Date " +
                          //     sosListData.dataArray[index].created);
                          final daty = parseCustomDate(
                              sosListData.dataArray[index].created);
                          String dateFormatApi =
                              DateFormat("yyyy-dd-MM").format(daty);

                          // print("After Api Date " + dateFormatApi);

                          if ((sosListData.dataArray[index].reference
                                      .toLowerCase() ==
                                  ref.toLowerCase()) &&
                              (statusFilter.toLowerCase() ==
                                  sosListData.dataArray[index].status
                                      .toLowerCase()) &&
                              (typeSelect.toLowerCase() ==
                                  sosListData.dataArray[index].name
                                      .toLowerCase()) &&
                              (dateFormatApi == dateFormatFil)) {
                            print("Condition 1");
                            return SosListWidget(
                              index: index,
                              sosCreatedAt:
                                  sosListData.dataArray[index].createdAt,
                              sosStatus:
                                  sosListData.dataArray[index].status.isNotEmpty
                                      ? sosListData.dataArray[index].status
                                      : 'No Comment',
                              sosComment: sosListData.dataArray[index]
                                      .actions[0].comments.isNotEmpty
                                  ? sosListData.dataArray[index].actions[0]
                                      .comments[0].comment
                                  : 'No Comment',
                              sosDay:
                                  sosListData.dataArray[index].created ?? '',
                              sosRefNo:
                                  sosListData.dataArray[index].reference ?? '',
                              sosComplainStatus:
                                  sosListData.dataArray[index].status ?? '',
                              sosType: sosListData.dataArray[index].name ?? '',
                              sosCreatedTime:
                                  sosListData.dataArray[index].created ?? '',
                              colorComplait: sosListData
                                          .dataArray[index].status ==
                                      "Submitted"
                                  ? HexColor.fromHex(submitted)
                                  : sosListData.dataArray[index].status ==
                                          "In Process"
                                      ? HexColor.fromHex(inProcess)
                                      : sosListData.dataArray[index].status ==
                                              "Closed"
                                          ? HexColor.fromHex(closed)
                                          : sosListData.dataArray[index]
                                                      .status ==
                                                  "Pending"
                                              ? HexColor.fromHex(pending)
                                              : sosListData.dataArray[index]
                                                          .status ==
                                                      "Resolved"
                                                  ? HexColor.fromHex(resolved)
                                                  : sosListData.dataArray[index]
                                                              .status ==
                                                          "Reopen"
                                                      ? HexColor.fromHex(reOpen)
                                                      : sosListData
                                                                  .dataArray[
                                                                      index]
                                                                  .status ==
                                                              "Cancel"
                                                          ? HexColor.fromHex(
                                                              cancel)
                                                          : HexColor.fromHex(
                                                              tesForwarded),
                            );
                          } else if ((ref.toLowerCase() ==
                              sosListData.dataArray[index].reference
                                  .toLowerCase())) {
                            print("Condition 2");
                            return ((statusFilter == "null" ||
                                        statusFilter.toLowerCase() ==
                                            sosListData.dataArray[index].status
                                                .toLowerCase()) &&
                                    (typeSelect == "null" ||
                                        typeSelect.toLowerCase() ==
                                            sosListData.dataArray[index].name
                                                .toLowerCase()) &&
                                    (dateFormatApi == dateFormatFil))
                                ? SosListWidget(
                                    index: index,
                                    sosCreatedAt:
                                        sosListData.dataArray[index].createdAt,
                                    sosStatus: sosListData
                                            .dataArray[index].status.isNotEmpty
                                        ? sosListData.dataArray[index].status
                                        : 'No Comment',
                                    sosComment: sosListData.dataArray[index]
                                            .actions[0].comments.isNotEmpty
                                        ? sosListData.dataArray[index]
                                            .actions[0].comments[0].comment
                                        : 'No Comment',
                                    sosDay:
                                        sosListData.dataArray[index].created ??
                                            '',
                                    sosRefNo: sosListData
                                            .dataArray[index].reference ??
                                        '',
                                    sosComplainStatus:
                                        sosListData.dataArray[index].status ??
                                            '',
                                    sosType:
                                        sosListData.dataArray[index].name ?? '',
                                    sosCreatedTime:
                                        sosListData.dataArray[index].created ??
                                            '',
                                    colorComplait: sosListData
                                                .dataArray[index].status ==
                                            "Submitted"
                                        ? HexColor.fromHex(submitted)
                                        : sosListData.dataArray[index].status ==
                                                "In Process"
                                            ? HexColor.fromHex(inProcess)
                                            : sosListData.dataArray[index]
                                                        .status ==
                                                    "Closed"
                                                ? HexColor.fromHex(closed)
                                                : sosListData.dataArray[index]
                                                            .status ==
                                                        "Pending"
                                                    ? HexColor.fromHex(pending)
                                                    : sosListData
                                                                .dataArray[
                                                                    index]
                                                                .status ==
                                                            "Resolved"
                                                        ? HexColor.fromHex(
                                                            resolved)
                                                        : sosListData
                                                                    .dataArray[
                                                                        index]
                                                                    .status ==
                                                                "Reopen"
                                                            ? HexColor.fromHex(
                                                                reOpen)
                                                            : sosListData
                                                                        .dataArray[
                                                                            index]
                                                                        .status ==
                                                                    "Cancel"
                                                                ? HexColor
                                                                    .fromHex(
                                                                        cancel)
                                                                : HexColor.fromHex(
                                                                    tesForwarded),
                                  )
                                : Container();
                          } else if ((statusFilter.toLowerCase() ==
                              sosListData.dataArray[index].status
                                  .toLowerCase())) {
                            print("Condition 3");
                            return ((ref.isEmpty ||
                                        ref.toLowerCase() ==
                                            sosListData
                                                .dataArray[index].reference
                                                .toLowerCase()) &&
                                    (typeSelect == "null" ||
                                        typeSelect.toLowerCase() ==
                                            sosListData.dataArray[index].name
                                                .toLowerCase()) &&
                                    (dateFormatApi == dateFormatFil))
                                ? SosListWidget(
                                    index: index,
                                    sosCreatedAt:
                                        sosListData.dataArray[index].createdAt,
                                    sosStatus: sosListData
                                            .dataArray[index].status.isNotEmpty
                                        ? sosListData.dataArray[index].status
                                        : 'No Comment',
                                    sosComment: sosListData.dataArray[index]
                                            .actions[0].comments.isNotEmpty
                                        ? sosListData.dataArray[index]
                                            .actions[0].comments[0].comment
                                        : 'No Comment',
                                    sosDay:
                                        sosListData.dataArray[index].created ??
                                            '',
                                    sosRefNo: sosListData
                                            .dataArray[index].reference ??
                                        '',
                                    sosComplainStatus:
                                        sosListData.dataArray[index].status ??
                                            '',
                                    sosType:
                                        sosListData.dataArray[index].name ?? '',
                                    sosCreatedTime:
                                        sosListData.dataArray[index].created ??
                                            '',
                                    colorComplait: sosListData
                                                .dataArray[index].status ==
                                            "Submitted"
                                        ? HexColor.fromHex(submitted)
                                        : sosListData.dataArray[index].status ==
                                                "In Process"
                                            ? HexColor.fromHex(inProcess)
                                            : sosListData.dataArray[index]
                                                        .status ==
                                                    "Closed"
                                                ? HexColor.fromHex(closed)
                                                : sosListData.dataArray[index]
                                                            .status ==
                                                        "Pending"
                                                    ? HexColor.fromHex(pending)
                                                    : sosListData
                                                                .dataArray[
                                                                    index]
                                                                .status ==
                                                            "Resolved"
                                                        ? HexColor.fromHex(
                                                            resolved)
                                                        : sosListData
                                                                    .dataArray[
                                                                        index]
                                                                    .status ==
                                                                "Reopen"
                                                            ? HexColor.fromHex(
                                                                reOpen)
                                                            : sosListData
                                                                        .dataArray[
                                                                            index]
                                                                        .status ==
                                                                    "Cancel"
                                                                ? HexColor
                                                                    .fromHex(
                                                                        cancel)
                                                                : HexColor.fromHex(
                                                                    tesForwarded),
                                  )
                                : Container();
                          } else if ((typeSelect.toLowerCase() ==
                              sosListData.dataArray[index].name
                                  .toLowerCase())) {
                            print("Condition 4");
                            return ((ref.isEmpty ||
                                        ref.toLowerCase() ==
                                            sosListData
                                                .dataArray[index].reference
                                                .toLowerCase()) &&
                                    (statusFilter == "null" ||
                                        statusFilter.toLowerCase() ==
                                            sosListData.dataArray[index].status
                                                .toLowerCase()) &&
                                    (dateFormatApi == dateFormatFil))
                                ? SosListWidget(
                                    index: index,
                                    sosCreatedAt:
                                        sosListData.dataArray[index].createdAt,
                                    sosStatus: sosListData
                                            .dataArray[index].status.isNotEmpty
                                        ? sosListData.dataArray[index].status
                                        : 'No Comment',
                                    sosComment: sosListData.dataArray[index]
                                            .actions[0].comments.isNotEmpty
                                        ? sosListData.dataArray[index]
                                            .actions[0].comments[0].comment
                                        : 'No Comment',
                                    sosDay:
                                        sosListData.dataArray[index].created ??
                                            '',
                                    sosRefNo: sosListData
                                            .dataArray[index].reference ??
                                        '',
                                    sosComplainStatus:
                                        sosListData.dataArray[index].status ??
                                            '',
                                    sosType:
                                        sosListData.dataArray[index].name ?? '',
                                    sosCreatedTime:
                                        sosListData.dataArray[index].created ??
                                            '',
                                    colorComplait: sosListData
                                                .dataArray[index].status ==
                                            "Submitted"
                                        ? HexColor.fromHex(submitted)
                                        : sosListData.dataArray[index].status ==
                                                "In Process"
                                            ? HexColor.fromHex(inProcess)
                                            : sosListData.dataArray[index]
                                                        .status ==
                                                    "Closed"
                                                ? HexColor.fromHex(closed)
                                                : sosListData.dataArray[index]
                                                            .status ==
                                                        "Pending"
                                                    ? HexColor.fromHex(pending)
                                                    : sosListData
                                                                .dataArray[
                                                                    index]
                                                                .status ==
                                                            "Resolved"
                                                        ? HexColor.fromHex(
                                                            resolved)
                                                        : sosListData
                                                                    .dataArray[
                                                                        index]
                                                                    .status ==
                                                                "Reopen"
                                                            ? HexColor.fromHex(
                                                                reOpen)
                                                            : sosListData
                                                                        .dataArray[
                                                                            index]
                                                                        .status ==
                                                                    "Cancel"
                                                                ? HexColor
                                                                    .fromHex(
                                                                        cancel)
                                                                : HexColor.fromHex(
                                                                    tesForwarded),
                                  )
                                : Container();
                          } else if ((dateFormatApi == dateFormatFil)) {
                            print("Condition 5");
                            return ((ref.isEmpty ||
                                        ref.toLowerCase() ==
                                            sosListData
                                                .dataArray[index].reference
                                                .toLowerCase()) &&
                                    (typeSelect == "null" ||
                                        typeSelect.toLowerCase() ==
                                            sosListData.dataArray[index].name
                                                .toLowerCase()) &&
                                    (statusFilter == "null" ||
                                        statusFilter.toLowerCase() ==
                                            sosListData.dataArray[index].status
                                                .toLowerCase()))
                                ? SosListWidget(
                                    index: index,
                                    sosCreatedAt:
                                        sosListData.dataArray[index].createdAt,
                                    sosStatus: sosListData
                                            .dataArray[index].status.isNotEmpty
                                        ? sosListData.dataArray[index].status
                                        : 'No Comment',
                                    sosComment: sosListData.dataArray[index]
                                            .actions[0].comments.isNotEmpty
                                        ? sosListData.dataArray[index]
                                            .actions[0].comments[0].comment
                                        : 'No Comment',
                                    sosDay:
                                        sosListData.dataArray[index].created ??
                                            '',
                                    sosRefNo: sosListData
                                            .dataArray[index].reference ??
                                        '',
                                    sosComplainStatus:
                                        sosListData.dataArray[index].status ??
                                            '',
                                    sosType:
                                        sosListData.dataArray[index].name ?? '',
                                    sosCreatedTime:
                                        sosListData.dataArray[index].created ??
                                            '',
                                    colorComplait: sosListData
                                                .dataArray[index].status ==
                                            "Submitted"
                                        ? HexColor.fromHex(submitted)
                                        : sosListData.dataArray[index].status ==
                                                "In Process"
                                            ? HexColor.fromHex(inProcess)
                                            : sosListData.dataArray[index]
                                                        .status ==
                                                    "Closed"
                                                ? HexColor.fromHex(closed)
                                                : sosListData.dataArray[index]
                                                            .status ==
                                                        "Pending"
                                                    ? HexColor.fromHex(pending)
                                                    : sosListData
                                                                .dataArray[
                                                                    index]
                                                                .status ==
                                                            "Resolved"
                                                        ? HexColor.fromHex(
                                                            resolved)
                                                        : sosListData
                                                                    .dataArray[
                                                                        index]
                                                                    .status ==
                                                                "Reopen"
                                                            ? HexColor.fromHex(
                                                                reOpen)
                                                            : sosListData
                                                                        .dataArray[
                                                                            index]
                                                                        .status ==
                                                                    "Cancel"
                                                                ? HexColor
                                                                    .fromHex(
                                                                        cancel)
                                                                : HexColor.fromHex(
                                                                    tesForwarded),
                                  )
                                : Container();
                          } else {
                            print("Condition final");
                            return ((ref.isEmpty) &&
                                    ((statusFilter == "null" ||
                                        statusFilter == "")) &&
                                    ((typeSelect == "null" ||
                                        typeSelect == "")) &&
                                    dateFormatFil == null)
                                ? SosListWidget(
                                    index: index,
                                    sosCreatedAt:
                                        sosListData.dataArray[index].createdAt,
                                    sosStatus: sosListData
                                            .dataArray[index].status.isNotEmpty
                                        ? sosListData.dataArray[index].status
                                        : 'No Comment',
                                    sosComment: sosListData.dataArray[index]
                                            .actions[0].comments.isNotEmpty
                                        ? sosListData.dataArray[index]
                                            .actions[0].comments[0].comment
                                        : 'No Comment',
                                    sosDay:
                                        sosListData.dataArray[index].created ??
                                            '',
                                    sosRefNo: sosListData
                                            .dataArray[index].reference ??
                                        '',
                                    sosComplainStatus:
                                        sosListData.dataArray[index].status ??
                                            '',
                                    sosType:
                                        sosListData.dataArray[index].name ?? '',
                                    sosCreatedTime:
                                        sosListData.dataArray[index].created ??
                                            '',
                                    colorComplait: sosListData
                                                .dataArray[index].status ==
                                            "Submitted"
                                        ? HexColor.fromHex(
                                            submitted ?? appcolorHex)
                                        : sosListData.dataArray[index].status ==
                                                "In Process"
                                            ? HexColor.fromHex(
                                                inProcess ?? appcolorHex)
                                            : sosListData.dataArray[index]
                                                        .status ==
                                                    "Closed"
                                                ? HexColor.fromHex(
                                                    closed ?? appcolorHex)
                                                : sosListData.dataArray[index]
                                                            .status ==
                                                        "Pending"
                                                    ? HexColor.fromHex(
                                                        pending ?? appcolorHex)
                                                    : sosListData.dataArray[index].status ==
                                                            "Resolved"
                                                        ? HexColor.fromHex(
                                                            resolved ??
                                                                appcolorHex)
                                                        : sosListData
                                                                    .dataArray[index]
                                                                    .status ==
                                                                "Reopen"
                                                            ? HexColor.fromHex(reOpen ?? appcolorHex)
                                                            : sosListData.dataArray[index].status == "Cancel"
                                                                ? HexColor.fromHex(cancel ?? appcolorHex)
                                                                : HexColor.fromHex(tesForwarded ?? appcolorHex),
                                  )
                                : Container();
                          }
                        },
                        itemCount: sosListData!.dataArray.length,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
