import 'dart:async';

import 'package:flutter/material.dart';

class VanishSection extends StatefulWidget {
  const VanishSection({
    Key? key,
  }) : super(key: key);

  @override
  State<VanishSection> createState() => _VanishSectionState();
}

class _VanishSectionState extends State<VanishSection> {
  bool isVisible = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      Timer(Duration(seconds: 5), () {
        if (isVisible) {
          isVisible = false;
        } else {
          isVisible = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: true,
              // maintainSize: true,
              // maintainAnimation: true,
              // maintainState: true,
              child: Container(
                color: Colors.amber,
                width: 300,
                height: 300,
                // child: const SpeedMeter(),
                // child: const Wave(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
