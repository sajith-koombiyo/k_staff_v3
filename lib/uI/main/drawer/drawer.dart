import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/uI/main/drawer/my_oders/my_oders.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../../app_details/color.dart';
import '../../../provider/provider.dart';
import '../../widget/drower/drower_button.dart';
import 'about/about.dart';
import 'attendance/attendance.dart';
import 'branch_operation/cod_0_approval.dart';
import 'branch_operation/dd_aproval/dd_aproval.dart';
import 'contact_us/contact_us.dart';
import 'genaral/add_employe/add_employee.dart';
import 'genaral/contact/contact.dart';
import 'genaral/employee/employee_details.dart';
import 'genaral/location/location_update.dart';
import 'genaral/manage_users/manage_users.dart';
import 'genaral/youtube_tutorial.dart';
import 'my_delivery/my_delivery.dart';
import 'pending_picked/pending_picked.dart';
import 'picked/assign_pickup/assign_pickup.dart';
import 'picked/picked.dart';
import 'reschedule/reschedule.dart';
import 'shuttle/shuttle.dart';

class customDrawer extends StatefulWidget {
  const customDrawer({super.key, required this.skey, required this.ytc});
  final GlobalKey<ScaffoldState> skey;
  final List ytc;

  @override
  State<customDrawer> createState() => _customDrawerState();
}

class _customDrawerState extends State<customDrawer> {
  bool tap = false;
  bool lite = false;
  bool en = false;
  bool drawTab = false;
  int drawOpen = 0;
  String key = '';
  int temp = 0;

  List modeData = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List drawerButtonList = [];
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Consumer<ProviderS>(
      builder: (context, color, child) => ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Drawer(
            backgroundColor: white.withOpacity(0.4),
            child: Container(
              width: w / 1.7,
              child: Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 0, right: 1),
                  child: SizedBox(
                    height: h,
                    child: Column(
                      children: [
                        SizedBox(
                          height: h / 1.1,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: AppBar().preferredSize.height,
                                ),

                                Container(
                                    height: h / 7,
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                          blurRadius: 300,
                                          color: Color.fromARGB(
                                              255, 180, 230, 253))
                                    ]),
                                    child: Image.asset(
                                        'assets/Untitled-1-01.png')),

                                // SizedBox(
                                //   height: 20,
                                // ),
                                // CustomDrawerButton(
                                //   icon: Icons.account_balance_wallet_rounded,
                                //   myPage: PendingPicked(),
                                //   text: 'Pending Pickups',
                                // ),
                                // CustomDrawerButton(
                                //   icon: Icons.ad_units_outlined,
                                //   myPage: Picked(),
                                //   text: 'Picked',
                                // ),

                                drawwerList(
                                    'Picked', Icons.local_shipping_outlined,
                                    () {
                                  setState(() {
                                    if (drawOpen == 1 && drawTab) {
                                      drawTab = false;
                                    } else {
                                      drawOpen = 1;
                                      // temp = drawOpen;

                                      drawTab = true;
                                    }
                                  });
                                }, 1, [
                                  tileButton(' Pickup', () {
                                    setState(() {
                                      key = '1';
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Picked()),
                                    );
                                  }, key, '1'),
                                  tileButton('Pending Pickup', () {
                                    setState(() {
                                      key = '2';
                                    });

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PendingPicked()),
                                    );
                                  }, key, '2'),
                                  tileButton('Assign Pickup', () {
                                    setState(() {
                                      key = '3';
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AssignPickup()),
                                    );
                                  }, key, '3'),
                                ]),
                                CustomDrawerButton(
                                  icon: Icons.all_inbox_sharp,
                                  onTap: () {
                                    navigation(MyDelivery(
                                      isFromHome: false,
                                    ));
                                  },
                                  text: 'My Delivery',
                                ),
                                CustomDrawerButton(
                                  icon: Icons.border_outer_rounded,
                                  onTap: () {
                                    navigation(MyOrders());
                                  },
                                  text: 'My Orders',
                                ),
                                CustomDrawerButton(
                                  icon: Icons.query_builder,
                                  onTap: () {
                                    navigation(Reschedule());
                                  },
                                  text: 'Reschedule',
                                ),
                                drawwerList('Branch Operations',
                                    Icons.accessibility_outlined, () {
                                  setState(() {
                                    if (drawOpen == 2 && drawTab) {
                                      drawTab = false;
                                    }
                                    drawOpen = 2;
                                    drawTab = true;
                                  });
                                }, 2, [
                                  tileButton('DD Approval', () {
                                    setState(() {
                                      key = '1';
                                    });

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DDApproval()),
                                    );
                                    setState(() {
                                      key = '0';
                                    });
                                  }, key, '1'),
                                  tileButton('COD 0 (zero) Approval', () {
                                    setState(() {
                                      key = '2';
                                    });

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CODZeroApproval()),
                                    );
                                    setState(() {
                                      key = '0';
                                    });
                                  }, key, '2'),
                                ]),

                                drawwerList('General', Icons.gps_fixed_rounded,
                                    () {
                                  setState(() {
                                    if (drawOpen == 3 && drawTab) {
                                      drawTab = false;
                                    } else {
                                      drawOpen = 3;
                                      // temp = drawOpen;

                                      drawTab = true;
                                    }
                                  });
                                }, 3, [
                                  tileButton('Tutorial', () {
                                    setState(() {
                                      key = '1';
                                    });
                                    widget.ytc.isEmpty
                                        ? notification().warning(context,
                                            "Apologies, couldn't connect to the tutorial video.")
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    YoutubeTutorial(
                                                      ytc: widget.ytc,
                                                    )),
                                          );
                                    setState(() {
                                      key = '0';
                                    });
                                  }, key, '1'),
                                  tileButton('Add Employee', () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddEmployee(
                                                branchId: color.userData[0]
                                                    ['branch_id'],
                                              )),
                                    );
                                    setState(() {
                                      key = '2';
                                    });
                                  }, key, '2'),
                                  tileButton('Manage Users', () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ManageUsers()),
                                    );
                                    setState(() {
                                      key = '4';
                                    });
                                  }, key, '4'),
                                  tileButton('Employee', () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EmployeeDetails()),
                                    );
                                    setState(() {
                                      key = '5';
                                    });
                                  }, key, '5'),
                                  tileButton('Employee Contact', () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Contact()),
                                    );
                                    setState(() {
                                      key = '6';
                                    });
                                  }, key, '6'),
                                  tileButton('Location Update', () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LocationScreen()),
                                    );
                                    setState(() {
                                      key = '7';
                                    });
                                  }, key, '7'),
                                ]),

                                CustomDrawerButton(
                                  icon: Icons.group,
                                  onTap: () {
                                    navigation(Attendance());
                                  },
                                  text: 'Attendance',
                                ),
                                CustomDrawerButton(
                                  icon: Icons.departure_board_outlined,
                                  onTap: () {
                                    navigation(Shuttle());
                                  },
                                  text: 'Shuttle',
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    focusColor: white,
                                    onTap: () {
                                      share();
                                    },
                                    child: Card(
                                      color: color.pwhite1.withOpacity(0.2),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.share_outlined,
                                              color: white,
                                            ),
                                            SizedBox(
                                              width: w / 15,
                                            ),
                                            Text(
                                              'Share',
                                              style: TextStyle(
                                                fontSize: 12.dp,
                                                color: white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // InkWell(
                                //   borderRadius: BorderRadius.circular(10),
                                //   onTap: () async {
                                //     final InAppReview inAppReview =
                                //         InAppReview.instance;

                                //     if (await inAppReview.isAvailable()) {
                                //       inAppReview.requestReview();
                                //     }

                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) => Review()),
                                //     );
                                //   },
                                //   child: Card(
                                //     color: color.pwhite1.withOpacity(0.2),
                                //     child: Padding(
                                //       padding: const EdgeInsets.all(8.0),
                                //       child: Row(
                                //         mainAxisAlignment: MainAxisAlignment.start,
                                //         children: [
                                //           Icon(
                                //             Icons.star_border_outlined,
                                //             color: white,
                                //           ),
                                //           SizedBox(
                                //             width: w / 15,
                                //           ),
                                //           Text(
                                //             'Review',
                                //             style: TextStyle(
                                //               fontSize: 12.dp,
                                //               color: white,
                                //               fontWeight: FontWeight.bold,
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                CustomDrawerButton(
                                  icon: Icons.check_circle_outline_outlined,
                                  onTap: () {
                                    navigation(About());
                                  },
                                  text: 'About',
                                ),
                                CustomDrawerButton(
                                  icon: Icons.add_call,
                                  onTap: () {
                                    navigation(ContactUs());
                                  },
                                  text: 'Contact Us',
                                ),

                                // Spacer(),

                                // Spacer(),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        Text("Copyright 2024 by \nKoobiyo IT (pvt)Ltd",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: black1,
                              fontSize: 12.dp,
                              fontWeight: FontWeight.normal,
                            )),
                        SizedBox(
                          height: 12,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  navigation(Widget myPage) {
    setState(() {
      drawTab = false;
    });
    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.bottomToTop,
          duration: Duration(milliseconds: 600),
          child: myPage,
          inheritTheme: true,
          ctx: context),
    );
  }

  Widget drawwerList(String title, IconData icon, VoidCallback onTap,
      int tabIndex, List<Widget> list) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Card(
          color: white3.withOpacity(0.2),
          child: SizedBox(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        icon,
                        color: white,
                      ),
                      SizedBox(
                        width: w / 15,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 12.dp,
                          color: white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: white,
                      ),
                    ],
                  ),
                ),
                drawOpen == tabIndex && drawTab ? Divider() : SizedBox(),
                drawOpen == tabIndex && drawTab
                    ? Column(children: list)
                    : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  tileButton(String text, VoidCallback onTap, String key, String selectIndex) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: onTap,
        child: Card(
          margin: EdgeInsets.all(0),
          key: Key(key),
          color: key == selectIndex ? logoliteblue4 : black.withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Container(
            width: w,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(text,
                      style: TextStyle(
                        color: white,
                        fontSize: 12.sp,
                      )),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: white1,
                    size: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Koobiyo rider',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title');
  }
}
