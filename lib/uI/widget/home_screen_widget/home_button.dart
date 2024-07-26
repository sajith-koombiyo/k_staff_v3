// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../../app_details/color.dart';

class HomeButton extends StatefulWidget {
  const HomeButton({super.key, required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  State<HomeButton> createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> {
  bool tap = false;
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
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
        duration: Duration(milliseconds: 30),
        child: Container(
          alignment: Alignment.center,
          height: h / 14,
          width: w,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(blurRadius: 10, spreadRadius: 10, color: Colors.black12)
            ],
            color: Color.fromARGB(255, 18, 201, 233),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color: white,
              fontFamily: 'Rubik',
              fontSize: 13.dp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
