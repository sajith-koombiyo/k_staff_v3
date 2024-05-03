import 'package:flutter/material.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:lottie/lottie.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appliteBlue,
        title: Text(
          'About',
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
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: SizedBox(
          //       child: Image.asset(
          //     'assets/icon.PNG',
          //   )),
          // ),
          Lottie.asset('assets/about_us_image.json'),
          Container(
            padding: EdgeInsets.only(left: 12),
            alignment: Alignment.centerLeft,
            child: Text(
              'Koombiyo Delivery ',
              style: TextStyle(
                fontSize: 18.dp,
                color: Color.fromARGB(255, 196, 71, 49),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Koombiyo Delivery Pvt Ltd began life in January 2019. Koombiyo was originally about leveraging the sharing economy and satisfying a specific logistical need. Koombiyo Delivery is offering lowest rate ever in Srilanka for COD or Non COD deliveries.\n\n Our highly acclaimed 5-star next day delivery service guarantees you the fastest local collection and delivery service.\n\n Koombiyo Delivery Pvt Ltd - Srilanka's Fastest parcel delivery network. Koombiyo Delivery Pvt Ltd. It has more operating experience, with presence in over 30 locations. We are a strategic partner of Corporate Clients in Srilanka. Building enduring and close ties with the customers is our priority and we pride ourselves in offering a high range of services to our esteemed patrons.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.dp,
                color: black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
