import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:date_format/date_format.dart';
import 'package:dha_resident_app/constant.dart';
import 'package:dha_resident_app/view/widgets/pick_date.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class ComplaintFilterSearch extends StatefulWidget {
  final void Function(String, String, String, String, String) onSearchComplaint;
  const ComplaintFilterSearch({Key? key, required this.onSearchComplaint})
      : super(key: key);

  @override
  State<ComplaintFilterSearch> createState() => _ComplaintFilterSearchState();
}

class _ComplaintFilterSearchState extends State<ComplaintFilterSearch> {
  SingleValueDropDownController? _cnt;
  SingleValueDropDownController? _Subcnt;
  bool isVisible = false;
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<DateTime?> dateofBirth = ValueNotifier(null);

  TextEditingController refController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  dynamic _category;
  dynamic _catID;
  dynamic _subcategory;
  dynamic _subCatID;
  int selectedCategory = 0;

  //---------
  String reff = '';
  String dat = '';
  String catgo = '';
  String SubCatgo = '';
  String Stat = '';
  //-------

  List<DropDownValueModel> dropDownList = [];
  List<DropDownValueModel> subcategoryList = [];
  List<DropDownValueModel> subcategoryL = [];
  List<ChatagoriDataArray> chatagoriDataArray = [];
  List<SubChatagoriDataArray> subchatagoriDataArray = [];
  List<SubChatagoriDataArray> subchatagoriData = [];

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

  List<DropDownValueModel> getSubcategoriesByCategoryId(
      List<ChatagoriDataArray> chatagoriDataArray, int categoryId) {
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

  @override
  void initState() {
    super.initState();
    getCategoriesFromSharedPreferences();
    storelistApi();
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
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: marginLR,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        elevation: 2,
        child: Column(
          children: [
            Container(
              width: scWidth,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(roundBtn)),
                  border: Border.all(width: 1.5, color: drakGreyColor)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                    child: Text(
                      "Search",
                      style: TextStyle(
                          fontSize: exSmFontSize,
                          // fontWeight: FontWeight.w500,
                          color: appcolor),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          widget.onSearchComplaint(
                              reff, dat, catgo, SubCatgo, Stat);
                        },
                        icon: isVisible == false
                            ? Container()
                            : Icon(
                                Icons.search,
                                color: appcolor,
                                size: 25,
                              ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (isVisible == false) {
                            isVisible = true;
                          } else {
                            isVisible = false;
                          }
                          setState(() {});
                        },
                        icon: Icon(
                          isVisible == false
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          color: appcolor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isVisible,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                width: scWidth,
                // height: scHeight / 3,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          refController.clear();
                          dateofBirth.value = null;
                          _cnt?.clearDropDown();
                          _Subcnt?.clearDropDown();
                          widget.onSearchComplaint('', '', '', '', '');
                          reff = '';
                          dat = '';
                          catgo = '';
                          SubCatgo = '';
                          Stat = '';
                          isVisible = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(bottom: 8, left: 8, right: 8),
                        alignment: Alignment.topRight,
                        child: Text(
                          'Clear Filter',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Container(
                      height: scHeight / 4,
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: TextFormField(
                                  controller: refController,
                                  textInputAction: TextInputAction.next,
                                  autofocus: false,
                                  style: TextStyle(
                                      fontSize: 19.0, color: Colors.black45),
                                  decoration: InputDecoration(
                                    hintText: "Reference No",
                                    hintStyle: TextStyle(
                                        color: Colors.black54, fontSize: 15),
                                    filled: true,
                                    fillColor: dfColor,
                                    contentPadding: const EdgeInsets.only(
                                        left: 1.0, bottom: 8.0, top: 8.0),
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your Reference number';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    reff = refController.text;
                                  },
                                ),
                              ),

                              //------------------

                              ValueListenableBuilder<DateTime?>(
                                  valueListenable: dateofBirth,
                                  builder: (context, dateVal, child) {
                                    return InkWell(
                                        onTap: () async {
                                          DateTime? date = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1920),
                                              lastDate: DateTime.now(),
                                              currentDate: DateTime.now(),
                                              initialEntryMode:
                                                  DatePickerEntryMode.calendar,
                                              initialDatePickerMode:
                                                  DatePickerMode.day,
                                              builder: (context, child) {
                                                return Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                          colorScheme:
                                                              ColorScheme
                                                                  .fromSwatch(
                                                    primarySwatch: Colors.blue,
                                                    accentColor: appcolor,
                                                    backgroundColor:
                                                        Colors.lightBlue,
                                                    cardColor: Colors.white,
                                                  )),
                                                  child: child!,
                                                );
                                              });
                                          dateofBirth.value = date;
                                          dat = dateofBirth.value.toString();
                                        },
                                        child: PickDate(
                                            date: dateVal != null
                                                ? formatDate(dateVal,
                                                    [dd, '-', mm, '-', yyyy])
                                                : 'DD-MM-YYYY'));
                                  }),
                              //------------------
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
                                              icon: Icons.keyboard_arrow_down),

                                          // keyboardType: TextInputType.number,
                                          autovalidateMode:
                                              AutovalidateMode.disabled,
                                          clearIconProperty:
                                              IconProperty(color: Colors.green),

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

                                              catgo = value.name;

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
                                            SubCatgo = value.name;
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
                              //------------------
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Status:",
                                        style: TextStyle(
                                            fontSize: exSmFontSize,
                                            fontWeight: FontWeight.w500,
                                            color: appcolor),
                                      ),
                                      DropDownTextField(
                                        // initialValue: "name4",
                                        // readOnly: true,
                                        // controller: _cnt,
                                        clearOption: true,
                                        dropDownIconProperty: IconProperty(
                                            icon: Icons.keyboard_arrow_down),

                                        keyboardType: TextInputType.number,
                                        autovalidateMode:
                                            AutovalidateMode.always,
                                        clearIconProperty:
                                            IconProperty(color: Colors.green),

                                        validator: (value) {
                                          return null;

                                          // if (value!.isEmpty) {
                                          //   return "Required field";
                                          // }
                                        },
                                        dropDownItemCount: 6,

                                        dropDownList: const [
                                          DropDownValueModel(
                                              name: 'Submitted', value: "01"),
                                          DropDownValueModel(
                                              name: 'In Process', value: "03"),
                                          DropDownValueModel(
                                              name: 'Pending', value: "04"),
                                          DropDownValueModel(
                                              name: 'Resolved', value: "05"),
                                          DropDownValueModel(
                                              name: 'Closed', value: "06"),
                                          DropDownValueModel(
                                              name: 'Reopen', value: "07"),
                                          DropDownValueModel(
                                              name: 'Cancel', value: "08"),
                                          DropDownValueModel(
                                              name: 'TES-Forwarded',
                                              value: "09"),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            Stat = value.name;
                                          });
                                        },
                                      ),
                                    ]),
                              ),

                              //------------------
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
