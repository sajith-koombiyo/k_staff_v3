import 'dart:ui';

import 'package:flutter/material.dart';

class SendButton extends StatefulWidget {
  const SendButton(
      {super.key,
      required this.icon,
      required this.onTap,
      required this.radius,
      required this.color,
      required this.color2});
  final IconData icon;
  final VoidCallback onTap;
  final double radius;
  final Color color;
  final Color color2;

  @override
  State<SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<SendButton> {
  bool tap = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(100),
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
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 50),
          opacity: tap ? 0.2 : 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 5),
              child: CircleAvatar(
                  radius: widget.radius,
                  backgroundColor: widget.color.withOpacity(0.7),
                  child: Image.asset('assets/send-4008.png')),
            ),
          ),
        ));
  }
}
