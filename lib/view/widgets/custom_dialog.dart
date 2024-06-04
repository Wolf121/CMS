import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dha_resident_app/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

///----------Customdialog 5

Future<void> customDialog5(BuildContext context) async {
  String htmlContent = """
<style>
    .centered-div {
      margin: 0 auto; /* Set margin to auto horizontally */
      text-align: center; /* Optionally, you can center-align text inside the div */
    }
    br {
      line-height: 0; /* Adjust as needed */
      display: none; /* Optionally hide the line break */
    }
  </style>
</head>
<body>
  <div class="centered-div">
    <p>If you have any technical queries, you may contact our technical support team at
    <strong>1092 (Dial 4).</strong></p>
    <br>
    <p><strong>Timing: 9:00 AM to 4:30 PM</strong></p>
  </div>
""";

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text('Help'),
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: 10.0, horizontal: 24.0), // Adjust padding here
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: SingleChildScrollView(
            child: Html(data: htmlContent),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 10.0), // Adjust left and right padding here
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Image.asset(
                    'asserts/icons/cross.png',
                    width: 32,
                  ),
                ),
              ),
              SizedBox(width: 40), // Increased spacing between buttons
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 10.0), // Adjust left and right padding here
                child: TextButton(
                  onPressed: () async {
                    FlutterPhoneDirectCaller.callNumber("1092");
                  },
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Future CustomDialog2(BuildContext context) {
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.noHeader,
    animType: AnimType.bottomSlide,
    descTextStyle: TextStyle(
      fontWeight: FontWeight.w400,
    ),
    title: 'Help',
    desc:
        'If you have any technical queries, you may contact our technical support team at 1092 (Dial 4). \n\nTiming: 9:00 AM to 4:30 PM',
    btnCancel: IconButton(
      onPressed: () {
        Navigator.pop(context); // Close the dialog
      },
      icon: Image.asset(
        'asserts/icons/cross.png',
        width: 40,
      ),
      color: Colors.red,
    ),
    btnOk: IconButton(
      onPressed: () async {
        FlutterPhoneDirectCaller.callNumber("1092");
      },
      icon: CircleAvatar(
        radius: 16,
        backgroundColor: Colors.green,
        child: Icon(
          Icons.phone,
          color: dfColor,
        ),
      ),
      color: Colors.green,
    ),
  ).show();
}

//-------
Future<void> customDialog3(BuildContext context) async {
  String htmlContent = """
<style>
    .centered-div {
      margin: 0 auto; /* Set margin to auto horizontally */
      text-align: center; /* Optionally, you can center-align text inside the div */
    }
    br {
      line-height: 0; /* Adjust as needed */
      display: none; /* Optionally hide the line break */
    }
  </style>
</head>
<body>
  <div class="centered-div">
    <p>If you have any technical queries, you may contact our technical support team at
    <strong>1092 (Dial 4).</strong></p>
    <br>
    <p><strong>Timing: 9:00 AM to 4:30 PM</strong></p>
  </div>
""";

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text('Help'),
        ),

        contentPadding: EdgeInsets.symmetric(
            vertical: 10.0, horizontal: 24.0), // Adjust padding here
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: SingleChildScrollView(
            child: Html(data: htmlContent),
          ),
        ),
        actions: <Widget>[
          Center(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Image.asset(
                'asserts/icons/checked.png',
                width: 40,
              ),
            ),
          ),
        ],
      );
    },
  );
}

Future CustomDialog(BuildContext context) {
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.noHeader,
    animType: AnimType.bottomSlide,
    descTextStyle: TextStyle(
      fontWeight: FontWeight.w400,
    ),
    title: 'Help',
    desc:
        'If you have any technical queries, you may contact our technical support team at 1092\n (Dial 4). \n\nTiming: 9:00 AM to 4:30 PM',
    btnOk: IconButton(
      onPressed: () async {
        Navigator.pop(context); // Close the dialog
      },
      icon: Image.asset(
        'asserts/icons/checked.png',
        width: 40,
      ),
      color: Colors.green,
    ),
  ).show();
}
// Future CustomDialog(BuildContext context) {
//   return AwesomeDialog(
//     context: context,
//     dialogType: DialogType.noHeader,
//     animType: AnimType.bottomSlide,
//     descTextStyle: TextStyle(
//       fontWeight: FontWeight.w400,
//     ),
//     title: 'Help',
//     desc:
//         'If you have any technical queries, you may contact our technical support team at 1092 (Dial 4). \n\n'
//         'Timing: \u{1D7D0}\u{1D7D1}:\u{1D7D2}\u{1D7D3} AM to \u{1D7D4}\u{1D7D5} PM',
//     btnOk: IconButton(
//       onPressed: () async {
//         Navigator.pop(context); // Close the dialog
//       },
//       icon: Image.asset(
//         'asserts/icons/checked.png',
//         width: 40,
//       ),
//       color: Colors.green,
//     ),
//   ).show();
// }