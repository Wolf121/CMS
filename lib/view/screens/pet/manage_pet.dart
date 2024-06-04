import 'dart:convert';

import 'package:dha_resident_app/constant.dart';
import 'package:dha_resident_app/view/widgets/custom_dialog.dart';
import 'package:dha_resident_app/view/widgets/pet_search_filter.dart';
import 'package:flutter/material.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/pet_list_widget.dart';
import 'package:http/http.dart' as http;

class ManagePet extends StatefulWidget {
  @override
  State<ManagePet> createState() => _ManagePetState();
}

class _ManagePetState extends State<ManagePet> {
  bool _isLoading = true;
  List<Map<String, dynamic>> managePet = [];
  String petNameFil = '';
  String petTypeFil = '';

  List<Map<String, dynamic>> pet_list = [
    {
      "image_url": "asserts/images/cat.png",
      "petName": "TONNY",
      "petStatus": "PENDING",
      "petGender": "Male",
      "petVaccinDob": "2021-10-12",
      "petType": "Cat",
      "petDescp": "Testingtwst",
    },
    {
      "image_url": "asserts/images/dog.png",
      "petName": "LUCY",
      "petStatus": "PENDING",
      "petGender": "Male",
      "petVaccinDob": "2021-10-12",
      "petType": "Dog",
      "petDescp": "Testingtwst",
    },
    {
      "image_url": "asserts/images/parrot.png",
      "petName": "POLLY",
      "petStatus": "PENDING",
      "petGender": "Male",
      "petVaccinDob": "2021-10-12",
      "petType": "Parrot",
      "petDescp": "Testingtwst",
    },
    {
      "image_url": "asserts/images/dog2.png",
      "petName": "RONNY",
      "petStatus": "PENDING",
      "petGender": "Male",
      "petVaccinDob": "2021-10-12",
      "petType": "Dog",
      "petDescp": "Testingtwst",
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchManagePetData();
    // loadManagePetFromPrefs();
  }

// getting data from api and storing in the sharedPref
  Future<void> fetchManagePetData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    Uri apiUrl = Uri.parse('http://110.93.244.74/api/pet/pet_list/personal');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(apiUrl, headers: headers);

      if (response.statusCode == 200) {
        _isLoading = false;
        Map<String, dynamic> responseData = json.decode(response.body);
        // prefs.setString('managePetData', json.encode(responseData));

        final managePetArray = responseData['data_array'] as List<dynamic>;

        setState(() {
          managePet = managePetArray.cast<Map<String, dynamic>>();
        });

        print('Manage Pet data saved in state.');
      } else {
        _isLoading = false;
        print('Failed to fetch staff data: ${response.reasonPhrase}');
      }
    } catch (error) {
      _isLoading = false;
      print('Error fetching staff data: $error');
    }
  }

  void SearchPet(String newPetName, newPetType) {
    petNameFil = newPetName;
    petTypeFil = newPetType;

    setState(() {
      print("Just came: " + petNameFil);
      print("Just came: " + petTypeFil);
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
          isLoading: _isLoading,
          overlayBackgroundColor: Colors.transparent,
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
                    "Pet List",
                    style:
                        TextStyle(color: dfColor, fontWeight: FontWeight.w700),
                  ),
                ),
                PetFilterSearch(onSearchPet: SearchPet),
                Expanded(
                  flex: 11,
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: 5, top: 20, left: marginLR, right: marginLR),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        if ((managePet[index]['name']
                                    .toString()
                                    .toLowerCase()) ==
                                petNameFil.toLowerCase() &&
                            (managePet[index]['type']
                                    .toString()
                                    .toLowerCase()) ==
                                petTypeFil.toLowerCase()) {
                          print("Condition 1");
                          return PetListWidget(
                            petRequestDelete: managePet[index]
                                ['request_to_delete'],
                            uid: managePet[index]['uid'],
                            petImage: managePet[index]['pic'],
                            petName: managePet[index]['name'] != null
                                ? managePet[index]['name']
                                : "N/A",
                            petStatus: managePet[index]['status'] != null
                                ? managePet[index]['status']
                                : "N/A",
                            petGender: managePet[index]['gender'] != null
                                ? managePet[index]['gender']
                                : "N/A",
                            petVaccinDob:
                                managePet[index]['vaccination_date'] != null
                                    ? managePet[index]['vaccination_date']
                                    : "N/A",
                            petType: managePet[index]['type'] != null
                                ? managePet[index]['type']
                                : "N/A",
                            petDescp: managePet[index]['description'] != null
                                ? managePet[index]['description']
                                : "N/A",

                            // currentTime: time,
                          );
                        } else if ((managePet[index]['name']
                                .toString()
                                .toLowerCase()) ==
                            petNameFil.toLowerCase()) {
                          print("Condition 2");

                          return (petTypeFil.toLowerCase().isNotEmpty)
                              ? Container()
                              : PetListWidget(
                                  petRequestDelete: managePet[index]
                                      ['request_to_delete'],
                                  uid: managePet[index]['uid'],
                                  petImage: managePet[index]['pic'],
                                  petName: managePet[index]['name'] != null
                                      ? managePet[index]['name']
                                      : "N/A",
                                  petStatus: managePet[index]['status'] != null
                                      ? managePet[index]['status']
                                      : "N/A",
                                  petGender: managePet[index]['gender'] != null
                                      ? managePet[index]['gender']
                                      : "N/A",
                                  petVaccinDob: managePet[index]
                                              ['vaccination_date'] !=
                                          null
                                      ? managePet[index]['vaccination_date']
                                      : "N/A",
                                  petType: managePet[index]['type'] != null
                                      ? managePet[index]['type']
                                      : "N/A",
                                  petDescp:
                                      managePet[index]['description'] != null
                                          ? managePet[index]['description']
                                          : "N/A",

                                  // currentTime: time,
                                );
                        } else if ((managePet[index]['type']
                                .toString()
                                .toLowerCase()) ==
                            petTypeFil.toLowerCase()) {
                          print("Condition 3");

                          return (petNameFil.toLowerCase().isNotEmpty)
                              ? Container()
                              : PetListWidget(
                                  petRequestDelete: managePet[index]
                                      ['request_to_delete'],
                                  uid: managePet[index]['uid'],
                                  petImage: managePet[index]['pic'],
                                  petName: managePet[index]['name'] != null
                                      ? managePet[index]['name']
                                      : "N/A",
                                  petStatus: managePet[index]['status'] != null
                                      ? managePet[index]['status']
                                      : "N/A",
                                  petGender: managePet[index]['gender'] != null
                                      ? managePet[index]['gender']
                                      : "N/A",
                                  petVaccinDob: managePet[index]
                                              ['vaccination_date'] !=
                                          null
                                      ? managePet[index]['vaccination_date']
                                      : "N/A",
                                  petType: managePet[index]['type'] != null
                                      ? managePet[index]['type']
                                      : "N/A",
                                  petDescp:
                                      managePet[index]['description'] != null
                                          ? managePet[index]['description']
                                          : "N/A",

                                  // currentTime: time,
                                );
                        } else {
                          return petNameFil.toLowerCase() != "" ||
                                  petTypeFil.toLowerCase() != ""
                              ? Container()
                              : PetListWidget(
                                  petRequestDelete: managePet[index]
                                      ['request_to_delete'],
                                  uid: managePet[index]['uid'],
                                  petImage: managePet[index]['pic'],
                                  petName: managePet[index]['name'] != null
                                      ? managePet[index]['name']
                                      : "N/A",
                                  petStatus: managePet[index]['status'] != null
                                      ? managePet[index]['status']
                                      : "N/A",
                                  petGender: managePet[index]['gender'] != null
                                      ? managePet[index]['gender']
                                      : "N/A",
                                  petVaccinDob: managePet[index]
                                              ['vaccination_date'] !=
                                          null
                                      ? managePet[index]['vaccination_date']
                                      : "N/A",
                                  petType: managePet[index]['type'] != null
                                      ? managePet[index]['type']
                                      : "N/A",
                                  petDescp:
                                      managePet[index]['description'] != null
                                          ? managePet[index]['description']
                                          : "N/A",

                                  // currentTime: time,
                                );
                        }
                      },
                      itemCount: managePet.length,
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
