import 'package:dha_resident_app/constant.dart';
import 'package:flutter/material.dart';

class ContactFilterSearch extends StatefulWidget {
  final void Function(String) onSearchContact;
  const ContactFilterSearch({Key? key, required this.onSearchContact})
      : super(key: key);

  @override
  State<ContactFilterSearch> createState() => _ContactFilterSearchState();
}

class _ContactFilterSearchState extends State<ContactFilterSearch> {
  bool isVisible = false;
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<DateTime?> dateofBirth = ValueNotifier(null);
  String ContactName = '';
  TextEditingController ContactController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: marginLR,
      ),
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
                            widget.onSearchContact(ContactName);
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
                          controller: ContactController,
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          style:
                              TextStyle(fontSize: 19.0, color: Colors.black45),
                          decoration: InputDecoration(
                            hintText: "Contact Name",
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
                              return 'Please enter your Contact Name';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            ContactName = ContactController.text;
                          },
                        ),
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
