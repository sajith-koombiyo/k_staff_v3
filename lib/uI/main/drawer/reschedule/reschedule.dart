import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/uI/main/navigation/navigation.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../api/api.dart';
import '../../../widget/nothig_found.dart';

class Reschedule extends StatefulWidget {
  const Reschedule({super.key});

  @override
  State<Reschedule> createState() => _RescheduleState();
}

class _RescheduleState extends State<Reschedule> {
  DateTime selectedDate = DateTime.now();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController dateController = TextEditingController();
  bool isLoading = false;
  List<Map<String, dynamic>> depositList = [
    {'date': '2023/01/23'},
    {'date': '2023/11/23'},
    {'date': '2023/02/23'},
    {'date': '2023/01/21'},
    {'date': '2023/01/23'},
    {'date': '2023/01/24'}
  ];
  List rescheduleList = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);

        getData();
      });
    }
  }

  @override
  void initState() {
    setState(() {
      DateTime now = DateTime.now();
      dateController.text = DateFormat('yyyy-MM-dd').format(now);
    });
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    rescheduleList =
        await CustomApi().getReScheduleData('', context, dateController.text);

    setState(() {
      rescheduleList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Consumer<ProviderS>(
      builder: (context, provider, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: appliteBlue,
          bottom: PreferredSize(
              preferredSize: Size(w, 70),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: serchBarr(context),
              )),
          title: Text(
            'My Rescheduled',
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
        body: Stack(
          children: [
            SingleChildScrollView(
              child: SizedBox(
                child: Column(children: [
                  rescheduleList.isEmpty && isLoading == false
                      ? NoData()
                      : ListView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: rescheduleList.length,
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
                                        bool updateBTN = true;
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
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Icon(
                                                            Icons
                                                                .delivery_dining_sharp,
                                                            size: 40,
                                                            color: Color(Random()
                                                                    .nextInt(
                                                                        0xffffffff))
                                                                .withAlpha(
                                                                    0xff),
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
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                'ID:${rescheduleList[index]['waybill_id']}',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: black,
                                                                  fontSize:
                                                                      14.dp,
                                                                )),
                                                            Text(
                                                                'Client:-${rescheduleList[index]['cust_name']}',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize:
                                                                      14.dp,
                                                                )),
                                                            Text(
                                                                '${rescheduleList[index]['address']}',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize:
                                                                      12.dp,
                                                                )),
                                                            Text(
                                                                'COD:-${rescheduleList[index]['cod_final']}',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          221,
                                                                          31,
                                                                          116,
                                                                          152),
                                                                  fontSize:
                                                                      14.dp,
                                                                )),
                                                            Text(
                                                                'Phone:-${rescheduleList[index]['phone']}',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          221,
                                                                          220,
                                                                          44,
                                                                          44),
                                                                  fontSize:
                                                                      14.dp,
                                                                )),
                                                            Card(
                                                              elevation: 20,
                                                              margin: EdgeInsets
                                                                  .all(0),
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      62,
                                                                      13,
                                                                      130),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Text(
                                                                    '${rescheduleList[index]['status']}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      color:
                                                                          white,
                                                                      fontSize:
                                                                          10.dp,
                                                                    )),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
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
                ]),
              ),
            ),
            isLoading ? Loader().loader(context) : SizedBox(),
            provider.isanotherUserLog ? UserLoginCheck() : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget serchBarr(BuildContext con) {
    var h = MediaQuery.of(con).size.height;
    var w = MediaQuery.of(con).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: h / 15,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                onTap: () {
                  _selectDate(context);
                },
                readOnly: true,
                onChanged: (value) {},
                controller: dateController,
                style: TextStyle(color: black, fontSize: 13.sp),
                validator: (value) {},
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.calendar_month),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: black3),
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
                  hintText: 'Search by date',
                  fillColor: white2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
