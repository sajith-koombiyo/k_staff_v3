import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../../class/class.dart';

class StudentChats extends StatefulWidget {
  const StudentChats({super.key, required this.dpId});
  final String dpId;

  @override
  State<StudentChats> createState() => _StudentChatsState();
}

class _StudentChatsState extends State<StudentChats> {
  bool isLoading = false;
  TextEditingController msg = TextEditingController();

  List remarkList = [];
  ScrollController scroll = ScrollController();
  bool noData = false;
  bool validUser = false;
  String vid = "";
  String sid = "";

  @override
  void initState() {
    data();
    // TODO: implement initState
    super.initState();
  }

  data() async {
    setState(() {
      isLoading = true;
    });
    var res = await CustomApi().depositremarkHistry(context, widget.dpId);
    setState(() {
      remarkList = res;
      isLoading = false;
    });
 
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appliteBlue,
        title: Text(
          'Remark History',
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
      backgroundColor: Color.fromARGB(255, 154, 154, 145),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        controller: scroll,
        child: SizedBox(
          height: h,
          child: Stack(children: [
            SizedBox(
              height: h,
              child: ListView.builder(
                controller: scroll,
                // padding: const EdgeInsets.only(bottom: 50, top: 70),
                itemCount: remarkList.length,
                itemBuilder: (context, index) {
                  return remarkList[index]['type'] == '1'
                      ? Column(
                          children: [
                            ChatBubble(
                              clipper: ChatBubbleClipper1(
                                  type: BubbleType.sendBubble),
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(top: 20),
                              backGroundColor: Colors.blue,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Head office',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        remarkList[index]['dire_remark'],
                                        textAlign: TextAlign.end,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(right: 8, top: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      remarkList[index]['datetime'],
                                      style: TextStyle(
                                          fontSize: 10.sp,
                                          color:
                                              Color.fromARGB(255, 84, 81, 81),
                                          fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Icon(
                                      Icons.done_all_rounded,
                                      size: 15,
                                      color: Color.fromARGB(255, 71, 100, 148),
                                    ),
                                  ],
                                ))
                          ],
                        )
                      : Column(
                          children: [
                            ChatBubble(
                                clipper: ChatBubbleClipper1(
                                    radius: 20,
                                    type: BubbleType.receiverBubble),
                                backGroundColor:
                                    Color.fromARGB(255, 200, 200, 209),
                                margin: EdgeInsets.only(top: 20, left: 10),
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.7,
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Text(
                                            remarkList[index]['staff_name'],
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: black2,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          remarkList[index]['dire_remark'],
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 8, bottom: 12),
                              child: Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    children: [
                                      Text(
                                        remarkList[index]['datetime'],
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            color:
                                                Color.fromARGB(255, 84, 81, 81),
                                            fontWeight: FontWeight.normal),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Icon(
                                        Icons.done_all_rounded,
                                        size: 15,
                                        color:
                                            Color.fromARGB(255, 71, 100, 148),
                                      ),
                                    ],
                                  )),
                            )
                          ],
                        );
                },
              ),
            ),
            isLoading
                ? Center(
                    child: Loader().loader(context),
                  )
                : SizedBox(),
          ]),
        ),
      ),
    );
  }
}
