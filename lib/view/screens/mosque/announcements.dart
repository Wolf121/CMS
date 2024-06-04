import 'dart:convert';

import 'package:dha_resident_app/constant.dart';
import 'package:dha_resident_app/view/widgets/annuncement_widget.dart';
import 'package:dha_resident_app/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marqueer/marqueer.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Announcements extends StatefulWidget {
  @override
  State<Announcements> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  List<Map<String, dynamic>> newsList = [];

  bool _isLoading = true;

  List<Map<String, dynamic>> newsLists = [
    {
      "news_heading": "lern diw wpoqan",
      "color": Colors.blue,
      "news_details":
          "lern reome wakh rhwo pow sa is thw go sge bru a ths poi wiuyra then ayoj fs vwc owdw, d o oj itggr rdghdi dndkg jdigjkmfoig jfig k jgk dm vc vmc, mfogfbnmb jgof bm",
      "image_url":
          "https://thumbs.dreamstime.com/b/news-newspapers-folded-stacked-word-wooden-block-puzzle-dice-concept-newspaper-media-press-release-42301371.jpg"
    },
    {
      "news_heading": "lern diw wpoqan",
      "color": Colors.red,
      "news_details":
          "lern reome wakh rhwo pow sa is thw go sge bru a ths poi wiuyra then ayoj fs vwc owdw, d o oj itggr rdghdi dndkg jdigjkmfoig jfig k jgk dm vc vmc, mfogfbnmb jgof bm",
      "image_url":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWzMCFzlLTXS5jozv4oek7as3ig5GUGk3WY0FWSyNHJBB8e9Ml5Uy0KeB0AUML5ynfSr8&usqp=CAU"
    },
    {
      "news_heading": "lern diw wpoqan",
      "color": Colors.green,
      "news_details":
          "lern reome wakh rhwo pow sa is thw go sge bru a ths poi wiuyra then ayoj fs vwc owdw, d o oj itggr rdghdi dndkg jdigjkmfoig jfig k jgk dm vc vmc, mfogfbnmb jgof bm",
      "image_url":
          "https://thumbs.dreamstime.com/b/news-newspapers-folded-stacked-word-wooden-block-puzzle-dice-concept-newspaper-media-press-release-42301371.jpg"
    },
    {
      "news_heading": "lern diw wpoqan",
      "color": Colors.grey,
      "news_details":
          "lern reome wakh rhwo pow sa is thw go sge bru a ths poi wiuyra then ayoj fs vwc owdw, d o oj itggr rdghdi dndkg jdigjkmfoig jfig k jgk dm vc vmc, mfogfbnmb jgof bm",
      "image_url":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWzMCFzlLTXS5jozv4oek7as3ig5GUGk3WY0FWSyNHJBB8e9Ml5Uy0KeB0AUML5ynfSr8&usqp=CAU"
    },
    {
      "news_heading": "lern diw wpoqan",
      "color": Colors.orange,
      "news_details":
          "lern reome wakh rhwo pow sa is thw go sge bru a ths poi wiuyra then ayoj fs vwc owdw, d o oj itggr rdghdi dndkg jdigjkmfoig jfig k jgk dm vc vmc, mfogfbnmb jgof bm",
      "image_url":
          "https://thumbs.dreamstime.com/b/news-newspapers-folded-stacked-word-wooden-block-puzzle-dice-concept-newspaper-media-press-release-42301371.jpg"
    },
    {
      "news_heading": "lern diw wpoqan",
      "color": Colors.blue,
      "news_details":
          "lern reome wakh rhwo pow sa is thw go sge bru a ths poi wiuyra then ayoj fs vwc owdw, d o oj itggr rdghdi dndkg jdigjkmfoig jfig k jgk dm vc vmc, mfogfbnmb jgof bm",
      "image_url":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWzMCFzlLTXS5jozv4oek7as3ig5GUGk3WY0FWSyNHJBB8e9Ml5Uy0KeB0AUML5ynfSr8&usqp=CAU"
    },
    {
      "news_heading": "lern diw wpoqan",
      "color": Colors.blue,
      "news_details":
          "lern reome wakh rhwo pow sa is thw go sge bru a ths poi wiuyra then ayoj fs vwc owdw, d o oj itggr rdghdi dndkg jdigjkmfoig jfig k jgk dm vc vmc, mfogfbnmb jgof bm",
      "image_url":
          "https://thumbs.dreamstime.com/b/news-newspapers-folded-stacked-word-wooden-block-puzzle-dice-concept-newspaper-media-press-release-42301371.jpg"
    },
    {
      "news_heading": "lern diw wpoqan",
      "color": Colors.blue,
      "news_details":
          "lern reome wakh rhwo pow sa is thw go sge bru a ths poi wiuyra then ayoj fs vwc owdw, d o oj itggr rdghdi dndkg jdigjkmfoig jfig k jgk dm vc vmc, mfogfbnmb jgof bm",
      "image_url":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWzMCFzlLTXS5jozv4oek7as3ig5GUGk3WY0FWSyNHJBB8e9Ml5Uy0KeB0AUML5ynfSr8&usqp=CAU"
    },
    {
      "news_heading": "lern diw wpoqan",
      "color": Colors.blue,
      "news_details":
          "lern reome wakh rhwo pow sa is thw go sge bru a ths poi wiuyra then ayoj fs vwc owdw, d o oj itggr rdghdi dndkg jdigjkmfoig jfig k jgk dm vc vmc, mfogfbnmb jgof bm",
      "image_url":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWzMCFzlLTXS5jozv4oek7as3ig5GUGk3WY0FWSyNHJBB8e9Ml5Uy0KeB0AUML5ynfSr8&usqp=CAU"
    },
    {
      "news_heading": "lern diw wpoqan",
      "color": Colors.blue,
      "news_details":
          "lern reome wakh rhwo pow sa is thw go sge bru a ths poi wiuyra then ayoj fs vwc owdw, d o oj itggr rdghdi dndkg jdigjkmfoig jfig k jgk dm vc vmc, mfogfbnmb jgof bm",
      "image_url":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWzMCFzlLTXS5jozv4oek7as3ig5GUGk3WY0FWSyNHJBB8e9Ml5Uy0KeB0AUML5ynfSr8&usqp=CAU"
    },
    {
      "news_heading": "lern diw wpoqan",
      "color": Colors.blue,
      "news_details":
          "lern reome wakh rhwo pow sa is thw go sge bru a ths poi wiuyra then ayoj fs vwc owdw, d o oj itggr rdghdi dndkg jdigjkmfoig jfig k jgk dm vc vmc, mfogfbnmb jgof bm",
      "image_url":
          "https://images.unsplash.com/photo-1495020689067-958852a7765e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bmV3c3xlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60"
    },
    {
      "news_heading": "lern diw wpoqan",
      "color": Colors.blue,
      "news_details":
          "lern reome wakh rhwo pow sa is thw go sge bru a ths poi wiuyra then ayoj fs vwc owdw, d o oj itggr rdghdi dndkg jdigjkmfoig jfig k jgk dm vc vmc, mfogfbnmb jgof bm",
      "image_url":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWzMCFzlLTXS5jozv4oek7as3ig5GUGk3WY0FWSyNHJBB8e9Ml5Uy0KeB0AUML5ynfSr8&usqp=CAU"
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNewsListData();
    // loadNewsListFromPrefs();
  }

// getting data from api and storing in the sharedPref
  Future<void> fetchNewsListData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    Uri apiUrl = Uri.parse('http://110.93.244.74/api/dashboard/announcements');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(apiUrl, headers: headers);

      if (response.statusCode == 200) {
        _isLoading = false;
        Map<String, dynamic> responseData = json.decode(response.body);
        // prefs.setString('newsListData', json.encode(responseData));

        final announcementsArray = responseData['data_array'] as List<dynamic>;

        setState(() {
          newsList = announcementsArray.cast<Map<String, dynamic>>();
        });

        print('Announcements data saved in state.');
      } else {
        _isLoading = false;
        print('Failed to fetch news data: ${response.reasonPhrase}');
      }
    } catch (error) {
      _isLoading = false;
      print('Error fetching news data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(),
      body: OverlayLoaderWithAppIcon(
        overlayBackgroundColor: Colors.transparent,
        isLoading: _isLoading,
        appIcon: CircularProgressIndicator(),
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
                "Announcements",
                style: TextStyle(color: dfColor, fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: Container(
                height: scHeight,
                width: scWidth,
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Marqueer.builder(
                  direction: MarqueerDirection.rtl,
                  itemBuilder: (ctx, index) {
                    DateTime now = DateTime.now();

                    final String currentTime =
                        DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

                    return AnnouncementHorWidegt(
                      newsHeading: newsList[index]['title'],
                      newsDetails: newsList[index]['description'],
                      customColor: newsLists[index]['color'],
                      imageURL: newsList[index]['banner'],

                      createdAt: currentTime,
                      // currentTime: time,
                    );
                  },
                  itemCount: newsList.length,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: scHeight / 7,
                margin: new EdgeInsets.only(
                    bottom: 15, right: marginLR, left: marginLR),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return AnnouncementVerWidegt(
                      newsHeading: newsList[index]['title'],
                      newsDetails: newsList[index]['description'],
                      imageURL: newsList[index]['banner'],
                    );
                  },
                  itemCount: newsList.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
