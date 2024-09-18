import 'dart:convert';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dha_resident_app/anim/animated_checkmark_dialog.dart';
import 'package:dha_resident_app/constant.dart';
import 'package:dha_resident_app/view/screens/dashboard/bottomNavBar.dart';
import 'package:dha_resident_app/view/widgets/pick_date.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/card_Image_widget.dart';
import 'package:dio/dio.dart';

import '../../widgets/custom_dialog.dart';

// Flutter create custom Widget class
enum IdentityCardNo { CNIC, NICOP, DLNO }

enum IdentityShift { Day, Night, DayNight }

/// Flutter code sample for DropdownButton.

class AddStaff extends StatefulWidget {
  const AddStaff({super.key});

  @override
  State<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  SingleValueDropDownController? _cnt;
  final _formKey = GlobalKey<FormState>();
  dynamic _title;
  String _personName = '';
  String _fatherName = '';
  dynamic _gender;
  IdentityCardNo? _cardType = IdentityCardNo.CNIC;
  String? dateofBirthValue;
  String? dateExpireValue;
  String _cnicNo = '';
  String _source = '';
  String _categoryType = '';

  final ValueNotifier<DateTime?> dateSub = ValueNotifier(null);
  final ValueNotifier<DateTime?> dateofBirth = ValueNotifier(null);

  String _description = '';
  dynamic _mobileNo = '';
  dynamic _landlineNo = '';
  String _staffImagePath = '';
  String _idFrontPath = '';
  String _idBackPath = '';
  List<DropDownValueModel> _staffTypes = [];
  IdentityShift? _identityShift;
  String idenShift = '';

  String _profilepic = "";
  String cnicfrontpic = "";
  String cnicbackpic = "";

  final picker = ImagePicker();

  String? driverName;
  bool isChecked = false;
  bool _isLoading = false;

  late String logName = "";
  late String phase = "";
  late String sector = "";
  late int plot = 0;
  late String street = "";

  @override
  void initState() {
    super.initState();
    print("Add Staff Class Executing!");
    loadStaffTypesFromPrefs().then((staffTypes) {
      setState(() {
        _staffTypes = staffTypes;
      });
    });

    bool isPlatformAndroid() {
      return Platform.isAndroid;
    }

    bool isPlatformiOS() {
      return Platform.isIOS;
    }

    if (isPlatformiOS()) {
      _source = "IOs";
    } else if (isPlatformAndroid()) {
      _source = "Android";
    }

    loadSessionData();
  }

  Future<void> loadSessionData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      logName = prefs.getString('logedUser') ?? "";

      phase = prefs.getString('phase') ?? "";
      sector = prefs.getString('sector') ?? "";

      plot = prefs.getInt('plot') ?? 0;
      street = prefs.getString('street') ?? "";
    });
  }

  void _showCustomDialog(
    BuildContext context,
    String title,
    String descrption,
  ) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),

        width: scWidth / 1.05,
        // height: scHeight / 1.8, // Set the desired width here
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  fontSize: scWidth / 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(height: 5),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: scHeight / 2.1, // Set the maximum height here
              ),
              child: SingleChildScrollView(
                child: RichText(
                  text: TextSpan(
                    text: 'I ',
                    style: TextStyle(
                      color: appcolor,
                      fontSize: scWidth / 30,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '$logName ',
                        style: TextStyle(
                            color: appcolor,
                            fontSize: scWidth / 30,
                            fontWeight: FontWeight.w800),
                      ),
                      TextSpan(
                        text: 'resident of House No ',
                        style: TextStyle(
                          color: appcolor,
                          fontSize: scWidth / 30,
                        ),
                      ),
                      TextSpan(
                        text: '$plot ',
                        style: TextStyle(
                            color: appcolor,
                            fontSize: scWidth / 30,
                            fontWeight: FontWeight.w800),
                      ),
                      TextSpan(
                        text: 'Street/ Lane/ Boulevard ',
                        style: TextStyle(
                          color: appcolor,
                          fontSize: scWidth / 30,
                        ),
                      ),
                      TextSpan(
                        text: '$street ',
                        style: TextStyle(
                            color: appcolor,
                            fontSize: scWidth / 30,
                            fontWeight: FontWeight.w800),
                      ),
                      TextSpan(
                        text: 'Sector ',
                        style: TextStyle(
                          color: appcolor,
                          fontSize: scWidth / 30,
                        ),
                      ),
                      TextSpan(
                        text: '$sector ',
                        style: TextStyle(
                            color: appcolor,
                            fontSize: scWidth / 30,
                            fontWeight: FontWeight.w800),
                      ),
                      TextSpan(
                        text: 'Phase ',
                        style: TextStyle(
                          color: appcolor,
                          fontSize: scWidth / 30,
                        ),
                      ),
                      TextSpan(
                        text: '$phase ',
                        style: TextStyle(
                            color: appcolor,
                            fontSize: scWidth / 30,
                            fontWeight: FontWeight.w800),
                      ),
                      TextSpan(
                        text:
                            'hereby  give  an  undertaking  that  I  personally  know  background  of ',
                        style: TextStyle(
                          color: appcolor,
                          fontSize: scWidth / 30,
                        ),
                      ),
                      TextSpan(
                        text: '$_personName ',
                        style: TextStyle(
                            color: appcolor,
                            fontSize: scWidth / 30,
                            fontWeight: FontWeight.w800),
                      ),
                      TextSpan(
                        text: 'S/O,  D/O,  W/O ',
                        style: TextStyle(
                          color: appcolor,
                          fontSize: scWidth / 30,
                        ),
                      ),
                      TextSpan(
                        text: '$_fatherName ',
                        style: TextStyle(
                            color: appcolor,
                            fontSize: scWidth / 30,
                            fontWeight: FontWeight.w800),
                      ),
                      TextSpan(
                        text: 'CNIC  No ',
                        style: TextStyle(
                          color: appcolor,
                          fontSize: scWidth / 30,
                        ),
                      ),
                      TextSpan(
                        text: '$_cnicNo ',
                        style: TextStyle(
                            color: appcolor,
                            fontSize: scWidth / 30,
                            fontWeight: FontWeight.w800),
                      ),
                      TextSpan(
                        text:
                            'for  employment  as  servant  /  maid  /  driver  and  I  shall  be  responsible  for his/her conduct in DHAI-R. I Opt to forgo police verification of individual.',
                        style: TextStyle(
                          color: appcolor,
                          fontSize: scWidth / 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    setState(() {
                      isChecked = false;

                      Navigator.pop(context); // close the dialog only
                    });
                  },
                  child: Text('Disagree'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: appcolor),
                  onPressed: () {
                    setState(() {
                      isChecked = true;
                      Navigator.pop(context); // close the dialog only
                    });
                  },
                  child: Text('Agree'),
                ),
              ],
            ),
          ],
        ),
      ),
    )..show();
  }

// Choice Dialog
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

  Future<String?> useImageFromGallery(ImageSource source) async {
    // Add code to open image picker and return the selected image path
    // For example, using the image_picker package
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      return pickedImage.path;
    }
    return null; // Return null if no image is selected
  }

  //Take Pic From Camera/Gallary
  Future<void> _takePicture(ImageSource source, int VariPath) async {
    String? imagePath = await useImageFromGallery(source);
    // final picker = ImagePicker();
    // final pickedImage = await picker.pickImage(source: source);

    if (imagePath != null) {
      setState(() {
        if (VariPath == 0) {
          _staffImagePath = imagePath.toString(); // Save the image URL
          print(
              'Image Path profile : $_staffImagePath'); // Print the image path
        } else if (VariPath == 1) {
          _idFrontPath = imagePath.toString();
          print('Image Path ID Front : $_idFrontPath'); // Print the image path
        } else if (VariPath == 2) {
          _idBackPath = imagePath.toString();
          print('Image Path ID Back: $_idBackPath'); // Print the image path
        }
      });
      print(
          'Image picked from: ${source == ImageSource.camera ? "Camera" : "Gallery"}');
    }
  }

  void _handleCardImageTap(String imageType) {
    print('Tapped on: $imageType'); // Print the tapped image type

    // You can add more code here to handle the tap, such as opening an image picker or performing other actions.
  }

  Future<String?> _getTokenFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Replace 'authToken' with your key
  }
// lark

  Future<void> sendStaffData(Map<String, dynamic> staffData) async {
    final String apiUrl = 'http://110.93.244.74/api/staff/staff_save';

    final String? authToken = await _getTokenFromSharedPreferences();
    if (authToken == null) {
      _isLoading = false;
      print('Authentication token not available.');
      return;
    }

    Map<String, String> headers = {
      'Authorization': 'Bearer $authToken',
    };

    // Create a Random instance to generate a boundary
    var random = Random();
    var boundary = '---------------------------${random.nextInt(1000000000)}';

    // Set Content-Type with boundary parameter
    headers['Content-Type'] = 'multipart/form-data; boundary=$boundary';

    var formData = FormData.fromMap({
      'mobile_1': staffData['mobile_1'].toString(),
      'mobile_2': staffData['mobile_2'].toString(),
      'name': staffData['name'].toString(),
      'father_name': staffData['father_name'].toString(),
      'category': staffData['category'].toString(),
      'shift': staffData['shift'].toString(),
      'source': staffData['source'].toString(),
      'gender': staffData['gender'].toString(),
      'cnic': staffData['cnic'].toString(),
      'dob': staffData['dob'].toString(),
      'cnic_expiry_date': staffData['cnic_expiry_date'].toString(),
      'profile_pic': await MultipartFile.fromFile(staffData['profile_pic']),
      'cnic_front': await MultipartFile.fromFile(staffData['cnic_front']),
      'cnic_back': await MultipartFile.fromFile(staffData['cnic_back']),
      'description': staffData['description'].toString(),
    });

    print("Mobile 1: ${staffData['mobile_1'].toString()}");
    print("Mobile 2: ${staffData['mobile_2'].toString()}");
    print("Name: ${staffData['name'].toString()}");
    print("f Name: ${staffData['father_name'].toString()}");
    print("Category : ${staffData['category'].toString()}");
    print("shift: ${staffData['shift'].toString()}");
    print("source : ${staffData['source'].toString()}");
    print("Gender: ${staffData['gender'].toString()}");
    print("cnic: ${staffData['cnic'].toString()}");
    print("dob : ${staffData['dob'].toString()}");
    print("cnic_expiry_date : ${staffData['cnic_expiry_date'].toString()}");
    print("decsp: ${staffData['description'].toString()}");
    print("p pic: ${staffData['profile_pic'].toString()}");
    print("cf pic: ${staffData['cnic_front'].toString()}");
    print("cb pic: ${staffData['cnic_back'].toString()}");

    var dio = Dio();
    var response = await dio.post(
      apiUrl,
      data: formData,
      options: Options(
        headers: headers,
      ),
    );

    try {
      final responseData = response.data;
      // Assuming responseData is a Map<String, dynamic>
      Map<String, dynamic> responseJson =
          Map<String, dynamic>.from(responseData);

      int success = responseJson["success"];

      if (response.statusCode == 200 && success == 1) {
        print('Response : ${response.data}');
        //Successful
        showAnimatedCheckmarkDialog(context, 'Staff Added!', appcolor);
        _isLoading = false;
        await Future.delayed(Duration(seconds: 1));

        final route = MaterialPageRoute(builder: (context) => BottomNavBar());

        Navigator.pushAndRemoveUntil(context, route, (route) => false);
      } else {
        _isLoading = false;
        // Error handling
        print('API Error: ${response.statusCode}}');
        print('Response : ${response.data}');
      }
    } catch (e) {
      print("Error2 $e");
    }
  }

  /////////------- Getting StaffTypeData From SP---------//////
  Future<List<DropDownValueModel>> loadStaffTypesFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String staffTypeData = prefs.getString('staffType') ??
        '[]'; // Default to an empty list if data is not available

    List<dynamic> staffTypeList = json.decode(staffTypeData);

    // Map the JSON data to DropDownValueModel objects
    List<DropDownValueModel> dropDownList = staffTypeList.map((item) {
      return DropDownValueModel(
        name: item['name'],
        value:
            item['id'].toString(), // Assuming 'id' is the value you want to use
      );
    }).toList();

    return dropDownList;
  }

  void clearFields() {
    setState(() {
      _title = null;
      _personName = '';
      _fatherName = '';
      _gender = null;
      dateofBirthValue = '';
      // _cardNo = null;
      _cnicNo = '';
      dateSub.value = null;
      dateofBirth.value = null;
      _categoryType = '';
      _mobileNo = '';
      _landlineNo = '';
      _identityShift = null;
      _description = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scheight = MediaQuery.of(context).size.height;

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
            height: Platform.isAndroid ? scheight / 1.13 : scheight / 1.12,
            width: scWidth,
            color: greyColor,
            child: Column(
              children: [
                Container(
                  color: appcolor,
                  width: scWidth,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    bottom: marginLR,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Add Staff",
                    style:
                        TextStyle(color: dfColor, fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: scheight / 8,
                          width: scWidth,
                          margin: EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CardImageWidget(
                                onRemovePressed: () {
                                  // Handle the remove image action here

                                  setState(() {
                                    _staffImagePath = ''; // Set to empty string
                                  });
                                },
                                licenseImage: _staffImagePath,
                                function: () {
                                  _showImagePickerDialog(0);
                                },
                                imageText: 'Upload Staff\'s Image',
                                customImage: 'asserts/images/addstaff.png',
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
                                  top: scheight / 7.3, bottom: scheight / 10)
                              : EdgeInsets.only(
                                  top: scheight / 7.4, bottom: scheight / 11),
                          height: Platform.isAndroid
                              ? scheight / 1.75
                              : scheight / 1.80,
                          child: SingleChildScrollView(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: dfColor,
                                ),
                                margin: EdgeInsets.only(
                                  left: marginLR,
                                  right: marginLR,
                                ),
                                child: Container(
                                    margin: Platform.isAndroid
                                        ? EdgeInsets.only(
                                            top: 10,
                                            right: 20,
                                            left: 20,
                                            bottom: 5)
                                        : EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Select Title:",
                                                    style: TextStyle(
                                                        fontSize: exSmFontSize,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: appcolor),
                                                  ),
                                                  Container(
                                                    child: DropDownTextField(
                                                      // initialValue: "Select",
                                                      // readOnly: true,
                                                      controller: _cnt,
                                                      padding: EdgeInsets
                                                          .symmetric(),
                                                      clearOption: true,
                                                      isEnabled: true,

                                                      dropDownIconProperty:
                                                          IconProperty(
                                                              icon: Icons
                                                                  .keyboard_arrow_down),

                                                      keyboardType:
                                                          TextInputType.number,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .disabled,
                                                      clearIconProperty:
                                                          IconProperty(
                                                              color:
                                                                  Colors.green),

                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return "Please Select Title";
                                                        }
                                                        return null;
                                                      },
                                                      dropDownItemCount: 6,

                                                      dropDownList: const [
                                                        DropDownValueModel(
                                                            name: 'Mr',
                                                            value: "Mr"),
                                                        DropDownValueModel(
                                                            name: 'Mrs',
                                                            value: "Mrs"),
                                                      ],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _title = value.name;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ]),
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
                                                  color: Colors.black45),
                                              decoration: InputDecoration(
                                                hintText: "Name",
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

                                              ///  alloewed  alphabet and space only
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                        RegExp(r'[a-zA-Z\s]')),
                                              ],
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please Enter Name';
                                                }

                                                return null;
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  _personName = value.trim();
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
                                                  color: Colors.black45),
                                              decoration: InputDecoration(
                                                hintText: "Father/Spouse Name",
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

                                              ///  alloewed  alphabet and space only
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                        RegExp(r'[a-zA-Z\s]')),
                                              ],
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please Enter Father/Spouse Name';
                                                }

                                                return null;
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  _fatherName = value.trim();
                                                  print("Father Name : " +
                                                      _fatherName);
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: appcolor),
                                                  ),
                                                  DropDownTextField(
                                                    // initialValue: "name4",
                                                    // readOnly: true,
                                                    controller: _cnt,
                                                    clearOption: true,
                                                    isEnabled: true,
                                                    dropDownIconProperty:
                                                        IconProperty(
                                                            icon: Icons
                                                                .keyboard_arrow_down),

                                                    keyboardType:
                                                        TextInputType.number,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .disabled,
                                                    clearIconProperty:
                                                        IconProperty(
                                                            color:
                                                                Colors.green),

                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Please Select Gender";
                                                      }
                                                      return null;
                                                    },
                                                    dropDownItemCount: 6,

                                                    dropDownList: const [
                                                      DropDownValueModel(
                                                          name: 'Male',
                                                          value: "1"),
                                                      DropDownValueModel(
                                                          name: 'Female',
                                                          value: "2"),
                                                      DropDownValueModel(
                                                          name: 'Other',
                                                          value: "3"),
                                                    ],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _gender = value.value;
                                                      });
                                                    },
                                                  ),
                                                ]),
                                          ),

                                          //------------------
                                          Container(
                                            margin: EdgeInsets.only(top: 8),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Select Category:",
                                                    style: TextStyle(
                                                        fontSize: exSmFontSize,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: appcolor),
                                                  ),
                                                  DropDownTextField(
                                                    controller: _cnt,
                                                    clearOption: true,
                                                    isEnabled: true,
                                                    dropDownIconProperty:
                                                        IconProperty(
                                                            icon: Icons
                                                                .keyboard_arrow_down),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .disabled,
                                                    clearIconProperty:
                                                        IconProperty(
                                                            color:
                                                                Colors.green),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Please Select Category";
                                                      }
                                                      return null;
                                                    },
                                                    dropDownList:
                                                        _staffTypes, // Use the _staffTypes list
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _categoryType = value
                                                            .value
                                                            .toString();

                                                        //get type name
                                                        driverName = value.name
                                                            .toString();

                                                        print("Driver Name: " +
                                                            driverName
                                                                .toString());
                                                      });
                                                    },
                                                  ),
                                                ]),
                                          ),

                                          //------------------

                                          Container(
                                            margin: EdgeInsets.only(top: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Select Identity Type:",
                                                  style: TextStyle(
                                                      fontSize: exSmFontSize,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: appcolor),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 8),
                                                  child: Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Radio<IdentityCardNo>(
                                                            activeColor:
                                                                appcolor,
                                                            value:
                                                                IdentityCardNo
                                                                    .CNIC,
                                                            groupValue:
                                                                driverName ==
                                                                        "Driver"
                                                                    ? null
                                                                    : _cardType,
                                                            visualDensity: const VisualDensity(
                                                                horizontal:
                                                                    VisualDensity
                                                                        .minimumDensity,
                                                                vertical:
                                                                    VisualDensity
                                                                        .minimumDensity),
                                                            materialTapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                            onChanged:
                                                                (IdentityCardNo?
                                                                    value) {
                                                              setState(() {
                                                                _cardType =
                                                                    value;

                                                                if (driverName ==
                                                                    "Driver") {
                                                                  funToast(
                                                                      "Please Change Category",
                                                                      appcolor);
                                                                }
                                                              });
                                                            },
                                                          ),
                                                          Text(
                                                            "CNIC",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    dfFontSize,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: driverName ==
                                                                        "Driver"
                                                                    ? lightGrey
                                                                    : appcolor),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 20),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Radio<IdentityCardNo>(
                                                            activeColor:
                                                                appcolor,
                                                            value:
                                                                IdentityCardNo
                                                                    .NICOP,
                                                            groupValue:
                                                                driverName ==
                                                                        "Driver"
                                                                    ? null
                                                                    : _cardType,
                                                            visualDensity: const VisualDensity(
                                                                horizontal:
                                                                    VisualDensity
                                                                        .minimumDensity,
                                                                vertical:
                                                                    VisualDensity
                                                                        .minimumDensity),
                                                            materialTapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                            onChanged:
                                                                (IdentityCardNo?
                                                                    value) {
                                                              setState(() {
                                                                _cardType =
                                                                    value;

                                                                if (driverName ==
                                                                    "Driver") {
                                                                  funToast(
                                                                      "Please Change Category",
                                                                      appcolor);
                                                                }
                                                              });
                                                            },
                                                          ),
                                                          Text(
                                                            "NICOP",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    dfFontSize,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: driverName ==
                                                                        "Driver"
                                                                    ? lightGrey
                                                                    : appcolor),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 20),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Radio<IdentityCardNo>(
                                                            activeColor:
                                                                appcolor,
                                                            value:
                                                                IdentityCardNo
                                                                    .DLNO,
                                                            groupValue: driverName ==
                                                                    "Driver"
                                                                ? _cardType =
                                                                    IdentityCardNo
                                                                        .DLNO
                                                                : _cardType,
                                                            visualDensity: const VisualDensity(
                                                                horizontal:
                                                                    VisualDensity
                                                                        .minimumDensity,
                                                                vertical:
                                                                    VisualDensity
                                                                        .minimumDensity),
                                                            materialTapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                            onChanged:
                                                                (IdentityCardNo?
                                                                    value) {
                                                              setState(() {
                                                                _cardType =
                                                                    value;

                                                                print("Type " +
                                                                    _cardType
                                                                        .toString());
                                                              });
                                                            },
                                                          ),
                                                          Text(
                                                            "D.License",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    dfFontSize,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    appcolor),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
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
                                                  color: Colors.black45),
                                              maxLength: 15,
                                              decoration: InputDecoration(
                                                hintText: driverName ==
                                                            "Driver" ||
                                                        _cardType ==
                                                            IdentityCardNo.DLNO
                                                    ? "License Number"
                                                    : _cardType ==
                                                            IdentityCardNo.CNIC
                                                        ? "CNIC Number"
                                                        : "NICOP Number",
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
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                driverName == "Driver" ||
                                                        _cardType ==
                                                            IdentityCardNo.DLNO
                                                    ? DrivingLicense()
                                                    : CNICInputFormatter()
                                              ],
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please Enter CNIC';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                _cnicNo =
                                                    value.replaceAll('-', '');
                                              },
                                            ),
                                          ),

                                          //------------------
                                          Container(
                                            margin: EdgeInsets.only(top: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                CardImageWidget(
                                                  onRemovePressed: () {
                                                    // Handle the remove image action here

                                                    setState(() {
                                                      _idFrontPath =
                                                          ''; // Set to empty string
                                                    });
                                                  },
                                                  licenseImage: _idFrontPath,
                                                  function: () {
                                                    _showImagePickerDialog(1);
                                                  },
                                                  imageText: driverName ==
                                                              "Driver" ||
                                                          _cardType ==
                                                              IdentityCardNo
                                                                  .DLNO
                                                      ? 'License Front Image'
                                                      : _cardType ==
                                                              IdentityCardNo
                                                                  .CNIC
                                                          ? 'CNIC Front Image'
                                                          : 'NICOP Front Image',
                                                  customImage:
                                                      'asserts/images/cnicfornt.png',
                                                  ftSize: Platform.isAndroid
                                                      ? scWidth / 33
                                                      : scWidth / 34,
                                                ),
                                                CardImageWidget(
                                                  onRemovePressed: () {
                                                    // Handle the remove image action here

                                                    setState(() {
                                                      _idBackPath =
                                                          ''; // Set to empty string
                                                    });
                                                  },
                                                  licenseImage: _idBackPath,
                                                  function: () {
                                                    _showImagePickerDialog(2);
                                                  },
                                                  imageText: driverName ==
                                                              "Driver" ||
                                                          _cardType ==
                                                              IdentityCardNo
                                                                  .DLNO
                                                      ? 'License Back Image'
                                                      : _cardType ==
                                                              IdentityCardNo
                                                                  .CNIC
                                                          ? 'CNIC Back Image'
                                                          : 'NICOP Back Image',
                                                  customImage:
                                                      'asserts/images/cnicback.png',
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
                                              builder:
                                                  (context, dateVal, child) {
                                                return InkWell(
                                                    onTap: () async {
                                                      DateTime? date =
                                                          await showDatePicker(
                                                              context: context,
                                                              initialDate:
                                                                  DateTime
                                                                      .now(),
                                                              firstDate:
                                                                  DateTime(
                                                                      1920),
                                                              lastDate: DateTime(
                                                                  2080),
                                                              currentDate:
                                                                  DateTime
                                                                      .now(),
                                                              initialEntryMode:
                                                                  DatePickerEntryMode
                                                                      .calendar,
                                                              initialDatePickerMode:
                                                                  DatePickerMode
                                                                      .day,
                                                              builder: (context,
                                                                  child) {
                                                                return Theme(
                                                                  data: Theme.of(
                                                                          context)
                                                                      .copyWith(
                                                                          colorScheme:
                                                                              ColorScheme.fromSwatch(
                                                                    primarySwatch:
                                                                        Colors
                                                                            .blue,
                                                                    accentColor:
                                                                        appcolor,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .lightBlue,
                                                                    cardColor:
                                                                        Colors
                                                                            .white,
                                                                  )),
                                                                  child: child!,
                                                                );
                                                              });
                                                      dateSub.value = date;

                                                      dateExpireValue = dateVal !=
                                                              null
                                                          ? DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(dateVal)
                                                          : '';

                                                      print(
                                                          "Date of Birth : $dateExpireValue");
                                                    },
                                                    child: PickDate(
                                                        date: dateVal != null
                                                            ? dateExpireValue =
                                                                formatDate(
                                                                    dateVal, [
                                                                yyyy,
                                                                '-',
                                                                mm,
                                                                '-',
                                                                dd
                                                              ])
                                                            : driverName ==
                                                                        "Driver" ||
                                                                    _cardType ==
                                                                        IdentityCardNo
                                                                            .DLNO
                                                                ? 'License Expiry (DD-MM-YY)'
                                                                : _cardType ==
                                                                        IdentityCardNo
                                                                            .CNIC
                                                                    ? 'CNIC Expiry (DD-MM-YY)'
                                                                    : 'NICOP Expiry (DD-MM-YY)'));
                                              }),
                                          //------------------
                                          ValueListenableBuilder<DateTime?>(
                                              valueListenable: dateofBirth,
                                              builder:
                                                  (context, dateVal, child) {
                                                return InkWell(
                                                    onTap: () async {
                                                      DateTime? date =
                                                          await showDatePicker(
                                                              context: context,
                                                              initialDate:
                                                                  DateTime
                                                                      .now(),
                                                              firstDate:
                                                                  DateTime(
                                                                      1920),
                                                              lastDate: DateTime
                                                                  .now(),
                                                              currentDate:
                                                                  DateTime
                                                                      .now(),
                                                              initialEntryMode:
                                                                  DatePickerEntryMode
                                                                      .calendar,
                                                              initialDatePickerMode:
                                                                  DatePickerMode
                                                                      .day,
                                                              builder: (context,
                                                                  child) {
                                                                return Theme(
                                                                  data: Theme.of(
                                                                          context)
                                                                      .copyWith(
                                                                          colorScheme:
                                                                              ColorScheme.fromSwatch(
                                                                    primarySwatch:
                                                                        Colors
                                                                            .blue,
                                                                    accentColor:
                                                                        appcolor,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .lightBlue,
                                                                    cardColor:
                                                                        Colors
                                                                            .white,
                                                                  )),
                                                                  child: child!,
                                                                );
                                                              });
                                                      dateofBirth.value = date;

                                                      dateofBirthValue = dateVal !=
                                                              null
                                                          ? DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(dateVal)
                                                          : '';

                                                      print(
                                                          "Date of Birth : $dateofBirthValue");
                                                    },
                                                    child: PickDate(
                                                        date: dateVal != null
                                                            ? dateofBirthValue =
                                                                formatDate(
                                                                    dateVal, [
                                                                yyyy,
                                                                '-',
                                                                mm,
                                                                '-',
                                                                dd
                                                              ])
                                                            : 'Date of Birth (DD-MM-YY)'));
                                              }),
                                          //------------------

                                          Container(
                                            margin: EdgeInsets.only(top: 8),
                                            child: TextFormField(
                                              textInputAction:
                                                  TextInputAction.next,
                                              autofocus: false,
                                              maxLength: 11,
                                              style: TextStyle(
                                                  fontSize: 19.0,
                                                  color: Colors.black45),
                                              decoration: InputDecoration(
                                                hintText: "Mobile Number",
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
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please Enter Mobile Number';
                                                }

                                                return null;
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  _mobileNo = value.trim();
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
                                              maxLength: 10,
                                              autofocus: false,
                                              style: TextStyle(
                                                  fontSize: 19.0,
                                                  color: Colors.black45),
                                              decoration: InputDecoration(
                                                hintText: "Landline Number",
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
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) {
                                                return null;
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  _landlineNo = value.trim();
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
                                                  "Select Shift:",
                                                  style: TextStyle(
                                                      fontSize: exSmFontSize,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: appcolor),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 8),
                                                  child: Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Radio<IdentityShift>(
                                                            activeColor:
                                                                appcolor,
                                                            value: IdentityShift
                                                                .Day,
                                                            groupValue:
                                                                _identityShift,
                                                            visualDensity: const VisualDensity(
                                                                horizontal:
                                                                    VisualDensity
                                                                        .minimumDensity,
                                                                vertical:
                                                                    VisualDensity
                                                                        .minimumDensity),
                                                            materialTapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                            onChanged:
                                                                (IdentityShift?
                                                                    value) {
                                                              setState(() {
                                                                _identityShift =
                                                                    value;
                                                                idenShift =
                                                                    "Day";
                                                              });
                                                            },
                                                          ),
                                                          Text(
                                                            "Day",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    dfFontSize,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    appcolor),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 30),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Radio<IdentityShift>(
                                                            activeColor:
                                                                appcolor,
                                                            value: IdentityShift
                                                                .Night,
                                                            groupValue:
                                                                _identityShift,
                                                            visualDensity: const VisualDensity(
                                                                horizontal:
                                                                    VisualDensity
                                                                        .minimumDensity,
                                                                vertical:
                                                                    VisualDensity
                                                                        .minimumDensity),
                                                            materialTapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                            onChanged:
                                                                (IdentityShift?
                                                                    value) {
                                                              setState(() {
                                                                _identityShift =
                                                                    value;
                                                                idenShift =
                                                                    "Night";
                                                              });
                                                            },
                                                          ),
                                                          Text(
                                                            "Night",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    dfFontSize,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    appcolor),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 30),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Radio<IdentityShift>(
                                                            activeColor:
                                                                appcolor,
                                                            value: IdentityShift
                                                                .DayNight,
                                                            groupValue:
                                                                _identityShift,
                                                            visualDensity: const VisualDensity(
                                                                horizontal:
                                                                    VisualDensity
                                                                        .minimumDensity,
                                                                vertical:
                                                                    VisualDensity
                                                                        .minimumDensity),
                                                            materialTapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                            onChanged:
                                                                (IdentityShift?
                                                                    value) {
                                                              setState(() {
                                                                _identityShift =
                                                                    value;
                                                                idenShift =
                                                                    "Day_Night";
                                                              });
                                                            },
                                                          ),
                                                          Text(
                                                            "Day/Night",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    dfFontSize,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    appcolor),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
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
                                              minLines: 1,
                                              maxLength: 500,
                                              maxLines: 5,
                                              style: TextStyle(
                                                fontSize: 19.0,
                                                color: Colors.black87,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: "Staff's Description",
                                                hintStyle: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 12),
                                                filled: true,
                                                fillColor: drakGreyColor,
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 16.0,
                                                        bottom: 30.0,
                                                        top: 30.0),
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
                                                        r'[a-zA-Z0-9., ]'))
                                              ],
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please Add Staff Description';
                                                }

                                                // Define a regular expression pattern to match alphabets, numbers, and full stops
                                                final RegExp pattern = RegExp(
                                                    r'^[a-zA-Z0-9., ]*$');

                                                if (!pattern.hasMatch(value)) {
                                                  return 'Only alphabets, numbers, and full stops are allowed';
                                                }

                                                return null;
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  _description = value.trim();
                                                });
                                              },
                                            ),
                                          ),

                                          //--------------------
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
                                // margin: EdgeInsets.only(bottom: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 25,
                                          height: Platform.isAndroid
                                              ? scheight / 30
                                              : scheight / 35,
                                          child: Checkbox(
                                            checkColor: greyColor,
                                            fillColor: WidgetStateProperty
                                                .resolveWith<Color>(
                                                    (Set<WidgetState>
                                                        states) {
                                              if (states.contains(
                                                  WidgetState.disabled)) {
                                                return drakGreyColor;
                                              }
                                              return appcolor;
                                            }),
                                            value: isChecked,
                                            onChanged: (bool? value) {
                                              _showCustomDialog(
                                                  context,
                                                  "Terms & Conditions",
                                                  "I ${logName} resident of House No $plot Street/ Lane/ Boulevard $street  Sector  $sector  Phase $phase  hereby  give  an  undertaking  that  I  personally  know  background  of $_personName  S/O,  D/O,  W/O  $_fatherName  CNIC  No  $_cnicNo  for  employment  as  servant  /  maid  /  driver  and  I  shall  be  responsible  for his/her conduct in DHAI-R. I Opt to forgo police verification of individual.");
                                            },
                                          ),
                                        ),
                                        Text(
                                          " Accept Terms and Conditions?",
                                          style: TextStyle(
                                            height: 1,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              //---------------------
                              Container(
                                decoration: BoxDecoration(
                                    gradient: lgBlue,
                                    borderRadius:
                                        BorderRadius.circular(roundBtn)),
                                width: scWidth,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      // printFormData();
                                      if (isChecked == true) {
                                        if (_staffImagePath.isEmpty) {
                                          funToast(
                                              "Profile Picture Is Required!",
                                              Colors.red);
                                        } else if (_idFrontPath.isEmpty) {
                                          funToast(
                                              "ID Card Front Picture Is Required!",
                                              Colors.red);
                                        } else if (_idBackPath.isEmpty) {
                                          funToast(
                                              "ID Card Back Picture Is Required!",
                                              Colors.red);
                                        } else {
                                          setState(() {
                                            _isLoading = true;
                                          });

                                          final Map<String, dynamic> postData =
                                              {
                                            'mobile_1': _mobileNo,
                                            'mobile_2': _landlineNo,
                                            'name': _personName,
                                            'father_name': _fatherName,
                                            'category': _categoryType,
                                            'shift': idenShift,
                                            'source': _source,
                                            'gender': _gender,
                                            'cnic': _cnicNo,
                                            'dob': dateofBirthValue,
                                            'cnic_expiry_date': dateExpireValue,
                                            'profile_pic': _staffImagePath,
                                            'cnic_front': _idFrontPath,
                                            'cnic_back': _idBackPath,
                                            'description': _description,
                                          };

                                          sendStaffData(postData);
                                        }
                                      } else if (isChecked == false) {
                                        funToast(
                                            "Please Read Terms And Conditions!",
                                            Colors.redAccent);
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Add Staff',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// CNIC FOrmattor Class
class CNICInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    final cleanText =
        text.replaceAll(RegExp(r'[^\d]'), ''); // Remove non-digits

    if (cleanText.isEmpty) {
      return TextEditingValue();
    }

    final formattedText = _formatCNIC(cleanText);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatCNIC(String text) {
    if (text.length <= 5) {
      // Format: 12345
      return text;
    } else if (text.length <= 12) {
      // Format: 12345-67890
      return '${text.substring(0, 5)}-${text.substring(5)}';
    } else {
      // Format: 12345-6789012-3
      return '${text.substring(0, 5)}-${text.substring(5, 12)}-${text.substring(12, 13)}'; // Only include the last digit
    }
  }
}

class DrivingLicense extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    final cleanText = text.replaceAll(
        RegExp(r'[^\dA-Za-z]'), ''); // Remove non-digits and non-letters

    if (cleanText.isEmpty) {
      return TextEditingValue();
    }

    final formattedText = _formatCustomCNIC(cleanText);

    if (formattedText.length > 12) {
      return TextEditingValue(
        text: formattedText.substring(0, 12),
        selection: TextSelection.collapsed(offset: 12),
      );
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatCustomCNIC(String text) {
    final length = text.length;
    if (length <= 8) {
      // Format: 12345678
      return text;
    } else {
      // Format: 12345678-ABC
      return '${text.substring(0, 8)}-${text.substring(8)}';
    }
  }
}
