import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../../app_details/color.dart';
import '../../../app_details/size.dart';

class DashbordCard extends StatelessWidget {
  const DashbordCard(
      {super.key,
      required this.color,
      required this.text,
      required this.text2});
  final String text;
  final String text2;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: EdgeInsets.all(0),
      child: Card(
        margin: EdgeInsets.all(0),
        color: black.withOpacity(0.1),
        child: Container(
          padding: EdgeInsets.all(8),
          width: AppSize().width(context) / 3.4,
          height: AppSize().height(context) / 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                    fontSize: 12.dp,
                    color: white.withOpacity(0.9),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'sinhala'),
              ),
              Spacer(),
              Text(
                text2,
                style: TextStyle(
                    fontSize: 12.dp,
                    color: white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'sinhala'),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
