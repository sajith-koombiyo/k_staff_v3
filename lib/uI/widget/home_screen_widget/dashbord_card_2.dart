import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../app_details/color.dart';
import '../../../app_details/size.dart';

class DashbordCard2 extends StatelessWidget {
  const DashbordCard2(
      {super.key,
      required this.color,
      required this.color2,
      required this.text,
      required this.text2,
      required this.data});
  final String text;
  final String text2;
  final Color color;
  final Color color2;
  final List data;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                blurRadius: 2, spreadRadius: 1, blurStyle: BlurStyle.inner)
          ],
          gradient: LinearGradient(colors: [color, color2]),
          borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.all(8),
      width: AppSize().width(context) / 2.2,
      // height: AppSize().height(context) / 9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 4,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.dp,
              color: white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          data.isEmpty
              ? loader()
              : Text(
                  text2,
                  style: TextStyle(
                    fontSize: 16.dp,
                    color: white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  Widget loader() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: 15,
        width: 15,
        child: LoadingAnimationWidget.threeArchedCircle(
          color: Color.fromARGB(255, 153, 166, 177),
          size: 25,
        ),
      ),
    );
  }
}
