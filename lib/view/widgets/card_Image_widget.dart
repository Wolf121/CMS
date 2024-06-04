import 'dart:io';

import 'package:dha_resident_app/anim/image_zoom_animation.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import '../../constant.dart';

class CardImageWidget extends StatelessWidget {
  const CardImageWidget({
    super.key,
    required this.imageText,
    required this.ftSize,
    required this.customImage,
    required this.function,
    required this.licenseImage,
    required this.onRemovePressed,
  });
  final String imageText;
  final double ftSize;
  final String customImage;
  final function;
  final String licenseImage;
  final VoidCallback onRemovePressed;

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scheight = MediaQuery.of(context).size.height;

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
              contentPadding: EdgeInsets.zero,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: InstaImageViewer(
                      child: Image.file(
                        File(imageNew),
                        width: scWidth / 2,
                        errorBuilder: (context, exception, stackTrace) {
                          return Image.asset("asserts/icons/icon.png");
                        },
                        // height: scHeight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      );
    }

    return ElevatedButton(
      onPressed: function,
      child:
          // Check if imagePath is null or empty
          licenseImage == '' || licenseImage.isEmpty
              ?

              // Handle the case where imagePath is null or empty
              Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: Image.asset(
                        customImage,
                        color: appcolor,
                        width: scWidth / 9,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      // margin: EdgeInsets.only(top: 10),
                      child: Text(
                        imageText,
                        style: TextStyle(
                            fontSize: ftSize,
                            fontWeight: FontWeight.w500,
                            color: appcolor),
                      ),
                    ),
                  ],
                )
              :

              // Display the image using Image.file if imagePath is not null

              Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                          width: scWidth / 2.7,
                          height: scheight / 9,
                          child: Image.file(File(licenseImage),
                              fit: BoxFit.cover)),
                    ),
                    InkWell(
                      onTap: () {
                        onRemovePressed();
                      },
                      child: Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: scWidth / 16,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          _showCustomDialog(licenseImage);
                          // onRemovePressed();
                        },
                        child: Icon(
                          Icons.remove_red_eye,
                          color: appcolor,
                          size: scWidth / 16,
                        ),
                      ),
                    ),
                  ],
                ),
      style: ElevatedButton.styleFrom(
        // elevation: dfElevation,
        backgroundColor: dfColor,

        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}

class CompalintImgCardWidget extends StatelessWidget {
  const CompalintImgCardWidget({
    super.key,
    required this.imageText,
    required this.ftSize,
    required this.customImage,
    required this.function,
    required this.licenseImage,
    required this.onRemovePressed,
  });
  final String imageText;
  final double ftSize;
  final String customImage;
  final function;
  final String licenseImage;
  final VoidCallback onRemovePressed;

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scheight = MediaQuery.of(context).size.height;

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
              contentPadding: EdgeInsets.zero,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: InstaImageViewer(
                      child: ImageZoomWidget(
                        zoomImage: Image.file(
                          File(imageNew),
                          width: scWidth,
                          errorBuilder: (context, exception, stackTrace) {
                            return Image.asset("asserts/icons/icon.png");
                          },
                          // height: scHeight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      );
    }

    return Column(
      children: [
        Container(
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(roundBtn)),
          width: scWidth,
          child: ElevatedButton(
            onPressed: function,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  imageText,
                  style: TextStyle(color: dfColor, fontSize: 12),
                ),
                Container(
                  width: scWidth / 10,
                  child: Icon(
                    Icons.file_upload_outlined,
                    size: 30,
                    color: dfColor,
                  ),
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: appcolor,
              // padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        licenseImage.isEmpty
            ? Container()
            : Stack(
                alignment: Alignment.topLeft,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                        width: scWidth / 3.5,
                        height: scheight / 9,
                        child:
                            Image.file(File(licenseImage), fit: BoxFit.cover)),
                  ),
                  InkWell(
                    onTap: () {
                      onRemovePressed();
                    },
                    child: Icon(
                      Icons.cancel,
                      color: Colors.red,
                      size: scWidth / 16,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        // InstaImageViewer(
                        //   child: Image.file(
                        //     File(licenseImage),
                        //     width: scWidth,
                        //     errorBuilder: (context, exception, stackTrace) {
                        //       return Image.asset("asserts/icons/icon.png");
                        //     },
                        //     // height: scHeight,
                        //   ),
                        // );

                        _showCustomDialog(licenseImage);
                        // onRemovePressed();
                      },
                      child: Icon(
                        Icons.remove_red_eye,
                        color: appcolor,
                        size: scWidth / 16,
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
