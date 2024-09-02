import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../app_details/color.dart';

class DialogButton extends StatefulWidget {
  const DialogButton(
      {super.key,
      required this.text,
      required this.onTap,
      required this.buttonHeight,
      required this.width,
      required this.color});
  final String text;
  final VoidCallback onTap;
  final double buttonHeight;
  final double width;
  final Color color;

  @override
  State<DialogButton> createState() => _DialogButtonState();
}

class _DialogButtonState extends State<DialogButton> {
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
        duration: Duration(milliseconds: 60),
        child: Container(
          padding: EdgeInsets.all(4),
          alignment: Alignment.center,
          height: widget.buttonHeight,
          width: widget.width,
          decoration: BoxDecoration(
            color: widget.color,
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

class DialogButton3 extends StatefulWidget {
  const DialogButton3(
      {super.key,
      required this.text,
      required this.onTap,
      // required this.buttonHeight,
      required this.width,
      required this.color});
  final String text;
  final VoidCallback onTap;
  // final double buttonHeight;
  final double width;
  final Color color;

  @override
  State<DialogButton3> createState() => _DialogButton3State();
}

class _DialogButton3State extends State<DialogButton3> {
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
        duration: Duration(milliseconds: 60),
        child: Container(
          padding: EdgeInsets.all(4),
          alignment: Alignment.center,
          // height: widget.buttonHeight,
          width: widget.width,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(15),
            // gradient: LinearGradient(colors: [appBlue, Color.fromARGB(31, 35, 38, 238)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Column(
            children: [
              Text(widget.text,
                  style: TextStyle(
                      color: white,
                      fontSize: 15.dp,
                      fontWeight: FontWeight.normal)),
              Text(widget.text,
                  style: TextStyle(
                      color: white,
                      fontSize: 15.dp,
                      fontWeight: FontWeight.normal)),
            ],
          ),
        ),
      ),
    );
  }
}
