import 'package:flutter/material.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class HomeCard extends StatelessWidget {
  const HomeCard(
      {super.key,
      required this.icon,
      required this.text,
      required this.text2,
      required this.color});
  final String text;
  final String text2;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 2,
        color: Color.fromARGB(255, 223, 250, 255),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                radius: 30,
                child: Icon(
                  icon,
                  size: 30,
                  color: white,
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: black,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    text2 == 'null' ? '0' : text2,
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: Color.fromARGB(255, 82, 81, 83),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
