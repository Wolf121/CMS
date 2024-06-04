import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant.dart';

class Check extends StatefulWidget {
  const Check({super.key});

  @override
  State<Check> createState() => _CheckState();
}

class _CheckState extends State<Check> {
  List<Map<String, dynamic>> masjidTiming = [];

  bool _isLoading = true;

  List<Map<String, dynamic>> mosqueLists = [
    {
      "title": "Phase-I",
      "image_url": "asserts/images/iconmosque.png",
      'ph_title': 'DHA Ph-I Jummah Prayer Masjaid Timing',
      'mosque1': 'Jamia Masjad 1st Jummah',
      'mosque2': 'Jamia Masjad 2nd Jummah',
      'mosque3': 'Shafi Masjid',
      'mosque4': 'Sarfaraz Masjid',
      'time1': '1:15',
      'time2': '2:00',
      'time3': '1:45',
      'time4': '1:45',
    },
    {
      "title": "Phase-II",
      "image_url": "asserts/images/iconmosque.png",
      'ph_title': 'DHA Ph-II Jummah Prayer Masjaid Timing',
      'mosque1': 'Jamia Masjad 1st Jummah',
      'mosque2': 'Jamia Masjad 2nd Jummah',
      'mosque3': 'Shafi Masjid',
      'mosque4': 'Sarfaraz Masjid',
      'time1': '1:15',
      'time2': '2:00',
      'time3': '1:45',
      'time4': '1:45',
    },
    {
      "title": "Phase-III",
      "image_url": "asserts/images/iconmosque.png",
      'ph_title': 'DHA Ph-II Jummah Prayer Masjaid Timing',
      'mosque1': 'Jamia Masjad 1st Jummah',
      'mosque2': 'Jamia Masjad 2nd Jummah',
      'mosque3': 'Shafi Masjid',
      'mosque4': 'Sarfaraz Masjid',
      'time1': '1:15',
      'time2': '2:00',
      'time3': '1:45',
      'time4': '1:45',
    },
  ];

  @override
  void initState() {
    print("Mosq_timimg executing");
    super.initState();
    fetchMasjidTimingData();

    // loadMasjidTimingFromPrefs();
  }

  // // getting data from sharedPref to populate the list
  // void loadMasjidTimingFromPrefs() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String jsonData = prefs.getString('masjidTimingData') ?? '';
  //   if (jsonData.isNotEmpty) {
  //     Map<String, dynamic> responseData = json.decode(jsonData);
  //     List<dynamic> dataArray = responseData['data_array'];
  //     // List<dynamic>  masjidArray = responseData['data_array'][0]['masjids'];
  //     masjidTiming = List<Map<String, dynamic>>.from(dataArray);
  //     setState(() {});
  //   }
  //   _isLoading = false;
  // }

// getting data from api and storing in the sharedPref
  Future<void> fetchMasjidTimingData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('longToken') ?? '';

    Uri apiUrl = Uri.parse('http://110.93.244.74/api/dashboard/masjidtimings');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(apiUrl, headers: headers);

      if (response.statusCode == 200) {
        _isLoading = false;
        Map<String, dynamic> responseData = json.decode(response.body);
        // prefs.setString('masjidTimingData', json.encode(responseData));

        final masjidTimingArray = responseData['data_array'] as List<dynamic>;
        extractMasjidNamesAndTimings(masjidTimingArray);

        setState(() {
          masjidTiming = masjidTimingArray.cast<Map<String, dynamic>>();
        });

        print('Masjid Timing data saved in state.');
      } else {
        _isLoading = false;
        print('Failed to fetch masjid timing data: ${response.reasonPhrase}');
      }
    } catch (error) {
      _isLoading = false;
      print('Error fetching masjid timing data: $error');
    }
  }

//Printing shit
  void printingTheShitOutOFEeverything(List<Masjid> masjidList) {
    for (var masjid in masjidList) {
      print('Masjid Name: ${masjid.name}');
      print('Timing: ${masjid.timing}');
      print('---');
    }
  }

  // New Function

  List<Masjid> masjidList = [];
  List<Masjid> extractMasjidNamesAndTimings(List<dynamic> data_array) {
    for (final phaseData in data_array) {
      final masjids = phaseData['masjids'];

      for (final masjid in masjids) {
        // final title = masjid['title'];
        final description = masjid['description'];

        final masjidNameMatches =
            RegExp(r'<td>([^<]+)<\/td>').allMatches(description);
        final masjidTimeMatches =
            RegExp(r'(\d+\s*:\s*\d+\s*[APapMm]+)').allMatches(description);

        final masjidNames =
            masjidNameMatches.map((match) => match.group(1) ?? '').toList();
        final masjidTimings =
            masjidTimeMatches.map((match) => match.group(1) ?? '').toList();

        // Check if the number of masjid names and timings match
        if (masjidNames.length != masjidTimings.length) {
          print('Error: Mismatch in the number of masjid names and timings');
          continue; // Skip this iteration if there's a mismatch
        }

        // Create Masjid objects and add them to the list
        for (var i = 0; i < masjidNames.length; i++) {
          masjidList.add(Masjid(masjidNames[i], masjidTimings[i]));
        }
      }
    }
    printingTheShitOutOFEeverything(masjidList);
    return masjidList;
  }

  List<String> parseJummahTimings(String description) {
    // Implement the logic to parse Jummah timings from the description
    // You can use regular expressions or HTML parsing libraries for this task
    // Example: Use regex to find and extract Jummah timings

    final List<String> jummahTimings = [];
    // Implement your parsing logic here and add timings to jummahTimings list

    return jummahTimings;
  }

// Call the function to print all Jummah timings

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greyColor,
        title: Text(
          "Mosque Timings",
          style: TextStyle(color: appcolor, fontSize: lgFontSize),
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
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: OverlayLoaderWithAppIcon(
        isLoading: _isLoading,
        appIcon: Image.asset(
          "asserts/icons/icon.png",
          width: 40,
        ),
        child: Container(
          color: dfColor,
          child: Container(
            margin: EdgeInsets.only(top: 10, right: marginLR, left: marginLR),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  flex: 11,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5, top: 20),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        final description =
                            masjidTiming[index]['masjids'][0]['description'];

                        return new MosqueeWidget(
                          title: masjidTiming[index]['phase'],
                          imageURL: masjidTiming[index]['masjids'][0]['banner'],
                          iconURL: mosqueLists[index]['image_url'],
                          phTitle: masjidTiming[index]['masjids'][0]['title'],
                          mosqueName1: masjidList[index].name,
                          timing1: masjidList[index].timing,
                        );
                      },
                      itemCount: masjidTiming.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MosqueeWidget extends StatefulWidget {
  final String title;
  final String imageURL;
  final String iconURL;
  final String phTitle;
  final String mosqueName1;
  final String timing1;

  const MosqueeWidget({
    required this.title,
    required this.imageURL,
    required this.iconURL,
    required this.phTitle,
    required this.mosqueName1,
    required this.timing1,
  });

  @override
  State<MosqueeWidget> createState() => _MosqueeWidgetState();
}

class _MosqueeWidgetState extends State<MosqueeWidget> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: [
          Container(
            width: scWidth,
            margin: EdgeInsets.only(top: marginLR + 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(roundBtn)),
                border: Border.all(width: 1.5, color: drakGreyColor)),
            child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: lgFontSize,
                          // height: 1,
                          fontWeight: FontWeight.w500,
                          color: blackColor),
                    ),
                  ),
                  Positioned(
                      right: 0,
                      child: Container(
                        // color: Colors.amber,

                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0),
                          child: Icon(
                            isVisible == false
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
                            color: appcolor,
                          ),
                          onPressed: () {
                            if (isVisible == false) {
                              isVisible = true;
                              setState(() {});
                            } else {
                              isVisible = false;
                              setState(() {});
                            }
                          },
                        ),
                      )),

                  //-----------------
                  Positioned(
                    top: -20,
                    // left: 60,
                    child: CircleAvatar(
                      backgroundColor: blueAlert,
                      radius: 20.0,
                      child: Image.asset(
                        widget.iconURL,
                        width: 20,
                      ),
                    ),
                  )
                ]),
          ),
          Visibility(
            visible: isVisible,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              // color: Colors.amber,
              width: scWidth,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Image.network(
                        widget.imageURL,
                        width: scWidth,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        widget.phTitle,
                        style: TextStyle(
                            fontSize: exSmFontSize,
                            fontWeight: FontWeight.w500,
                            color: appcolor),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                    MosqueTimingList(
                      mosqueName: widget.mosqueName1,
                      timing: widget.timing1,
                    ),
                    // MosqueTimingList(
                    //   mosqueName: widget.mosqueName2,
                    //   timing: widget.timing2,
                    // ),
                    // MosqueTimingList(
                    //   mosqueName: widget.mosqueName3,
                    //   timing: widget.timing3,
                    // ),
                    // MosqueTimingList(
                    //   mosqueName: widget.mosqueName4,
                    //   timing: widget.timing4,
                    // )
                  ]),
            ),
          )
        ],
      ),
    );
  }
}

class MosqueTimingList extends StatelessWidget {
  const MosqueTimingList({
    super.key,
    required this.mosqueName,
    required this.timing,
  });

  final String mosqueName;
  final String timing;

  // final desc = parse(mosqueName);

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    print(mosqueName);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      width: scWidth,
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          color: dfColor,
          borderRadius: BorderRadius.all(Radius.circular(roundBtn)),
          border: Border.all(width: 1.5, color: drakGreyColor)),
      child: Column(children: [
        // mosqueName.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')

        Text(
          mosqueName,
          // .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')
          // .replaceAll("\n", ""),
          style: TextStyle(
              fontSize: dfFontSize,
              fontWeight: FontWeight.w500,
              color: appcolor),
          textAlign: TextAlign.center,
        ),
        Text(
          timing,
          style: TextStyle(
              fontSize: exSmFontSize,
              fontWeight: FontWeight.w400,
              color: appcolor),
        ),
      ]),
    );
  }
}

class Masjid {
  final String name;
  final String timing;

  Masjid(this.name, this.timing);
}
