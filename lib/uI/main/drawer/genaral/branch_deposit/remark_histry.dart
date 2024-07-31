import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StudentChats extends StatefulWidget {
  const StudentChats({
    super.key,
  });

  @override
  State<StudentChats> createState() => _StudentChatsState();
}

class _StudentChatsState extends State<StudentChats> {
  bool isLoading = false;
  TextEditingController msg = TextEditingController();

  List studentChatList = [];
  ScrollController scroll = ScrollController();
  bool noData = false;
  bool validUser = false;
  String vid = "";
  String sid = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
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
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return index == 1
                        ? Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    right: w / 5, top: 20, left: 8, bottom: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                      topRight: Radius.circular(30)),
                                  child: BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: black.withOpacity(0.6),
                                          gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(
                                                    255, 19, 49, 161),
                                                Color.fromARGB(255, 19, 1, 26)
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(30),
                                              bottomRight: Radius.circular(30),
                                              topRight: Radius.circular(30))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 88, right: 8),
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "ffffffffffff",
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    fontFamily: 'Play',
                                                    color: Colors.white60,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'ffffffffffffffffffff',
                                                  style: TextStyle(
                                                      fontSize: 9.sp,
                                                      fontFamily: 'Play',
                                                      color: white,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8, right: 8, bottom: 8),
                                            child: Container(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Text(
                                                  '2024/04/56',
                                                  style: TextStyle(
                                                      fontSize: 8.sp,
                                                      fontFamily: 'Play',
                                                      color: Colors.white70,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Positioned(
                              //   left: 15,
                              //   child: CircleAvatar(
                              //       radius: 20.sp,
                              //       foregroundImage: NetworkImage(
                              //           "https://ftm.novasoft.lk/ssss}")),
                              // ),
                            ],
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                                right: 8, top: 20, left: w / 5, bottom: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                  topLeft: Radius.circular(30)),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 59, 130, 127),
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
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'f   VBn bVunZKz VZ BvUNKZkzbzvn  bsyFSILAXXKbkHVU  ABYIGIAX ASCTS7Y8EUBX',
                                              style: TextStyle(
                                                  fontSize: 9.sp,
                                                  color: white,
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
                                              '2023-05-10:10.25 AM',
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
                            ),
                          );
                  },
                ),
              ),
              isLoading
                  ? Positioned(
                      top: 80,
                      right: 0,
                      left: 0,
                      child: Container(
                          alignment: Alignment.topCenter,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor:
                                const Color.fromARGB(255, 68, 70, 70),
                            child: LoadingAnimationWidget.discreteCircle(
                                color: Colors.white, size: 17),
                          )),
                    )
                  : Container()
            ]),
          ),
        ),
      ),
    );
  }
}
