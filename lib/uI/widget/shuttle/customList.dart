import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../../app_details/color.dart';

class CustomList extends StatelessWidget {
  const CustomList({super.key, required this.icon, required this.list});
  final IconData icon;
  final List list;

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return SizedBox(
      height: h,
      child: ListView.separated(
        padding: const EdgeInsets.all(15),
        itemCount: list.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (context, index) {
          return Card(
            elevation: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: w,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Icon(
                        Icons.add_business_sharp,
                        size: 45,
                        color:
                            Color(Random().nextInt(0xffffffff)).withAlpha(0xff),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          list[index]['branch'],
                          style: TextStyle(
                            fontSize: 18.dp,
                            color: black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Pending Picked',
                          style: TextStyle(
                            fontSize: 12.dp,
                            color: black2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '2024/01/02',
                          style: TextStyle(
                            fontSize: 12.dp,
                            color: black2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Card(
                      elevation: 20,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          icon,
                          size: 45,
                          color: Colors.green,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
