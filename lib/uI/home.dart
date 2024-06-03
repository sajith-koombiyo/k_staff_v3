import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/const.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/uI/main/drawer/my_delivery/testCall.dart';
import 'package:flutter_launcher_icons/config/config.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../app_details/color.dart';
import '../provider/provider.dart';
import 'main/drawer/my_delivery/my_delivery.dart';
import 'main/drawer/my_delivery/voice_call.dart';
import 'main/navigation/navigation.dart';
import 'widget/gauge/gauge.dart';
import 'widget/home_screen_widget/card.dart';
import 'widget/home_screen_widget/chart.dart';
import 'widget/home_screen_widget/dashbord_card_2.dart';
import 'widget/home_screen_widget/home_button.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  String userId = '';
  bool isLoading = false;
  String successRate = '';
  List dataList = [];
  String riderCharge = '';
  String pendingComm = '';
  String nextday = '';
  String bankAmount = '';
  String formattedDate = '';
  var cashOutstanding;
  var totalOutstanding;
  var rider;
  var pending;
  int x = 0;
  int y = 0;
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    dashBoardData();
    data();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    //don't forget to dispose of it when not needed anymore
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  //  AppLifecycleState ?_lastState;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {}
    if (state == AppLifecycleState.resumed) {
      bool serviceEnabled;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (Provider.of<ProviderS>(context, listen: false).isUpdtatLocation ==
              false &&
          serviceEnabled) {
        x = 1;
        Provider.of<ProviderS>(context, listen: false).location = true;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? id = await prefs.getString('userId');
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        Future.delayed(const Duration(milliseconds: 200), () async {
          CustomApi().userLocation(id.toString(), position!.latitude.toString(),
              position!.longitude.toString());
        });

        Provider.of<ProviderS>(context, listen: false).location = false;
        Provider.of<ProviderS>(context, listen: false).isUpdtatLocation = true;
      }
    }
    //register the last state. When you get "paused" it means the app went to the background.
  }

// loading all dashboard data
  dashBoardData() async {
    setState(() {
      DateTime now = DateTime.now();
      formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
      // isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var temp = await CustomApi().dashboardData(id.toString(), context);

    setState(() {
      userId = id.toString();
      dataList = temp;
    });
    var noteCount = await CustomApi().notificationCount(id.toString());

    Provider.of<ProviderS>(context, listen: false).noteCount = noteCount;
    double to = double.parse(temp[0]['total_orders'].toString());
    double td = double.parse(temp[0]['total_delivery'].toString());
    double success = double.parse(((td / to) * 100).toStringAsFixed(1));

    print(to);
    print(td);
    print(success);
    successRate = success.toStringAsFixed(2).toString();
    print(successRate);
    print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    var codDelivery = dataList[0]['cod_delivery'];

    if (successRate == "NaN" || successRate == "Infinity") {
      successRate = "0.00";
    }
    riderCharge = temp[0]['rider_charge'].toString();

    pendingComm = temp[0]['com_pending'].toString();

    nextday = temp[0]['next_day'].toString();

    rider = (double.parse(riderCharge)).toStringAsFixed(2).toString();
    pending = (double.parse(pendingComm)).toStringAsFixed(2).toString();
    double res = double.parse(codDelivery) - double.parse(riderCharge);
    double out = double.parse(dataList[0]['outstanding']);
    double dp = double.parse(dataList[0]['deposit']);
    double cod = double.parse(dataList[0]['total_cod']);

    var totalOut = (cod + out - dp);
    var cashOut = out - dp;
    totalOutstanding = double.parse(totalOut.toString()).toStringAsFixed(2);
    cashOutstanding = double.parse(cashOut.toString()).toStringAsFixed(2);
    final amount = double.parse(res.toString()).toStringAsFixed(2);
    bankAmount = amount.replaceAll(RegExp('-'), '');

    setState(() {
      cashOutstanding;
      totalOutstanding;
      nextday;
      pending;
      rider;
      dataList = temp;
      riderCharge;
      successRate;
      pendingComm;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VoiceCall(
                          id: userId,
                        )));
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () {
          return dashBoardData();
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(children: [
                Stack(
                  children: [
                    SizedBox(
                        height: h / 3.5,
                        width: w,
                        child: Image.asset(
                          'assets/app 12.png',
                          fit: BoxFit.cover,
                        )),
                    Container(
                      width: w,
                      height: h / 3.5,
                      color: black.withOpacity(0.4),
                    ),
                    Positioned(
                      bottom: -2,
                      left: 0,
                      right: 0,
                      child: CustomPaint(
                        size: Size(
                            w,
                            (h /
                                8)), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                        painter: RPSCustomPainter(),
                      ),
                    ),
                    Positioned(
                      bottom: 15,
                      left: w / 3.5,
                      right: w / 3.5,
                      child: AnimationLimiter(
                        child: AnimationConfiguration.synchronized(
                          duration: Duration(milliseconds: 900),
                          child: SizedBox(
                            width: w / 2,
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                duration: Duration(milliseconds: 900),
                                child: HomeButton(
                                  onTap: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    var userId = await prefs.get(
                                      'user_id',
                                    );

                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        duration: Duration(milliseconds: 200),
                                        type: PageTransitionType.bottomToTop,
                                        child: MyDelivery(isFromHome: true),
                                        // child: VoiceCall(
                                        //   usrId: userId.toString(),
                                        // )
                                      ),
                                    );
                                    // onUserLogin(userId.toString());
                                  },
                                  text: "Track Orders",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: h / 14,
                      right: 0,
                      left: 0,
                      child: Center(
                        child: SizedBox(
                          child: Text(
                            '',
                            style: TextStyle(
                                fontSize: 30.dp,
                                color: white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                AnimationLimiter(
                  child: AnimationConfiguration.synchronized(
                    duration: Duration(milliseconds: 900),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        duration: Duration(milliseconds: 900),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Icon(Icons.query_builder_rounded,
                                      size: 25.sp, color: Colors.black54),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      dataList.isEmpty
                                          ? loader()
                                          : Text(
                                              "~${dataList[0]['total_pickups']}"
                                                  .toString(),
                                              style: TextStyle(
                                                  letterSpacing: 0,
                                                  fontFamily: '',
                                                  fontSize: 13.sp,
                                                  color: appBlue,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                      Text(
                                        "Total\npickups",
                                        style: TextStyle(
                                            fontFamily: '',
                                            fontSize: 10.dp,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Icon(Icons.landslide_outlined,
                                      size: 25.sp, color: Colors.black54),
                                  Column(
                                    children: [
                                      dataList.isEmpty
                                          ? loader()
                                          : Text(
                                              "~${dataList[0]['pending_pickups']}"
                                                  .toString(),
                                              style: TextStyle(
                                                  letterSpacing: 0,
                                                  fontFamily: '',
                                                  fontSize: 13.sp,
                                                  color: appBlue,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                      Text(
                                        "Pending\npickups",
                                        style: TextStyle(
                                            fontFamily: '',
                                            fontSize: 10.sp,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle_outline,
                                      size: 25.sp, color: Colors.black54),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      dataList.isEmpty
                                          ? loader()
                                          : Text(
                                              "~${dataList[0]['completed_pickups'].toString()}",
                                              style: TextStyle(
                                                  letterSpacing: 0,
                                                  fontFamily: '',
                                                  fontSize: 13.dp,
                                                  color: appBlue,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                      Text(
                                        "Completed\npickups",
                                        style: TextStyle(
                                            fontFamily: '',
                                            fontSize: 10.sp,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black12)),
                        width: w,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12, top: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Consumer<ProviderS>(
                                builder: (context, provider, child) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5)),
                                        border:
                                            Border.all(color: Colors.black12)),
                                    // alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Text(
                                        provider.userData.isEmpty ||
                                                provider.dpCode.isEmpty
                                            ? "Deposit Code-"
                                            : "Deposit Code-${provider.dpCode} ",
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color:
                                                Color.fromARGB(255, 47, 45, 47),
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Gauge(),
                                  SizedBox(
                                    width: 20,
                                  ),

                                  //s
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Banking amount",
                                        style: TextStyle(
                                            fontFamily: '',
                                            fontSize: 10.sp,
                                            color:
                                                Color.fromARGB(255, 47, 45, 47),
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Rs  ",
                                            style: TextStyle(
                                                fontFamily: '',
                                                fontSize: 14,
                                                color: Color.fromARGB(
                                                    255, 38, 60, 133),
                                                fontWeight: FontWeight.normal),
                                          ),
                                          dataList.isEmpty
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: loader(),
                                                )
                                              : Text(
                                                  "$bankAmount",
                                                  style: TextStyle(
                                                      fontFamily: '',
                                                      fontSize: 20,
                                                      color: Color.fromARGB(
                                                          255, 242, 76, 110),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                        ],
                                      ),
                                      const Text(
                                        'Last refresh time',
                                        style: TextStyle(fontSize: 9),
                                      ),
                                      Text(
                                        formattedDate,
                                        style: TextStyle(fontSize: 11),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Delivery Orders",
                          style: TextStyle(
                              fontFamily: '',
                              fontSize: 14.sp,
                              color: black,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DashbordCard2(
                      data: dataList,
                      color: Color.fromARGB(255, 23, 6, 109),
                      color2: Color.fromARGB(255, 101, 99, 103),
                      text: 'Total Pending',
                      text2:
                          "${dataList.isEmpty ? "0" : dataList[0]['total_pending'].toString()}",
                    ),
                    DashbordCard2(
                      data: dataList,
                      color: Color.fromARGB(255, 6, 27, 109),
                      color2: Color.fromARGB(255, 110, 95, 126),
                      text: 'Today Delivery',
                      text2:
                          '${dataList.isEmpty ? "0" : dataList[0]['next_day']}/${dataList.isEmpty ? "0" : dataList[0]['day_delivery']}',
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DashbordCard2(
                      data: dataList,
                      color: Color.fromARGB(255, 12, 80, 23),
                      color2: Color.fromARGB(255, 95, 190, 18),
                      text: 'Success Rate ',
                      text2:
                          ' ${dataList.isEmpty ? "0" : successRate.toString()}%',
                    ),
                    DashbordCard2(
                      data: dataList,
                      color: Color.fromARGB(255, 135, 27, 145),
                      color2: Color.fromARGB(255, 129, 98, 5),
                      text: 'Updated',
                      text2:
                          'Rs ${dataList.isEmpty ? "0" : dataList[0]['cod_hand'].toString()}',
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DashbordCard2(
                      data: dataList,
                      color: Color.fromARGB(255, 224, 207, 17),
                      color2: Color.fromARGB(255, 190, 95, 18),
                      text: 'Daily Commission',
                      text2: 'Rs ${dataList.isEmpty ? "0" : rider}',
                    ),
                    DashbordCard2(
                      data: dataList,
                      color: Color.fromARGB(255, 145, 27, 57),
                      color2: Color.fromARGB(255, 129, 40, 5),
                      text: 'Pending Commission',
                      text2: 'Rs ${dataList.isEmpty ? "0" : pending}',
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Finance Summery",
                      style: TextStyle(
                          fontFamily: '',
                          fontSize: 14.sp,
                          color: black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Column(
                  children: [
                    HomeCard(
                        color: Color.fromARGB(255, 141, 101, 42),
                        icon: Icons.account_balance,
                        text: 'Bank Amount',
                        text2: dataList.isEmpty ? '0' : "RS ${bankAmount}"),
                    HomeCard(
                        color: Color(0xff5049bd),
                        icon: Icons.account_balance_wallet_outlined,
                        text: 'Cash Outstanding',
                        text2: dataList.isEmpty
                            ? '0'
                            : "RS ${dataList.isEmpty ? "0" : cashOutstanding.toString()}"),
                    HomeCard(
                      color: Color(0xffdc1431),
                      icon: Icons.account_tree_outlined,
                      text: 'Total Outstanding',
                      text2: dataList.isEmpty ? '0' : "RS ${totalOutstanding}",
                    ),
                    HomeCard(
                        color: Color(0xff57c298),
                        icon: Icons.deblur,
                        text: 'Partial Delivered',
                        text2: dataList.isEmpty
                            ? '0'
                            : 'RS ${dataList.isEmpty ? "0" : dataList[0]['to_branch'].toString()}'),
                    SizedBox(
                      height: 4,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          "Monthly Performance",
                          style: TextStyle(
                              fontFamily: '',
                              fontSize: 14.sp,
                              color: black,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                dataList.isEmpty
                    ? loader()
                    : Chart(
                        nextDay: dataList[0]['next_delivery'],
                        data: dataList,
                        commission: dataList[0]['monthly_com'],
                        delivered: dataList[0]['total_delivery'],
                        oders: dataList[0]['total_orders'],
                        bankAmount: bankAmount,
                      ),
                SizedBox(
                  height: 90,
                ),
              ]),
            ),
            isLoading
                ? Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: Loader().loader(context))
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget loader() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: SizedBox(
        height: 20,
        width: 20,
        child: LoadingAnimationWidget.threeArchedCircle(
          color: Color.fromARGB(255, 153, 166, 177),
          size: 30,
        ),
      ),
    );
  }

  data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('user_id');
    bool serviceEnabled;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    var status = Provider.of<ProviderS>(context, listen: false).permission;

    if (Provider.of<ProviderS>(context, listen: false).isUpdtatLocation ==
        false) {
      if (serviceEnabled == false &&
          Provider.of<ProviderS>(context, listen: false).isUpdtatLocation ==
              false) {
        userLoaction().diloag(context);
      } else {
        if (status.isDenied) {
          userLoaction().diloag(context);
        } else if (status.isGranted) {
          Provider.of<ProviderS>(context, listen: false).location = true;
          position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          if (!mounted) return;
          Future.delayed(const Duration(milliseconds: 200), () async {
            setState(() {
              position;
            });
            CustomApi().userLocation(id.toString(),
                position!.latitude.toString(), position!.longitude.toString());
          });

          Provider.of<ProviderS>(context, listen: false).location = false;
        } else if (status.isPermanentlyDenied) {
          userLoaction().diloag(context);
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }
}
