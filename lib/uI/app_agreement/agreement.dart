import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../login_and_signup/login.dart';

class Condition extends StatefulWidget {
  Condition({super.key});

  @override
  State<Condition> createState() => _ConditionState();
}

class _ConditionState extends State<Condition> {
  ScrollController _scrollController = ScrollController();
  bool check = false;
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Agreement'),
      ),
      persistentFooterAlignment: AlignmentDirectional.bottomCenter,
      persistentFooterButtons: [
        check
            ? InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Accept',
                    style: TextStyle(color: white),
                  ),
                  width: w / 2.5,
                  height: h / 16,
                  decoration: BoxDecoration(
                      color: appButtonColorLite,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all()),
                ),
              )
            : SizedBox()
      ],
      // appBar: FadableAppBar(
      //   title: const Text('Terms And Conditions'),
      //   centerTitle: true,
      //   foregroundColorOnFaded: black,
      //   foregroundColor: white,
      //   backgroundColor: appliteBlue,
      //   scrollController: _scrollController,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Scrollbar(
          trackVisibility: true,
          thumbVisibility: true,
          thickness: 7,
          radius: Radius.circular(5),
          interactive: true,
          child: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    pdfText,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: black2,
                        fontSize: 12.dp,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    checkColor: white,
                    value: check,
                    onChanged: (value) {
                      setState(() {
                        check = value!;
                      });
                    },
                  ),
                  Text(
                    "I've read all terms and Conditions",
                    style: TextStyle(color: appButtonColorLite),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  String pdfText = """
Welcome to Koombiyo Delivery! Before you proceed to download and use our mobile application, please read and agree to the following User Agreement. By using the Koombiyo Delivery app, you acknowledge that you have read, understood, and consented to the terms outlined below.

1. Introduction 

  1.1. Koombiyo Delivery (hereinafter referred to as "the App") is a product of Koombiyo Delivery (pvt) LTD, and its affiliates (hereinafter collectively referred to as "we," "our," or "us").

2. App Description 

  2.1. Koombiyo Delivery is a delivery service application that enables Delivery Agents to receive and update order through company. 
  2.2. The App allows access to certain features and functions, subject to the permissions granted by the user.

3. User Permissions 

  3.1. The App requests the following permissions to function properly:
  3.1.1. Geo-Location
    •	Purpose: To provide location-based services, such as finding end delivery location and displaying best direction.
    •	Use: We may collect and use your device's location data in real-time during app usage.
  3.1.2. File Access
      •	Purpose: To access files stored on your device necessary for smooth app functionality.
      •	Use: We may request access to your device's files to store relevant app data and ensure efficient app performance.
  3.1.3. Camera Access
      •	Purpose: To facilitate image-related features, such as capturing images for verification purposes.
      •	Use: We may request permission to access your device's camera to enable scanning, capturing images, or taking photos.

4. Data Privacy and Security 

  4.1. Your privacy and data security are of utmost importance to us. We collect, store, and process personal data as outlined in our Privacy Policy, which can be accessed through the App. 
  4.2. We use appropriate security measures to safeguard your data, but we cannot guarantee absolute security. By using the App, you acknowledge and accept any potential risks associated with data transmission over the internet.

5. App Usage Guidelines 

  5.1. You agree not to misuse the App, including but not limited to unauthorized access, interference, or distribution of harmful content. 
  5.2. You are solely responsible for any activity conducted through your account.

6. Changes to the User Agreement 

  6.1. We reserve the right to modify, amend, or update this User Agreement at any time. 
  6.2. Any changes made will be communicated to users through the App or other appropriate means. 
  6.3. Continued use of the App after such modifications constitutes acceptance of the revised User Agreement.

7. Termination 

  7.1. We may terminate your access to the App for violation of this User Agreement or any other reason deemed necessary.
  7.2. Upon termination, you must cease using the App and uninstall it from your device.

8. Governing Law 

  8.1. This User Agreement shall be governed by and construed in accordance with the laws of Sri Lanka, without regard to its conflict of laws principles.

9. Contact Information 

  9.1. For any questions, concerns, or feedback regarding this User Agreement or the App, please contact us at system@koombiyodelivery.com.
  
By installing and using Koombiyo Delivery, you agree to abide by the terms and conditions of this User Agreement. If you do not agree to these terms, please refrain from using the App.

.
""";
}
