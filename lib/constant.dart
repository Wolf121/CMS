import 'package:flutter/material.dart';

const marginLR = 15.0;
const marginSet = 5.0; // If the marginLR add more 5 it's also increment 5

/// -------- Font Size
const double exXSmFontSize = 12.0;
const double exSmFontSize = 14.0;
const double dfFontSize = 16.0;
const double smFontSize = 18.0;
const double lgFontSize = 20.0;
const double exLgFontSize = 22.0;

///------- Icon Size
const double dfIconSize = 22;

const double dfElevation = 8.0;
const double smElevation = 4.0;

///------- App Color

const dfColor = Colors.white;
const appcolor = Color.fromRGBO(21, 34, 56, 1);
const appcolorHex = "#152238";
const lightappcolor = Color.fromRGBO(127, 146, 179, 1);
const ligappcolor = Color.fromRGBO(127, 146, 179, 0.5);
const greyColor = Color.fromRGBO(245, 245, 245, 1);
const greyLoaderColor = Color.fromRGBO(245, 245, 245, 0.4);
const lightGrey = Colors.grey;
const drakGreyColor = Color.fromARGB(221, 219, 218, 218);
const btnTextColor = Colors.white;
const blackColor = Colors.black;
const redAlert = Color.fromRGBO(240, 155, 145, 1);
const redlert = Color.fromRGBO(246, 207, 203, 1);
const yellowAlert = Color.fromRGBO(254, 247, 229, 1);
const blueAlert = Color.fromRGBO(243, 249, 250, 1);

const dfGreyColor = Color(0xfff1B1B1B);

///---------- Rounded Style

const roundBtn = 8.0;

/////

const lgBlue = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(21, 34, 56, 1),
      Color.fromRGBO(63, 99, 158, 1),
    ]);

const lgWhite = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.white]);

const shimmerGradient = LinearGradient(
  colors: [
    Color(0xFFEBEBF4),
    Color(0xFFF4F4F4),
    Color(0xFFEBEBF4),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);
