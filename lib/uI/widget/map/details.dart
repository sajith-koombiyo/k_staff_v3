import 'package:flutter/material.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Detail extends StatelessWidget {
  const Detail(
      {super.key,
      required this.icon,
      required this.title,
      required this.title2,
      required this.color,
      required this.onTap});
  final String title;
  final String title2;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: AnimationConfiguration.synchronized(
        child: SlideAnimation(
          horizontalOffset: 200,
          duration: Duration(milliseconds: 900),
          child: FadeInAnimation(
            child: Card(
              elevation: 20,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    SlideAnimation(
                      verticalOffset: 200,
                      duration: Duration(milliseconds: 900),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: onTap,
                        child: Card(
                          elevation: 20,
                          child: Icon(
                            icon,
                            size: 40,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 14.dp,
                              color: black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              title2,
                              style: TextStyle(
                                fontSize: 12.dp,
                                color: black2,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
