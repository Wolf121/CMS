import 'dart:io';
import 'dart:math';
import 'package:dha_resident_app/constant.dart';
import 'package:dha_resident_app/view/screens/dashboard/bottomNavBar.dart';
import 'package:dha_resident_app/view/widgets/card_Image_widget.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:geolocator/geolocator.dart';

import 'package:image_picker/image_picker.dart';

import '../../../anim/animated_checkmark_dialog.dart';
import 'package:file_picker/file_picker.dart';

import '../../widgets/custom_dialog.dart';

// Catagori Class
class ChatagoriDataArray {
  final int id;

  final String name;

  ChatagoriDataArray({
    required this.id,
    required this.name,
  });

  factory ChatagoriDataArray.fromJson(Map<String, dynamic> json) {
    return ChatagoriDataArray(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return '{\n'
        'id: $id,\n'
        'name: $name,\n'
        '}';
  }
}

// Sub Catagory Class
class SubChatagoriDataArray {
  final int id;
  final String name;

  SubChatagoriDataArray({
    required this.id,
    required this.name,
  });

  factory SubChatagoriDataArray.fromJson(Map<String, dynamic> json) {
    return SubChatagoriDataArray(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return '{\n'
        'id: $id,\n'
        'name: $name,\n'
        '}';
  }
}

/// Flutter code sample for DropdownButton.

class NewComplaint extends StatefulWidget {
  const NewComplaint({super.key});

  @override
  State<NewComplaint> createState() => _NewComplaintState();
}

class _NewComplaintState extends State<NewComplaint> {
  SingleValueDropDownController? _cnt;
  SingleValueDropDownController? _Subcnt;
  final _formKey = GlobalKey<FormState>();

  dynamic _category;
  dynamic _catID;
  dynamic _subcategory;
  dynamic _subCatID;
  dynamic _type;
  String _personName = '';
  String _mobileNo = '';
  String _landline = '';
  String _description = '';
  String _memberId = '';
  String _source = '';
  dynamic path = '';
  String? latitude;
  String? longitude;
  String? currentTime;
  List<DropDownValueModel> dropDownList = [];
  List<DropDownValueModel> subcategoryList = [];
  List<DropDownValueModel> subcategoryL = [];
  List<ChatagoriDataArray> chatagoriDataArray = [];
  List<SubChatagoriDataArray> subchatagoriDataArray = [];
  List<SubChatagoriDataArray> subchatagoriData = [];
  int selectedCategory = 0;
  String filePath = '';
  bool _isLoading = false;

  // String token =
  //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjVmRjOTFkNmI5MGYwMzRmZDE5MjhlNWI2MDhhMmJmZTBmNDNkMjg2ZmZkMDExZGI0MTRlNzNjMmRlMTc5ZjlkNjRmYzJhNzg0YjI0ZjBkIn0.eyJhdWQiOiIxIiwianRpIjoiNWY4NGM5MWQ2YjkwZjAzNGZkMTkyOGU1YjYwOGEyYmZlMGY0M2QyODZmZmQwMTFkYjQxNGU3M2MyZGUxNzlmOWQ2NGZjMmE3ODRiMjRmMGQiLCJpYXQiOjE2OTE2NTg5NzksIm5iZiI6MTY5MTY1ODk3OSwiZXhwIjoxNzIzMjgxMzc5LCJzdWIiOiI4MjAiLCJzY29wZXMiOltdfQ.PFjC4ww7Uop1QOX54oG5bXcinjWZxOcCyi2D9aomTu-RK5gpdO6pz0N0jZZEX3_WeNjB3h8jcIopcUBGlNOnZyATwFBcLfg6CVvjcw7n3ZdjZ4x0Ev05buIPUYhlN7SIY1cI9sIKQzAK-afiHhk6A7jSma56f0gCrUTmbB7g37dvl4o9YCVj0DEcgPMiSEkeBRas42aPwXP4TwyUiVFWwhmHCd1feYWW1vAGmaV5lrp4Tj2WtWiUw-pWla9Bo2fLXA9BIxLWKJ5WgsbJ8Mhx-siVJsoB-SpU9TJhJ4AT9KyYJK8PM9Jl8-GZSvFMSthW1r-GHl4w0xiXOq2RLBsk6cGTFDMxxMmnyNLO6sAsdMD6lg0Befoz0segKqmoUUWURQbKLC0MyG4qfP-o8DNzrWTGjJsOktlC3gNxaQG86diA-CxbDceOX_vu5-8aAUBKGvUU7gKXKF83xZMfCAdRaldS3FDjQjEvSQ87C-Hx9HyNmoV5XV7Rw-_uBFo_OyxN6W_j-IMOHiRg0Ncc6TgcWurVcoFZgpCeUpx4OO3AX_scwIipOZg00YKSO3mJ1PxPty5T6Q5Hu7jv0wbvufL6WtYa51Jm0XHjxiH0cianpw9MYFtvCItASOExDnBQ3q4soNOffHrycl5mrjGQ9ohEsZToeVO9pc7ahQAvV9tBs1U';
// getting Category ID
  Future<int?> getCategoryIdByName(String categoryName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String storedData = prefs.getString('chatagoriDataArray') ?? '';

    if (storedData.isNotEmpty) {
      final List<dynamic> dataArray = jsonDecode(storedData);

      for (var jsonData in dataArray) {
        final ChatagoriDataArray chatagoriData =
            ChatagoriDataArray.fromJson(jsonData);

        if (chatagoriData.name == categoryName) {
          selectedCategory = chatagoriData.id;
          print(chatagoriData.id);
          return chatagoriData.id;
        }
      }
    } else {
      print("storedData is Empty!");
    }

    return null; // Return null if category name is not found
  }

  // // Dialog fuction
  // void showCustomDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Upload Image!"),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               GestureDetector(
  //                 onTap: () async {
  //                   String fPath = "";
  //                   String? imagePath = await useImageFromCamera();
  //                   setState(() {});
  //                   print("File Name: " + imagePath.toString());
  //                   if (imagePath != null) {
  //                     filePath = imagePath.toString();
  //                     Navigator.of(context).pop(); // Close the dialog
  //                   }
  //                   File imageFile = File(filePath);
  //                   try {
  //                     int fileSize4MB = (4 * 1024); //4MB
  //                     int fileSizeMB = imageFile.lengthSync(); // file length
  //                     if (fileSizeMB <= fileSize4MB) {
  //                       filePath = filePath;
  //                       print('File size: $filePath');
  //                     }
  //                   } catch (error) {
  //                     print('Upload error: $error');
  //                     // Show a simple dialog with the error message
  //                   }
  //                 },
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       "Take a Photo",
  //                       style: TextStyle(
  //                         color: appcolor,
  //                       ),
  //                     ),
  //                     Icon(
  //                       Icons.camera,
  //                       color: appcolor,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(height: 20),
  //               ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                     backgroundColor: Colors.transparent, elevation: 0),
  //                 onPressed: () async {
  //                   String fPath = "";
  //                   String? imagePath = await useImageFromGallery();
  //                   setState(() {});
  //                   print("File Name: " + imagePath.toString());
  //                   if (imagePath != null) {
  //                     filePath = imagePath.toString();
  //                     Navigator.of(context).pop(); // Close the dialog
  //                   }
  //                   File imageFile = File(filePath);
  //                   try {
  //                     int fileSize4MB = (4 * 1024); //4MB
  //                     int fileSizeMB = imageFile.lengthSync(); // file length
  //                     if (fileSizeMB <= fileSize4MB) {
  //                       filePath = filePath;
  //                       print('File size: $filePath');
  //                     }
  //                   } catch (error) {
  //                     print('Upload error: $error');
  //                     // Show a simple dialog with the error message
  //                   }
  //                 },
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       "Choose From Gallery",
  //                       style: TextStyle(
  //                         color: appcolor,
  //                       ),
  //                     ),
  //                     Icon(
  //                       Icons.photo_library_outlined,
  //                       color: appcolor,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(height: 10),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Dialog fuction
  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Upload Image!",
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              mainAxis: Axis.vertical,
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
                      onPressed: () async {
                        String fPath = "";
                        String? imagePath = await useImageFromCamera();
                        setState(() {});
                        print("File Name: " + imagePath.toString());
                        if (imagePath != null) {
                          filePath = imagePath.toString();
                          Navigator.of(context).pop(); // Close the dialog
                        }

                        File imageFile = File(filePath);

                        try {
                          int fileSize4MB = (4 * 1024); //4MB

                          int fileSizeMB =
                              imageFile.lengthSync(); // file length

                          if (fileSizeMB <= fileSize4MB) {
                            filePath = filePath;

                            print('File size: $filePath');
                          }
                        } catch (error) {
                          print('Upload error: $error');

                          // Show a simple dialog with the error message
                        }
                      },
                      child: Icon(
                        Icons.camera,
                        color: dfColor,
                        size: MediaQuery.of(context).size.width / 12,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appcolor,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.width / 15,
                            horizontal: MediaQuery.of(context).size.width / 10),
                      ),
                      onPressed: () async {
                        String fPath = "";
                        String? imagePath = await useImageFromGallery();
                        setState(() {});
                        print("File Name: " + imagePath.toString());
                        if (imagePath != null) {
                          filePath = imagePath.toString();
                          Navigator.of(context).pop(); // Close the dialog
                        }

                        File imageFile = File(filePath);

                        try {
                          int fileSize4MB = (4 * 1024); //4MB

                          int fileSizeMB =
                              imageFile.lengthSync(); // file length

                          if (fileSizeMB <= fileSize4MB) {
                            filePath = filePath;

                            print('File size: $filePath');
                          }
                        } catch (error) {
                          print('Upload error: $error');

                          // Show a simple dialog with the error message
                        }
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

  //Browsing Image

  Future<XFile?> browseImageFromGallery() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  Future<String?> useImageFromGallery() async {
    // Add code to open image picker and return the selected image path
    // For example, using the image_picker package
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      return pickedImage.path;
    }
    return null; // Return null if no image is selected
  }

  Future<String?> useImageFromCamera() async {
    // Add code to open image picker and return the selected image path
    // For example, using the image_picker package
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    print("Use Camera: ${pickedImage?.path.toString()}");
    if (pickedImage != null) {
      return pickedImage.path;
    }
    return null; // Return null if no image is selected
  }

  //pick pdf
  Future<String?> pickPdf() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        return file.path;
      }
    } catch (e) {
      print('Error picking PDF: $e');
    }

    return null;
  }

// validate Mobile
  String? validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter follow-up mobile number";
    }

    // Remove any whitespace or special characters from the input
    String cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Check if the cleaned value is exactly 11 digits
    if (cleanValue.length != 11) {
      return "Mobile number must be 11 digits long (e.g., 03325426198)";
    }

    return null;
  }

//get Longs And Lats
  Future<void> getLocation() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        latitude = '${position.latitude}';
        longitude = '${position.longitude}';
      });
    } catch (e) {
      print("Error while getting location: $e");
    }
  }

  // get Device Time

  void getCurrentTime() {
    final DateTime now = DateTime.now();
    final String formattedTime = "${now.hour}:${now.minute}:${now.second}";
    setState(() {
      currentTime = formattedTime;
    });
  }

  Future<List<DropDownValueModel>> getItemsByMainCategoryWithPref(
      int mainCategoryId) async {
    List<DropDownValueModel> items = [];
    ChatagoriDataArray? mainCategory;

    // Retrieve stored data from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedData = prefs.getString('chatagoriDataArray');

    if (storedData!.isNotEmpty) {
      // Parse the stored data
      List<dynamic> storedList = jsonDecode(storedData);

      // Find the main category with the specified ID
      for (var category in storedList) {
        if (category['categoryId'] == mainCategoryId) {
          mainCategory = ChatagoriDataArray.fromJson(category);
          break;
        }
      }
    }

    if (mainCategory != null) {
      items.add(DropDownValueModel(
        name: mainCategory.name,
        value: mainCategory.id,
      ));
    }

    return items;
  }

  Future<int?> getCategoryIdFromName(String categoryName) async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString('chatagoriDataArray');

    if (storedData != null) {
      final List<dynamic> dataArray = jsonDecode(storedData);

      for (var jsonData in dataArray) {
        final ChatagoriDataArray chatagoriData =
            ChatagoriDataArray.fromJson(jsonData);

        if (chatagoriData.name == categoryName) {
          return chatagoriData.id;
        }
      }
    }
    //("this is comming from shared pref: " + chatagoriData.id.toString());
    return null; // Return null if category name is not found
  }

  Future<List<ChatagoriDataArray>> fetchChatagoriDataArrayFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String storedData = prefs.getString('chatagoriDataArray') ?? '';

    if (storedData.isNotEmpty) {
      final List<dynamic> dataArray = jsonDecode(storedData);
      final List<ChatagoriDataArray> chatagoriDataArray =
          dataArray.map((json) => ChatagoriDataArray.fromJson(json)).toList();
      return chatagoriDataArray;
    } else {
      return [];
    }
  }

  //submitting
  void printSelectedValues() async {
    print("Selected Category: $_category");
    print("Selected Subcategory: $_subcategory");
    print("Selected Type: $_type");

    final int? selectedCategoryId = await getCategoryIdByName(_category);
    final int? selectedSubcategoryId =
        await getCategoryIdFromName(_subcategory);

    print("Selected Category ID: ${selectedCategoryId ?? 'Not found'}");
    print("Selected Subcategory ID: ${selectedSubcategoryId ?? 'Not found'}");
  }

  // Shared Pref
  Future<void> storelistApi() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    const String url = 'http://110.93.244.74/api/categories';
    // const String url = 'http://110.93.244.74/api/categories';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> dataArray = data['data_array'];
      final List<ChatagoriDataArray> chatagoriDataArray = dataArray
          .map((jsonData) => ChatagoriDataArray.fromJson(jsonData))
          .toList();

      // Convert ChatagoriDataArray instances to JSON-compatible maps
      final List<Map<String, dynamic>> serializedData = chatagoriDataArray
          .map((chatagoriItem) => chatagoriItem.toJson())
          .toList();

      print("Data Category : ${serializedData.length}");

      // Store the serialized data in SharedPreferences
      await prefs.setString('chatagoriDataArray', jsonEncode(serializedData));
      //print(chatagoriDataArray);
      // Now you have the chatagoriDataArray stored in SharedPreferences
    } else {
      print('API request failed with status: ${response.statusCode}.');
    }
  }

  // Shared Pref
  Future<void> storeSubCategorylistApi(dynamic catIId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    String url = 'http://110.93.244.74/api/SubCategories/$catIId';
    // const String url = 'http://110.93.244.74/api/categories';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> dataArray = data['data_array'];

      // final List<SubChatagoriDataArray> chatagoriDataArray = dataArray
      //   .map((jsonData) => SubChatagoriDataArray.fromJson(jsonData))
      //   .toList();

      subchatagoriData = dataArray
          .map((jsonData) => SubChatagoriDataArray.fromJson(jsonData))
          .toList();

      final updatedDropDownList = <DropDownValueModel>[];
      subchatagoriData.forEach((item) {
        // Use the category id as the value and the name as the name
        // Check if the category id is 0 before adding to the list
        // if (item.id == 0) {
        updatedDropDownList.add(DropDownValueModel(
          name: item.name,
          value: item.id,
        ));
        // }
      });

      setState(() {
        subcategoryL = updatedDropDownList; // Update the category dropdown list

        print("List Sub Category : ${subcategoryL}");
      });

      // Convert SubChatagoriDataArray instances to JSON-compatible maps
      final List<Map<String, dynamic>> serializedData = subchatagoriData
          .map((chatagoriItem) => chatagoriItem.toJson())
          .toList();

      print("Data SubCategory : ${serializedData.length}");
      print("Data SubCategory List : ${serializedData}");

      // Store the serialized data in SharedPreferences
      await prefs.setString('subchatagoriData', jsonEncode(serializedData));
      //print(chatagoriDataArray);
      // Now you have the chatagoriDataArray stored in SharedPreferences
    } else {
      print('API request failed with status: ${response.statusCode}.');
    }
  }

// getting Api Data

// Function to retrieve categories from SharedPreferences and populate the list
  Future<void> getCategoriesFromSharedPreferences() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? serializedData = prefs.getString('chatagoriDataArray');

      if (serializedData != null && serializedData.isNotEmpty) {
        final List<dynamic> dataArray = jsonDecode(serializedData);
        chatagoriDataArray =
            dataArray.map((json) => ChatagoriDataArray.fromJson(json)).toList();

        print("category Id : ${chatagoriDataArray}");

        // Update the dropdown lists if needed
        final updatedDropDownList = <DropDownValueModel>[];
        chatagoriDataArray.forEach((item) {
          // Use the category id as the value and the name as the name
          // Check if the category id is 0 before adding to the list
          // if (item.id == 0) {
          updatedDropDownList.add(DropDownValueModel(
            name: item.name,
            value: item.id,
          ));
          // }
        });

        setState(() {
          dropDownList =
              updatedDropDownList; // Update the category dropdown list

          print("List Category : ${dropDownList}");

          subcategoryList.clear();
          subcategoryList = [];
          //     selectedCategory); // Update the subcategory dropdown list
        });
      } else {
        print('No category data found in SharedPreferences.');
      }
    } catch (e) {
      print('Error retrieving category data from SharedPreferences: $e');
    }
  }

  // Function to get subcategories by category ID
  Future<void> getSubcategoriesByCatId() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? serializedData = prefs.getString('subchatagoriData');

      if (serializedData != null && serializedData.isNotEmpty) {
        final List<dynamic> dataArray = jsonDecode(serializedData);
        subchatagoriDataArray = dataArray
            .map((json) => SubChatagoriDataArray.fromJson(json))
            .toList();

// print("sub category Id : ${subchatagoriDataArray}");

        // Update the dropdown lists if needed
        final updatedDropDownList = <DropDownValueModel>[];
        subchatagoriDataArray.forEach((item) {
          // Use the category id as the value and the name as the name
          // Check if the category id is 0 before adding to the list
          // if (item.id == 0) {
          updatedDropDownList.add(DropDownValueModel(
            name: item.name,
            value: item.id,
          ));
          // }
        });

        setState(() {
          subcategoryList =
              updatedDropDownList; // Update the category dropdown list

          print("List Sub Category : ${subcategoryList}");
        });
      } else {
        print('No sub category data found in SharedPreferences.');
      }
    } catch (e) {
      print('Error retrieving category data from SharedPreferences: $e');
    }
  }

  // Function to get subcategories by category ID
  List<DropDownValueModel> getSubcategoriesByCategoryId(
      List<SubChatagoriDataArray> chatagoriDataArray, int categoryId) {
    List<DropDownValueModel> subcategories = [];

    for (var item in chatagoriDataArray) {
      if (item.id == categoryId && item.id != categoryId) {
        // Only add items with a category ID matching the selected category,
        // and exclude items with the same ID as the category (main category).
        subcategories.add(DropDownValueModel(
          name: item.name,
          value: item.id,
        ));
      }
    }

    return subcategories;
  }

  // Future<void> getDataFromApi() async {
  //   //getting token from the SharedPreference
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String token = prefs.getString('token') ?? '';
  //   // Getting Main Catagories
  //   const String url = 'http://110.93.244.74/api/categories';
  //   final response = await http.get(Uri.parse(url), headers: {
  //     'Authorization': 'Bearer $token',
  //   });
  //   //print('API Response: ${response.body}');
  //   if (response.statusCode == 200) {
  //     _isLoading = false;
  //     final Map<String, dynamic> data = jsonDecode(response.body);
  //     final int? success = data['success'];
  //     final String message = data['message'];
  //     final List<dynamic> dataArray = data['data_array'];
  //     chatagoriDataArray =
  //         dataArray.map((json) => ChatagoriDataArray.fromJson(json)).toList();
  //     // Declare a list of DropDownValueModel
  //     final updatedDropDownList = <DropDownValueModel>[];
  //     await Future.forEach(chatagoriDataArray, (item) {
  //       // Use the category id as the value and the name as the name
  //       // Check if the category id is 0 before adding to the list
  //       if (item.categoryId == 0) {
  //         updatedDropDownList.add(DropDownValueModel(
  //           name: item.name,
  //           value: item.categoryId,
  //         ));
  //       }
  //     });
  //     setState(() {
  //       dropDownList = updatedDropDownList; // Update the category dropdown list
  //       //print("this is selected ctegori: " + updatedDropDownList.toString());
  //       subcategoryList = getSubcategories(chatagoriDataArray,
  //           selectedCategory); // Update the subcategory dropdown list
  //     });
  //   } else if (response.statusCode == 404) {
  //     _isLoading = false;
  //     // Handle the error
  //     print('Request failed with status: ${response.statusCode}.');
  //   } else if (response.statusCode == 500) {
  //     _isLoading = false;
  //     print('Request failed with status: ${response.statusCode}.');
  //   } else {
  //     _isLoading = false;
  //     print('Other Error!');
  //   }
  // }
  // geting Membership ID

  Future<void> fetchAndSaveMembershipIds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    final headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
        Uri.parse('http://110.93.244.74/api/complaint/complaint_membership'),
        headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> dataArray = data['data_array'];

      List<String> membershipIds = [];

      for (var item in dataArray) {
        final String membershipId = item['membershipid'] ?? "";

        if (membershipId.isEmpty) {
          _memberId = _memberId;
        } else {
          _memberId = membershipId;
        }

        print("MemberShip :${membershipId}");
        membershipIds.add(membershipId);
      }

      // Save membershipIds in shared preferences
      await prefs.setStringList('membershipIds', membershipIds);

      // Check if membership IDs are the same and store in _memberId
      if (membershipIds.isNotEmpty &&
          membershipIds.every((id) => id == membershipIds[0])) {
        setState(() {
          _memberId = membershipIds[0];
        });
        print('_memberId: $_memberId');
      }
    } else {
      print('API request failed with status: ${response.statusCode}.');
    }
  }

  List<DropDownValueModel> getItemsByCategory(
      List<ChatagoriDataArray> chatagoriDataArray, int selectedCategoryId) {
    List<DropDownValueModel> items = [];

    for (var item in chatagoriDataArray) {
      if (item.id == selectedCategoryId) {
        items.add(DropDownValueModel(
          name: item.name,
          value: item.id,
        ));
      }
    }

    return items;
  }

  // List<DropDownValueModel> getSubcategories(
  //     List<ChatagoriDataArray> chatagoriDataArray, int selectedcatagoryId) {
  //   List<DropDownValueModel> subcategories = [];
  //   if (selectedcatagoryId != 0) {
  //     for (var item in chatagoriDataArray) {
  //       if (item.categoryId == selectedcatagoryId) {
  //         subcategories.add(DropDownValueModel(
  //           name: item.name,
  //           value: item.id,
  //         ));
  //       }
  //       // print("this is item name:" + item.name);
  //       // print("this is item ID:" + item.id.toString());
  //     }
  //   }
  //   return subcategories;
  // }

  //Posting Data
  Future<String?> _getTokenFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Replace 'authToken' with your key
  }

  justPrinting() {
    print("category : ${_catID}");
    print("subcategory : ${_subCatID}");
    print("descript : ${_description}");
    print("lat : ${latitude}");
    print("log: ${longitude}");
    print("type: ${_type}");
    print("person : ${_personName}");
    print("mobile : ${_mobileNo}");
    print("landline: ${_landline}");
    print("MemberId: ${_memberId}");
    print("CurrentId : ${currentTime}");
    print("Source: ${_source}");
  }

  Future<void> postComplaintData(Map<String, dynamic> complaint) async {
    final String apiUrl = 'http://110.93.244.74/api/complaint/complaint_store';

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
    var formData;

    if (filePath != '') {
      formData = FormData.fromMap({
        'category_id': complaint['category_id'].toString(),
        'subcategory_id': complaint['subcategory_id'].toString(),
        'description': complaint['description'].toString(),
        'lat': complaint['lat'].toString(),
        'lng': complaint['lng'].toString(),
        'type': complaint['type'].toString(),
        'followup_name': complaint['followup_name'].toString() ?? "N/A",
        'followup_cell': complaint['followup_cell'].toString() ?? "N/A",
        'followup_landline': complaint['followup_landline'].toString() ?? "N/A",
        'membership_id': complaint['membership_id'].toString(),
        'device_time': complaint['device_time'].toString(),
        'request_time': complaint['request_time'].toString(),
        'source': complaint['source'].toString(),
        'document': await MultipartFile.fromFile(complaint['document']),
      });
      print("Image with");
    } else {
      formData = FormData.fromMap({
        'category_id': complaint['category_id'].toString(),
        'subcategory_id': complaint['subcategory_id'].toString(),
        'description': complaint['description'].toString(),
        'lat': complaint['lat'].toString(),
        'lng': complaint['lng'].toString(),
        'type': complaint['type'].toString(),
        'followup_name': complaint['followup_name'].toString() ?? "N/A",
        'followup_cell': complaint['followup_cell'].toString() ?? "N/A",
        'followup_landline': complaint['followup_landline'].toString() ?? "N/A",
        'membership_id': complaint['membership_id'].toString(),
        'device_time': complaint['device_time'].toString(),
        'request_time': complaint['request_time'].toString(),
        'source': complaint['source'].toString(),
        // 'document': await MultipartFile.fromFile(complaint['document']),
      });
      print("Image without");
    }

    var dio = Dio();
    var response = await dio.post(
      apiUrl,
      data: formData,
      options: Options(
        headers: headers,
      ),
    );

    if (response.statusCode == 200) {
      // Successful request
      print(response);
      showAnimatedCheckmarkDialog(context, 'Complaint Submitted!', appcolor);
      _isLoading = false;

      await Future.delayed(Duration(seconds: 1));

      final route = MaterialPageRoute(builder: (context) => BottomNavBar());

      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    } else {
      _isLoading = false;
      // Error handling

      print('API Error: ${response.statusCode}+${response.data}');

      // Show a simple dialog with the API error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Server Side Issue!'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text(
                    'Something Went Wrong! ' + response.statusCode.toString()),
              ),
            ],
          );
        },
      );
    }
  }

  // //uploading image
  // Future<void> uploadFile(String complaintId, String filePath) async {
  //   final String apiUrl =
  //       'http://110.93.244.74/api/complaint/complaint_fileupload';
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String? authToken = prefs.getString('token');
  //   if (authToken == null) {
  //     print('Authentication token not available.');
  //     return;
  //   }
  //   final Map<String, String> headers = {
  //     'Authorization': 'Bearer $authToken',
  //   };
  //   //String fileName = getFileNameFromPath(filePath);
  //   final Map<String, String> fields = {
  //     'id':
  //         complaintId, // Replace with the actual ID// Replace with the actual document name
  //   };
  //   var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
  //   request.headers.addAll(headers);
  //   request.fields.addAll(fields);
  //   var file = await http.MultipartFile.fromPath('document', filePath);
  //   request.files.add(file);
  //   try {
  //     final response = await request.send();
  //     if (response.statusCode == 200) {
  //       final responseData = await response.stream.bytesToString();
  //       print('Response Data: $responseData');
  //     } else {
  //       print('File upload error: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     print('File upload error: $error');
  //   }
  // }
  // //uploading PDF
  // Future<void> uploadPdf(String complaintId, String pdfPath) async {
  //   final String apiUrl =
  //       'http://110.93.244.74/api/complaint/complaint_fileupload';
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String? authToken = prefs.getString('token');
  //   if (authToken == null) {
  //     print('Authentication token not available.');
  //     return;
  //   }
  //   final Map<String, String> headers = {
  //     'Authorization': 'Bearer $authToken',
  //   };
  //   var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
  //   request.headers.addAll(headers);
  //   print(complaintId);
  //   request.fields['id'] = complaintId;
  //   print(pdfPath);
  //   var file = await http.MultipartFile.fromPath('document', pdfPath);
  //   request.files.add(file);
  //   try {
  //     final response = await request.send();
  //     if (response.statusCode == 200) {
  //       final responseData = await response.stream.bytesToString();
  //       print('PDF uploaded successfully. Response Data: $responseData');
  //     } else {
  //       print('PDF upload error: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     print('PDF upload error: $error');
  //   }
  // }
//Get Complaint submittime id for uploading file.
  // int extractIdFromApiResponse(String responseBody) {
  //   Map<String, dynamic> responseJson = json.decode(responseBody);
  //   if (responseJson.containsKey("data_array")) {
  //     Map<String, dynamic> dataArray = responseJson["data_array"];
  //     if (dataArray.containsKey("id")) {
  //       int id = dataArray["id"];
  //       return id;
  //     }
  //   }
  //   // Return a default value or handle the case when id is not found
  //   return -1; // You can choose a suitable default value or error indicator
  // }
  // ends here..........

  @override
  void initState() {
    super.initState();
    // getCatDataFromSharedPreferences();
    getCategoriesFromSharedPreferences();

    storelistApi();
    fetchAndSaveMembershipIds();
    getLocation();
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
  }

//getting Catagory dta from SP
// Function to retrieve data from SharedPreferences
  Future<List<dynamic>> getCatDataFromSharedPreferences() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? serializedData = prefs.getString('apiData');

      if (serializedData != null && serializedData.isNotEmpty) {
        final List<dynamic> apiData = jsonDecode(serializedData);
        print(apiData);
        return apiData;
      } else {
        print('No data found in SharedPreferences.');
        return [];
      }
    } catch (e) {
      print('Error retrieving data from SharedPreferences: $e');
      return [];
    }
  }

  void clearSubcategoryList() {
    setState(() {
      subcategoryL.clear();
      _Subcnt?.clearDropDown();
      clearSubcategoryList();
      _Subcnt?.clearDropDown();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // Logout function
  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    // You can also clear any other session-related data if needed
  }

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: greyColor,
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
            height: scheight / 1.2,
            width: scWidth,
            // color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                    "Register your Complaint",
                    style:
                        TextStyle(color: dfColor, fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: marginLR, right: marginLR, top: 0),
                  child: Form(
                    key: _formKey,
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: scheight / 15),
                          padding: Platform.isAndroid
                              ? EdgeInsets.only(
                                  top: 15, right: 20, left: 20, bottom: 0)
                              : EdgeInsets.all(marginLR),
                          height: _type == "Suggestions" || _type == "Report"
                              ? scheight / 2.1
                              : scheight / 1.41,
                          decoration: BoxDecoration(
                              color: dfColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Category:",
                                          style: TextStyle(
                                              fontSize: exSmFontSize,
                                              fontWeight: FontWeight.w500,
                                              color: appcolor),
                                        ),
                                        Container(
                                          child: DropDownTextField(
                                            // initialValue: "name4",
                                            // readOnly: true
                                            controller: _cnt,
                                            padding: EdgeInsets.symmetric(),
                                            clearOption: true,
                                            isEnabled: true,
                                            dropDownIconProperty: IconProperty(
                                                icon:
                                                    Icons.keyboard_arrow_down),

                                            // keyboardType: TextInputType.number,
                                            autovalidateMode:
                                                AutovalidateMode.disabled,
                                            clearIconProperty: IconProperty(
                                                color: Colors.green),

                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Please Select Category";
                                              }
                                              return null;
                                            },
                                            // dropDownItemCount:
                                            //     dropDownList.length,

                                            dropDownList: dropDownList,

                                            onChanged: (value) {
                                              _Subcnt =
                                                  SingleValueDropDownController();
                                              setState(() {
                                                //_isLoading = true;

                                                _category = value.name;
                                                _catID = value.value;

                                                print(
                                                    "SubCategory : ${value.value}");
                                                storeSubCategorylistApi(
                                                    value.value);
                                                _Subcnt =
                                                    SingleValueDropDownController();
                                                getSubcategoriesByCatId();
                                                //clearSubcategoryList();
                                              });
                                            },
                                          ),
                                        ),
                                      ]),
                                ),

                                //------------------

                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Sub Category:",
                                          style: TextStyle(
                                              fontSize: exSmFontSize,
                                              fontWeight: FontWeight.w500,
                                              color: appcolor),
                                        ),
                                        DropDownTextField(
                                          // initialValue: "name4",
                                          // readOnly: true,
                                          controller: _Subcnt,
                                          clearOption: true,
                                          isEnabled: true,
                                          dropDownIconProperty: IconProperty(
                                              icon: Icons.keyboard_arrow_down),

                                          keyboardType: TextInputType.number,
                                          autovalidateMode:
                                              AutovalidateMode.disabled,
                                          clearIconProperty:
                                              IconProperty(color: Colors.green),

                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Select Subcategory";
                                            }
                                            return null;
                                          },

                                          dropDownList: subcategoryL,
                                          onChanged: (value) {
                                            setState(() {
                                              _subcategory = value.name;
                                              _subCatID = value.value;

                                              storeSubCategorylistApi(_catID);
                                              getSubcategoriesByCatId();
                                            });
                                          },
                                        ),
                                      ]),
                                ),
                                //------------------

                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Type:",
                                          style: TextStyle(
                                              fontSize: exSmFontSize,
                                              fontWeight: FontWeight.w500,
                                              color: appcolor),
                                        ),
                                        DropDownTextField(
                                          // initialValue: "name4",
                                          // readOnly: true,
                                          controller: _cnt,
                                          clearOption: true,
                                          dropDownIconProperty: IconProperty(
                                              icon: Icons.keyboard_arrow_down),

                                          keyboardType: TextInputType.number,
                                          autovalidateMode:
                                              AutovalidateMode.disabled,
                                          clearIconProperty:
                                              IconProperty(color: Colors.green),

                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Select Type";
                                            }
                                            return null;
                                          },
                                          // dropDownItemCount: 6,

                                          dropDownList: const [
                                            DropDownValueModel(
                                                name: 'Complaint', value: "01"),
                                            DropDownValueModel(
                                                name: 'Suggestions',
                                                value: "02"),
                                            DropDownValueModel(
                                                name: 'Report', value: "03"),
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _type = value.name;
                                            });
                                          },
                                        ),
                                      ]),
                                ),
                                //------------------
                                _type == "Suggestions" || _type == "Report"
                                    ? Container()
                                    : Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: TextFormField(
                                          textInputAction: TextInputAction.next,
                                          autofocus: false,
                                          style: TextStyle(
                                              fontSize: 19.0,
                                              color: Colors.black45),
                                          decoration: InputDecoration(
                                            hintText: "Follow-up Person Name",
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
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[a-zA-Z\s]')),
                                          ],
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Enter follow-up name";
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

                                _type == "Suggestions" || _type == "Report"
                                    ? Container()
                                    : Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: TextFormField(
                                          textInputAction: TextInputAction.next,
                                          maxLength: 11,
                                          autofocus: false,
                                          style: TextStyle(
                                              fontSize: 19.0,
                                              color: Colors.black87),
                                          decoration: InputDecoration(
                                            hintText:
                                                "Follow-up Person Mobile No",
                                            hintStyle: TextStyle(
                                                color: Colors.black45,
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
                                          validator: validateMobileNumber,
                                          onChanged: (value) {
                                            setState(() {
                                              _mobileNo = value.trim();
                                            });
                                          },
                                        ),
                                      ),

                                //------------------

                                _type == "Suggestions" || _type == "Report"
                                    ? Container()
                                    : Container(
                                        margin: EdgeInsets.only(top: 0),
                                        child: TextFormField(
                                          textInputAction: TextInputAction.next,
                                          maxLength: 10,
                                          autofocus: false,
                                          style: TextStyle(
                                              fontSize: 19.0,
                                              color: Colors.black87),
                                          decoration: InputDecoration(
                                            hintText:
                                                "Follow-up Person Landline No",
                                            hintStyle: TextStyle(
                                                color: Colors.black45,
                                                fontSize: 15),
                                            filled: true,
                                            fillColor: dfColor,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 1.0,
                                                    bottom: 8.0,
                                                    top: 8.0),
                                          ),
                                          keyboardType: TextInputType.phone,
                                          // validator: (value) {
                                          //   if (value == null ||
                                          //       value.isEmpty) {
                                          //     return "Enter follow-up landline number";
                                          //   }
                                          //   return null;
                                          // },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _landline = value.trim();
                                            });
                                          },
                                        ),
                                      ),

                                //------------------

                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    autofocus: false,
                                    minLines: 1,
                                    maxLength: 500,
                                    maxLines: 5,
                                    style: TextStyle(
                                      fontSize: 19.0,
                                      color: Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Complaint Description",
                                      hintStyle: TextStyle(
                                          color: Colors.black45, fontSize: 12),
                                      filled: true,
                                      fillColor: drakGreyColor,
                                      contentPadding: const EdgeInsets.only(
                                          left: 10.0, bottom: 30.0, top: 30.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    keyboardType: TextInputType.text,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[a-zA-Z0-9., ]'))
                                    ],
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please Add Complaint Description';
                                      }

                                      // Define a regular expression pattern to match alphabets, numbers, and full stops
                                      final RegExp pattern =
                                          RegExp(r'^[a-zA-Z0-9., ]*$');

                                      if (!pattern.hasMatch(value)) {
                                        return 'Only Alphabets, Numbers, & Full Stops Are Allowed';
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

                                //------------------

                                Container(
                                  margin: EdgeInsets.only(top: 0),
                                  child: CompalintImgCardWidget(
                                    onRemovePressed: () {
                                      // Handle the remove image action here

                                      setState(() {
                                        filePath = ''; // Set to empty string
                                      });
                                    },
                                    licenseImage: filePath,
                                    function: () {
                                      showCustomDialog(context);
                                    },
                                    imageText: 'Upload Image',
                                    customImage: 'asserts/images/addstaff.png',
                                    ftSize: Platform.isAndroid
                                        ? scWidth / 8
                                        : scWidth / 8,
                                  ),
                                ),

                                //-------------------

                                //---------------------
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            margin: EdgeInsets.only(
                              top: 10,
                            ),
                            decoration: BoxDecoration(
                                gradient: lgBlue,
                                borderRadius: BorderRadius.circular(roundBtn)),
                            width: scWidth,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  getCurrentTime();

                                  final Map<String, dynamic> postData = {
                                    'category_id': _catID,
                                    'subcategory_id': _subCatID,
                                    'description': _description,
                                    'lat': latitude,
                                    'lng': longitude,
                                    'type': _type,
                                    'followup_name': (_type == "Suggestions" ||
                                            _type == "Report")
                                        ? "N/A"
                                        : _personName,
                                    'followup_cell': (_type == "Suggestions" ||
                                            _type == "Report")
                                        ? "N/A"
                                        : _mobileNo,
                                    'followup_landline':
                                        (_type == "Suggestions" ||
                                                _type == "Report")
                                            ? "N/A"
                                            : _landline,
                                    'membership_id': _memberId,
                                    'device_time': currentTime,
                                    'request_time': currentTime,
                                    'source': _source,
                                    'document': filePath,
                                  };

                                  postComplaintData(postData);
                                  _isLoading = true;
                                  // justPrinting();
                                }
                              },
                              child: Text(
                                'Submit',
                                style: TextStyle(color: btnTextColor),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(roundBtn),
                                ),
                              ),
                            ),
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
