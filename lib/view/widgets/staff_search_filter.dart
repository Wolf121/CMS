import 'dart:convert';

import 'package:dha_resident_app/constant.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaffFilterSearch extends StatefulWidget {
  final void Function(String, String, String, String) onSearchStaff;
  const StaffFilterSearch({Key? key, required this.onSearchStaff})
      : super(key: key);

  @override
  State<StaffFilterSearch> createState() => _StaffFilterSearchState();
}

class DropDownController extends TextEditingController {
  String? _selectedValue;
  String? _selectedName;

  DropDownController({String? initialValue, String? initialName}) {
    _selectedValue = initialValue;
    _selectedName = initialName;
    this.text = initialName ?? '';
  }

  String? get selectedValue => _selectedValue;
  String? get selectedName => _selectedName;

  set selectedValue(String? value) {
    _selectedValue = value;
  }

  set selectedName(String? name) {
    _selectedName = name;
    this.text = name ?? '';
  }
}

class _StaffFilterSearchState extends State<StaffFilterSearch> {
  bool isVisible = false;
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<DateTime?> dateofBirth = ValueNotifier(null);
  TextEditingController nameController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  DropDownController dropDownController = DropDownController(
    initialName: '', // Initial name
    initialValue: '', // Initial value
  );

  String name = '';
  String cnic = '';
  String phone = '';
  String status = '';
  List<DropDownValueModel> _staffTypes = [];

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

  @override
  void initState() {
    super.initState();
    loadStaffTypesFromPrefs().then((staffTypes) {
      setState(() {
        _staffTypes = staffTypes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: marginLR),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        elevation: 2,
        child: Form(
          key: _formKey,
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
                        "Filter",
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
                            widget.onSearchStaff(name, cnic, phone, status);
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: TextFormField(
                          controller: nameController,
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          style:
                              TextStyle(fontSize: 19.0, color: Colors.black45),
                          decoration: InputDecoration(
                            hintText: "Name",
                            hintStyle:
                                TextStyle(color: Colors.black54, fontSize: 15),
                            filled: true,
                            fillColor: dfColor,
                            contentPadding: const EdgeInsets.only(
                                left: 1.0, bottom: 8.0, top: 8.0),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Name';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            name = nameController.text;
                          },
                        ),
                      ),

                      //------------------

                      Container(
                        margin: EdgeInsets.only(top: 8),
                        child: TextFormField(
                          controller: cnicController,
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          style:
                              TextStyle(fontSize: 19.0, color: Colors.black45),
                          decoration: InputDecoration(
                            hintText: "CNIC",
                            hintStyle:
                                TextStyle(color: Colors.black54, fontSize: 15),
                            filled: true,
                            fillColor: dfColor,
                            contentPadding: const EdgeInsets.only(
                                left: 1.0, bottom: 8.0, top: 8.0),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your cnic number';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            cnic = cnicController.text;
                          },
                        ),
                      ),

                      //------------------
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        child: TextFormField(
                          controller: phoneController,
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          style:
                              TextStyle(fontSize: 19.0, color: Colors.black45),
                          decoration: InputDecoration(
                            hintText: "Phone",
                            hintStyle:
                                TextStyle(color: Colors.black54, fontSize: 15),
                            filled: true,
                            fillColor: dfColor,
                            contentPadding: const EdgeInsets.only(
                                left: 1.0, bottom: 8.0, top: 8.0),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your cnic number';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            phone = phoneController.text;
                          },
                        ),
                      ),

                      //------------------

                      Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Type:",
                              style: TextStyle(
                                fontSize: exSmFontSize,
                                fontWeight: FontWeight.w500,
                                color: appcolor,
                              ),
                            ),
                            StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return DropDownTextField(
                                  // Remove the controller property
                                  clearOption: true,
                                  dropDownIconProperty: IconProperty(
                                      icon: Icons.keyboard_arrow_down),
                                  keyboardType: TextInputType.number,
                                  autovalidateMode: AutovalidateMode.always,
                                  clearIconProperty:
                                      IconProperty(color: Colors.green),
                                  validator: (value) {
                                    return null;
                                  },
                                  dropDownList:
                                      _staffTypes, // Use the _staffTypes list
                                  onChanged: (value) {
                                    setState(() {
                                      status = value.name.toString();
                                    });
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
