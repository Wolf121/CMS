import 'package:dha_resident_app/constant.dart';
import 'package:flutter/material.dart';

class ImageZoomAnimation extends StatefulWidget {
  final Widget zoomImage;
  ImageZoomAnimation({
    required this.zoomImage,
  });

  @override
  State<ImageZoomAnimation> createState() => _ImageZoomAnimationState();
}

class _ImageZoomAnimationState extends State<ImageZoomAnimation>
    with SingleTickerProviderStateMixin {
  late TransformationController controller;
  TapDownDetails? tapDownDetails;

  late AnimationController animationController;
  Animation<Matrix4>? animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TransformationController();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            controller.value = animation!.value;
          });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTapDown: (details) {
          tapDownDetails = details;
        },
        onTap: () {
          final position = tapDownDetails!.localPosition;

          final double scale = 2;
          final x = -position.dx * (scale - 1);
          final y = -position.dy * (scale - 1);
          final zoomed = Matrix4.identity()
            ..translate(x, y)
            ..scale(scale);

          final end =
              controller.value.isIdentity() ? zoomed : Matrix4.identity();
          // controller.value = end;

          animation = Matrix4Tween(begin: controller.value, end: end).animate(
              CurveTween(curve: Curves.easeOut).animate(animationController));
          animationController.forward(from: 0);
        },
        child: InteractiveViewer(
          transformationController: controller,
          // clipBehavior: Clip.none,
          panEnabled: false,
          scaleEnabled: false,
          child: AspectRatio(
            aspectRatio: 1,
            child: widget.zoomImage,
          ),
        ),
      ),
    );
  }
}

class ImageZoomWidget extends StatefulWidget {
  final Widget zoomImage;
  ImageZoomWidget({
    required this.zoomImage,
  });

  @override
  State<ImageZoomWidget> createState() => _ImageZoomWidgetState();
}

class _ImageZoomWidgetState extends State<ImageZoomWidget>
    with SingleTickerProviderStateMixin {
  late TransformationController controller;
  TapDownDetails? tapDownDetails;

  late AnimationController animationController;
  Animation<Matrix4>? animation;

  final double minScale = 1;
  final double maxScale = 5;
  OverlayEntry? entry;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TransformationController();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200))
          ..addListener(() {
            controller.value = animation!.value;
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              removeOverlay();
            }
          });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildImage(),
    );
  }

  Widget buildImage() {
    return Builder(builder: (context) {
      return InteractiveViewer(
        transformationController: controller,
        clipBehavior: Clip.none,
        panEnabled: false,
        maxScale: maxScale, minScale: minScale,
        onInteractionStart: (details) {
          if (details.pointerCount < 2) return;

          showOverlay(context);
        },
        onInteractionEnd: (detail) {
          resetAnimation();
        },
        // scaleEnabled: false,
        child: AspectRatio(
          aspectRatio: 1,
          child: widget.zoomImage,
        ),
      );
    });
  }

  void removeOverlay() {
    entry?.remove();
    entry = null;
  }

  void showOverlay(BuildContext context) {
    final renderBox = context.findRenderObject()! as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = MediaQuery.of(context).size;

    entry = OverlayEntry(builder: (context) {
      return Stack(
        children: <Widget>[
          Positioned.fill(
              child: Container(
            color: blackColor,
          )),
          Positioned(
            left: offset.dx,
            top: offset.dy,
            width: size.width,
            child: buildImage(),
          ),
        ],
      );
    });

    final overlay = Overlay.of(context);
    overlay.insert(entry!);
  }

  void resetAnimation() {
    animation = Matrix4Tween(begin: controller.value, end: Matrix4.identity())
        .animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));
    animationController.forward(from: 0);
  }
}
