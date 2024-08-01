import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
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
    log(res.toString());
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
      backgroundColor: backgroundColor2,
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
                      ? Padding(
                          padding: EdgeInsets.only(
                              right: w / 5, top: 10, left: 8, bottom: 8),
                          child: Card(
                            elevation: 20,
                            color: const Color.fromARGB(255, 98, 132, 160),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        'Head office',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        remarkList[index]['dire_remark'],
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: white,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, right: 12, bottom: 12),
                                  child: Container(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        remarkList[index]['datetime'],
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: white,
                                            fontWeight: FontWeight.normal),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                              right: 8, top: 10, left: w / 10, bottom: 8),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 50,
                                  color: Color.fromARGB(255, 6, 51, 88),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(30),
                                          bottomRight: Radius.circular(30),
                                          topLeft: Radius.circular(30))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),

                                      
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Text(
                                              'Branch remark',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              remarkList[index]['dire_remark'],
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: white2,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, right: 8, bottom: 12),
                                        child: Container(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              remarkList[index]['datetime'],
                                              style: TextStyle(
                                                  fontSize: 10.sp,
                                                  color: white3,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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
