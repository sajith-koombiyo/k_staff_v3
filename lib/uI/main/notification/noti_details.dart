import 'package:flutter/material.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';

import '../../../api/api.dart';
import '../../../provider/provider.dart';

class NotificationDetails extends StatefulWidget {
  const NotificationDetails(
      {super.key, required this.date, required this.msg, required this.title,required this.userId});
  final String title;
  final String msg;
  final String date;
  final String userId;

  @override
  State<NotificationDetails> createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificationDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

    readNotification() async {
    await CustomApi().notificationMarkAsRead(context);
    var res = await CustomApi().notificationCount(widget.userId);

    Provider.of<ProviderS>(context, listen: false).noteCount = res;
  }
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
                  widget.title,
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
                widget.msg,
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
                  widget.date,
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
