import 'package:flutter/material.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class NotificationDetails extends StatelessWidget {
  const NotificationDetails(
      {super.key, required this.date, required this.msg, required this.title});
  final String title;
  final String msg;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appliteBlue,
        title: Text(
          'Notification Details',
          style: TextStyle(
            fontSize: 18.dp,
            color: white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: white,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.dp,
                    color: black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                msg,
                style: TextStyle(
                  fontSize: 12.dp,
                  color: black1,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  date,
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
      ),
    );
  }
}
