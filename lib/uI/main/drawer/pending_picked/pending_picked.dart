import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/uI/widget/nothig_found.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

import '../../../../class/class.dart';

class PendingPicked extends StatefulWidget {
  const PendingPicked({super.key});

  @override
  State<PendingPicked> createState() => _PendingPickedState();
}

class _PendingPickedState extends State<PendingPicked> {
  List pickup = [];
  List pendingPickup = [];
  bool isLoading = false;
  @override
  void initState() {
    loadData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appliteBlue,
        bottom: PreferredSize(
            preferredSize: Size(w, 70),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: serchBarr(context),
            )),
        title: Text(
          'Pending Pickup',
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
      body: Stack(
        children: [
          isLoading == false && pickup.isEmpty
              ? NoData()
              : ListView.builder(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemCount: pickup.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              splashColor: blue,
                              onTap: () {
                                // itemDetails();
                              },
                              onLongPress: () {},
                              child: Card(
                                margin: EdgeInsets.only(left: 0),
                                color: appliteBlue,
                                child: Card(
                                  elevation: 50,
                                  margin: EdgeInsets.only(left: 3),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: w,
                                          child: Row(
                                            children: [
                                              Card(
                                                elevation: 1,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons
                                                        .local_shipping_outlined,
                                                    size: 40,
                                                    color: Color(Random()
                                                            .nextInt(
                                                                0xffffffff))
                                                        .withAlpha(0xff),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: w / 2.4,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        '${pickup[index]['pickr_id']}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: black,
                                                          fontSize: 14.dp,
                                                        )),
                                                    Text(
                                                        'Client:- ${pickup[index]['cust_name']}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black87,
                                                          fontSize: 14.dp,
                                                        )),
                                                    Text(
                                                        '${pickup[index]['address']}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.black87,
                                                          fontSize: 12.dp,
                                                        )),
                                                    Text(
                                                        'Phone:-${pickup[index]['phone']}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Color.fromARGB(
                                                              221, 220, 44, 44),
                                                          fontSize: 14.dp,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Spacer(),
                                              Card(
                                                elevation: 20,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100)),
                                                child: IconButton(
                                                  onPressed: () async {
                                                    final call = Uri.parse(
                                                        'tel:${pickup[index]['phone']}');
                                                    if (await canLaunchUrl(
                                                        call)) {
                                                      launchUrl(call);
                                                    } else {
                                                      throw 'Could not launch $call';
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons.call,
                                                    size: 35,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
          isLoading ? Loader().loader(context) : SizedBox()
        ],
      ),
    );
  }

  Widget serchBarr(BuildContext con) {
    var h = MediaQuery.of(con).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: h / 15,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (value) {
                  _runFilter(value);
                },
                // controller: search,
                style: TextStyle(color: black, fontSize: 13.sp),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        // color: pink.withOpacity(0.1),
                        ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  filled: true,
                  hintStyle: TextStyle(fontSize: 13.dp),
                  hintText: 'Search by id or client name',
                  fillColor: white2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  loadData() async {
    setState(() {
      isLoading = true;
    });
    var temp = await CustomApi().pendingPickup(context);
    if (mounted)
      setState(() {
        pendingPickup = temp;
        pickup = temp;
        isLoading = false;
      });
  }

  void _runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = pendingPickup;
    } else if (pendingPickup
        .where((user) => user["pickr_id"]
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()))
        .toList()
        .isNotEmpty) {
      results = pendingPickup
          .where((user) => user["pickr_id"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    } else if (pendingPickup
        .where((user) => user["cust_name"]
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()))
        .toList()
        .isNotEmpty) {
      results = pendingPickup
          .where((user) => user["cust_name"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    // Refresh the UI
    setState(() {
      pickup = results;
    });
  }
}
