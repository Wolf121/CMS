import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dha_resident_app/view/widgets/color_widget.dart';
import 'package:dha_resident_app/view/widgets/custom_app_bar.dart';
import 'package:dha_resident_app/view_model/chart_model/chart_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_button/group_button.dart';
import 'package:http/http.dart' as http;
import 'package:dha_resident_app/constant.dart';
import 'package:dha_resident_app/view_model/complaint_state_model/complaint_list_long_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class CompalintDetailWidget extends StatefulWidget {
  final String userId;

  const CompalintDetailWidget({
    required this.userId,
  });

  @override
  State<CompalintDetailWidget> createState() => _CompalintDetailWidgetState();
}

class _CompalintDetailWidgetState extends State<CompalintDetailWidget> {
  //track variales

  String uid1 = "";
  String ratingg = "";
  String feedback = "";
  String lat = '0.0';
  String lng = '0.0';
  String status = '';
  bool rateYes = false;
  bool ratePartialy = false;
  bool rateNo = false;
  TextEditingController textEditingController = TextEditingController();

  List<ChartDataArray> fetchChartModel = [];
  List<ChartDataArray> allChartModel = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation();
    fetchComplaintListLongDetailModel();
    getChartComplaintFromSharedPreferences();
    print('complaint details user id ' + widget.userId);
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

  //getting data from api complaint Detail
  Future<ComplaintDetailModel> fetchComplaintListLongDetailModel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(
      Uri.parse(
          'http://110.93.244.74/api/complaint/complaint_detail/${widget.userId}'),
      headers: headers,
    );

    // Print the entire response body
    print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check if the 'status' field exists in the JSON
      if (responseData.containsKey('status')) {
        final String status = responseData['status'];
        print('Status: $status');
      } else {
        print('Status field not found in JSON response.');
      }

      return ComplaintDetailModel.fromJson(responseData);
    } else {
      throw Exception('Failed to load data');
    }
  }

  ///------------------------Resolved--------------------///

  Future<void> Resolved({
    required String uid,
    required String comment,
  }) async {
    // Retrieve the token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      // Handle the case where the token is not available
      print('Token not found in SharedPreferences');
      return;
    }

    // API endpoint URL
    final apiUrl = 'http://110.93.244.74/api/complaint/complaint_resolved';

    // Create a map of data to send in the request body
    final Map<String, String> data = {
      'uid': uid,
      'comment': comment,
    };

    // Encode the data as JSON
    final jsonData = jsonEncode(data);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the token in the headers
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        // Successful POST request
        print('Data posted successfully' + response.body);
        waitTwoSeconds();
        funToast(
            "Complaint Marked As Resolved!", Colors.green, ToastGravity.BOTTOM);
      } else {
        // Handle the API response for other status codes
        funToast("Somthing went Wrong! Complait Not Resolved!", Colors.red,
            ToastGravity.BOTTOM);
        print('Failed to post data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle any network or API request errors
      print('Error posting data: $e');
    }
  }

// delay for few
  Future<void> waitTwoSeconds() async {
    // Use Future.delayed to wait for two seconds
    await Future.delayed(Duration(seconds: 2));

    // Code execution resumes after the two-second delay
    print('Two seconds have passed!');
  }

  //////------------------///////////////
  Future<void> CancelComplaint(String uid, String comment) async {
    // Define the API endpoint
    final apiUrl = 'http://110.93.244.74/api/complaint/complaint_cancel';

    // Retrieve the authentication token from shared preferences
    final prefs = await SharedPreferences.getInstance();
    final authToken =
        prefs.getString('token'); // Replace 'authToken' with your token key

    // Create a Map containing the data to be sent in the request body
    final Map<String, dynamic> data = {
      'uid': uid,
      'comment': comment,
    };

    // Encode the data as JSON
    final jsonData = jsonEncode(data);

    try {
      // Send a POST request to the API with the authentication token in the headers
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json', // Specify JSON content type
          'Authorization':
              'Bearer $authToken', // Include the token in the headers
        },
        body: jsonData, // Send the JSON-encoded data in the request body
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the response JSON
        final responseData = jsonDecode(response.body);

        // Extract and print the message
        final message = responseData['message'];
        funToast(message, Colors.green, ToastGravity.BOTTOM);
        print('Response Message: $message');
      } else {
        // If the request was not successful, print the error message
        print('Request failed with status: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    } catch (error) {
      // Handle any exceptions that may occur during the request
      print('Error: $error');
    }
  }

  void funToast(String ToastMessage, Color custcolor, ToastGravity) {
    Fluttertoast.showToast(
        msg: ToastMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity,
        timeInSecForIosWeb: 1,
        backgroundColor: custcolor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  ////--------------lat&lng-----------//

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        lat = position.latitude.toString();
        lng = position.longitude.toString();
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  ///------------------------feedBack--------------///
  Future<void> feedBack({
    required String userId,
    required String rating,
    required String feedback,
    required String lat,
    required String lng,
    required String status,
  }) async {
    // Retrieve the token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      // Handle the case where the token is not available
      print('Token not found in SharedPreferences');
      return;
    }

    // API endpoint URL
    final apiUrl = 'http://110.93.244.74/api/complaint/complaint_feedback';

    // Create a map of data to send in the request body
    switch (status) {
      case "0":
        status = "Yes";
      case "1":
        status = "Partially";
      case "2":
        status = "No";
    }
    print("uid: " + userId);
    print("rating: " + rating);
    print("feedBack: " + feedback);
    print("lat: " + lat);
    print("lng: " + lng);
    print("status: " + status);
    final Map<String, String> data = {
      'uid': userId,
      'rating': rating,
      'feedback': feedback,
      'lat': lat,
      'lng': lng,
      'status': status,
    };

    // Encode the data as JSON
    final jsonData = jsonEncode(data);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the token in the headers
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        // Successful POST request
        waitTwoSeconds();
        print('Data posted successfully' + response.body);
        funToast("Feedback Submitted", Colors.green, ToastGravity.BOTTOM);
        textEditingController.text = "";
      } else {
        // Handle the API response for other status codes
        print('Failed to post data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle any network or API request errors
      print('Error posting data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    // final controller = GroupButtonController();

    ///Custom Dialog
    _showCustomImgDialog(String imageNew) {
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
                ),
                // padding: EdgeInsets.all(5),
                child: IconButton(
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              contentPadding: EdgeInsets.zero,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: InstaImageViewer(
                      child: Image.network(
                        imageNew,
                        width: scWidth,
                        // fit: BoxFit.fill,
                        errorBuilder: (context, exception, stackTrace) {
                          return Image.asset("asserts/icons/icon.png");
                        },
                        // height: scHeight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      );
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
                decoration: BoxDecoration(
                    color: appcolor,
                    image: DecorationImage(
                        opacity: 0.2,
                        alignment: Alignment.bottomCenter,
                        image: AssetImage(
                          "asserts/images/building.png",
                        ))),
                padding: EdgeInsets.all(0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              content: Container(
                height: scHeight / 2.3,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Image.asset(
                          "asserts/images/rate.png",
                          width: scWidth / 3.5,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: RatingBar.builder(
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: appcolor,
                          ),
                          onRatingUpdate: (rating) {
                            ratingg = rating.toString();
                          },
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  // Icon(
                                  //   Icons.subdirectory_arrow_right_outlined,
                                  //   color: appcolor,
                                  // ),
                                  Container(
                                    width: scWidth / 1.7,
                                    child: Text(
                                      'Rate our service and give feedback comments',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      softWrap: true,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: appcolor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextFormField(
                              controller: textEditingController,
                              textInputAction: TextInputAction.next,
                              autofocus: false,
                              minLines: 1,
                              maxLength: 500,
                              maxLines: 5,
                              style:
                                  TextStyle(fontSize: 19.0, color: blackColor),
                              decoration: InputDecoration(
                                hintText: "Please write your reason here...",
                                hintStyle:
                                    TextStyle(color: blackColor, fontSize: 12),
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
                                feedback = textEditingController.text;
                              },
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  // Icon(
                                  //   Icons.subdirectory_arrow_right_outlined,
                                  //   color: appcolor,
                                  // ),
                                  Text(
                                    'Was your complaint resolved?',
                                    style: TextStyle(
                                        color: appcolor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GroupButton(
                                    isRadio: true,
                                    onSelected: (index, isSelected) {
                                      status = "$index";
                                    },
                                    direction: Axis.horizontal,
                                    spacing: 5,
                                    // controller: controller,
                                    selectedColor: appcolor,
                                    unselectedBorderColor: appcolor,
                                    selectedTextStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: dfColor,
                                    ),
                                    unselectedTextStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: appcolor,
                                    ),
                                    buttons: [
                                      "Yes",
                                      "Partially",
                                      "No",
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
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
                          if (ratingg.isEmpty ||
                              feedback.isEmpty ||
                              status.isEmpty) {
                            funToast(
                                "Please Write A FeedBack And Rate The Service!",
                                appcolor,
                                ToastGravity.BOTTOM);
                          } else {
                            feedBack(
                                userId: widget.userId,
                                rating: ratingg,
                                feedback: feedback,
                                lat: lat,
                                lng: lng,
                                status: status);
                            Navigator.of(context).pop();

                            setState(() {
                              fetchComplaintListLongDetailModel();
                            });
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
                      margin: EdgeInsets.only(top: 20),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      );
    }

    Future<void> _refreash() async {
      fetchComplaintListLongDetailModel();
    }

/////Color-----

    Color statusResolve =
        HexColor.fromHex(allChartModel[4].color.toString() ?? appcolorHex);
    Color statusCancel =
        HexColor.fromHex(allChartModel[7].color.toString() ?? appcolorHex);

    return Scaffold(
      appBar: CustomAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreash,
        child: FutureBuilder<ComplaintDetailModel>(
            future: fetchComplaintListLongDetailModel(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final complaintLongModel = snapshot.data;
                print(
                    "Complaint Detail:" + complaintLongModel!.dataArray.status);

                print("Action Length: " +
                    complaintLongModel.dataArray.actions.length.toString());
                print("Complaint Detail created :" +
                    complaintLongModel.dataArray.created);
                print("Complaint Detail createdAt:" +
                    complaintLongModel.dataArray.createdAt);

                return SingleChildScrollView(
                  child: Container(
                    color: dfColor,
                    height: scHeight / 1.1,
                    // margin: EdgeInsets.symmetric(horizontal: marginLR),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.antiAlias,
                      children: [
                        //Image Show

                        complaintLongModel.dataArray.image != null ||
                                complaintLongModel.dataArray.image.isNotEmpty
                            ? Positioned(
                                top: marginLR + 14,
                                right: 10,
                                child: Container(
                                  // height: scHeight / 4.5,
                                  child: IconButton(
                                    icon: Image.asset(
                                      'asserts/images/attachments.jpeg',
                                      width: scWidth / 4,
                                      // color: appcolor,
                                    ),
                                    onPressed: () {
                                      _showCustomImgDialog(
                                          complaintLongModel.dataArray.image);
                                      print("Image Press");
                                    },
                                  ),
                                ),
                              )
                            : Container(),

                        Container(
                          height: scHeight,
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: scWidth,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                color: appcolor,
                                child: Text(
                                  "Complaint Details",
                                  style: TextStyle(
                                      color: dfColor,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(marginLR),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: scWidth / 2.2,
                                      height: scHeight / 5.2,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconTextWidget(
                                            color: appcolor,
                                            text: complaintLongModel
                                                .dataArray.reference,
                                            imageIcon:
                                                "asserts/images/refrence.jpeg",
                                          ),
                                          IconTextWidget(
                                            color: appcolor,
                                            text: complaintLongModel
                                                .dataArray.category,
                                            imageIcon:
                                                "asserts/images/category.jpeg",
                                          ),
                                          IconTextWidget(
                                            color: appcolor,
                                            text: complaintLongModel
                                                .dataArray.fellowupName,
                                            imageIcon:
                                                "asserts/images/person.jpeg",
                                          ),
                                          IconTextWidget(
                                            color: appcolor,
                                            text: complaintLongModel
                                                .dataArray.fellowupLandline,
                                            imageIcon:
                                                "asserts/images/cell.jpeg",
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: scWidth / 2.2,
                                      height: scHeight / 5.2,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconTextWidget(
                                            color: appcolor,
                                            text: complaintLongModel
                                                .dataArray.status,
                                            imageIcon:
                                                "asserts/images/status.jpeg",
                                          ),
                                          IconTextWidget(
                                            color: appcolor,
                                            text: complaintLongModel
                                                .dataArray.subcategory,
                                            imageIcon:
                                                "asserts/images/subcategory.jpeg",
                                          ),
                                          IconTextWidget(
                                            color: appcolor,
                                            text: complaintLongModel
                                                .dataArray.fellowupCell,
                                            imageIcon:
                                                "asserts/images/phone.jpeg",
                                          ),
                                          IconTextWidget(
                                            color: appcolor,
                                            text: complaintLongModel
                                                .dataArray.createdAt,
                                            imageIcon:
                                                "asserts/images/calendar.jpeg",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: scWidth,
                                margin: EdgeInsets.symmetric(
                                    horizontal: marginLR - 5),
                                padding: EdgeInsets.symmetric(vertical: 5),
                                color: appcolor,
                                child: Text(
                                  "Actions",
                                  style: TextStyle(
                                      color: dfColor,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              complaintLongModel.dataArray.status !=
                                          'Resolved' ||
                                      complaintLongModel.dataArray.status !=
                                          'Closed' ||
                                      complaintLongModel.dataArray.status !=
                                          'Cancel'
                                  ? Container(
                                      alignment: Alignment.center,
                                      width: scWidth,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: marginLR, vertical: 10),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: marginLR),
                                      child: Row(
                                        mainAxisAlignment: complaintLongModel
                                                    .dataArray.status ==
                                                'Reopen'
                                            ? MainAxisAlignment.spaceEvenly
                                            : MainAxisAlignment.center,
                                        children: [
                                          complaintLongModel.dataArray.status ==
                                                      'Submitted' ||
                                                  complaintLongModel
                                                          .dataArray.status ==
                                                      'Reopen'
                                              ? Container(
                                                  alignment: Alignment.topLeft,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      AwesomeDialog(
                                                        context: context,
                                                        dialogType:
                                                            DialogType.noHeader,
                                                        animType: AnimType
                                                            .bottomSlide,
                                                        title: 'Info',
                                                        desc:
                                                            'Do you want to cancel the Complaint?',
                                                        btnCancel: IconButton(
                                                          onPressed: () {
                                                            print(
                                                                "Nope I wont");
                                                            Navigator.pop(
                                                                context); // Close the dialog
                                                          },
                                                          icon: Image.asset(
                                                            'asserts/icons/cross.png',
                                                            width: 40,
                                                          ),
                                                          color: Colors.red,
                                                        ),
                                                        btnOk: IconButton(
                                                          onPressed: () async {
                                                            CancelComplaint(
                                                                widget.userId,
                                                                "I Want To Cancl The complain.");
                                                            waitTwoSeconds();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          icon: Image.asset(
                                                            'asserts/icons/checked.png',
                                                            width: 40,
                                                          ),
                                                          color: Colors.green,
                                                        ),
                                                      ).show();
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: scWidth / 3.8,
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                          color: statusCancel,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .not_interested_outlined,
                                                            color: dfColor,
                                                            size: 16,
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 5),
                                                            child: Text(
                                                              "Cancel",
                                                              style: TextStyle(
                                                                  color:
                                                                      dfColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(),

                                          //Resolved Action
                                          complaintLongModel.dataArray.status ==
                                                      'Pending' ||
                                                  complaintLongModel
                                                          .dataArray.status ==
                                                      'Reopen' ||
                                                  complaintLongModel
                                                          .dataArray.status ==
                                                      'In Process'
                                              ? Container(
                                                  // margin:
                                                  //     EdgeInsets.only(top: 5),
                                                  alignment: Alignment.topLeft,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      AwesomeDialog(
                                                        context: context,
                                                        dialogType:
                                                            DialogType.noHeader,
                                                        animType: AnimType
                                                            .bottomSlide,
                                                        title: 'Info',
                                                        desc:
                                                            'Do you want to mark this complaint as Resolved?',
                                                        btnCancel: IconButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context); // Close the dialog
                                                          },
                                                          icon: Image.asset(
                                                            'asserts/icons/cross.png',
                                                            width: 40,
                                                          ),
                                                          color: Colors.red,
                                                        ),
                                                        btnOk: IconButton(
                                                          onPressed: () async {
                                                            Resolved(
                                                                uid: widget
                                                                    .userId,
                                                                comment:
                                                                    "Resolved");
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {
                                                              fetchComplaintListLongDetailModel();
                                                            });
                                                          },
                                                          icon: Image.asset(
                                                            'asserts/icons/checked.png',
                                                            width: 40,
                                                          ),
                                                          color: Colors.green,
                                                        ),
                                                      ).show();
                                                    },
                                                    child: Container(
                                                      width: scWidth / 3.8,
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                          color: statusResolve,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.check,
                                                            color: dfColor,
                                                            size: 16,
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 5),
                                                            child: Text(
                                                              "Resolved",
                                                              style: TextStyle(
                                                                  color:
                                                                      dfColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    )

                                  // Container(
                                  //     alignment: Alignment.center,
                                  //     width: scWidth,
                                  //     margin: EdgeInsets.symmetric(
                                  //         horizontal: marginLR, vertical: 10),
                                  //     padding: EdgeInsets.symmetric(
                                  //         vertical: 10, horizontal: marginLR),
                                  //     // color: appcolor,
                                  //     decoration: BoxDecoration(
                                  //         borderRadius:
                                  //             BorderRadius.circular(15),
                                  //         border: Border.all(
                                  //             width: 1.5, color: appcolor)),
                                  //     child: Column(
                                  //       children: [
                                  //         Text(
                                  //           "Take Action",
                                  //           style: TextStyle(
                                  //             color: appcolor,
                                  //             fontSize: dfFontSize,
                                  //             fontWeight: FontWeight.bold,
                                  //           ),
                                  //         ),
                                  //         Container(
                                  //           width: scWidth / 5,
                                  //           child: Divider(
                                  //             color: appcolor,
                                  //             thickness: 0.5,
                                  //           ),
                                  //         ),
                                  //         //Cancel Action
                                  //       ],
                                  //     ),
                                  //   )
                                  : Container(),
                              Container(
                                alignment: Alignment.center,
                                width: scWidth,
                                margin: EdgeInsets.symmetric(
                                    horizontal: marginLR - 5),
                                padding: EdgeInsets.symmetric(vertical: 5),
                                color: appcolor,
                                child: Text(
                                  "Comments",
                                  style: TextStyle(
                                      color: dfColor,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Container(
                                height: scHeight / 2.8,
                                child: SingleChildScrollView(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, int i) {
                                      return ActionList(
                                        statusName: complaintLongModel
                                            .dataArray.actions[i].name,
                                        createdDate: complaintLongModel
                                            .dataArray.actions[i].startTime,
                                        index: i,
                                        function:
                                            fetchComplaintListLongDetailModel(),
                                      );
                                    },
                                    itemCount: complaintLongModel
                                        .dataArray.actions.length,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Resolved FeedBack Btn
                        complaintLongModel.dataArray.feedback == ""
                            ? complaintLongModel.dataArray.status == 'Resolved'
                                ? Positioned(
                                    bottom: 20,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            gradient: lgBlue,
                                            borderRadius: BorderRadius.circular(
                                                roundBtn)),
                                        width: scWidth / 3.2,
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            _showCustomDialog();
                                          },
                                          icon: Icon(Icons.thumb_up_alt),
                                          label: Text(
                                            'Feedback',
                                            style: TextStyle(
                                                color: btnTextColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            padding: EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      roundBtn),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                            : Container(),
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}

class IconTextWidget extends StatelessWidget {
  const IconTextWidget({
    super.key,
    required this.text,
    required this.imageIcon,
    required this.color,
  });
  final String text;
  final String imageIcon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Row(
        children: [
          Image.asset(
            imageIcon,
            width: scWidth / 15,
            // color: appcolor,
          ),
          Container(
            width: scWidth / 3,
            margin: EdgeInsets.only(left: 4),
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w500, color: color),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionList extends StatelessWidget {
  const ActionList({
    super.key,
    required this.statusName,
    required this.createdDate,
    // required this.commment,
    required this.index,
    required this.function,
  });

  final String statusName;
  final String createdDate;
  // final String commment;
  final int index;
  final function;

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;

    String sosDate = "";

    try {
      DateTime originalDateTime = DateTime.parse(createdDate);

      // Step 2: Format the DateTime object into a string with the desired format
      sosDate = DateFormat('dd-MM-yyyy hh:mm:ss').format(originalDateTime);
    } catch (e) {
      print("SOS Date Format $e");
    }

    return FutureBuilder<ComplaintDetailModel>(
        future: function, // fetch data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Text(
              "...",
              style: TextStyle(color: appcolor),
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final complaintLongModel = snapshot.data;

            String? textComment = "";

            int len =
                complaintLongModel!.dataArray.actions[index].comments.length;

            for (int i = 0; i < len; i++) {
              textComment = complaintLongModel
                  .dataArray.actions[index].comments[i].comment;
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
                    width: scWidth / 1.19,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                statusName,
                                style: TextStyle(
                                    color: dfColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: appcolor,
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            Container(
                              child: Text(sosDate),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Divider(
                            height: marginLR,
                            color: appcolor,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: marginLR),
                          child: Row(children: [
                            Icon(
                              Icons.subdirectory_arrow_right_outlined,
                              color: appcolor,
                            ),
                            Text(
                              textComment.toString(),
                              style: TextStyle(
                                  fontSize: dfFontSize,
                                  fontWeight: FontWeight.w500),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
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
