import 'package:flutter/material.dart';

import '../../constant.dart';

class PickDate extends StatelessWidget {
  const PickDate({super.key, required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: greyColor, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date,
            style: TextStyle(color: date != null ? Colors.black : lightGrey),
          ),
          Icon(
            Icons.calendar_month,
            color: appcolor,
          ),
        ],
      ),
    );
  }
}
