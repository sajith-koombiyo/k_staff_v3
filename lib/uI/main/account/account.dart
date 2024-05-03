import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/uI/login_and_signup/login.dart';
import 'package:flutter_application_2/uI/widget/diloag_button.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import '../../../class/class.dart';
import '../../widget/account_widegt/text_container.dart';
import '../../widget/home_screen_widget/home_button.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Consumer<ProviderS>(
      builder: (context, provider, child) => Scaffold(
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 100),
          child: RippleAnimation(
            repeat: true,
            color: appliteBlue2,
            // color: Color(Provider.of<ColorProvider>(context, listen: false).appColor),
            minRadius: 30,
            ripplesCount: 1,
            child: FloatingActionButton(
              shape: CircleBorder(),
              backgroundColor: Color.fromARGB(255, 49, 156, 234),
              child: Icon(
                Icons.add,
                color: white,
              ),
              onPressed: () {
                CustomDialog().numberUpdate(context, 'sss');
                // editNumber();
              },
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 122, 209, 231),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: h,
                width: w,
              ),
              Positioned(
                top: h / 4,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 100, sigmaY: 6),
                    child: Container(
                      height: h,
                      width: w,
                      decoration: BoxDecoration(
                          color: white.withOpacity(0.6),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60))),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  provider.userData.isEmpty
                                      ? '-'
                                      : provider.userData[0]['staff_name'],
                                  style: TextStyle(
                                    fontSize: 18.dp,
                                    color: black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Address',
                                style: TextStyle(
                                  fontSize: 14.dp,
                                  color: black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextContainer(
                                text: provider.userData.isEmpty
                                    ? '-'
                                    : provider.userData[0]['address'],
                              ),
                              Text(
                                'Phone',
                                style: TextStyle(
                                  fontSize: 14.dp,
                                  color: black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextContainer(
                                text: provider.userData.isEmpty
                                    ? '-'
                                    : provider.userData[0]['phone'],
                              ),
                              Text(
                                'NIC',
                                style: TextStyle(
                                  fontSize: 14.dp,
                                  color: black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextContainer(
                                text: provider.userData.isEmpty
                                    ? '-'
                                    : provider.userData[0]['nic'],
                              ),
                              Text(
                                'Branch',
                                style: TextStyle(
                                  fontSize: 14.dp,
                                  color: black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextContainer(
                                text: provider.userData.isEmpty
                                    ? '-'
                                    : provider.userData[0]['dname'],
                              ),
                              Text(
                                'Deposit Code',
                                style: TextStyle(
                                  fontSize: 14.dp,
                                  color: black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextContainer(
                                text: provider.userData.isEmpty
                                    ? '-'
                                    : "${provider.dpCode}",
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: HomeButton(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Login()));
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => Login(),
                                    //     ));
                                    // CustomDialog().Warning(
                                    //     context,
                                    //     'Dou you want to log out',
                                    //     'Dou You want Exit ', () {
                                    //   Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder: (context) => Login(),
                                    //       ));

                                    // });
                                  },
                                  text: 'LOGOUT',
                                ),
                              ),
                              SizedBox(
                                height: 300,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: h / 3,
                    child: Lottie.asset('assets/default_user.json',
                        fit: BoxFit.fitHeight),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  editNumber() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close))),
          Text(
            'Change Phone Number',
            style: TextStyle(
              fontSize: 18.dp,
              color: black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'enter new phone number and admin will update it',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.dp,
              color: black1,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(
                hintText: 'type here',
                focusedBorder: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(),
                prefixIcon: Icon(Icons.call),
                fillColor: white3,
                filled: true),
          ),
          SizedBox(
            height: 20,
          ),
          DialogButton(
              text: 'Send Update request',
              onTap: () {},
              buttonHeight: h / 18,
              width: w,
              color: Color.fromARGB(255, 26, 123, 203)),
        ]),
      ),
    );
  }
}
