import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../../app_details/color.dart';

class TextContainer extends StatelessWidget {
  const TextContainer({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ClipRRect(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
              color: black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15)),
          alignment: Alignment.centerLeft,
          width: w,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.dp,
              color: black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
