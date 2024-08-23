import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:page_transition/page_transition.dart';

import '../../../app_details/color.dart';

class CustomDrawerButton extends StatelessWidget {
  const CustomDrawerButton(
      {super.key, required this.icon, required this.text, required this.onTap});
  final String text;
  final IconData icon;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Card(
          color: white3.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: white,
                ),
                SizedBox(
                  width: w / 15,
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 12.dp,
                    color: white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDrawerButton2 extends StatelessWidget {
  const CustomDrawerButton2(
      {super.key, required this.icon, required this.text, required this.onTap});
  final String text;
  final IconData icon;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Card(
          color: white3.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: white,
                ),
                SizedBox(
                  width: w / 15,
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 12.dp,
                    color: white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
