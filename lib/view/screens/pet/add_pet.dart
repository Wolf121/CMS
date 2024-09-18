import 'dart:convert';

import 'package:dha_resident_app/constant.dart';
import 'package:dha_resident_app/view/screens/dashboard/bottomNavBar.dart';
import 'package:dha_resident_app/view/widgets/pick_date.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'dart:io' show File, Platform;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import '../../widgets/card_Image_widget.dart';
import '../../../anim/animated_checkmark_dialog.dart';
import '../../widgets/custom_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Flutter create custom Widget class
enum IdentityCardNo { CNIC, NICOP }

enum IdentityShift { Day, Night, DayNight }

/// Flutter code sample for DropdownButton.

class AddPet extends StatefulWidget {
  const AddPet({super.key});

  @override
  State<AddPet> createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {
  SingleValueDropDownController? _cnt;
  final _formKey = GlobalKey<FormState>();
  dynamic _title;
  dynamic _gender;
  IdentityCardNo? _cardNo;
  String _cnicNo = '';
  List<DropDownValueModel> genderData =
      []; // This will store the selected pet type.
  List<DropDownValueModel> _petdata = [];

  final ValueNotifier<DateTime?> dateSub = ValueNotifier(null);
  final ValueNotifier<DateTime?> dateofBirth = ValueNotifier(null);

  String _petName = '';
  String _petType = '';
  String _petHeight = '';
  String _petColor = '';
  String _petAge = '';
  String _petLicenseNo = '';
  String _dateSubActual = '';
  String _dateBirthActual = '';
  String _description = '';
  // String _ppPath = 'asserts/images/addpet.png';
  String _licenseFront = '';
  String _licenseBack = '';
  String _petImage = '';

  bool isChecked = false;
  bool _isLoading = false;

  List checkLsit = [];
  int? _selectedItems;
  List<DropDownValueModel> genderDropdownList = [];
  @override
  void initState() {
    super.initState();
    fetchGenderData().then((data) {
      setState(() {
        genderData = data;
      });
    });
    fetchPetTypes().then((data) {
      setState(() {
        _petdata = data;
      });
    });
  }

  //colored Toast function
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

  //choice Dialog
  Future<void> _showImagePickerDialog(int whatkindpic) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Upload Image!',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.width / 15,
                              horizontal:
                                  MediaQuery.of(context).size.width / 10),
                          backgroundColor: appcolor,
                          elevation: 0),
                      onPressed: () {
                        Navigator.of(context).pop();
                        //_takePicture(ImageSource.camera);
                        print("Took From Camera");
                        _takePicture(ImageSource.camera, whatkindpic);
                      },
                      child: Icon(
                        Icons.camera,
                        color: dfColor,
                        size: MediaQuery.of(context).size.width / 12,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.width / 15,
                              horizontal:
                                  MediaQuery.of(context).size.width / 10),
                          backgroundColor: appcolor,
                          elevation: 0),
                      onPressed: () {
                        Navigator.of(context).pop();
                        //_takePicture(ImageSource.gallery);
                        _takePicture(ImageSource.gallery, whatkindpic);
                      },
                      child: Icon(
                        Icons.photo_library_outlined,
                        color: dfColor,
                        size: MediaQuery.of(context).size.width / 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Take Picture From Cam / Gal
  Future<void> _takePicture(ImageSource source, int VariPath) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        if (VariPath == 0) {
          _petImage = pickedImage.path; // Save the image URL
          print('Image Path profile : $_petImage'); // Print the image path
        } else if (VariPath == 1) {
          _licenseFront = pickedImage.path;
          print('Image Path ID Front : $_licenseFront'); // Print the image path
        } else if (VariPath == 2) {
          _licenseBack = pickedImage.path;
          print('Image Path ID Back: $_licenseBack'); // Print the image path
        }
        // else if (VariPath == 3) {
        //   _petImage = pickedImage.path;
        //   print('Image Path Pet Image: $_petImage'); // Print the image path
        // }
      });
      print(
          'Image picked from: ${source == ImageSource.camera ? "Camera" : "Gallery"}');
    }
  }

  // geting Gender
  Future<List<DropDownValueModel>> fetchGenderData() async {
    // Get the token from shared preferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? authToken =
        prefs.getString('token'); // Replace 'authToken' with your actual key

    try {
      final res = await http.get(
        Uri.parse("http://110.93.244.74/api/gender/gender_list"),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (res.statusCode == 200) {
        List<dynamic> data = json.decode(res.body)["data_array"];
        List<DropDownValueModel> genderDataList = data.map((entry) {
          return DropDownValueModel(
            name: entry['name'],
            value: entry['id'].toString(),
          );
        }).toList();
        return genderDataList;
      } else {
        print("Failed to load gender data - ${res.statusCode}");
        return []; // Return an empty list
      }
    } catch (e) {
      print("Error loading gender data - $e");
      return []; // Return an empty list
    }
  }

  // geting Pet Type
  Future<List<DropDownValueModel>> fetchPetTypes() async {
    // Get the token from shared preferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? authToken =
        prefs.getString('token'); // Replace with your actual key

    try {
      final res = await http.get(
        Uri.parse("http://110.93.244.74/api/pet/pet_types/1"),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (res.statusCode == 200) {
        List<dynamic> data = json.decode(res.body)["data_array"];
        List<DropDownValueModel> petTypes = data.map((entry) {
          return DropDownValueModel(
            name: entry['name'],
            value: entry['id'].toString(),
          );
        }).toList();
        return petTypes;
      } else {
        print("Failed to load pet types - ${res.statusCode}");
        return []; // Return an empty list
      }
    } catch (e) {
      print("Error loading pet types - $e");
      return []; // Return an empty list
    }
  }

  void justPrinting() {
    String source = '';
    if (defaultTargetPlatform == TargetPlatform.android) {
      source = 'Android';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      source = 'IOs';
    }
    print('this is name $_petName');
    print('this is Gender $_gender');
    print('this is Source source' + source);
    print('this is Breed $_petType');
    print('this is Height $_petHeight');
    print('this is Color $_petColor');
    print('this is Age $_petAge');
    print('this is Licence $_petLicenseNo');
    print('this is License Expire $_dateBirthActual');
    print('this is DOB $_dateSubActual');
    print('this is Decscription $_description');
  }

//alternative petupluad
  Future<void> uploadPetData2(
    String _petName,
    String petType,
    String _petHeight,
    String _petColor,
    String _petAge,
    String _petLicenseNo,
    String _dateSubActual,
    String _dateBirthActual,
    String _description,
    String ppPath,
    String licenseFront,
    String licenseBack,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('token');

    if (authToken == null) {
      print('Authentication token not available.');
      return;
    }

    final String apiUrl = 'http://110.93.244.74/api/pet/pet_store';
    String source = '';

    if (defaultTargetPlatform == TargetPlatform.android) {
      source = 'Android';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      source = 'IOs';
    }

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers.addAll({
      'Authorization': 'Bearer $authToken',
    });

    request.fields.addAll({
      'name': _petName,
      'type_id': petType,
      'height': _petHeight,
      'color': _petColor,
      'age': _petAge,
      'source': source,
      'gender_id': _gender,
      'license_no': _petLicenseNo,
      'sub_actual': _dateSubActual,
      'birth_actual': _dateBirthActual,
      'description': _description,
    });

    var petPic = await http.MultipartFile.fromPath(
      'pic',
      ppPath,
    );
    request.files.add(petPic);

    var licensePic1 = await http.MultipartFile.fromPath(
      'license_pic_1',
      licenseFront,
    );
    request.files.add(licensePic1);

    var licensePic2 = await http.MultipartFile.fromPath(
      'license_pic_2',
      licenseBack,
    );
    request.files.add(licensePic2);

    try {
      final response = await request.send();
      final responseStream = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(responseStream);

        if (responseJson.containsKey("message")) {
          String message = responseJson["message"];
          print('Upload Pet Data Response Message: $message');
          // Handle success or show a dialog with the message
        }
      } else {
        // Error handling
        print(
            'Upload Pet Data API Error: ${response.statusCode}+${responseStream}');
        // Handle the error or show an error message
      }
    } catch (error) {
      print('Upload Pet Data Request error: $error');
      // Handle the request error or show an error message
    }
  }

// Uloading Pet Data

  Future<void> uploadPetData(
      String _petName,
      String petType,
      String _petHeight,
      String _petColor,
      String _petAge,
      String _petLicenseNo,
      String _dateSubActual,
      String _dateBirthActual,
      String _description,
      String gender,
      String ppPath,
      String licenseFront,
      String licenseBack) async {
    // Get the token from shared preferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('token');

    // Check if authToken is available
    if (authToken == null) {
      print('Authentication token not available.');
      return;
    }

    final String apiUrl = 'http://110.93.244.74/api/pet/pet_store';
    String source = '';
    if (defaultTargetPlatform == TargetPlatform.android) {
      source = 'Android';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      source = 'IOs';
    }

    // Create a FormData object to send data and files
    FormData formData = FormData.fromMap({
      'name': _petName,
      'type_id': petType,
      'height': _petHeight,
      'color': _petColor,
      'age': _petAge,
      'source': source,
      'gender_id': gender,
      'license_no': _petLicenseNo,
      'license_expiry': _dateSubActual,
      'vaccination_date': _dateBirthActual,
      'description': _description,
      'pic': await MultipartFile.fromFile(ppPath),
      'license_pic_1': await MultipartFile.fromFile(licenseFront),
      'license_pic_2': await MultipartFile.fromFile(licenseBack),
    });

    try {
      final response = await Dio().post(
        apiUrl,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        // Assuming responseData is a Map<String, dynamic>
        Map<String, dynamic> responseJson =
            Map<String, dynamic>.from(responseData);

        if (responseJson.containsKey("message")) {
          String message = responseJson["message"];
          print('Upload Pet Data Response Message: $message');
          _isLoading = false;

          showAnimatedCheckmarkDialog(context, 'Pet Added!', appcolor);
          await Future.delayed(Duration(seconds: 1));

          final route = MaterialPageRoute(builder: (context) => BottomNavBar());
          //final route = MaterialPageRoute(builder: (context) => ManagePet());
          Navigator.pushAndRemoveUntil(context, route, (route) => false);
        }
      } else {
        _isLoading = false;
        // Error handling
        print(
            'Upload Pet Data API Error: ${response.statusCode}+${response.data}');
        showAnimatedCheckmarkDialog(context, "Upload Failed!", appcolor);
      }
    } catch (error) {
      _isLoading = false;

      print('Upload Pet Data Request error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scheight = MediaQuery.of(context).size.height;

    return Scaffold(
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
            // final route =
            //     MaterialPageRoute(builder: (context) => BottomNavBar());
            // Navigator.pushAndRemoveUntil(context, route, (route) => false);
            Navigator.of(context).pop();
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
        child: SingleChildScrollView(
          child: Container(
            height: Platform.isAndroid ? scheight / 1.12 : scheight / 1.155,
            width: scWidth,
            color: greyColor,
            child: Column(
              children: [
                Container(
                  color: appcolor,
                  width: scWidth,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(),
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Add Pet",
                    style:
                        TextStyle(color: dfColor, fontWeight: FontWeight.w700),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Stack(
                    children: [
                      Container(
                        height: scheight / 8,
                        width: scWidth / 1,
                        margin: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CardImageWidget(
                              onRemovePressed: () {
                                // Handle the remove image action here

                                setState(() {
                                  _petImage = ''; // Set to empty string
                                });
                              },
                              licenseImage: _petImage,
                              function: () {
                                _showImagePickerDialog(0);
                              },
                              imageText: 'Upload Pet Image',
                              customImage: 'asserts/images/addpet.png',
                              ftSize: Platform.isAndroid
                                  ? scWidth / 33
                                  : scWidth / 34,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // height: 200,
                        margin: Platform.isAndroid
                            ? EdgeInsets.only(
                                top: scheight / 6.8, bottom: scheight / 13)
                            : EdgeInsets.only(
                                top: scheight / 6.8, bottom: scheight / 14),
                        height: Platform.isAndroid
                            ? scheight / 1.59
                            : scheight / 1.85,
                        child: SingleChildScrollView(
                          child: Container(
                              decoration: BoxDecoration(
                                  // color: dfColor,
                                  ),
                              margin: EdgeInsets.only(
                                left: marginLR,
                                right: marginLR,
                              ),
                              child: Container(
                                  padding: Platform.isAndroid
                                      ? EdgeInsets.only(
                                          top: 10,
                                          right: 20,
                                          left: 20,
                                          bottom: 20)
                                      : EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      color: dfColor,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 8),
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            autofocus: false,
                                            style: TextStyle(
                                                fontSize: 19.0,
                                                color: blackColor),
                                            decoration: InputDecoration(
                                              hintText: "Pet Name",
                                              hintStyle: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15),
                                              filled: true,
                                              fillColor: dfColor,
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 1.0,
                                                      bottom: 8.0,
                                                      top: 8.0),
                                            ),
                                            keyboardType: TextInputType.text,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[a-zA-Z]')),
                                            ],
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please Enter Pet Name';
                                              }
                                              if (!RegExp(r'^[a-zA-Z]+$')
                                                  .hasMatch(value)) {
                                                return 'Please enter a valid name with alphabets only';
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                _petName = value.trim();
                                              });
                                            },
                                          ),
                                        ),

                                        //------------------

                                        Container(
                                          margin: EdgeInsets.only(top: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Select Gender:",
                                                style: TextStyle(
                                                  fontSize: exSmFontSize,
                                                  fontWeight: FontWeight.w500,
                                                  color: appcolor,
                                                ),
                                              ),
                                              DropDownTextField(
                                                controller: _cnt,
                                                dropDownIconProperty:
                                                    IconProperty(
                                                  icon:
                                                      Icons.keyboard_arrow_down,
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                clearIconProperty: IconProperty(
                                                  color: Colors.green,
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please Select A Gender'; // Validation message when no gender is selected
                                                  }
                                                  return null;
                                                },
                                                dropDownItemCount:
                                                    genderData.length,
                                                dropDownList: genderData,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _gender = value.value;
                                                    print("Gender " + _gender);
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),

                                        //------------------

                                        // Container(
                                        //   margin: EdgeInsets.only(top: 8),
                                        //   child: Column(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.start,
                                        //     children: [
                                        //       Text(
                                        //         "Pet Type",
                                        //         style: TextStyle(
                                        //             fontSize: exSmFontSize,
                                        //             fontWeight: FontWeight.w500,
                                        //             color: appcolor),
                                        //       ),
                                        //       TextFormField(
                                        //         textInputAction: TextInputAction.next,
                                        //         autofocus: false,
                                        //         style: TextStyle(
                                        //             fontSize: 19.0, color: blackColor),
                                        //         decoration: InputDecoration(
                                        //           // prefixIcon: Image.asset(
                                        //           //   "asserts/images/pet.png",
                                        //           //   color: appcolor,
                                        //           //   // width: 5,
                                        //           //   // height: scWidth / 9,
                                        //           // ),
                                        //           hintText: "Breed",
                                        //           hintStyle: TextStyle(
                                        //               color: Colors.black54,
                                        //               fontSize: 15),
                                        //           filled: true,
                                        //           fillColor: dfColor,
                                        //           contentPadding: const EdgeInsets.only(
                                        //               left: 1.0, bottom: 8.0, top: 8.0),
                                        //         ),
                                        //         keyboardType: TextInputType.text,
                                        //         inputFormatters: <TextInputFormatter>[
                                        //           FilteringTextInputFormatter.allow(
                                        //               RegExp(r'[a-zA-Z]'))
                                        //         ],
                                        //         validator: (value) {
                                        //           if (value!.isEmpty) {
                                        //             return 'Please Enter Your Pet Type';
                                        //           }
                                        //           // Check if the value contains only alphabets (letters)
                                        //           if (!RegExp(r'^[a-zA-Z]+$')
                                        //               .hasMatch(value)) {
                                        //             return 'Please Enter A Valid Pet type';
                                        //           }
                                        //           return null;
                                        //         },
                                        //         onChanged: (value) {
                                        //           setState(() {
                                        //             _petType = value.trim();
                                        //           });
                                        //         },
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        // //------------------

                                        Container(
                                          margin: EdgeInsets.only(top: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Pet Type",
                                                style: TextStyle(
                                                    fontSize: exSmFontSize,
                                                    fontWeight: FontWeight.w500,
                                                    color: appcolor),
                                              ),
                                              Container(
                                                child: DropDownTextField(
                                                  // initialValue: "name4",
                                                  // readOnly: true,
                                                  controller: _cnt,
                                                  padding:
                                                      EdgeInsets.symmetric(),
                                                  clearOption: true,
                                                  isEnabled: true,
                                                  dropDownIconProperty:
                                                      IconProperty(
                                                          icon: Icons
                                                              .keyboard_arrow_down),

                                                  keyboardType:
                                                      TextInputType.number,
                                                  autovalidateMode:
                                                      AutovalidateMode.disabled,
                                                  clearIconProperty:
                                                      IconProperty(
                                                          color: Colors.green),

                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "Please Select Pet Type";
                                                    }
                                                    return null;
                                                  },
                                                  dropDownItemCount: _petdata
                                                      .length, // Use the length of _petTypes list
                                                  dropDownList: _petdata,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _petType = value.value;
                                                      print("Pet Type " +
                                                          _petType);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        //------------------

                                        Container(
                                          margin: EdgeInsets.only(top: 8),
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            autofocus: false,
                                            style: TextStyle(
                                                fontSize: 19.0,
                                                color: blackColor),
                                            decoration: InputDecoration(
                                              hintText: "Height",
                                              hintStyle: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15),
                                              filled: true,
                                              fillColor: dfColor,
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 1.0,
                                                      bottom: 8.0,
                                                      top: 8.0),
                                            ),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Please Enter Pet's Height";
                                              }

                                              return null;
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                _petHeight = value.trim();
                                              });
                                            },
                                          ),
                                        ),

                                        //------------------
                                        Container(
                                          margin: EdgeInsets.only(top: 8),
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            autofocus: false,
                                            style: TextStyle(
                                                fontSize: 19.0,
                                                color: blackColor),
                                            decoration: InputDecoration(
                                              hintText: "Color",
                                              hintStyle: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15),
                                              filled: true,
                                              fillColor: dfColor,
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 1.0,
                                                      bottom: 8.0,
                                                      top: 8.0),
                                            ),
                                            keyboardType: TextInputType.text,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[a-zA-Z]'))
                                            ],
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Please State Pet's Color";
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                _petColor = value.trim();
                                              });
                                            },
                                          ),
                                        ),

                                        //------------------
                                        Container(
                                          margin: EdgeInsets.only(top: 8),
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            autofocus: false,
                                            style: TextStyle(
                                                fontSize: 19.0,
                                                color: blackColor),
                                            decoration: InputDecoration(
                                              hintText: "Age",
                                              hintStyle: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15),
                                              filled: true,
                                              fillColor: dfColor,
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 1.0,
                                                      bottom: 8.0,
                                                      top: 8.0),
                                            ),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Please Enter Pet's Age";
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                _petAge = value.trim();
                                              });
                                            },
                                          ),
                                        ),

                                        //------------------
                                        Container(
                                          margin: EdgeInsets.only(top: 8),
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            autofocus: false,
                                            style: TextStyle(
                                                fontSize: 19.0,
                                                color: blackColor),
                                            decoration: InputDecoration(
                                              hintText: "License Number",
                                              hintStyle: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15),
                                              filled: true,
                                              fillColor: dfColor,
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 1.0,
                                                      bottom: 8.0,
                                                      top: 8.0),
                                            ),
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please Enter Pet License Number';
                                              }

                                              return null;
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                _petLicenseNo = value.trim();
                                              });
                                            },
                                          ),
                                        ),

                                        //------------------

                                        Container(
                                          margin: EdgeInsets.only(top: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CardImageWidget(
                                                onRemovePressed: () {
                                                  // Handle the remove image action here

                                                  setState(() {
                                                    _licenseFront =
                                                        ''; // Set to empty string
                                                  });
                                                },
                                                licenseImage: _licenseFront,
                                                function: () {
                                                  _showImagePickerDialog(1);
                                                },
                                                imageText:
                                                    'License Front Image',
                                                customImage:
                                                    "asserts/images/cnicfornt.png",
                                                ftSize: Platform.isAndroid
                                                    ? scWidth / 33
                                                    : scWidth / 34,
                                              ),
                                              CardImageWidget(
                                                onRemovePressed: () {
                                                  // Handle the remove image action here

                                                  setState(() {
                                                    _licenseBack =
                                                        ''; // Set to empty string
                                                  });
                                                },
                                                licenseImage: _licenseBack,
                                                function: () {
                                                  _showImagePickerDialog(2);
                                                },
                                                imageText: 'License Back Image',
                                                customImage:
                                                    "asserts/images/cnicback.png",
                                                ftSize: Platform.isAndroid
                                                    ? scWidth / 33
                                                    : scWidth / 34,
                                              ),
                                            ],
                                          ),
                                        ),

                                        //------------------

                                        ValueListenableBuilder<DateTime?>(
                                          valueListenable: dateSub,
                                          builder: (context, dateVal, child) {
                                            return InkWell(
                                              onTap: () async {
                                                DateTime? date =
                                                    await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime(1920),
                                                        lastDate:
                                                            DateTime(2080),
                                                        currentDate:
                                                            DateTime.now(),
                                                        initialEntryMode:
                                                            DatePickerEntryMode
                                                                .calendar,
                                                        initialDatePickerMode:
                                                            DatePickerMode.day,
                                                        builder:
                                                            (context, child) {
                                                          return Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                                    colorScheme:
                                                                        ColorScheme
                                                                            .fromSwatch(
                                                              primarySwatch:
                                                                  Colors.blue,
                                                              accentColor:
                                                                  appcolor,
                                                              backgroundColor:
                                                                  Colors
                                                                      .lightBlue,
                                                              cardColor:
                                                                  Colors.white,
                                                            )),
                                                            child: child!,
                                                          );
                                                        });
                                                // Update _dateSubActual with the selected date
                                                setState(() {
                                                  _dateBirthActual =
                                                      formatDate(date!, [
                                                    yyyy,
                                                    '-',
                                                    mm,
                                                    '-',
                                                    dd
                                                  ]);
                                                });

                                                // Update the ValueNotifier with the selected date
                                                dateSub.value = date;
                                                                                            },
                                              child: PickDate(
                                                date: dateVal != null
                                                    ? formatDate(dateVal, [
                                                        yyyy,
                                                        '-',
                                                        mm,
                                                        '-',
                                                        dd
                                                      ])
                                                    : ' Licence Expire (DD-MM-YY)',
                                              ),
                                            );
                                          },
                                        ),
                                        //------------------
                                        ValueListenableBuilder<DateTime?>(
                                          valueListenable: dateofBirth,
                                          builder: (context, dateVal, child) {
                                            return InkWell(
                                              onTap: () async {
                                                DateTime? date =
                                                    await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime(1920),
                                                        lastDate:
                                                            DateTime(2080),
                                                        currentDate:
                                                            DateTime.now(),
                                                        initialEntryMode:
                                                            DatePickerEntryMode
                                                                .calendar,
                                                        initialDatePickerMode:
                                                            DatePickerMode.day,
                                                        builder:
                                                            (context, child) {
                                                          return Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                                    colorScheme:
                                                                        ColorScheme
                                                                            .fromSwatch(
                                                              primarySwatch:
                                                                  Colors.blue,
                                                              accentColor:
                                                                  appcolor,
                                                              backgroundColor:
                                                                  Colors
                                                                      .lightBlue,
                                                              cardColor:
                                                                  Colors.white,
                                                            )),
                                                            child: child!,
                                                          );
                                                        });
                                                // Update _dateSubActual with the selected date
                                                setState(() {
                                                  _dateSubActual = formatDate(
                                                      date!, [
                                                    yyyy,
                                                    '-',
                                                    mm,
                                                    '-',
                                                    dd
                                                  ]);
                                                });

                                                // Update the ValueNotifier with the selected date
                                                dateofBirth.value = date;
                                                                                            },
                                              child: PickDate(
                                                date: dateVal != null
                                                    ? formatDate(dateVal, [
                                                        yyyy,
                                                        '-',
                                                        mm,
                                                        '-',
                                                        dd
                                                      ])
                                                    : ' Vaccination Date (DD-MM-YY)',
                                              ),
                                            );
                                          },
                                        ),
                                        //------------------

                                        Container(
                                          margin: EdgeInsets.only(top: 8),
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            autofocus: false,
                                            minLines: 1,
                                            maxLength: 500,
                                            maxLines: 5,
                                            style: TextStyle(
                                                fontSize: 19.0,
                                                color: Colors.black87),
                                            decoration: InputDecoration(
                                              hintText: "Pet's Description",
                                              hintStyle: TextStyle(
                                                  color: blackColor,
                                                  fontSize: 12),
                                              filled: true,
                                              fillColor: greyColor,
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 16.0,
                                                      bottom: 30.0,
                                                      top: 30.0),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            keyboardType: TextInputType.text,

                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[a-zA-Z0-9., ]')),
                                            ],

                                            // inputFormatters: <TextInputFormatter>[
                                            //   FilteringTextInputFormatter.allow(
                                            //       RegExp(r'^[a-zA-Z.]*$'))
                                            // ],
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Pet's Description";
                                              }
                                              return null;

                                              // return null;
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                _description = value.trim();
                                              });
                                            },
                                          ),
                                        ),

                                        //------------------

                                        //Check Read Me
                                        // Container(
                                        //   margin: EdgeInsets.only(top: 8),
                                        //   child: Column(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.start,
                                        //     children: [
                                        //       Row(
                                        //         mainAxisAlignment:
                                        //             MainAxisAlignment.start,
                                        //         children: [
                                        //           Container(
                                        //             width: 25,
                                        //             height: 25,
                                        //             child: Checkbox(
                                        //               checkColor: greyColor,
                                        //               fillColor:
                                        //                   MaterialStateProperty
                                        //                       .resolveWith<
                                        //                           Color>((Set<
                                        //                               MaterialState>
                                        //                           states) {
                                        //                 if (states.contains(
                                        //                     MaterialState
                                        //                         .disabled)) {
                                        //                   return drakGreyColor;
                                        //                 }
                                        //                 return appcolor;
                                        //               }),
                                        //               value: isChecked,
                                        //               onChanged: (bool? value) {
                                        //                 setState(() {
                                        //                   isChecked = value!;
                                        //                 });
                                        //               },
                                        //             ),
                                        //           ),
                                        //           Text(
                                        //             "Read Terms and Conditions",
                                        //             style: TextStyle(
                                        //               height: 1,
                                        //               color: Colors.redAccent,
                                        //               fontWeight: FontWeight.w400,
                                        //             ),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),

                                        ///--------------------
                                      ],
                                    ),
                                  ]))),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 35,
                        right: 35,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  gradient: lgBlue,
                                  borderRadius:
                                      BorderRadius.circular(roundBtn)),
                              width: scWidth,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    // if (isChecked == true) {
                                    if (_petImage == '') {
                                      funToast(
                                          "Please Upload Your Pet's Picture!",
                                          appcolor);
                                    } else {
                                      justPrinting();
                                      if (_petImage == '') {
                                        showAboutDialog(context: context);
                                      }

                                      uploadPetData(
                                        _petName,
                                        _petType,
                                        _petHeight,
                                        _petColor,
                                        _petAge,
                                        _petLicenseNo,
                                        _dateSubActual,
                                        _dateBirthActual,
                                        _description,
                                        _gender,
                                        _petImage,
                                        _licenseFront,
                                        _licenseBack,
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  'Add Pet',
                                  style: TextStyle(color: btnTextColor),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(roundBtn),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
