import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/class/location.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/uI/widget/diloag_button.dart';
import 'package:flutter_application_2/uI/widget/nothig_found.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as https;

import 'exchange/exchange.dart';
import 'voice_call.dart';

class MyDelivery extends StatefulWidget {
  const MyDelivery({super.key, required this.isFromHome});
  final bool isFromHome;

  @override
  State<MyDelivery> createState() => _MyDeliveryState();
}

class _MyDeliveryState extends State<MyDelivery> {
  ScrollController _controller = ScrollController();
  TextEditingController search = TextEditingController();
  TextEditingController waybill = TextEditingController();
  TextEditingController codController = TextEditingController();
  List<Map<String, dynamic>> product = [];
  List<Map<String, dynamic>> allProduct = [];
  String newImage = '';
  String formattedDate = '';
  List<Map<dynamic, dynamic>> dataList = [];
  bool itemLoading = false;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  double progress = 0.0;
  ScrollController _scrollController = ScrollController();

  List item = [];
  int x = 0;

  String? dropdownvalue;
  String? dropdownvalue2;
  String dropdownvalueItem = '';
  String dropdownvalueItem2 = '';

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    getData(true);

    // TODO: implement initState
    super.initState();
  }

  getData(bool load) async {
    setState(() {
      isLoading = load;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('user_id');

    var temp =
        await CustomApi().getmyorders(search.text, id.toString(), context);
    setState(() {
      dataList = temp;

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: widget.isFromHome == false
          ? AppBar(
              backgroundColor: appliteBlue,
              bottom: PreferredSize(
                  preferredSize: Size(w, 70),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: serchBar(),
                  )),
              title: Text(
                'My Delivery',
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
            )
          : null,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () {
              return getData(false);
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  widget.isFromHome
                      ? Stack(
                          children: [
                            Container(
                              child: Image.asset(
                                'assets/picked_50.png',
                                fit: BoxFit.cover,
                              ),
                              height: h / 3,
                              width: w,
                            ),
                            Container(
                              height: h / 3,
                              width: w,
                              color: black.withOpacity(0.4),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Track Orders',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: white,
                                      fontSize: 22.dp,
                                    )),
                              ),
                            ),
                            Positioned(
                                bottom: h / 9,
                                left: 0,
                                right: 0,
                                child: serchBar())
                          ],
                        )
                      : SizedBox(),
                  dataList.isEmpty && isLoading == false
                      ? SizedBox(
                          height: h,
                          width: w,
                          child: Column(
                            children: [
                              Center(child: NoData()),
                            ],
                          ))
                      : SizedBox(
                          height: dataList.length >= 2 ? null : h,
                          width: w,
                          child: ListView.builder(
                            shrinkWrap: true,
                            controller: _scrollController,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.all(0),
                            itemCount: dataList.length,
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
                                          bool updateBTN = false;
                                          setState(() {
                                            newImage = '';
                                            dropdownvalue = null;
                                            codController.clear();
                                          });
                                          itemDetails(
                                              dataList[index]['waybill_id'],
                                              updateBTN,
                                              dataList[index]['cod_final']);
                                        },
                                        onLongPress: () {},
                                        child: Card(
                                          margin: EdgeInsets.only(left: 0),
                                          color: appliteBlue,
                                          child: Card(
                                            elevation: 50,
                                            margin: EdgeInsets.only(left: 3),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
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
                                                                  '${dataList[index]['waybill_id']}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        black,
                                                                    fontSize:
                                                                        14.dp,
                                                                  )),
                                                              Text(
                                                                  'Name:-${dataList[index]['name']}',
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
                                                                  'Client:-${dataList[index]['cust_name']}',
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
                                                                  '${dataList[index]['address']}',
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
                                                                  'COD:-${dataList[index]['cod_final']}',
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
                                                                  'Phone:-${dataList[index]['phone']}',
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
                                                              dataList[index][
                                                                          'cust_internal'] ==
                                                                      ''
                                                                  ? SizedBox()
                                                                  : Text(
                                                                      'Remark:-${dataList[index]['cust_internal']}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        color: Colors
                                                                            .black87,
                                                                        fontSize:
                                                                            12.dp,
                                                                      )),
                                                              Card(
                                                                elevation: 20,
                                                                margin:
                                                                    EdgeInsets
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
                                                                      '${dataList[index]['status']}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal,
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
                                                        Spacer(),
                                                        Column(
                                                          children: [
                                                            Card(
                                                              elevation: 20,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100)),
                                                              child: IconButton(
                                                                onPressed:
                                                                    () {},
                                                                icon: Icon(
                                                                  Icons
                                                                      .voice_over_off_rounded,
                                                                  size: 35,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          13,
                                                                          173,
                                                                          45),
                                                                ),
                                                              ),
                                                            ),
                                                            Card(
                                                              elevation: 20,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100)),
                                                              child: IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  final call =
                                                                      Uri.parse(
                                                                          'tel:${dataList[index]['phone']}');
                                                                  if (await canLaunchUrl(
                                                                      call)) {
                                                                    launchUrl(
                                                                        call);
                                                                  } else {
                                                                    throw 'Could not launch $call';
                                                                  }
                                                                },
                                                                icon: Icon(
                                                                  Icons.call,
                                                                  size: 35,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                            ),
                                                            Card(
                                                              elevation: 20,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100)),
                                                              child: IconButton(
                                                                  onPressed:
                                                                      () async {
                                                                    notification().warning(
                                                                        context,
                                                                        'Location not found');
                                                                    // MapUtils.openMap(
                                                                    //     -3.823216,
                                                                    //     -38.481700);
                                                                  },
                                                                  icon: Image.asset(
                                                                      'assets/icons8-google-maps-old-30.png')),
                                                            ),
                                                          ],
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
                        ),
                ],
              ),
            ),
          ),
          widget.isFromHome
              ? Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 12,
                  child: CircleAvatar(
                    backgroundColor: black.withOpacity(0.4),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: white,
                        )),
                  ),
                )
              : SizedBox(),
          isLoading ? Loader().loader(context) : SizedBox()
        ],
      ),
    );
  }

  itemDetails(String waybill, bool updateBTN, String cod) {
    String? dropdownvalue;
    String? dropdownvalue2;
    String dropdownvalueItem = '';
    String dropdownvalueItem2 = '';
    Provider.of<ProviderS>(context, listen: false).progress = 0.0;
    Provider.of<ProviderS>(context, listen: false).fomatedDate =
        DateFormat.yMMMEd().format(DateTime.now());
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    x = 0;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setstate) {
        return Consumer<ProviderS>(
          builder: (context, provider, child) => AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.all(0),
            actionsPadding: EdgeInsets.all(20),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            actions: [
              DialogButton(
                buttonHeight: h / 14,
                width: w,
                text: 'Save',
                color:
                    updateBTN ? Color.fromARGB(255, 8, 152, 219) : Colors.grey,
                onTap: updateBTN
                    ? () async {
                        setstate(() {
                          itemLoading = true;
                        });

                        if (x == 2 && newImage.isEmpty) {
                          setstate(() {
                            updateBTN = false;
                          });
                        } else {
                          var res = await CustomApi().oderData(
                              x,
                              waybill,
                              context,
                              dropdownvalueItem.toString(),
                              dropdownvalueItem2.toString(),
                              codController.text,
                              provider.fomatedDate);

                          print(res);
                          if (res == 200) {
                            getData(false);
                            codController.clear();
                          }
                        }
                        setstate(() {
                          itemLoading = false;
                        });
                      }
                    : () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Exchange(),
                            ));
                      },
              )
            ],
            content: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                    color: Color.fromARGB(31, 227, 94, 94))
                              ],
                              color: Colors.black12,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10))),
                          child: Text("  $waybill  ",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: black,
                                fontSize: 14.dp,
                              )),
                        ),
                        Container(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                onPressed: () {
                                  setstate(() {
                                    newImage = '';
                                    dropdownvalue = null;
                                    codController.clear();
                                  });
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: black2,
                                ))),
                      ],
                    ),
                    Text('ITEM DETAILS',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: black,
                          fontSize: 18.dp,
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("COD  $cod",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 5, 45, 116),
                              fontSize: 15.dp,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      height: 0,
                    ),
                    InkWell(
                      onTap: () {
                        setstate(() {
                          x = 1;
                          updateBTN = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        height: h / 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Delivered',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: black2,
                                  fontSize: 15.dp,
                                )),
                            Icon(
                              x == 1
                                  ? Icons.check_circle_rounded
                                  : Icons.remove_circle_outline,
                              color: x == 1
                                  ? Color.fromARGB(255, 7, 138, 125)
                                  : black3,
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 0,
                    ),
                    InkWell(
                      onTap: () {
                        setstate(() {
                          x = 2;
                          updateBTN = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        height: h / 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Partially Delivered',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: black2,
                                  fontSize: 15.dp,
                                )),
                            Icon(
                              x == 2
                                  ? Icons.check_circle_rounded
                                  : Icons.remove_circle_outline,
                              color: x == 2
                                  ? Color.fromARGB(255, 7, 138, 125)
                                  : black3,
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 0,
                    ),
                    InkWell(
                      onTap: () {
                        setstate(() {
                          x = 3;
                          updateBTN = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        height: h / 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Rescheduled',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: black2,
                                  fontSize: 15.dp,
                                )),
                            Icon(
                              x == 3
                                  ? Icons.check_circle_rounded
                                  : Icons.remove_circle_outline,
                              color: x == 3
                                  ? Color.fromARGB(255, 74, 143, 136)
                                  : black3,
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          alignment: Alignment.centerRight,
                          width: w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: black3,
                                style: BorderStyle.solid,
                                width: 0.80),
                          ),
                          child: Column(
                            children: [
                              DropdownButton(
                                underline: Divider(
                                  color: white,
                                  height: 0,
                                ),
                                isExpanded: true,
                                padding: EdgeInsets.only(right: 10),
                                alignment: AlignmentDirectional.centerEnd,
                                hint: Text(
                                    'Select Rider Remark                                                                   '),
                                value: dropdownvalue,
                                //implement initial value or selected value
                                onChanged: (value) {
                                  setstate(() {
                                    //set state will update UI and State of your App
                                    dropdownvalue = value.toString();
                                    if (value.toString().isNotEmpty &&
                                        newImage.isNotEmpty) {
                                      updateBTN = true;
                                    } //change selectval to new value
                                  });
                                },
                                items: _pdelivery.map((itemone) {
                                  return DropdownMenuItem(
                                      onTap: () {
                                        setstate(() {
                                          dropdownvalueItem =
                                              itemone['reason'].toString();
                                        });
                                      },
                                      value: itemone['reason_id'],
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            itemone['reason'].toString(),
                                            style: TextStyle(color: black2),
                                          ),
                                        ),
                                      ));
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    x == 2
                        ? Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Card(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                alignment: Alignment.centerRight,
                                width: w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: black3,
                                      style: BorderStyle.solid,
                                      width: 0.80),
                                ),
                                child: Column(
                                  children: [
                                    DropdownButton(
                                      underline: Divider(
                                        color: white,
                                        height: 0,
                                      ),
                                      isExpanded: true,
                                      padding: EdgeInsets.only(right: 10),
                                      alignment: AlignmentDirectional.centerEnd,
                                      hint: Text(
                                          'Select Reason                                                                   '),

                                      value: dropdownvalue,

                                      //implement initial value or selected value
                                      onChanged: (value) {
                                        setstate(() {
                                          //set state will update UI and State of your App
                                          dropdownvalue = value.toString();

                                          if (value.toString().isNotEmpty &&
                                              newImage.isNotEmpty) {
                                            updateBTN = true;
                                          } //change selectval to new value
                                        });
                                      },
                                      items: _pdelivery.map((itemone) {
                                        return DropdownMenuItem(
                                            onTap: () {
                                              setstate(() {
                                                dropdownvalueItem =
                                                    itemone['reason']
                                                        .toString();
                                              });
                                            },
                                            value: itemone['reason_id'],
                                            child: Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  itemone['reason'].toString(),
                                                  style:
                                                      TextStyle(color: black2),
                                                ),
                                              ),
                                            ));
                                      }).toList(),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Collected COD Rs',
                                          style: TextStyle(color: black2),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                            child: SizedBox(
                                          height: h / 17,
                                          child: TextField(
                                            controller: codController,
                                            keyboardType: TextInputType.number,
                                          ),
                                        ))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    x == 3
                        ? Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Card(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                alignment: Alignment.centerRight,
                                width: w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: black3,
                                      style: BorderStyle.solid,
                                      width: 0.80),
                                ),
                                child: Column(
                                  children: [
                                    DropdownButton(
                                      underline: Divider(
                                        color: white,
                                        height: 0,
                                      ),
                                      isExpanded: true,
                                      padding: EdgeInsets.only(right: 10),
                                      alignment: AlignmentDirectional.centerEnd,
                                      hint: Text(
                                          'Select Reason                                                                   '),

                                      value: dropdownvalue2,

                                      //implement initial value or selected value
                                      onChanged: (value) {
                                        setstate(() {
                                          //set state will update UI and State of your App
                                          dropdownvalue2 = value.toString();
                                          if (dropdownvalue2!.isNotEmpty) {
                                            updateBTN = true;
                                          } //change selectval to new value
                                        });
                                      },
                                      items: _recheduled.map((itemone) {
                                        return DropdownMenuItem(
                                            onTap: () {
                                              setstate(() {
                                                dropdownvalueItem2 =
                                                    itemone['reason']
                                                        .toString();
                                              });
                                            },
                                            value: itemone["reason_id"],
                                            child: Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  itemone["reason"],
                                                  style:
                                                      TextStyle(color: black2),
                                                ),
                                              ),
                                            ));
                                      }).toList(),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(provider.fomatedDate,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: black2,
                                              fontSize: 15.dp,
                                            )),
                                        IconButton(
                                            padding: EdgeInsets.all(0),
                                            onPressed: () {
                                              _selectDate(context);
                                            },
                                            icon:
                                                Icon(Icons.date_range_rounded))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    Divider(
                      height: 0,
                    ),
                    Divider(
                      height: 0,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    x == 7
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              newImage.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      child: Container(
                                          height: h / 7,
                                          width: w / 2.2,
                                          child: Image.file(
                                            File(newImage),
                                            fit: BoxFit.cover,
                                          )))
                                  : DottedBorder(
                                      color: Colors.black38,
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(12),
                                      padding: EdgeInsets.all(6),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: h / 7,
                                          width: w / 2,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.cloud_upload_outlined,
                                                size: 40,
                                                color: const Color.fromARGB(
                                                    96, 77, 76, 76),
                                              ),
                                              Text('Please upload \nyour image',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black38,
                                                    fontSize: 12.dp,
                                                  )),
                                              x == 2
                                                  ? Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'image required',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    )
                                                  : SizedBox()
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      provider.progress = 0.0;

                                      final XFile? image =
                                          await _picker.pickImage(
                                              imageQuality: 25,
                                              source: ImageSource.camera);

                                      setstate(() {
                                        newImage = image!.path;
                                      });
                                      CustomApi().immageUpload(
                                          context, image, waybill);
                                      setstate(() {
                                        updateBTN = true;
                                      });
                                    },
                                    child: Card(
                                        elevation: 5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Icon(
                                            color: Colors.black38,
                                            Icons.camera_alt,
                                          ),
                                        )),
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () async {
                                      provider.progress = 0.0;
                                      final XFile? image =
                                          await _picker.pickImage(
                                              imageQuality: 25,
                                              source: ImageSource.gallery);

                                      setstate(() {
                                        newImage = image!.path;
                                      });

                                      setstate(() {
                                        newImage = image!.path;
                                      });
                                      CustomApi().immageUpload(
                                          context, image, waybill);
                                      setstate(() {
                                        updateBTN = true;
                                      });
                                      // source
                                    },
                                    child: Card(
                                        elevation: 5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Icon(
                                            color: Colors.black38,
                                            Icons.photo,
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(),
                    LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(10),
                      semanticsValue: provider.progress.toString(),
                      value: provider.progress,
                      minHeight: 7.0,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                          const Color.fromARGB(255, 21, 107, 177)),
                    ),
                  ],
                ),
                itemLoading
                    ? Positioned(
                        top: 0, right: 0, bottom: 0, left: 0, child: loader())
                    : SizedBox()
              ],
            ),
          ),
        );
      }),
    );
  }

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        barrierColor: black.withOpacity(0.6),
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {});
      setState(() {
        selectedDate = picked;
        Provider.of<ProviderS>(context, listen: false).fomatedDate =
            DateFormat.yMMMEd().format(picked);

        var formattedDate = DateFormat.yMMMEd().format(picked);
      });
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = allProduct;
    } else if (allProduct
        .where((user) =>
            user["item"].toLowerCase().contains(enteredKeyword.toLowerCase()))
        .toList()
        .isNotEmpty) {
      results = allProduct
          .where((user) =>
              user["item"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    // Refresh the UI
    setState(() {
      product = results;
    });
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

  Widget serchBar() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: h / 15,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (value) {
                  getData(true);
                },
                controller: search,
                style: TextStyle(color: black, fontSize: 13.sp),
                validator: (value) {},
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () async {
                        scanBarcodeNormal();
                      },
                      icon: Icon(Icons.qr_code_scanner_sharp)),
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
                  hintText: 'Scan or Search',
                  fillColor: white2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      var _scanBarcode = barcodeScanRes;
      if (_scanBarcode == "-1") {
        search.text = "";
      } else {
        search.text = _scanBarcode.toString();
        getData(true);
      }
    });
  }

  final List<Map> _pdelivery = [
    {
      "reason_id": "34",
      "reason": "Customer has already paid partially in advance"
    },
    {"reason_id": "35", "reason": "Requested by online store"},
    {"reason_id": "36", "reason": "Damaged item"},
    {"reason_id": "37", "reason": "Waybill and system data mismatch"},
    {"reason_id": "38", "reason": "COD already paid in total"}
  ];
  final List<Map> _recheduled = [
    {"reason_id": "1", "reason": "Customer rescheduled"},
    {"reason_id": "2", "reason": "Customer phone switched off"},
    {"reason_id": "3", "reason": "Customer phone no answer"},
    {"reason_id": "4", "reason": "Customer out of city"},
    {"reason_id": "5", "reason": "Customer unable to pay"},
    {"reason_id": "6", "reason": "Different location"},
    {"reason_id": "7", "reason": "Customer request to open the package"},
    {"reason_id": "8", "reason": "Requested  online store"},
    {"reason_id": "9", "reason": "Wrong quantity"},
    {"reason_id": "10", "reason": "Bad weather (Floods)"},
    {"reason_id": "11", "reason": "Rescheduled Due to COVID-19"}
  ];
}




//  {
//       'oid': '13911039',
//       'waybill_id': '10000080',
//       'cod_final': '1000.00',
//       'cust_name': 'IT HOUSE',
//       'name':
//           'Dinesh Alahakoon, address: 603  Jayanthi Road  Gohagoda  Katugastota,',
//       'phone': '712345678',
//       'status': 'Out for Delivery, cust_internal:'
//     },
//     {
//       'oid': '13911039',
//       'waybill_id': '10000080',
//       'cod_final': '1000.00',
//       'cust_name': 'IT HOUSE',
//       'name':
//           'Dinesh Alahakoon, address: 603  Jayanthi Road  Gohagoda  Katugastota,',
//       'phone': '712345678',
//       'status': 'Out for Delivery, cust_internal:'
//     },
//     {
//       'oid': '13911039',
//       'waybill_id': '10000080',
//       'cod_final': '1000.00',
//       'cust_name': 'IT HOUSE',
//       'name':
//           'Dinesh Alahakoon, address: 603  Jayanthi Road  Gohagoda  Katugastota,',
//       'phone': '712345678',
//       'status': 'Out for Delivery, cust_internal:'
//     },
//     {
//       'oid': '13911039',
//       'waybill_id': '10000080',
//       'cod_final': '1000.00',
//       'cust_name': 'IT HOUSE',
//       'name':
//           'Dinesh Alahakoon, address: 603  Jayanthi Road  Gohagoda  Katugastota,',
//       'phone': '712345678',
//       'status': 'Out for Delivery, cust_internal:'
//     },
//     {
//       'oid': '13911039',
//       'waybill_id': '10000080',
//       'cod_final': '1000.00',
//       'cust_name': 'IT HOUSE',
//       'name':
//           'Dinesh Alahakoon, address: 603  Jayanthi Road  Gohagoda  Katugastota,',
//       'phone': '712345678',
//       'status': 'Out for Delivery, cust_internal:'
//     },
//     {
//       'oid': '13911039',
//       'waybill_id': '10000080',
//       'cod_final': '1000.00',
//       'cust_name': 'IT HOUSE',
//       'name':
//           'Dinesh Alahakoon, address: 603  Jayanthi Road  Gohagoda  Katugastota,',
//       'phone': '712345678',
//       'status': 'Out for Delivery, cust_internal:'
//     }
