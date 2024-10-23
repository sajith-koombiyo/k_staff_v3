import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';

import '../../app_details/color.dart';
import '../widget/main_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;

  @override
  void initState() {
    //st initState
    super.initState();
  }

  bool isVisible = true;
  TextEditingController userNameController = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false, // prevent back
      onPopInvoked: (pop) async {
        // Info().logOut(context);

        // This can be async and you can check your condition
      },
      child: AbsorbPointer(
        absorbing: isLoading,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                SizedBox(
                    height: h,
                    width: w,
                    child: Image.asset(
                      'assets/qa.PNG',
                      fit: BoxFit.cover,
                    )),
                Container(
                  height: h,
                  width: w,
                  color: black.withOpacity(0.9),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  child: SizedBox(
                    height: h,
                    width: w,
                    child: AnimationLimiter(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 0),
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  color: white.withOpacity(0.2),
                                  width: w,
                                  height: h / 1.45,
                                  child: Column(
                                    children:
                                        AnimationConfiguration.toStaggeredList(
                                      duration:
                                          const Duration(milliseconds: 375),
                                      childAnimationBuilder: (widget) =>
                                          SlideAnimation(
                                        horizontalOffset: 50.0,
                                        child: FadeInAnimation(
                                          child: widget,
                                        ),
                                      ),
                                      children: [
                                        Text(
                                          'Login',
                                          style: TextStyle(
                                              fontSize: 32.dp,
                                              color: white1,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Inter'),
                                        ),
                                        Text(
                                          'Please Login With Your Username',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14.dp,
                                              color: white2,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'Inter'),
                                        ),
                                        SizedBox(
                                            height: h / 3.5,
                                            child: Lottie.asset(
                                                'assets/login_screen.json')),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          height: h / 15,
                                          child: TextFormField(
                                            onFieldSubmitted: (value) async {
                                              setState(() {
                                                isLoading = true;
                                              });

                                              await CustomApi().login(
                                                  userNameController.text,
                                                  context);
                                              setState(() {
                                                isLoading = false;
                                              });
                                            },
                                            controller: userNameController,
                                            style: TextStyle(
                                                color: black, fontSize: 13.sp),
                                            validator: (value) {},
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.person),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.black12,
                                                  // color: pink.withOpacity(0.1),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              filled: true,
                                              hintStyle:
                                                  TextStyle(fontSize: 13.dp),
                                              hintText: 'Enter Your Username',
                                              fillColor: white.withOpacity(0.3),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        MainButton(
                                          buttonHeight: h / 15,
                                          width: w,
                                          onTap: () async {
                                            setState(() {
                                              isLoading = true;
                                            });

                                            await CustomApi().login(
                                                userNameController.text,
                                                context);
                                            setState(() {
                                              isLoading = false;
                                            });
                                            // final signCode = await SmsAutoFill()
                                            //     .getAppSignature;

                                            // Navigator.push(context, MaterialPageRoute(builder: (context) => NavigationScreen()));
                                          },
                                          text: 'Request OTP',
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
                isLoading
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
        ),
      ),
    );
  }
}
