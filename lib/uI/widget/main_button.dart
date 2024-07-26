import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../app_details/color.dart';

class MainButton extends StatefulWidget {
  const MainButton(
      {super.key,
      required this.text,
      required this.onTap,
      required this.buttonHeight,
      required this.width});
  final String text;
  final VoidCallback onTap;
  final double buttonHeight;
  final double width;

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  bool tap = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTapDown: (_) {
        setState(() {
          tap = true;
        });
      },
      onSecondaryTapDown: (_) {
        setState(() {
          tap = true;
        });
      },
      onSecondaryTapUp: (_) {
        setState(() {
          tap = false;
        });
      },
      onTapUp: (_) {
        setState(() {
          tap = false;
        });
      },
      onTapCancel: () {
        setState(() {
          tap = false;
        });
      },
      onTap: widget.onTap,
      mouseCursor: MouseCursor.defer,
      child: AnimatedOpacity(
        opacity: tap ? 0.2 : 1,
        duration: const Duration(milliseconds: 60),
        child: Container(
          padding: const EdgeInsets.all(4),
          alignment: Alignment.center,
          height: widget.buttonHeight,
          width: widget.width,
          decoration: BoxDecoration(
            color: appliteBlue,
            borderRadius: BorderRadius.circular(15),
            // gradient: LinearGradient(colors: [appBlue, Color.fromARGB(31, 35, 38, 238)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Text(widget.text,
              style: TextStyle(
                  color: white,
                  fontSize: 15.dp,
                  fontWeight: FontWeight.normal)),
        ),
      ),
    );
  }
}
