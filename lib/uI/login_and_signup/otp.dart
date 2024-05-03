import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/uI/widget/main_button.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import 'package:telephony/telephony.dart';
import '../../app_details/color.dart';
import '../../class/class.dart';

class OTP extends StatefulWidget {
  const OTP({super.key, required this.userId, required this.userName});
  final String userId;
  final String userName;

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  OtpFieldController otpController = OtpFieldController();
  bool isVisible = false;
  bool isLoading = false;
  String sms = "";
  String body = '';
  String msg = '';
  String otp = '';
  Telephony telephony = Telephony.instance;
  @override
  void initState() {
    if (Platform.isAndroid) {
      telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          setState(() {
            body = message.address.toString();
            msg = message.body.toString();
          }); //+977981******67, sender nubmer

          setState(() {
            if (body == 'Koombiyo') {
              otpController.set([
                message.body![0],
                message.body![1],
                message.body![2],
                message.body![3],
                message.body![4],
                message.body![5],
                message.body![6]
              ]);

              otpController;
            }
          });
        },
        listenInBackground: false,
      );
      // Android-specific code
    } else if (Platform.isIOS) {
      // iOS-specific code
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              SizedBox(
                  height: h,
                  width: w,
                  child: Image.asset(
                    'assets/qa.PNG',
                    color: black.withOpacity(0.9),
                    colorBlendMode: BlendMode.darken,
                    fit: BoxFit.cover,
                  )),
              Positioned(
                top: 0,
                bottom: 0,
                child: SizedBox(
                  height: h,
                  width: w,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 0),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                color: white.withOpacity(0.2),
                                width: w,
                                child: Column(
                                  children: [
                                    Text(
                                      'Enter OTP',
                                      style: TextStyle(
                                          fontSize: 32.dp,
                                          color: white1,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Inter'),
                                    ),
                                    Text(
                                      "We have send the  code verification to \nYour Mobile Number",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14.dp,
                                          color: white2,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Inter'),
                                    ),
                                    SizedBox(
                                        height: h / 4,
                                        child: Lottie.asset(
                                            'assets/enter_otp.json')),
                                    Center(
                                      child: OTPTextField(
                                          otpFieldStyle: OtpFieldStyle(
                                              borderColor: white,
                                              disabledBorderColor: white,
                                              enabledBorderColor: white,
                                              focusBorderColor: white,
                                              backgroundColor: Color.fromARGB(
                                                  255, 109, 106, 106)),
                                          controller: otpController,
                                          length: 7,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          textFieldAlignment:
                                              MainAxisAlignment.spaceAround,
                                          fieldWidth: 40,
                                          fieldStyle: FieldStyle.box,
                                          outlineBorderRadius: 15,
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Color.fromARGB(
                                                  255, 241, 142, 13)),
                                          onChanged: (pin) async {
                                            otp = pin.characters.toString();
                                            // setState(() {
                                            //   isLoading = true;
                                            // });
                                            // if (msg.isEmpty) {
                                            //   await CustomApi().setOtp(
                                            //       otp, widget.userId, context);
                                            //   setState(() {
                                            //     isLoading = false;
                                            //   });
                                            // }
                                          },
                                          onCompleted: (pin) async {
                                            if (msg.isNotEmpty) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              await CustomApi().setOtp(
                                                  pin, widget.userId, context);
                                              setState(() {
                                                isLoading = false;
                                              });
                                            }
                                          }),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Don't receve the OTP?",
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: white,
                                              fontSize: 14.sp,
                                            )),
                                        TextButton(
                                          onPressed: () async {
                                            setState(() {
                                              isLoading = true;
                                            });

                                            await CustomApi().login(
                                                widget.userName, context);
                                            setState(() {
                                              isLoading = false;
                                            });
                                          },
                                          child: Text('RESEND OTP',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: lightblue,
                                                fontSize: 14.sp,
                                              )),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    isVisible == false
                                        ? MainButton(
                                            buttonHeight: h / 15,
                                            width: w,
                                            onTap: () async {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              await CustomApi().setOtp(
                                                  otp.toString(),
                                                  widget.userId,
                                                  context);
                                              setState(() {
                                                isLoading = false;
                                              });
                                            },
                                            text: 'LOGIN')
                                        : Container(
                                            padding: EdgeInsets.all(4),
                                            alignment: Alignment.center,
                                            height: h / 13,
                                            width: w,
                                            decoration: BoxDecoration(
                                              color: appliteBlue,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              // gradient: LinearGradient(colors: [appBlue, Color.fromARGB(31, 35, 38, 238)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                                            ),
                                            child: Stack(
                                              children: [
                                                Center(
                                                  child: Text("Login",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: white,
                                                        fontSize: 22.sp,
                                                      )),
                                                ),
                                                Center(
                                                  child: LoadingAnimationWidget
                                                      .fourRotatingDots(
                                                    color: Colors.white,
                                                    size: 90,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
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
    );
  }

  // listenOTP() async {
  //   await SmsAutoFill().listenForCode();
  // }
}
