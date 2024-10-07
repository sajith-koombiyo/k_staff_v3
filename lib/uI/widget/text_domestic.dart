import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../app_details/color.dart';

class CustomTextFieldDomestic extends StatelessWidget {
  const CustomTextFieldDomestic(
      {super.key,
      required this.controller,
      required this.text,
      required this.icon});
  final TextEditingController controller;
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        height: h / 17,
        child: TextFormField(
          readOnly: true,
          controller: controller,
          style: TextStyle(color: black, fontSize: 14.sp),
          validator: (value) {},
          decoration: InputDecoration(
            prefixIcon: Icon(icon),

            border: OutlineInputBorder(),
            labelText: text,
            isDense: true, // Added this
            contentPadding: EdgeInsets.all(8), // Added this
          ),
        ),
      ),
    );
  }
}
