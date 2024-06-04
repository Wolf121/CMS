import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

import '../../constant.dart';

class NewsHorizontalWidget extends StatefulWidget {
  final String newsHeading;
  final String newsDetails;
  final Color customColor;
  final String imageURL;
  final String createdAt;

  const NewsHorizontalWidget(
      {required this.newsHeading,
      required this.customColor,
      required this.newsDetails,
      required this.imageURL,
      required this.createdAt});

  @override
  State<NewsHorizontalWidget> createState() => _NewsHorizontalWidgetState();
}

class _NewsHorizontalWidgetState extends State<NewsHorizontalWidget> {
  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    return Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        width: scWidth / 1.55,
        height: scHeight,
        margin: new EdgeInsets.symmetric(horizontal: 40),
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: widget.customColor),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white),
                    child: Text(
                      widget.newsHeading,
                      style: TextStyle(
                          color: widget.customColor,
                          fontSize: scWidth / 25,
                          fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: true,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    width: scWidth,
                    child: Text(
                      widget.newsDetails,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: scWidth,
              height: scHeight / 4.9,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: widget.imageURL != null
                      ? InstaImageViewer(
                          child: Image.network(
                            widget.imageURL,
                            // fit: BoxFit.fill,
                            errorBuilder: (context, exception, stackTrace) {
                              return Image.asset("asserts/icons/icon.png");
                            },
                          ),
                        )
                      : Icon(
                          Icons.newspaper_rounded,
                          size: 90,
                          color: dfColor,
                        )),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: Text(
                widget.createdAt,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: scWidth / 40,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ));
  }
}

class NewsVerticalWidget extends StatefulWidget {
  final String newsHeading;
  final String newsDetails;
  final String imageURL;

  const NewsVerticalWidget(
      {super.key,
      required this.newsHeading,
      required this.newsDetails,
      required this.imageURL});

  @override
  State<NewsVerticalWidget> createState() => _NewsVerticalWidgetState();
}

class _NewsVerticalWidgetState extends State<NewsVerticalWidget> {
  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;

    ///Custom Dialog
    _showCustomDialog(String imageNew) {
      showGeneralDialog(
        context: context,
        pageBuilder: (ctx, a1, a2) {
          return Container();
        },
        transitionBuilder: (ctx, a1, a2, child) {
          var curve = Curves.easeInOut.transform(a1.value);
          return Transform.scale(
            scale: curve,
            child: AlertDialog(
              titlePadding: EdgeInsets.all(0),
              title: Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  color: appcolor,
                ),
                // padding: EdgeInsets.all(5),
                child: IconButton(
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              content: SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: InstaImageViewer(
                          child: Image.network(
                            imageNew,
                            width: scWidth / 2,
                            errorBuilder: (context, exception, stackTrace) {
                              return Image.asset("asserts/icons/icon.png");
                            },
                            // height: scHeight,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10, top: 10),
                        child: Text(
                          widget.newsHeading,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: appcolor,
                              fontWeight: FontWeight.bold,
                              fontSize: exSmFontSize),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          widget.newsDetails,
                          style: TextStyle(
                              color: appcolor,
                              fontWeight: FontWeight.normal,
                              fontSize: exXSmFontSize),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      );
    }

///////////
    return Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: drakGreyColor),
        child: GestureDetector(
          onTap: () {
            _showCustomDialog(widget.imageURL);
          },
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                        width: scWidth / 3.5,
                        height: scHeight / 7,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.network(
                              widget.imageURL,
                              fit: BoxFit.fill,
                              errorBuilder: (context, exception, stackTrace) {
                                return Image.asset("asserts/icons/icon.png");
                              },
                            ))),
                    Container(
                      margin: EdgeInsets.all(10),
                      // color: Colors.amber,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: scWidth / 1.8,
                            child: Text(
                              widget.newsHeading,
                              style: TextStyle(
                                  color: appcolor,
                                  fontSize: scWidth / 20,
                                  fontWeight: FontWeight.w400),
                              overflow: TextOverflow.ellipsis,
                              // maxLines: 1,
                              softWrap: true,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            width: scWidth / 1.75,
                            child: Text(
                              widget.newsDetails,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
