import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dha_resident_app/constant.dart';
import 'package:dha_resident_app/view_model/news_model/news_model.dart';
import 'package:flutter/material.dart';
import 'package:marqueer/marqueer.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../widgets/news_widget.dart';

class News extends StatefulWidget {
  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  bool _isLoading = false;
  List<Map<String, dynamic>> newsList = [];

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
    _isLoading = true;
    // fetchNewsListData();
    // loadNewsListFromPrefs();
    fetchNews();
    isInternetConnect();
  }

  // getting data from sharedPref to populate the list
  void loadNewsListFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = prefs.getString('newsListData') ?? '';
    if (jsonData.isNotEmpty) {
      Map<String, dynamic> responseData = json.decode(jsonData);
      List<dynamic> dataArray = responseData['data_array'];

      newsList = List<Map<String, dynamic>>.from(dataArray);
      setState(() {});
    }
  }

// getting data from api and storing in the sharedPref
  Future<void> fetchNewsListData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    Uri apiUrl = Uri.parse('http://110.93.244.74/api/dashboard/news');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(apiUrl, headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        prefs.setString('newsListData', json.encode(responseData));
      } else {
        print('Failed to fetch news data: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error fetching news data: $error');
    }
  }

  Future<List<NewsItem>> fetchNews() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(
        Uri.parse('http://110.93.244.74/api/dashboard/news'),
        headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['data_array'];
      List<NewsItem> newsList =
          jsonData.map((item) => NewsItem.fromJson(item)).toList();

      // setState(() {
      //   newsList = newsListData.cast<Map<String, dynamic>>();
      // });

      return newsList;
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<bool> isInternetConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.mobile;
  }

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    return FutureBuilder<List<NewsItem>>(
        future: fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return OverlayLoaderWithAppIcon(
              overlayBackgroundColor: Colors.transparent,
              isLoading: _isLoading,
              appIcon: CircularProgressIndicator(),
              child: Container(),
            );
          } else if (snapshot.hasError) {
            if (Connectivity().checkConnectivity() ==
                ConnectivityResult.mobile) {
              return Center(
                  child: Text(
                      'No Internet Connection, Please Reconnect And Try Again!'));
            } else {
              return Center(
                  child: Text(
                      'Couldn\'t Fetch The News At This Moment.\nPlease Try Again Later!'));
            }
          } else {
            final newsListData = snapshot.data;

            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: scHeight,
                      width: scWidth,
                      margin: EdgeInsets.only(
                          top: 20, left: marginLR, right: marginLR, bottom: 10),
                      child: Marqueer.builder(
                        direction: MarqueerDirection.rtl,
                        itemBuilder: (ctx, index) {
                          return NewsHorizontalWidget(
                            newsHeading: newsListData![index].title,
                            newsDetails: newsListData[index].description,
                            customColor: lightappcolor,
                            imageURL: newsListData[index].banner,
                            createdAt: newsListData[index].createdAt,
                          );
                        },
                        itemCount: newsListData?.length,
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
                          return NewsVerticalWidget(
                            newsHeading: newsListData[index].title,
                            newsDetails: newsListData[index].description,
                            imageURL: newsListData[index].banner,
                          );
                        },
                        itemCount: newsListData!.length,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
