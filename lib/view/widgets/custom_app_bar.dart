import 'package:dha_resident_app/constant.dart';
import 'package:dha_resident_app/view/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // final String title;
  // final Widget? leading;
  // final List<Widget>? actions;

  // CustomAppBar({
  //   // required this.title,
  //   // this.leading,
  //   // this.actions,
  // });

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
