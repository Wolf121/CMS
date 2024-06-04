import 'package:dha_resident_app/constant.dart';
import 'package:flutter/material.dart';

class AnimatedCheckmarkDialog extends StatelessWidget {
  final String message;
  final Color checkmarkColor;
  AnimatedCheckmarkDialog({
    required this.message,
    required this.checkmarkColor,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedCheckmark(checkmarkColor: checkmarkColor),
          SizedBox(height: 16),
          Text(message,
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: dfFontSize, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class AnimatedCheckmark extends StatefulWidget {
  final Color checkmarkColor;

  AnimatedCheckmark({required this.checkmarkColor});
  @override
  _AnimatedCheckmarkState createState() => _AnimatedCheckmarkState();
}

class _AnimatedCheckmarkState extends State<AnimatedCheckmark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pop(); // Close the dialog
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Icon(
        Icons.check_circle,
        color: widget.checkmarkColor,
        size: 64,
      ),
    );
  }
}

void showAnimatedCheckmarkDialog(
    BuildContext context, String message, Color checkmarkColor) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AnimatedCheckmarkDialog(
        message: message,
        checkmarkColor: checkmarkColor,
      );
    },
  );
}
