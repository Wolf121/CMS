import 'dart:convert';

import 'package:dha_resident_app/constant.dart';
import 'package:dha_resident_app/view/widgets/staff_search_filter.dart';
import 'package:flutter/material.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../widgets/custom_dialog.dart';
import '../../widgets/manage_list_widget.dart';

class ManageStaff extends StatefulWidget {
  @override
  State<ManageStaff> createState() => _ManageStaffState();
}

class _ManageStaffState extends State<ManageStaff> {
  List<Map<String, dynamic>> manageStaff = [];
  bool isLoading = true;
  bool _isLoading = true;
  String nameFil = '';
  String cnicFil = '';
  String phoneFil = '';
  String statusFil = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchManageStaffData();
    bool isLoading = false;
    // loadManageStaffFromPrefs();
  }

  // getting data from api and storing in the sharedPref
  Future<void> fetchManageStaffData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    Uri apiUrl = Uri.parse('http://110.93.244.74/api/staff/staff_list');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(apiUrl, headers: headers);

      if (response.statusCode == 200) {
        _isLoading = false;
        Map<String, dynamic> responseData = json.decode(response.body);
        // prefs.setString('manageStaffData', json.encode(responseData));

        final manageStaffArray = responseData['data_array'] as List<dynamic>;

        setState(() {
          manageStaff = manageStaffArray.cast<Map<String, dynamic>>();
        });

        print('Manage data saved in state.');
      } else {
        _isLoading = false;
        print('Failed to fetch staff data: ${response.reasonPhrase}');
      }
    } catch (error) {
      _isLoading = false;
      print('Error fetching staff data: $error');
    }
  }

  //call back filter fuction
  void SearchStaff(String newName, newCnin, newPhone, newStatus) {
    nameFil = newName;
    cnicFil = newCnin;
    phoneFil = newPhone;
    statusFil = newStatus;
    setState(() {
      print("Just came: " + newName);
      print("Just came: " + newCnin);
      print("Just came: " + newPhone);
      print("Just came: " + newStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This controller will store the value of the search bar
    final TextEditingController _searchController = TextEditingController();
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
        body: OverlayLoaderWithAppIcon(
          overlayBackgroundColor: Colors.transparent,
          isLoading: _isLoading,
          appIcon: CircularProgressIndicator(),
          child: Container(
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
                    "Staff List",
                    style:
                        TextStyle(color: dfColor, fontWeight: FontWeight.w700),
                  ),
                ),
                StaffFilterSearch(onSearchStaff: SearchStaff),
                Expanded(
                  flex: 11,
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: 5, top: 20, left: marginLR, right: marginLR),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        print("Type: " + statusFil.toLowerCase());

                        if ((manageStaff[index]['name']
                                    .toString()
                                    .toLowerCase() ==
                                nameFil.toLowerCase()) &&
                            (manageStaff[index]['cnic'] == cnicFil) &&
                            (manageStaff[index]['mobile_1'] == phoneFil) &&
                            (manageStaff[index]['category']
                                    .toString()
                                    .toLowerCase() ==
                                statusFil.toLowerCase())) {
                          print("Condition 1");
                          return ManageListWidget(
                            staffuid: manageStaff[index]['uid'],
                            staffRequestDelete: manageStaff[index]
                                ['request_to_delete'],
                            Loading: isLoading,
                            staffImage: manageStaff[index]['pic'],
                            staffName: manageStaff[index]['name'] ?? "N/A",
                            staffFatherName:
                                manageStaff[index]['father_name'] ?? "N/A",
                            staffStatus: manageStaff[index]['status'] ?? "N/A",
                            staffCnic: manageStaff[index]['cnic'] ?? "N/A",
                            staffDob:
                                manageStaff[index]['date_of_birth'] ?? "N/A",
                            staffGender: manageStaff[index]['gender'] ?? "N/A",
                            staffShift: manageStaff[index]['shift'] ?? "N/A",
                            staffDescp:
                                manageStaff[index]['description'] ?? "N/A",
                            staffmobile:
                                manageStaff[index]['mobile_1'] ?? "N/A",
                            staffLandline:
                                manageStaff[index]['mobile_2'] ?? "N/A",
                            staffPosition:
                                manageStaff[index]['category'] ?? "N/A",
                            staffFCnicImg: manageStaff[index]['cnic_pic_1'],
                            staffBCnicImg: manageStaff[index]['cnic_pic_2'],
                            // currentTime: time,
                          );
                        } else if ((manageStaff[index]['name']
                                .toString()
                                .toLowerCase() ==
                            nameFil.toLowerCase())) {
                          print("Condition 2");

                          return ((cnicFil.isEmpty) ||
                                      (manageStaff[index]['cnic'] ==
                                          cnicFil)) &&
                                  ((phoneFil.isEmpty) ||
                                      (manageStaff[index]['mobile_1'] ==
                                          phoneFil)) &&
                                  (statusFil.isEmpty ||
                                      (manageStaff[index]['category']
                                              .toString()
                                              .toLowerCase() ==
                                          statusFil.toLowerCase()))
                              ? ManageListWidget(
                                  staffuid: manageStaff[index]['uid'],
                                  staffRequestDelete: manageStaff[index]
                                      ['request_to_delete'],
                                  Loading: isLoading,
                                  staffImage: manageStaff[index]['pic'],
                                  staffName:
                                      manageStaff[index]['name'] ?? "N/A",
                                  staffFatherName: manageStaff[index]
                                          ['father_name'] ??
                                      "N/A",
                                  staffStatus:
                                      manageStaff[index]['status'] ?? "N/A",
                                  staffCnic:
                                      manageStaff[index]['cnic'] ?? "N/A",
                                  staffDob: manageStaff[index]
                                          ['date_of_birth'] ??
                                      "N/A",
                                  staffGender:
                                      manageStaff[index]['gender'] ?? "N/A",
                                  staffShift:
                                      manageStaff[index]['shift'] ?? "N/A",
                                  staffDescp: manageStaff[index]
                                          ['description'] ??
                                      "N/A",
                                  staffmobile:
                                      manageStaff[index]['mobile_1'] ?? "N/A",
                                  staffLandline:
                                      manageStaff[index]['mobile_2'] ?? "N/A",
                                  staffPosition:
                                      manageStaff[index]['category'] ?? "N/A",
                                  staffFCnicImg: manageStaff[index]
                                      ['cnic_pic_1'],
                                  staffBCnicImg: manageStaff[index]
                                      ['cnic_pic_2'],
                                  // currentTime: time,
                                )
                              : Container();
                        } else if ((manageStaff[index]['cnic'] == cnicFil)) {
                          print("Condition 3");

                          return (nameFil.isEmpty ||
                                      (manageStaff[index]['name']
                                              .toString()
                                              .toLowerCase() ==
                                          nameFil.toLowerCase())) &&
                                  ((phoneFil.isEmpty) ||
                                      (manageStaff[index]['mobile_1'] ==
                                          phoneFil)) &&
                                  (statusFil.isEmpty ||
                                      (manageStaff[index]['category']
                                              .toString()
                                              .toLowerCase() ==
                                          statusFil.toLowerCase()))
                              ? ManageListWidget(
                                  staffuid: manageStaff[index]['uid'],
                                  staffRequestDelete: manageStaff[index]
                                      ['request_to_delete'],
                                  Loading: isLoading,
                                  staffImage: manageStaff[index]['pic'],
                                  staffName:
                                      manageStaff[index]['name'] ?? "N/A",
                                  staffFatherName: manageStaff[index]
                                          ['father_name'] ??
                                      "N/A",
                                  staffStatus:
                                      manageStaff[index]['status'] ?? "N/A",
                                  staffCnic:
                                      manageStaff[index]['cnic'] ?? "N/A",
                                  staffDob: manageStaff[index]
                                          ['date_of_birth'] ??
                                      "N/A",
                                  staffGender:
                                      manageStaff[index]['gender'] ?? "N/A",
                                  staffShift:
                                      manageStaff[index]['shift'] ?? "N/A",
                                  staffDescp: manageStaff[index]
                                          ['description'] ??
                                      "N/A",
                                  staffmobile:
                                      manageStaff[index]['mobile_1'] ?? "N/A",
                                  staffLandline:
                                      manageStaff[index]['mobile_2'] ?? "N/A",
                                  staffPosition:
                                      manageStaff[index]['category'] ?? "N/A",
                                  staffFCnicImg: manageStaff[index]
                                      ['cnic_pic_1'],
                                  staffBCnicImg: manageStaff[index]
                                      ['cnic_pic_2'],
                                  // currentTime: time,
                                )
                              : Container();
                        } else if ((manageStaff[index]['mobile_1'] ==
                            phoneFil)) {
                          print("Condition 4");

                          return (nameFil.isEmpty ||
                                      (manageStaff[index]['name']
                                              .toString()
                                              .toLowerCase() ==
                                          nameFil.toLowerCase())) &&
                                  ((cnicFil.isEmpty) ||
                                      (manageStaff[index]['cnic'] ==
                                          cnicFil)) &&
                                  (statusFil.isEmpty ||
                                      (manageStaff[index]['category']
                                              .toString()
                                              .toLowerCase() ==
                                          statusFil.toLowerCase()))
                              ? ManageListWidget(
                                  staffuid: manageStaff[index]['uid'],
                                  staffRequestDelete: manageStaff[index]
                                      ['request_to_delete'],
                                  Loading: isLoading,
                                  staffImage: manageStaff[index]['pic'],
                                  staffName:
                                      manageStaff[index]['name'] ?? "N/A",
                                  staffFatherName: manageStaff[index]
                                          ['father_name'] ??
                                      "N/A",
                                  staffStatus:
                                      manageStaff[index]['status'] ?? "N/A",
                                  staffCnic:
                                      manageStaff[index]['cnic'] ?? "N/A",
                                  staffDob: manageStaff[index]
                                          ['date_of_birth'] ??
                                      "N/A",
                                  staffGender:
                                      manageStaff[index]['gender'] ?? "N/A",
                                  staffShift:
                                      manageStaff[index]['shift'] ?? "N/A",
                                  staffDescp: manageStaff[index]
                                          ['description'] ??
                                      "N/A",
                                  staffmobile:
                                      manageStaff[index]['mobile_1'] ?? "N/A",
                                  staffLandline:
                                      manageStaff[index]['mobile_2'] ?? "N/A",
                                  staffPosition:
                                      manageStaff[index]['category'] ?? "N/A",
                                  staffFCnicImg: manageStaff[index]
                                      ['cnic_pic_1'],
                                  staffBCnicImg: manageStaff[index]
                                      ['cnic_pic_2'],
                                  // currentTime: time,
                                )
                              : Container();
                        } else if ((manageStaff[index]['category']
                                .toString()
                                .toLowerCase() ==
                            statusFil.toLowerCase())) {
                          print("Condition 5");

                          return (nameFil.isEmpty ||
                                      (manageStaff[index]['name']
                                              .toString()
                                              .toLowerCase() ==
                                          nameFil.toLowerCase())) &&
                                  ((cnicFil.isEmpty) ||
                                      (manageStaff[index]['cnic'] ==
                                          cnicFil)) &&
                                  ((phoneFil.isEmpty) ||
                                      (manageStaff[index]['mobile_1'] ==
                                          phoneFil))
                              ? ManageListWidget(
                                  staffuid: manageStaff[index]['uid'],
                                  staffRequestDelete: manageStaff[index]
                                      ['request_to_delete'],
                                  Loading: isLoading,
                                  staffImage: manageStaff[index]['pic'],
                                  staffName:
                                      manageStaff[index]['name'] ?? "N/A",
                                  staffFatherName: manageStaff[index]
                                          ['father_name'] ??
                                      "N/A",
                                  staffStatus:
                                      manageStaff[index]['status'] ?? "N/A",
                                  staffCnic:
                                      manageStaff[index]['cnic'] ?? "N/A",
                                  staffDob: manageStaff[index]
                                          ['date_of_birth'] ??
                                      "N/A",
                                  staffGender:
                                      manageStaff[index]['gender'] ?? "N/A",
                                  staffShift:
                                      manageStaff[index]['shift'] ?? "N/A",
                                  staffDescp: manageStaff[index]
                                          ['description'] ??
                                      "N/A",
                                  staffmobile:
                                      manageStaff[index]['mobile_1'] ?? "N/A",
                                  staffLandline:
                                      manageStaff[index]['mobile_2'] ?? "N/A",
                                  staffPosition:
                                      manageStaff[index]['category'] ?? "N/A",
                                  staffFCnicImg: manageStaff[index]
                                      ['cnic_pic_1'],
                                  staffBCnicImg: manageStaff[index]
                                      ['cnic_pic_2'],
                                  // currentTime: time,
                                )
                              : Container();
                        } else {
                          print("Else Case");
                          return nameFil != "" ||
                                  cnicFil != "" ||
                                  phoneFil != "" ||
                                  statusFil != ""
                              ? Container()
                              : ManageListWidget(
                                  staffuid: manageStaff[index]['uid'],
                                  staffRequestDelete: manageStaff[index]
                                      ['request_to_delete'],
                                  Loading: isLoading,
                                  staffImage: manageStaff[index]['pic'],
                                  staffName:
                                      manageStaff[index]['name'] ?? "N/A",
                                  staffFatherName: manageStaff[index]
                                          ['father_name'] ??
                                      "N/A",
                                  staffStatus:
                                      manageStaff[index]['status'] ?? "N/A",
                                  staffCnic:
                                      manageStaff[index]['cnic'] ?? "N/A",
                                  staffDob: manageStaff[index]
                                          ['date_of_birth'] ??
                                      "N/A",
                                  staffGender:
                                      manageStaff[index]['gender'] ?? "N/A",
                                  staffShift:
                                      manageStaff[index]['shift'] ?? "N/A",
                                  staffDescp: manageStaff[index]
                                          ['description'] ??
                                      "N/A",
                                  staffmobile:
                                      manageStaff[index]['mobile_1'] ?? "N/A",
                                  staffLandline:
                                      manageStaff[index]['mobile_2'] ?? "N/A",
                                  staffPosition:
                                      manageStaff[index]['category'] ?? "N/A",
                                  staffFCnicImg: manageStaff[index]
                                      ['cnic_pic_1'],
                                  staffBCnicImg: manageStaff[index]
                                      ['cnic_pic_2'],
                                  // currentTime: time,
                                );
                        }
                      },
                      itemCount: manageStaff.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
