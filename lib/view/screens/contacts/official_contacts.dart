import 'package:dha_resident_app/constant.dart';
import 'package:dha_resident_app/view/widgets/contact_filter_search.dart';
import 'package:dha_resident_app/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OfficialContacts extends StatefulWidget {
  @override
  _OfficialContactsState createState() => _OfficialContactsState();
}

class _OfficialContactsState extends State<OfficialContacts> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> emergencyContacts = [];

  bool _isLoading = true;
  String contactFil = '';
  List<Map<String, dynamic>> officialContactsList = [
    {
      "news_heading": "lern diw wpoqan",
      "news_details": "051-4848584",
      "image_url": "asserts/images/aleartsafety.png"
    },
  ];

//Class loading
  @override
  void initState() {
    super.initState();
    fetchEmergencyContactData();
    // loadEmergencyContactsFromPrefs();
  }

  void SearchContact(String newContact) {
    contactFil = newContact;

    setState(() {
      print("Just came: " + contactFil);
    });
  }

// getting data from api and storing in the sharedPref
  Future<void> fetchEmergencyContactData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    Uri apiUrl =
        Uri.parse('http://110.93.244.74/api/dashboard/emergencycontact');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(apiUrl, headers: headers);

      if (response.statusCode == 200) {
        _isLoading = false;
        Map<String, dynamic> responseData = json.decode(response.body);
        // prefs.setString('emergencyContactData', json.encode(responseData));

        final emergencyDataArray = responseData['data_array'] as List<dynamic>;

        setState(() {
          emergencyContacts = emergencyDataArray.cast<Map<String, dynamic>>();
        });

        print('Emergency Contact data saved in state.');
      } else {
        _isLoading = false;
        print(
            'Failed to fetch emergency contact data: ${response.reasonPhrase}');
      }
    } catch (error) {
      _isLoading = false;
      print('Error fetching emergency contact data: $error');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

// UI Design
  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(),
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
                    "Official Contacts",
                    style:
                        TextStyle(color: dfColor, fontWeight: FontWeight.w700),
                  ),
                ),
                ContactFilterSearch(onSearchContact: SearchContact),
                Expanded(
                  flex: 11,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5, top: 20),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return emergencyContacts[index]['title']
                                    .toString()
                                    .toLowerCase() ==
                                contactFil.toLowerCase()
                            ? contacts_list_item_Widget(
                                officeName: emergencyContacts[index]['title'],
                                officialContacts: emergencyContacts[index]
                                    ['phone'],
                                iconURL: officialContactsList[index %
                                    officialContactsList.length]['image_url'],
                              )
                            : contactFil != ""
                                ? Container()
                                : contacts_list_item_Widget(
                                    officeName: emergencyContacts[index]
                                        ['title'],
                                    officialContacts: emergencyContacts[index]
                                        ['phone'],
                                    iconURL: officialContactsList[
                                            index % officialContactsList.length]
                                        ['image_url'],
                                  );
                      },
                      itemCount: emergencyContacts.length,
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

// Populating
class contacts_list_item_Widget extends StatelessWidget {
  final String officeName;
  final String officialContacts;
  final String iconURL;

  const contacts_list_item_Widget({
    required this.officeName,
    required this.officialContacts,
    required this.iconURL,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(top: marginLR + 10, left: marginLR, right: marginLR),
      child: ElevatedButton(
        onPressed: () {
          print("Press");
          FlutterPhoneDirectCaller.callNumber(officialContacts);
        },
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(0),
            backgroundColor: Colors.transparent,
            elevation: 0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(roundBtn),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(roundBtn)),
              border: Border.all(width: 1.5, color: drakGreyColor),
            ),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 0, bottom: marginLR),
                  child: Text(
                    officeName.toUpperCase(),
                    style: TextStyle(
                      fontSize: dfFontSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.only(top: marginLR + 25, bottom: marginLR - 5),
                  child: Text(
                    officialContacts,
                    style: TextStyle(
                      fontSize: dfFontSize,
                      fontWeight: FontWeight.w500,
                      color: blackColor,
                    ),
                  ),
                ),
                Positioned(
                  top: -28,
                  child: CircleAvatar(
                    backgroundColor: redAlert,
                    radius: 20.0,
                    child: Image.asset(
                      iconURL,
                      width: 20,
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
