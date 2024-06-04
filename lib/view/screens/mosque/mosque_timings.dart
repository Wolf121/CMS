import 'dart:async';
import 'dart:convert';
import 'package:dha_resident_app/view/widgets/custom_app_bar.dart';
import 'package:dha_resident_app/view_model/mosquee_timing.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant.dart';

class MosqueTimings extends StatefulWidget {
  const MosqueTimings({Key? key});

  @override
  State<MosqueTimings> createState() => _MosqueTimingsState();
}

class _MosqueTimingsState extends State<MosqueTimings> {
  List<Map<String, dynamic>> masjidTiming = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    fetchDataAndUpdateList();
  }

  Future<void> fetchDataAndUpdateList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token != null) {
        final response = await http.get(
          Uri.parse('http://110.93.244.74/api/dashboard/masjidtimings'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);

          if (responseData['success'] == 1) {
            final List<dynamic> dataArray = responseData['data_array'];

            setState(() {
              masjidTiming = List<Map<String, dynamic>>.from(dataArray);
              _isLoading = false;
            });
          } else {
            print('API returned an error: ${responseData['message']}');
          }
        } else {
          print('Failed to load data from API');
        }
      } else {
        print('Token not found in SharedPreferences');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<MasjidTimingsResponse> fetchMasjidTimings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(
        Uri.parse('http://110.93.244.74/api/dashboard/masjidtimings'),
        headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return MasjidTimingsResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        color: dfColor,
        child: Container(
          // margin: EdgeInsets.only(top: 0, right: marginLR, left: marginLR),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                color: appcolor,
                width: scWidth,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  bottom: marginLR,
                ),
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "Masjid Timings",
                  style: TextStyle(color: dfColor, fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                flex: 11,
                child: FutureBuilder<MasjidTimingsResponse>(
                    future: fetchMasjidTimings(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // While the Future is still running, show a loading indicator.
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        // If there's an error, display an error message.
                        return Container(
                            alignment: Alignment.center,
                            height: scHeight / 1.5,
                            child: Text(
                              'Couldn\'t Fetch Masjid Timings At This Moment.\nPlease Try Again Later!',
                              style: TextStyle(
                                fontSize: smFontSize,
                              ),
                            ));
                      } else {
                        // If the Future is complete and successful, display the data.
                        final masjidTimingsResponse = snapshot.data;
                        return Container(
                          margin: EdgeInsets.only(
                              top: 0,
                              right: marginLR,
                              left: marginLR,
                              bottom: 5),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return new MosqueWidget(
                                  interationIndex: index,
                                  title: masjidTimingsResponse
                                      .dataArray[index].phase,
                                  imageURL: masjidTimingsResponse
                                      .dataArray[index].masjids[0].banner,
                                  phTitle: masjidTimingsResponse
                                      .dataArray[index].masjids[0].title,
                                  mosqueName: masjidTimingsResponse
                                              .dataArray[index]
                                              .masjids[0]
                                              .description !=
                                          null
                                      ? masjidTimingsResponse.dataArray[index]
                                          .masjids[0].description!
                                      : "N/A", // Pass the mosqueName here
                                  timing: masjidTimingsResponse
                                      .dataArray[index]
                                      .masjids[0]
                                      .timings // Use a default value if timing is null
                                  // Pass the timing here
                                  );
                            },
                            itemCount: masjidTimingsResponse!.dataArray.length,
                          ),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MosqueWidget extends StatefulWidget {
  final int interationIndex;
  final String title;
  final String imageURL;
  final String phTitle;
  final String mosqueName; // Add a mosqueName parameter
  final String timing; // Add a timing parameter

  const MosqueWidget({
    required this.interationIndex,
    required this.title,
    required this.imageURL,
    required this.phTitle,
    required this.mosqueName,
    required this.timing,
  });

  @override
  State<MosqueWidget> createState() => _MosqueWidgetState();
}

class _MosqueWidgetState extends State<MosqueWidget> {
  bool isVisible = false;

  Future<MasjidTimingsResponse> fetchMasjidTimings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(
        Uri.parse('http://110.93.244.74/api/dashboard/masjidtimings'),
        headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return MasjidTimingsResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
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
                          fontWeight: FontWeight.w600,
                          color: appcolor),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, elevation: 0),
                        child: Icon(
                          isVisible == false
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          color: appcolor,
                        ),
                        onPressed: () {
                          if (isVisible == false) {
                            isVisible = true;
                          } else {
                            isVisible = false;
                          }
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: -20,
                    child: CircleAvatar(
                        backgroundColor: blueAlert,
                        radius: 20.0,
                        backgroundImage: AssetImage('asserts/images/mosque.png')

                        // Image.network(
                        //   widget.imageURL,
                        //   width: 20,
                        //   errorBuilder: (BuildContext context, Object exception,
                        //       StackTrace? stackTrace) {
                        //     return Image.asset(
                        //       'asserts/images/mosque.png',
                        //       width: 20,
                        //     );
                        //   },
                        // ),

                        ),
                  )
                ]),
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
                    margin: EdgeInsets.only(bottom: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'asserts/images/mosque.png',
                        width: scWidth,
                      ),
                    ),

                    // Image.network(
                    //   widget.imageURL,
                    //   width: scWidth,
                    //   fit: BoxFit.cover,
                    //   errorBuilder: (context, error, stackTrace) {
                    //     return Image.asset(
                    //       'asserts/images/mosque.png',
                    //       width: scWidth,
                    //     );
                    //   },
                    // )
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      widget.phTitle,
                      style: TextStyle(
                          fontSize: exSmFontSize,
                          fontWeight: FontWeight.w700,
                          color: appcolor),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                  FutureBuilder<MasjidTimingsResponse>(
                      future: fetchMasjidTimings(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // While the Future is still running, show a loading indicator.
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          // If there's an error, display an error message.
                          return Text('Error: ${snapshot.error}');
                        } else {
                          // If the Future is complete and successful, display the data.
                          final masjidTimingsRes =
                              snapshot.data!.dataArray[widget.interationIndex];

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return MosqueTimingList(
                                mosqueName: masjidTimingsRes
                                            .masjids[index].description !=
                                        null
                                    ? masjidTimingsRes
                                        .masjids[index].description!
                                    : "N/A", // Display mosqueName here
                                timing: masjidTimingsRes.masjids[index]
                                    .timings, // Display timing here
                              );
                            },
                            itemCount: masjidTimingsRes.masjids.length,
                          );
                        }
                      }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MosqueTimingList extends StatelessWidget {
  const MosqueTimingList({
    Key? key,
    required this.mosqueName,
    required this.timing, // Add a required timing parameter
  });

  final String mosqueName;
  final String timing; // Store the timing information

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      width: scWidth,
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          color: dfColor,
          borderRadius: BorderRadius.all(Radius.circular(roundBtn)),
          border: Border.all(width: 1.5, color: drakGreyColor)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            mosqueName,
            style: TextStyle(
                fontSize: exSmFontSize,
                fontWeight: FontWeight.w700,
                color: appcolor),
          ),
          Text(
            timing, // Display the provided timing
            style: TextStyle(
                fontSize: exSmFontSize,
                fontWeight: FontWeight.w400,
                color: appcolor),
          ),
        ],
      ),
    );
  }
}
