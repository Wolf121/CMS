import 'package:dha_resident_app/constant.dart';
import 'package:dha_resident_app/view/widgets/staff_search_filter.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

class PetFilterSearch extends StatefulWidget {
  final void Function(String, String) onSearchPet;
  const PetFilterSearch({Key? key, required this.onSearchPet})
      : super(key: key);

  @override
  State<PetFilterSearch> createState() => _PetFilterSearchState();
}

class _PetFilterSearchState extends State<PetFilterSearch> {
  bool isVisible = false;
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<DateTime?> dateofBirth = ValueNotifier(null);
  String petName = '';
  String petType = '';
  TextEditingController PetNameController = TextEditingController();
  DropDownController PetTypedropDownController = DropDownController(
    initialName: '', // Initial name
    initialValue: '', // Initial value
  );
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
                            widget.onSearchPet(petName, petType);
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
                          controller: PetNameController,
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
                            petName = PetNameController.text;
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
                                autovalidateMode: AutovalidateMode.always,
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
                                  DropDownValueModel(name: 'Dog', value: "01"),
                                  DropDownValueModel(name: 'Cat', value: "02"),
                                  DropDownValueModel(
                                      name: 'Parrot', value: "03"),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    petType = value.name;
                                  });
                                },
                              ),
                            ]),
                      ),

                      //------------------
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
