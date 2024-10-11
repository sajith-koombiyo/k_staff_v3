import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/uI/main/notification/noti_details.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';

import '../../../class/class.dart';
import '../../../provider/provider.dart';
import '../../widget/nothig_found.dart';
import '../navigation/navigation.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key, required this.userId});
  final String userId;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List notification = [];

  bool isLoading = false;
  @override
  void initState() {
    getData(true);
    // TODO: implement initState
    super.initState();
  }

  getData(bool isInit) async {
    setState(() {
      isLoading = isInit;
    });
    notification = await CustomApi().getMyNotification(context);
    var temp = await CustomApi().notificationCount(widget.userId.toString());

    Provider.of<ProviderS>(context, listen: false).noteCount = temp;
    setState(() {
      notification;
      isLoading = false;
    });
  }

  readNot() async {
    var temp = await CustomApi().notificationCount(widget.userId.toString());

    Provider.of<ProviderS>(context, listen: false).noteCount = temp;
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Consumer<ProviderS>(
      builder: (context, provider, child) => Scaffold(
          backgroundColor: white,
          body: RefreshIndicator(
            onRefresh: () {
              return getData(false);
            },
            child: SizedBox(
              height: h,
              width: w,
              child: Stack(
                children: [
                  // Container(
                  //   height: h,
                  //   width: w,
                  // ),
                  isLoading == false && notification.isEmpty
                      ? NoData()
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: notification.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NotificationDetails(
                                        read: readNot,
                                        date: notification[index]
                                            ['notify_date'],
                                        msg: notification[index]['message'],
                                        title: notification[index]['title'],
                                        userId: widget.userId,
                                      ),
                                    ));
                              },
                              child: Card(
                                elevation: 20,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          notification[index]['title'],
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
                                        notification[index]['message'],
                                        overflow: TextOverflow.clip,
                                        maxLines: 2,
                                        softWrap: false,
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
                                          notification[index]['notify_date'],
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
                            ),
                          ),
                        ),
                  isLoading ? Loader().loader(context) : SizedBox(),
                  provider.isanotherUserLog ? UserLoginCheck() : SizedBox()
                ],
              ),
            ),
          )),
    );
  }
}
