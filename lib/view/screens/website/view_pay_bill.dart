import 'dart:convert';
import 'dart:io';

import 'package:dha_resident_app/view_model/bill_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dha_resident_app/constant.dart';
import 'package:dha_resident_app/view/widgets/custom_app_bar.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:flutter_media_downloader/flutter_media_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';

class ViewPayBill extends StatefulWidget {
  @override
  State<ViewPayBill> createState() => _ViewPayBillState();
}

class _ViewPayBillState extends State<ViewPayBill> {
  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;

    Future<void> _downloadAndOpenPDF() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? '';
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };
      final url =
          'https://www.dhai-r.com.pk/storage/app/media/bills/aug_2023/32420100710101.pdf';

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      final appDocDir = await getApplicationDocumentsDirectory();
      final file = File('${appDocDir.path}/32420100710101.pdf');
      await file.writeAsBytes(response.bodyBytes);
    }

    //Call Bill Api
    Future<BillListResponse> fetchBillList() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? '';
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await http.get(
        Uri.parse("http://110.93.244.74/api/dashboard/bills"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return BillListResponse.fromJson(jsonResponse);
      } else {
        throw Exception('No Bill Found');
      }
    }

    ////------- PDF Validate

    Future<bool> isPdfUrlValid(String url) async {
      try {
        final response = await http.head(Uri.parse(url));
        if (response.statusCode == 200) {
          if (response.headers.containsKey('content-type')) {
            final contentType = response.headers['content-type'];
            if (contentType != null && contentType.contains('pdf')) {
              // The URL is a valid PDF URL.
              return true;
            }
          }
        }
      } catch (e) {
        print("Shit Happened!");
      }
      // The URL is not a valid PDF URL.
      return false;
    }

    //-----------Download pdf
    Future<File> _storeFile(String url, List<int> bytes) async {
      final filename = basename(url);
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(bytes, flush: true);
      if (kDebugMode) {
        print('$file');
      }
      return file;
    }

    Future<File> loadPdfFromNetwork(String url) async {
      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;
      return _storeFile(url, bytes);
    }

    final _flutterMediaDownloaderPlugin = MediaDownload();

    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          Container(
            color: appcolor,
            width: scWidth,
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              bottom: marginLR,
            ),
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              "View Bill",
              style: TextStyle(color: dfColor, fontWeight: FontWeight.w700),
            ),
          ),
          FutureBuilder<BillListResponse>(
              future: fetchBillList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: scHeight / 2,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('No Bill Found!'));
                } else {
                  final billListResponse = snapshot.data;

                  final pdfUrl = billListResponse!.dataArray[0].url;
                  print("Bills: " + pdfUrl.toString());
                  // final pdfUrl =
                  //     "https://dhai-r.com.pk/storage/app/media/bills/oct_2023/32420100710101.pdf"; //test Bill

                  return FutureBuilder<bool>(
                    future: isPdfUrlValid(pdfUrl),
                    builder: (context, urlSnapshot) {
                      if (urlSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Container(
                          height: scHeight / 2,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        );
                      } else if (urlSnapshot.hasError) {
                        return Center(
                            child: Text('Error: ${urlSnapshot.error}'));
                      } else {
                        final isValidPdfUrl = urlSnapshot.data;
                        if (isValidPdfUrl == true) {
                          return Column(
                            children: [
                              // Container(
                              //   margin: EdgeInsets.only(
                              //       bottom: marginLR,
                              //       left: marginLR,
                              //       right: marginLR),
                              //   width: scWidth,
                              //   alignment: Alignment.topRight,
                              //   child: Container(
                              //     width: scWidth / 2.5,
                              //     child: ElevatedButton(
                              //       style: ElevatedButton.styleFrom(
                              //         elevation: 0,
                              //         padding: EdgeInsets.all(0),
                              //         backgroundColor: Colors.white,
                              //       ),
                              //       onPressed: () async {
                              //         final downloadedFile =
                              //             await loadPdfFromNetwork(pdfUrl);
                              //         print("Download : ${downloadedFile}");
                              //       },
                              //       child: DottedBorder(
                              //         dashPattern: [3, 4],
                              //         borderType: BorderType.RRect,
                              //         strokeCap: StrokeCap.butt,
                              //         padding: EdgeInsets.all(0),
                              //         radius: Radius.circular(roundBtn - 3),
                              //         color: appcolor,
                              //         strokeWidth: 1,
                              //         child: Container(
                              //           padding: EdgeInsets.symmetric(
                              //               horizontal: 10, vertical: 10),
                              //           child: Row(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.spaceBetween,
                              //             children: [
                              //               Image.asset(
                              //                 "asserts/images/pdf.png",
                              //                 width: scWidth / 18,
                              //               ),
                              //               Text(
                              //                 "Download PDF",
                              //                 style: TextStyle(
                              //                   fontSize: exSmFontSize,
                              //                   fontWeight: FontWeight.w700,
                              //                   color: appcolor,
                              //                   // decoration: TextDecoration.underline,
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),

                              ////Bill View
                              Container(
                                margin: EdgeInsets.only(
                                    top: marginLR * 2,
                                    left: marginLR,
                                    right: marginLR),
                                width: scWidth,
                                height: scHeight / 1.8,
                                child: SfPdfViewer.network(
                                  pdfUrl,
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(
                                    top: marginLR * 3,
                                    bottom: marginLR,
                                    left: marginLR,
                                    right: marginLR),
                                width: scWidth,
                                alignment: Alignment.center,
                                child: Container(
                                  width: scWidth / 2.5,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      padding: EdgeInsets.all(0),
                                      backgroundColor: Colors.white,
                                    ),
                                    onPressed: () async {
                                      print("Pressed");
                                      // final downloadedFile =
                                      //     await loadPdfFromNetwork(pdfUrl);

                                      // print("Download : ${downloadedFile}");

                                      //You can download a single file
                                      await _flutterMediaDownloaderPlugin
                                          .downloadMedia(context, pdfUrl);

                                      setState(() {});
                                    },
                                    child: DottedBorder(
                                      dashPattern: [3, 4],
                                      borderType: BorderType.RRect,
                                      strokeCap: StrokeCap.butt,
                                      padding: EdgeInsets.all(0),
                                      radius: Radius.circular(roundBtn - 3),
                                      color: appcolor,
                                      strokeWidth: 1,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Image.asset(
                                              "asserts/images/pdf.png",
                                              width: scWidth / 18,
                                            ),
                                            Text(
                                              "Download PDF",
                                              style: TextStyle(
                                                fontSize: exSmFontSize,
                                                fontWeight: FontWeight.w700,
                                                color: appcolor,
                                                // decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              //No Bill Found
                              Container(
                                height: scHeight / 1.5,
                                alignment: Alignment.center,
                                child: Text(
                                  'No Bill Found!',
                                  style: TextStyle(
                                      color: appcolor, fontSize: lgFontSize),
                                ),
                              ),
                            ],
                          );
                        }
                      }
                    },
                  );
                }
              }),
        ],
      ),
    );
  }
}
