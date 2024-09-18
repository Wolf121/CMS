import 'package:dha_resident_app/constant.dart';
import 'package:dha_resident_app/view/screens/sos/sos_history.dart';
import 'package:dha_resident_app/view/widgets/pick_date.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SosFilterSearch extends StatefulWidget {
  final Function(String, DateTime?, String?) onFilter;
  final Function(DateTime?, String?, String?, String?)
      onFetchAndFilterSosRecords; // Modified to accept three arguments

  SosFilterSearch({
    Key? key,
    required this.onFetchAndFilterSosRecords,
    required this.onFilter,
  }) : super(key: key);

  @override
  State<SosFilterSearch> createState() => _SosFilterSearchState();
}

String? selectedStaus; // Assuming selectedStaus is a nullable String
String? selectedType; // Assuming selectedType is a nullable String

DropDownValueModel extractDropDownValueModel(String? typeName) {
  // Check if typeName is not null and create a DropDownValueModel
  if (typeName != null) {
    return DropDownValueModel(name: typeName, value: typeName);
  } else {
    // Return a default value or handle the null case as needed
    return DropDownValueModel(name: 'Default', value: '00');
  }
}

class _SosFilterSearchState extends State<SosFilterSearch> {
  bool isVisible = false;
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<DateTime?> dateOfBirth = ValueNotifier(null);
  final TextEditingController referenceNoController = TextEditingController();
  String? selectedType;
  String? selectedStaus;

  final SosHistory sosHistory = SosHistory();

  ///__________
  void printFilterCriteria(
      String referenceNo, DateTime? selectedDate, String? type) {
    print('Reference No: $referenceNo');
    print('Selected Date: $selectedDate');
    print('Type: $type');
  }

  ///________

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: marginLR),
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
                        color: appcolor,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Toggle search visibility
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        icon: Icon(
                          isVisible
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: appcolor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Get the reference number, selected date, and selected type
                          final referenceNo = referenceNoController.text;
                          final selectedDate = dateOfBirth.value;
                          final status = selectedStaus;
                          final type = selectedType;
                          DropDownValueModel selectedModel =
                              extractDropDownValueModel(type);
                          String extractedName = selectedModel.name;

                          //date format yyyy-MM-dd
                          // String formattedDate =
                          //     DateFormat('yyyy-MM-dd').format(selectedDate!);

                          // print(formattedDate);
                          //printFilterCriteria(referenceNo, selectedDate, type);
                          widget.onFetchAndFilterSosRecords(
                              selectedDate, referenceNo, status, type);
                          // Call the filter function with the provided filter criteria
                          //widget.onFilter(referenceNo, selectedDate, type);

                          // Toggle search visibility
                          setState(() {
                            isVisible = false;
                          });
                        },
                        icon: Icon(
                          Icons.search,
                          color: appcolor,
                          size: 25,
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
                // height: scHeight / 2.7,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        referenceNoController.clear();

                        final referenceNo = '';
                        final selectedDate = null;
                        dateOfBirth.value = null;
                        final type = null;
                        final status = null;
                        DropDownValueModel selectedModel =
                            extractDropDownValueModel(type);
                        String extractedName = '';

                        //date format yyyy-MM-dd
                        // String formattedDate =
                        //     DateFormat('yyyy-MM-dd').format(selectedDate!);

                        // print(formattedDate);
                        //printFilterCriteria(referenceNo, selectedDate, type);
                        widget.onFetchAndFilterSosRecords(
                            selectedDate, referenceNo, status, type);
                        // Call the filter function with the provided filter criteria
                        //widget.onFilter(referenceNo, selectedDate, type);

                        // Toggle search visibility
                        setState(() {
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
                              //-------
                              Container(
                                child: TextFormField(
                                  controller: referenceNoController,
                                  textInputAction: TextInputAction.next,
                                  autofocus: false,
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    color: Colors.black45,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Reference No",
                                    hintStyle: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 15,
                                    ),
                                    filled: true,
                                    fillColor: dfColor,
                                    contentPadding: const EdgeInsets.only(
                                      left: 1.0,
                                      bottom: 8.0,
                                      top: 8.0,
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a reference number';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {},
                                ),
                              ),
                              //------------------
                              ValueListenableBuilder<DateTime?>(
                                valueListenable: dateOfBirth,
                                builder: (context, dateVal, child) {
                                  String formattedDate = dateVal != null
                                      ? DateFormat('dd-MM-yyyy').format(dateVal
                                          .toLocal()) // Format the date as 'yyyy-MM-dd'
                                      : 'DD-MM-YYYY';

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
                                            data: Theme.of(context).copyWith(
                                              colorScheme:
                                                  ColorScheme.fromSwatch(
                                                primarySwatch: Colors.blue,
                                                accentColor: appcolor,
                                                backgroundColor:
                                                    Colors.lightBlue,
                                                cardColor: Colors.white,
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );
                                      dateOfBirth.value = date!
                                          .toLocal(); // Convert to local time zone
                                                                        },
                                    child: PickDate(date: formattedDate),
                                  );
                                },
                              ),

                              //------------------
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Status:",
                                      style: TextStyle(
                                        fontSize: exSmFontSize,
                                        fontWeight: FontWeight.w500,
                                        color: appcolor,
                                      ),
                                    ),
                                    DropDownTextField(
                                      clearOption: true,
                                      dropDownIconProperty: IconProperty(
                                        icon: Icons.keyboard_arrow_down,
                                      ),
                                      keyboardType: TextInputType.number,
                                      autovalidateMode: AutovalidateMode.always,
                                      clearIconProperty: IconProperty(
                                        color: Colors.green,
                                      ),
                                      validator: (value) {
                                        return null;
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
                                            name: 'TES-Forwarded', value: "09"),
                                      ],
                                      onChanged: (value) {
                                        // Update the selected type
                                        setState(() {
                                          selectedStaus = value.name;
                                        });
                                      },
                                    ),
                                  ],
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
                                    DropDownTextField(
                                      clearOption: true,
                                      dropDownIconProperty: IconProperty(
                                        icon: Icons.keyboard_arrow_down,
                                      ),
                                      keyboardType: TextInputType.number,
                                      autovalidateMode: AutovalidateMode.always,
                                      clearIconProperty: IconProperty(
                                        color: Colors.green,
                                      ),
                                      validator: (value) {
                                        return null;
                                      },
                                      dropDownItemCount: 6,
                                      dropDownList: const [
                                        DropDownValueModel(
                                            name: 'Panic', value: "01"),
                                        DropDownValueModel(
                                            name: 'Fire', value: "03"),
                                        DropDownValueModel(
                                            name: 'Medical', value: "04"),
                                        DropDownValueModel(
                                            name: 'Ambulance', value: "05"),
                                      ],
                                      onChanged: (value) {
                                        // Update the selected type
                                        setState(() {
                                          selectedType = value.name;
                                        });
                                      },
                                    ),
                                  ],
                                ),
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
