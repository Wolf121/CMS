import 'dart:async';
import 'package:dha_resident_app/constant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool isPressed = false;
  double progress = 0.0;

  void onPressed() {
    setState(() {
      isPressed = true;
      progress = 0.0;
    });

    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        progress += 0.1;

        if (progress >= 1.0) {
          t.cancel();
          isPressed = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        onPressed();
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
      },
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        period: Duration(milliseconds: 1000),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          curve: Curves.linear,
          decoration: BoxDecoration(
            border: Border.all(
              color: isPressed ? Colors.blue : Colors.black,
              width: 4.0,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Text('Press Me!'),
          ),
        ),
      ),
    );
  }
}

////////////////////////////

class CustomButton extends StatefulWidget {
  final dynamic onLongFun;
  final String title;
  final iconData;
  final colorToast;
  // final onTapFun;
  CustomButton({
    required this.onLongFun,
    required this.title,
    required this.iconData,
    required this.colorToast,
  });
  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isPressed = false;
  double progress = 0.0;

  void onPressed() {
    setState(() {
      isPressed = true;
      progress = 0.0;
    });

    Timer.periodic(Duration(milliseconds: 200), (Timer t) {
      if (mounted)
        setState(() {
          progress += 0.1;

          if (progress >= 1.0) {
            Future.delayed(
                const Duration(
                  seconds: 2,
                ), () {
              //Successfully
              print("Between Submitted");
              widget.onLongFun;
            });
            t.cancel();
            isPressed = false;
          }
        });
    });
  }

  //Toast
  void funToast(String ToastMessage, Color custcolor) {
    Fluttertoast.showToast(
        msg: ToastMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: custcolor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        funToast("Please Hold The Button For 2 Seconds", widget.colorToast);
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
      },
      onLongPress: () {
        onPressed();
      },
      child: AnimatedContainer(
        duration: Duration(seconds: 2),
        curve: Curves.linear,
        decoration: BoxDecoration(
          color: dfColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isPressed ? Colors.blue : Colors.black,
            width: 4.0,
          ),
        ),
        child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 55, bottom: 10),
                child: Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: lgFontSize,
                      // height: 1,
                      fontWeight: FontWeight.w400,
                      color: blackColor),
                ),
              ),
              Positioned(
                top: 3,
                left: 3,
                child: Text("0"),
              ),
              Positioned(
                top: -20,
                // left: 60,
                child: CircleAvatar(
                  backgroundColor: lightappcolor,
                  radius: 30.0,
                  child: Image.asset(
                    widget.iconData,
                    width: 40,
                  ),
                ),
              )
            ]),
      ),
    );
  }
}

class ButtonEffect extends StatefulWidget {
  @override
  _ButtonEffectState createState() => _ButtonEffectState();
}

class _ButtonEffectState extends State<ButtonEffect> {
  bool isPressed = false;
  double progress = 0.0;

  void onPressed() {
    setState(() {
      isPressed = true;
      progress = 0.0;
    });

    Timer.periodic(Duration(milliseconds: 200), (Timer t) {
      if (mounted)
        setState(() {
          progress += 0.1;

          if (progress >= 1.0) {
            print("SOS Submitted");

            t.cancel();
            isPressed = false;
          }
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        onPressed();
      },
      onTap: () {
        print("Press for 2 Sec.");
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(seconds: 2), // 2 seconds
        curve: Curves.linear,
        decoration: BoxDecoration(
          border: Border.all(
            color: isPressed ? Colors.blue : Colors.black,
            width: 4.0,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              period: Duration(seconds: 2),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 55, bottom: 10),
                child: Text(
                  "PANIC",
                  style: TextStyle(
                    fontSize: 24, // Adjust as needed
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 3,
              left: 3,
              child: Text("0"),
            ),
            Positioned(
              top: -20,
              child: CircleAvatar(
                backgroundColor: Colors.grey[300], // Adjust as needed
                radius: 30.0,
                child: Image.asset(
                  "asserts/images/policeman.png", // Adjust the path
                  width: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
