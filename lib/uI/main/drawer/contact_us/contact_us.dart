import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app_details/color.dart';
import '../../../widget/diloag_button.dart';
import '../../../widget/textField.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController userName = TextEditingController();
  OverlayPortalController overlayControlle = OverlayPortalController();
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: backgroundColor2,
      appBar: AppBar(
        backgroundColor: appliteBlue,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: white,
            )),
        title: Text(
          'Contact Us',
          style: TextStyle(
            fontSize: 18.dp,
            color: white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Get in touch',
              style: TextStyle(
                  fontSize: 18.dp, fontWeight: FontWeight.bold, color: black),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Use our contact form for all information requests or contact us directly using the contact information below.\n\nFeel free to get in touch with us via email or phone Our Office Location',
              style: TextStyle(
                  fontSize: 12.dp, fontWeight: FontWeight.normal, color: black),
            ),
            Divider(),
            SizedBox(
              height: 12,
            ),
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.black12,
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   padding: EdgeInsets.all(20),
            //   width: w,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            // //       Text(
            // //         'Contact Us',
            // //         style: TextStyle(
            // //             fontSize: 18.dp,
            // //             fontWeight: FontWeight.bold,
            // //             color: black),
            // //       ),
            // //       SizedBox(
            // //         height: 12,
            // //       ),
            // //       SizedBox(
            // //         width: w,
            // //         height: h / 17,
            // //         child: CustomTextField(
            // //             icon: Icons.person_2_outlined,
            // //             controller: userName,
            // //             text: 'name'),
            // //       ),
            // //       SizedBox(
            // //         height: 12,
            // //       ),
            // //       SizedBox(
            // //         width: w,
            // //         height: h / 17,
            // //         child: CustomTextField(
            // //             icon: Icons.email_outlined,
            // //             controller: userName,
            // //             text: 'email'),
            // //       ),
            // //       SizedBox(
            // //         height: 12,
            // //       ),
            // //       SizedBox(
            // //         width: w,
            // //         child: TextFormField(
            // //           maxLines: 6,
            // //           minLines: 6,
            // //           style: TextStyle(color: black, fontSize: 13.dp),
            // //           validator: (value) {},
            // //           decoration: InputDecoration(
            // //             contentPadding:
            // //                 EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            // //             border: OutlineInputBorder(
            // //               borderRadius: BorderRadius.circular(10.0),
            // //             ),
            // //             enabledBorder: OutlineInputBorder(
            // //               borderSide: BorderSide(
            // //                 color: white.withOpacity(0.2),
            // //               ),
            // //               borderRadius: BorderRadius.circular(10),
            // //             ),
            // //             filled: true,
            // //             hintStyle: TextStyle(fontSize: 13.dp, color: black1),
            // //             hintText: 'Type here',
            // //             fillColor: white.withOpacity(0.3),
            // //           ),
            // //         ),
            // //       ),
            // //       SizedBox(
            // //         height: 20,
            // //       ),
            // //       DialogButton(
            // //         buttonHeight: h / 14,
            // //         color: appButtonColorLite,
            // //         onTap: () {},
            // //         text: 'SEND',
            // //         width: w,
            // //       ),
            // //       SizedBox(
            // //         height: 20,
            // //       ),
            // //     ],
            // //   ),
            // // ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                MapUtils.openMap(6.888623, 79.900913);
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    SizedBox(
                      width: w / 5,
                      child: Icon(
                        Icons.pin_drop,
                        color: Colors.green,
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Our Office Location',
                            style: TextStyle(
                                fontSize: 14.dp,
                                fontWeight: FontWeight.bold,
                                color: black),
                          ),
                          Text(
                            'NO. 25,EPITAMULLA ROAD,KOTTE,SRI LANKA.',
                            style: TextStyle(
                                fontSize: 12.dp,
                                fontWeight: FontWeight.normal,
                                color: black1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () async {
                final call = Uri.parse('tel:+94 11 7886786');
                if (await canLaunchUrl(call)) {
                  launchUrl(call);
                } else {
                  throw 'Could not launch $call';
                }
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12)),
                child: Row(
                  children: [
                    SizedBox(
                      width: w / 5,
                      child: Icon(
                        Icons.call,
                        color: appButtonColorLite,
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Phone (Landline)',
                            style: TextStyle(
                                fontSize: 14.dp,
                                fontWeight: FontWeight.bold,
                                color: black),
                          ),
                          Text(
                            '+94 11 7886786',
                            style: TextStyle(
                                fontSize: 12.dp,
                                fontWeight: FontWeight.normal,
                                color: black1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () async {
                // #docregion encode-query-parameters
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'smith@example.com',
                );

                launchUrl(emailLaunchUri);
                // #enddocregion encode-query-parameters
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12)),
                child: Row(
                  children: [
                    SizedBox(
                      width: w / 5,
                      child: Icon(
                        Icons.mail,
                        color: Colors.red,
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(
                                fontSize: 14.dp,
                                fontWeight: FontWeight.bold,
                                color: black),
                          ),
                          Text(
                            'sales@koombiyodelivery.com',
                            style: TextStyle(
                                fontSize: 12.dp,
                                fontWeight: FontWeight.normal,
                                color: black1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            // InkWell(
            //   borderRadius: BorderRadius.circular(10),
            //   onTap: () async {
            //     // #docregion encode-query-parameters
            //     launchWhatsapp();
            //     // #enddocregion encode-query-parameters
            //   },
            //   child: Container(
            //     padding: EdgeInsets.all(12),
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10),
            //         border: Border.all(color: Colors.black12)),
            //     child: Row(
            //       children: [
            //         SizedBox(
            //           width: w / 5,
            //           child: Icon(
            //             Icons.wechat_outlined,
            //             color: Color.fromARGB(255, 5, 130, 51),
            //           ),
            //         ),
            //         Flexible(
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 'Whatsapp',
            //                 style: TextStyle(
            //                     fontSize: 14.dp,
            //                     fontWeight: FontWeight.bold,
            //                     color: black),
            //               ),
            //               Text(
            //                 '0771413514',
            //                 style: TextStyle(
            //                     fontSize: 12.dp,
            //                     fontWeight: FontWeight.normal,
            //                     color: black1),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 12,
            ),
          ]),
        ),
      ),
    );
  }

  launchWhatsapp() async {
    final url = "https://wa.me/+94771413514?text=Hello";

//do not forgot to enter your country code instead of 91 and instead of XXXXXXXXXX enter phone number.

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }

  whatsapp() async {
    var contact = "+94771413514";
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    var iosUrl =
        "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }
}

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
