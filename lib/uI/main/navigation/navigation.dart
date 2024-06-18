import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/class/location.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/uI/widget/diloag_button.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import '../../../api/api.dart';
import '../../../app_details/color.dart';
import '../../../app_details/const.dart';
import '../../../app_details/size.dart';
import '../../home.dart';
import '../../login_and_signup/login.dart';
import '../../widget/tips_button.dart';
import '../account/account.dart';
import '../drawer/drawer.dart';
import '../drawer/my_deposit/my_deposite.dart';
import '../map/map.dart';
import '../notification/notification.dart';
import 'package:badges/badges.dart' as badges;

class NavigationScreen extends StatefulWidget {
  const NavigationScreen(
      {super.key, required this.staffId, required this.userId});
  final String userId;
  final String staffId;

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

Position? position;

class _NavigationScreenState extends State<NavigationScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController animationController;
  late Animation<double> animation;
  var selectval;
  List listitems = [
    'All',
    'Gampaha',
    'Nittmbuwa',
    'Colombo',
    'Nugegoda',
  ];
  bool tap = false;
  bool button2 = false;
  bool button3 = false;
  bool button4 = false;
  bool button1 = true;
  bool page = false;
  int x = 0;
  int _selectedIndex = 0;
  bool iconSize1 = false;
  bool iconSize2 = false;
  bool iconSize3 = false;
  List dataList = [];
  bool isLoading = false;
  bool locationUpdate = false;
  String bId = '';
  String uId = '';
  String dpCode = '';
  List youTube = [];
  int backTime = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List iconList = [Icons.abc, Icons.abc, Icons.abc];
  String count = '';
  final Geolocator _geolocator = Geolocator();
  static List<Widget> _pages = <Widget>[
    Home(),
    MapScreen(),
    MyDeposit(),
    Account()
    // MyWidget()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      log(_selectedIndex.toString());
    });
  }

  @override
  void initState() {
    // onUserLogin();
    notificationCount();
    data();
    super.initState();

    _controller = AnimationController(
      duration: Duration(microseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 1.0,
      end: 0.7,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.repeat(
      reverse: true,
      period: Duration(milliseconds: 500),
    );
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );
    if (animationController.status == AnimationStatus.forward ||
        animationController.status == AnimationStatus.completed) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  getData() async {
    var list = await CustomApi().getProfile();
    return list;
  }

  back() {
    setState(() {
      backTime += 1;
    });
    showAlertDialog(BuildContext context) {
      // set up the button
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {},
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("My title"),
        content: Text("This is my message."),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  notificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var res = await prefs.get(
      'userActive',
    );
    var userKey = await prefs.get(
      'userkey',
    );

    var userId = await prefs.get(
      'userId',
    );

    String userAcoontId = userKey.toString();
    String userActive = res.toString();

    List _ids = [];
    setState(() {
      if (userActive == '1') {
        page = true;
      } else {
        page = false;
      }
      isLoading = true;
    });
    var temp = await CustomApi().notificationCount(userKey.toString());
    count = temp;
    Provider.of<ProviderS>(context, listen: false).noteCount = temp;
    var data = await CustomApi().getProfile();
    var id = data[0]['user_id'].toString();
    var deposit = await CustomApi().getMyDeposit(context);
    Provider.of<ProviderS>(context, listen: false).userData = data;
    Provider.of<ProviderS>(context, listen: false).deposit = deposit;

    var branchId = data[0]['branch_id'].toString();
    if (branchId.length == 1) {
      branchId = "00" + branchId;
    } else if (branchId.length == 2) {
      branchId = "0" + branchId;
    }
    var bId = id.toString();
    if (bId.length == 1) {
      bId = "0000" + bId;
    } else if (bId.length == 2) {
      bId = "000" + bId;
    } else if (bId.length == 3) {
      bId = "00" + bId;
    } else if (bId.length == 4) {
      bId = "0" + bId;
    }
    Provider.of<ProviderS>(context, listen: false).dpCode = branchId + bId;
    Provider.of<ProviderS>(context, listen: false).bId = branchId;
    setState(() {
      isLoading = false;
    });
    var ytc = await CustomApi().getYoutubeDetails(context);
    setState(() {
      youTube = ytc;
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var p = MediaQuery.paddingOf(context).top;
    return AbsorbPointer(
      absorbing: isLoading,
      child: PopScope(
        canPop: false, // prevent back
        onPopInvoked: (pop) async {
          // Info().logOut(context);
          backTime += 1;
          if (backTime == 2) {
            CustomDialog().appExit(
                context, 'Do you want to Exit the app', 'Dou You want Exit ',
                () {
              exit(0);
            });
          }
          Future.delayed(Duration(milliseconds: 600))
              .then((value) => backTime = 0);
        },
        child: Consumer<ProviderS>(
          builder: (context, provider, child) => Scaffold(
              appBar: AppBar(
                title: Text(
                  _selectedIndex == 2 ? 'My Deposit' : '',
                  style: TextStyle(
                    fontSize: 18.dp,
                    color: white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                leadingWidth: 44,
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarIconBrightness:
                        _selectedIndex == 1 || _selectedIndex == 3
                            ? Brightness.dark
                            : Brightness.light,
                    statusBarColor: Colors.transparent),
                leading: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CircleAvatar(
                    backgroundColor: black.withOpacity(0.4),
                    child: IconButton(
                        color: Color.fromARGB(255, 18, 16, 154),
                        onPressed: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                        icon: Icon(
                          Icons.menu,
                          color: white,
                        )),
                  ),
                ),
                actions: [
                  _selectedIndex == 1 && provider.isAppbarsheerOpen
                      ? IconButton(
                          onPressed: () async {
                            MapUtils.openMap(
                                provider.mapDLat, provider.mapDLong);
                          },
                          icon: SizedBox(
                            height: 40,
                            child: Image.asset(
                                'assets/icons8-google-maps-old-48.png'),
                          ))
                      : SizedBox(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: black.withOpacity(0.4),
                      child: IconButton(
                          color: white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.leftToRight,
                                  duration: Duration(milliseconds: 600),
                                  child:
                                      NotificationScreen(userId: widget.userId),
                                  inheritTheme: true,
                                  ctx: context),
                            );
                          },
                          icon: provider.noteCount == '0'
                              ? Icon(Icons.notification_important)
                              : badges.Badge(
                                  badgeContent: Text(
                                    provider.noteCount,
                                    style: TextStyle(fontSize: 9, color: white),
                                  ),
                                  child: Icon(Icons.notification_important),
                                )),
                    ),
                  ),
                  _selectedIndex == 1 && provider.isAppbarsheerOpen
                      ? PopupMenuButton<int>(
                          iconColor: white,
                          itemBuilder: (context) => [
                            // popupmenu item 1
                            PopupMenuItem(
                              onTap: () {
                                cancelButton();
                              },
                              value: 1,
                              // row has two child icon and text.
                              child: Row(
                                children: [
                                  Icon(Icons.star),
                                  SizedBox(
                                    // sized box with width 10
                                    width: 10,
                                  ),
                                  Text("Cancel pickup")
                                ],
                              ),
                            ),
                            // popupmenu item 2
                            PopupMenuItem(
                              value: 2,
                              // row has two child icon and text
                              child: Row(
                                children: [
                                  Icon(Icons.chrome_reader_mode),
                                  SizedBox(
                                    // sized box with width 10
                                    width: 10,
                                  ),
                                  Text("About")
                                ],
                              ),
                            ),
                          ],
                          offset: Offset(0, 70),
                          color: Colors.grey,
                          elevation: 2,
                        )
                      : SizedBox(),
                ],
              ),
              extendBodyBehindAppBar: true,
              key: _scaffoldKey,
              drawer: customDrawer(skey: _scaffoldKey, ytc: youTube),
              extendBody: true,
              bottomNavigationBar: page
                  ? CurvedNavigationBar(
                      buttonBackgroundColor: Color.fromARGB(255, 192, 240, 247),
                      backgroundColor: appliteBlue,
                      color: const Color.fromARGB(255, 211, 235, 255),
                      items: [
                        CurvedNavigationBarItem(
                          child: Icon(Icons.home_outlined),
                          label: 'Home',
                        ),
                        CurvedNavigationBarItem(
                          child: Icon(Icons.pin_drop_outlined),
                          label: 'Map',
                        ),
                        CurvedNavigationBarItem(
                          child: Icon(Icons.newspaper),
                          label: 'My Deposit',
                        ),
                        CurvedNavigationBarItem(
                          child: Icon(Icons.perm_identity),
                          label: 'Acount',
                        ),
                      ],
                      onTap: (index) {
                        _onItemTapped(index);

                        // Handle button tap
                      },
                    )
                  : SizedBox(),
              body: SizedBox(
                // height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/qa.PNG',
                      width: AppSize().width(context),
                      height: AppSize().height(context),
                      fit: BoxFit.cover,
                    ),
                    Container(
                      width: AppSize().width(context),
                      height: AppSize().height(context),
                      color: black.withOpacity(0.9),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: _pages.elementAt(_selectedIndex), //New
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 4,
                          left: 8,
                          right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [],
                      ),
                    ),
                    page
                        ? SizedBox()
                        : Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: CurvedNavigationBar(
                              buttonBackgroundColor:
                                  Color.fromARGB(255, 192, 240, 247),
                              backgroundColor: appliteBlue,
                              color: const Color.fromARGB(255, 211, 235, 255),
                              items: [
                                CurvedNavigationBarItem(
                                  child: Icon(Icons.home_outlined),
                                  label: 'Home',
                                ),
                                CurvedNavigationBarItem(
                                  child: Icon(Icons.pin_drop_outlined),
                                  label: 'Map',
                                ),
                                CurvedNavigationBarItem(
                                  child: Icon(Icons.newspaper),
                                  label: 'My Deposit',
                                ),
                                CurvedNavigationBarItem(
                                  child: Icon(Icons.perm_identity),
                                  label: 'Acount',
                                ),
                              ],
                              onTap: (index) {
                                _onItemTapped(index);

                                // Handle button tap
                              },
                            ),
                          ),
                    page
                        ? Container()
                        : Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: CircularRevealAnimation(
                              centerAlignment: x == 0
                                  ? Alignment(-0.4, 0.9)
                                  : x == 1
                                      ? Alignment(-0.2, 0.9)
                                      : x == 2
                                          ? Alignment(0.20, 0.9)
                                          : Alignment(0.80, 0.9),
                              animation: animation,
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: w,
                                  height: h,
                                  alignment: Alignment.bottomLeft,
                                  color: Colors.black.withOpacity(0.75),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25, bottom: 100),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 113, 130, 147)
                                                .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.all(10),
                                      width: w / 1.1,
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Tips",
                                              style: TextStyle(
                                                  fontSize: 17.sp,
                                                  color: white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: h / 65,
                                            ),
                                            Text(
                                              x == 0
                                                  ? "Home screen for the dashboard view\nand account summary ."
                                                  : x == 1
                                                      ? "Map screen - Showing all the rider pickups \nand deliveries "
                                                      : x == 2
                                                          ? "My Deposit Screen - bank deposit history of the rider."
                                                          : "Account Screen, your personnel profile details",
                                              style: TextStyle(
                                                  fontSize: 11.sp,
                                                  color: white,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            SizedBox(
                                              height: h / 85,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                if (animationController
                                                            .status ==
                                                        AnimationStatus
                                                            .forward ||
                                                    animationController
                                                            .status ==
                                                        AnimationStatus
                                                            .completed) {
                                                  animationController
                                                      .reverse()
                                                      .then((value) =>
                                                          animationController
                                                              .forward());
                                                } else {
                                                  animationController
                                                      .forward()
                                                      .then((value) =>
                                                          animationController
                                                              .reverse());
                                                }

                                                x = x + 1;
                                                print(x);

                                                if (x == 1) {
                                                  setState(() {
                                                    button2 = true;
                                                    button1 = false;
                                                    button3 = false;
                                                  });
                                                }
                                                if (x == 2) {
                                                  setState(() {
                                                    button2 = false;
                                                    button3 = true;
                                                    button1 = false;
                                                  });
                                                }
                                                if (x == 3) {
                                                  setState(() {
                                                    button2 = false;
                                                    button3 = false;
                                                    button4 = true;
                                                  });
                                                }
                                                if (x == 4) {
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();

                                                  await prefs.setInt(
                                                      'userActive', 1);
                                                  _controller.dispose();
                                                  setState(() {
                                                    button4 = false;
                                                    page = true;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "UNDERSTAND",
                                                  style: TextStyle(
                                                      fontSize: 13.sp,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                height: h / 15,
                                                width: w / 2.3,
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    page
                        ? Container()
                        : Positioned(
                            bottom: 0,
                            left: -20,
                            right: -30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TipButton(
                                  button: button1,
                                  icon: Icons.home_outlined,
                                ),
                                TipButton(
                                  button: button2,
                                  icon: Icons.pin_drop_outlined,
                                  //     ));
                                ),
                                TipButton(
                                  button: button3,
                                  icon: Icons.newspaper,
                                ),
                                TipButton(
                                  button: button4,
                                  icon: Icons.perm_identity,
                                ),
                              ],
                            ),
                          ),
                    isLoading
                        ? Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            top: 0,
                            child: Loader().loader(context))
                        : SizedBox(),
                    provider.isanotherUserLog ? UserLoginCheck() : SizedBox()
                  ],
                ),
              )),
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

            print(position);
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

  cancelButton() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      barrierDismissible: true,
      confirmBtnText: '       Save       ',
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Pickup Cancellation',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Divider(),
          SizedBox(
            height: 12,
          ),
          Card(
            child: Container(
              height: h / 17,
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              // width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                    color: black3, style: BorderStyle.solid, width: 0.80),
              ),
              child: DropdownButton(
                isExpanded: true,
                alignment: AlignmentDirectional.centerEnd,
                hint: Container(
                  alignment: Alignment.centerLeft,
                  //and here
                  child: Text(
                    "Select reason",
                    style: TextStyle(color: black1),
                    textAlign: TextAlign.end,
                  ),
                ),
                value: selectval, //implement initial value or selected value
                onChanged: (value) {
                  setState(() {
                    //set state will update UI and State of your App
                    selectval =
                        value.toString(); //change selectval to new value
                  });
                },
                items: listitems.map((itemone) {
                  return DropdownMenuItem(
                      value: itemone,
                      child: Text(
                        itemone,
                        style: TextStyle(color: black2),
                      ));
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      onConfirmBtnTap: () async {
        if (1 < 5) {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Please input something',
          );
          return;
        }
        Navigator.pop(context);
        await Future.delayed(const Duration(milliseconds: 1000));
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Phone number '' has been saved!.",
        );
      },
    );

//  title: 'Custom',
//  text: 'Custom Widget Alert',
//  leadingImage: 'assets/custom.gif',
  }
// audio call all function are working
  // void onUserLogin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var userId = await prefs.get(
  //     'user_id',
  //   );

  //   ZegoUIKitPrebuiltCallInvitationService().init(
  //     uiConfig: ZegoCallInvitationUIConfig(),
  //     invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
  //       onOutgoingCallCancelButtonPressed: () {
  //         print(
  //             'xxxxxqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxaaaa');
  //       },
  //       onError: (p0) {
  //         print(p0);
  //         print(
  //             'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxaaaa');
  //       },
  //       onOutgoingCallDeclined: (callID, callee, customData) {
  //         Navigator.pop(context);
  //         print(customData);
  //         print(callID);
  //         print(callee);
  //         print(
  //             'xxxxxxxxxxxxxxxxxsssssssssssxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxaaaa');
  //       },

  //       onInvitationUserStateChanged: (value) {
  //         print("$value xxxxxxxxxxxxxxxxxxxxxxxxxaaaaaaaaaaaaaaaa");
  //         if (value[0].state ==
  //             ZegoSignalingPluginInvitationUserState.rejected) {
  //           notification().warning(context, 'rejected');
  //           Navigator.pop(context);
  //         }
  //         if (value[0].state ==
  //             ZegoSignalingPluginInvitationUserState.cancelled) {
  //           notification().warning(context, 'cancelled');
  //           Navigator.pop(context);
  //         }
  //         if (value[0].state ==
  //             ZegoSignalingPluginInvitationUserState.offline) {
  //           notification().warning(context, 'offline');
  //         }
  //         if (value[0].state ==
  //             ZegoSignalingPluginInvitationUserState.timeout) {
  //           notification().warning(context, 'timeout');
  //         }
  //         if (value[0].state == ZegoSignalingPluginInvitationUserState.quited) {
  //           notification().warning(context, 'quited');
  //         }
  //         print(
  //             'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxaaaa');
  //       },
  //       onOutgoingCallTimeout: (callID, callees, isVideoCall) {
  //         Navigator.pop(context);
  //       },
  //       onIncomingCallCanceled: (callID, caller, customData) {
  //         print(
  //             '--------------------------------------------------------------------------------');

  //         if (callID != userId) {}
  //       },
  //       onIncomingCallDeclineButtonPressed: () {
  //         print(
  //             '------ssssssssssssss--------------------------------------------------------------------------');
  //       },

  //       // onOutgoingCallDeclined: (callID, callee, customData) async {
  //       //   // ZegoUIKitPrebuiltCallInvitationService().cancel(callees: [callee]);
  //       //   // await notification().info(context, 'call canceled');
  //       //   // await ZegoCallEndEvent(
  //       //   //     callID: callID,
  //       //   //     reason: ZegoCallEndReason.kickOut,
  //       //   //     isFromMinimizing: true);
  //       //   back2('Call Declined');
  //       // },
  //       onOutgoingCallRejectedCauseBusy: (callID, callee, customData) {
  //         print(
  //             '------------sssssssssssssss--------------------------------------------------------------------');
  //       },
  //     ),
  //     events: ZegoUIKitPrebuiltCallEvents(room: ZegoCallRoomEvents(
  //       onStateChanged: (p0) {
  //         print(p0);
  //         print('ddddddddddddddddddddddddddddddddddddddddddddd');
  //       },
  //     )),
  //     notificationConfig: ZegoCallInvitationNotificationConfig(
  //         androidNotificationConfig: ZegoCallAndroidNotificationConfig(
  //             channelID: "ZegoUIKit",
  //             channelName: "Call Notifications",
  //             sound: "notification",
  //             icon: "appicon",
  //             showFullScreen: true)),
  //     appID: appId /*input your AppID*/,
  //     appSign: signId /*input your AppSign*/,
  //     userID: userId.toString(),
  //     userName: userId.toString(),
  //     plugins: [ZegoUIKitSignalingPlugin()],
  //     requireConfig: (ZegoCallInvitationData data) {
  //       var config = (data.invitees.length > 1)
  //           ? ZegoCallType.videoCall == data.type
  //               ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
  //               : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
  //           : ZegoCallType.videoCall == data.type
  //               ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
  //               : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

  //       // Modify your custom configurations here.
  //       config
  //         ..turnOnCameraWhenJoining = false
  //         ..turnOnMicrophoneWhenJoining = false
  //         ..useSpeakerWhenJoining = true;
  //       config.topMenuBar.isVisible = true;
  //       ZegoUIKitPrebuiltCallInvitationService()
  //         ..innerText.incomingCallPageAcceptButton = "Accept"
  //         ..innerText.incomingCallPageDeclineButton = "Decline";

  //       return config;
  //     },
  //   );
  // }

  back2(String text) async {
    await notification().warning(context, text);
    Navigator.pop(context, true);
  }
}

class userLoaction {
  diloag(BuildContext context) async {
    var status = Provider.of<ProviderS>(context, listen: false).permission;
    return Future.delayed(Duration(seconds: 1)).then((value) => QuickAlert.show(
          disableBackBtn: true,
          context: context,
          type: QuickAlertType.info,
          title: 'Location Update failed',

          titleColor: Colors.blue,
          textColor: Color.fromARGB(255, 38, 129, 36),
          onConfirmBtnTap: () async {
            if (status.isDenied) {
              await Geolocator.openAppSettings();
              Navigator.pop(context);
            } else if (status.isGranted) {
              await Geolocator.openLocationSettings();
              Navigator.pop(context);
            } else if (status.isPermanentlyDenied) {
              await Geolocator.openAppSettings();
            }
            Navigator.pop(context);
          },
          headerBackgroundColor: Colors.green,
          backgroundColor: Color.fromARGB(255, 179, 207, 178),

          // text: 'User Need to update user Location',
          confirmBtnText: '   Settings   ',
          confirmBtnTextStyle:
              TextStyle(fontWeight: FontWeight.normal, color: white),
          widget: Consumer<ProviderS>(
            builder: (context, provider, child) => Stack(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Divider(
                    color: black1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 30,
                          child: Image.asset(
                              'assets/icons8-google-maps-old-30.png')),
                      SizedBox(
                        width: 8,
                      ),
                      Flexible(
                          child: Text(
                        'Please enable location services from your settings to proceed pickups and deliveries',
                        style: TextStyle(
                          color: Color.fromARGB(255, 14, 14, 126),
                        ),
                      ))
                    ],
                  ),
                ]),
                provider.location
                    ? Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        top: 0,
                        child: Loader().loader(context))
                    : SizedBox()
              ],
            ),
          ),
          cancelBtnText: 'No',
          confirmBtnColor: Color.fromARGB(255, 25, 114, 174),
        ));
  }
}

class UserLoginCheck extends StatelessWidget {
  const UserLoginCheck({super.key});

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.transparent,
      height: h,
      width: w,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 2, 26, 63).withOpacity(0.9),
                borderRadius: BorderRadius.circular(25)),
            height: h / 4,
            width: w,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Your user account uses another device. \nPlease log out.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        color: white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DialogButton(
                        text: 'Log out',
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()));
                        },
                        buttonHeight: h / 17,
                        width: w / 2,
                        color: Color.fromARGB(57, 255, 238, 6)),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
