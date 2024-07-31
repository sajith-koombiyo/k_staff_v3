import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/uI/widget/drower/send_button.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class CustomTextField3 extends StatelessWidget {
  CustomTextField3({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return TextFormField(
      maxLines: 6,
      minLines: 2,
      keyboardType: TextInputType.multiline,
      textAlign: TextAlign.left,
      style: TextStyle(color: black2, fontSize: 13),
      controller: controller,
      validator: (value) {},
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        contentPadding: EdgeInsets.only(bottom: h / 20, left: 10),
        filled: true,
        hintStyle: TextStyle(color: black, fontSize: 12.sp),
        hintText: "Type here",
        fillColor: Color.fromARGB(255, 220, 216, 216).withOpacity(0.6),
      ),
    );
  }
}
