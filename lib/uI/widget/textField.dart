import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../app_details/color.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.text,
      required this.icon});
  final TextEditingController controller;
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: controller,
      style: TextStyle(color: black, fontSize: 13.sp),
      validator: (value) {},
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.black12,
          // color: pink.withOpacity(0.1),
        )),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black12,
            // color: pink.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        filled: true,
        hintStyle: TextStyle(fontSize: 13.dp),
        fillColor: white.withOpacity(0.3),
      ),
    );
  }
}
