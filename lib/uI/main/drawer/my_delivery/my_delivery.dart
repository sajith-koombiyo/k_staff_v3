import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/uI/widget/diloag_button.dart';
import 'package:flutter_application_2/uI/widget/nothig_found.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as https;
import '../../../../sql_db/db.dart';
import '../../navigation/navigation.dart';
import 'exchange/exchange.dart';

class MyDelivery extends StatefulWidget {
  const MyDelivery({super.key, required this.isFromHome});
  final bool isFromHome;

  @override
  State<MyDelivery> createState() => _MyDeliveryState();
}

class _MyDeliveryState extends State<MyDelivery> {
  var logger = Logger();
  SqlDb sqlDb = SqlDb();
  StreamSubscription<String>? _buttonSubscription;
  TextEditingController search = TextEditingController();
  TextEditingController waybill = TextEditingController();
  TextEditingController codController = TextEditingController();
  List product = [];
  List allProduct = [];
  List localData = [];
  List reasonList = [];
  String newImage = '';
  String errMsg = '';
  String formattedDate = '';
  List dataList = [];
  bool isOffline = true;
  bool isError = false;
  bool itemLoading = false;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  double progress = 0.0;
  ScrollController _scrollController = ScrollController();

  List item = [];
  int x = 0;

  String? dropdownvalue;
  String? dropdownvalue2;
  String? remarkValue;
  String dropdownvalueItem = '';
  String dropdownvalueItem2 = '';

  DateTime selectedDate = DateTime.now();
  List pdliveryList = [];
  List rescheduleList = [];
  List errorData = [];
  List remarkList = [];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;
  @override
  void initState() {
    // offlineDeliveryupdateApi();
    firstData();
    dropDownData();
    // TODO: implement initState

    _streamSubscription = _connectivity.onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        print('dddddddddddddddddddddddddddddddddddddddddddd');
        firstData();
        setState(() {
          isOffline = false;
        });
      } else {
        firstData();
        setState(() {
          isOffline = true;
        });
        print('dddddddsssssssssssssssssddddddddddddddddddddddddddddddddddddd');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
    _buttonSubscription?.cancel();
  }

  firstData() async {
    List datas = await sqlDb.readData('select * from deliver_error');
    logger.f(datas);
    List imageData = await sqlDb.readData('select * from pending_image');
    errorData = await sqlDb.readData('select * from deliver_error');
    // logger.i(imageData.toString());
    List pendinDiiveryData = await sqlDb.readData('select * from pending');
    logger.d(pendinDiiveryData.toString());
    if (imageData.isNotEmpty) {
      offlineImageUpload();
    }

    if (pendinDiiveryData.isNotEmpty) {
      print(
          'sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss1111111111111111');
      // await offlineDeliveryupdateApi();
    }

    print('empty dataaaaaaaaaaaaaa');
    getData(true);
  }

  getData(bool load) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    setState(() {
      isLoading = load;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('user_id');
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      List temp = await CustomApi()
          .getmyorders(search.text.toString(), id.toString(), context);

      if (temp == 1) {
        setState(() {
          isError = true;
        });
      }
      if (temp.isNotEmpty) {
        print('ffffffffffffffffffffffffffffffffffffffffffffff');
        var red = await sqlDb.truncateTable('delivery_oder');
        List.generate(temp.length, (index) async {
          var res = await sqlDb.replaceData('delivery_oder', {
            'oid': temp[index]['oid'],
            'waybill_id': temp[index]['waybill_id'],
            'cod_final': temp[index]['cod_final'],
            'order_type': temp[index]['order_type'],
            'cust_name': temp[index]['cust_name'],
            'name': temp[index]['name'],
            'address': temp[index]['address'],
            'phone': temp[index]['phone'],
            'status': temp[index]['status'],
            'cust_internal': temp[index]['cust_internal'],
            'prev_waybill': temp[index]['prev_waybill'],
            'ex_bag_waybill': temp[index]['ex_bag_waybill'],
            'type': '0'
          });
        });
      }

      // “Congratulations on your new job! I am sad to see you go.”
      List data = await sqlDb.readData('select * from delivery_oder');

      logger.e(data.toString());
      setState(() {
        errorData;
        dataList = data.where((item) => item['type'] == "0").toList();
        isLoading = false;
      });
    } else {
      print(
          'aaaaaaaaaaaaaaaaaaaaaaaaaaaadddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddaa');
      localData = await sqlDb.readData('select * from delivery_oder');
      // logger.e(localData.toString());
      setState(() {
        errorData;
        dataList = localData.where((item) => item['type'] == "0").toList();

        isLoading = false;
      });
    }
  }

  oderDataSerch(String waybill) async {
    setState(() {
      isLoading = true;
    });
    var data = await CustomApi().oderDetailAndTimeLine(context, waybill
        // '80808082'
        );

    setState(() {
      isLoading = false;
    });
  }

  dropDownData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      reasonList = await CustomApi().dropdownDataMyDelivery(context);

      if (reasonList.isNotEmpty) {
        var red = await sqlDb.truncateTable('reason_list');
        List.generate(reasonList.length, (index) async {
          var res = await sqlDb.replaceData('reason_list', {
            'reason_id': reasonList[index]['reason_id'],
            'reason': reasonList[index]['reason'],
            'type': reasonList[index]['type'],
          });
        });

        List data = await sqlDb.readData('select * from reason_list');

        setState(() {
          reasonList = data;
        });
      }
    } else {
      List data = await sqlDb.readData('select * from reason_list');
      setState(() {
        reasonList = data;
      });
    }

    if (reasonList.isNotEmpty) {
      List res = reasonList;
      setState(() {
        List.generate(res.length, (index) {
          if (res[index]['type'] == '3') {
            pdliveryList.add({
              "reason_id": "${res[index]['reason_id']}",
              "reason": "${res[index]['reason']}"
            });

            logger.f(pdliveryList.toString());
          }
          if (res[index]['type'] == '1') {
            rescheduleList.add({
              "reason_id": "${res[index]['reason_id']}",
              "reason": "${res[index]['reason']}"
            });
            logger.i(rescheduleList.toString());
          }
          if (res[index]['type'] == '4') {
            remarkList.add({
              "reason_id": "${res[index]['reason_id']}",
              "reason": "${res[index]['reason']}"
            });
            logger.d(rescheduleList.toString());
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Consumer<ProviderS>(
      builder: (context, provider, child) => Scaffold(
        backgroundColor: backgroundColor,
        appBar: widget.isFromHome == false
            ? AppBar(
                backgroundColor: appliteBlue,
                bottom: PreferredSize(
                    preferredSize: Size(w, isError ? 90 : 70),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: serchBar(),
                        ),
                        isError
                            ? Container(
                                width: w,
                                height: 30,
                                color: Colors.redAccent,
                                child: Text(
                                  'Server is not responding',
                                  style: TextStyle(color: white),
                                ))
                            : SizedBox()
                      ],
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
                              Column(
                                children: [
                                  Container(
                                    child: Image.asset(
                                      'assets/picked_50.png',
                                      fit: BoxFit.cover,
                                    ),
                                    height: h / 3,
                                    width: w,
                                  ),
                                  isOffline
                                      ? Container(
                                          alignment: Alignment.center,
                                          width: w,
                                          height: 20,
                                          color: Colors.redAccent,
                                          child: Text('offline',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: white,
                                                fontSize: 11.dp,
                                              )),
                                        )
                                      : SizedBox()
                                ],
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
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                                dataList[index]['cod_final'],
                                                dataList[index]['oid'],
                                                dataList[index]['order_type'],
                                                dataList[index]['order_type'] ==
                                                        '1'
                                                    ? dataList[index]
                                                            ['ex_bag_waybill']
                                                        .toString()
                                                    : "",
                                                dataList[index]['order_type']
                                                            .toString() ==
                                                        '1'
                                                    ? dataList[index]
                                                            ['prev_waybill']
                                                        .toString()
                                                    : '');
                                          },
                                          child: Card(
                                            margin: EdgeInsets.only(left: 0),
                                            color: dataList[index]
                                                        ['order_type'] ==
                                                    '1'
                                                ? Colors.red
                                                : appliteBlue,
                                            child: Card(
                                              color: dataList[index]
                                                          ['order_type'] ==
                                                      '1'
                                                  ? Color.fromARGB(
                                                      255, 243, 240, 210)
                                                  : white,
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
                                                            color: dataList[index]
                                                                        [
                                                                        'order_type'] ==
                                                                    '1'
                                                                ? Color
                                                                    .fromARGB(
                                                                        255,
                                                                        210,
                                                                        208,
                                                                        191)
                                                                : white,
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
                                                                      color: Color.fromARGB(
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
                                                                      color: Color.fromARGB(
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
                                                                          color:
                                                                              Colors.black87,
                                                                          fontSize:
                                                                              12.dp,
                                                                        )),
                                                                Card(
                                                                  elevation: 20,
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          62,
                                                                          13,
                                                                          130),
                                                                  child:
                                                                      Padding(
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
                                                              // Card(
                                                              //   elevation: 20,
                                                              //   shape: RoundedRectangleBorder(
                                                              //       borderRadius:
                                                              //           BorderRadius.circular(
                                                              //               100)),
                                                              //   child:
                                                              //       IconButton(
                                                              //     onPressed:
                                                              //         () {},
                                                              //     icon: Icon(
                                                              //       Icons
                                                              //           .voice_over_off_rounded,
                                                              //       size: 35,
                                                              //       color: Color
                                                              //           .fromARGB(
                                                              //               255,
                                                              //               13,
                                                              //               173,
                                                              //               45),
                                                              //     ),
                                                              //   ),
                                                              // ),
                                                              Card(
                                                                elevation: 20,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100)),
                                                                child:
                                                                    IconButton(
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
                                                                        BorderRadius.circular(
                                                                            100)),
                                                                child:
                                                                    IconButton(
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
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    errorData.any((element) {
                                                      print(element['oId']);
                                                      print(dataList[index]
                                                          ['oid']);

                                                      errMsg = element['msg']
                                                          .toString();
                                                      return element['oId']
                                                              .toString() ==
                                                          dataList[index]['oid']
                                                              .toString();
                                                    })
                                                        ? Container(
                                                            height: 20,
                                                            width: w,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    198,
                                                                    26,
                                                                    150),
                                                            child: Text(
                                                              errMsg == "400"
                                                                  ? "Bad Request: Error Occurred (400)"
                                                                  : errMsg ==
                                                                          "406"
                                                                      ? "Not Acceptable: Please Upload the POD (406)"
                                                                      : "Something went wrong (403)",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ))
                                                        : SizedBox()
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
            isLoading ? Loader().loader(context) : SizedBox(),
            provider.isanotherUserLog ? UserLoginCheck() : SizedBox()
          ],
        ),
      ),
    );
  }

  backDataLoad() {
    getData(false);
    codController.clear();
  }

  offlineDeliveryUpdate(
      String oId,
      String wayBillId,
      String statusType,
      String dropdownValue,
      String dropdownValue2,
      String cod,
      String rescheduleDate) async {
    var res = await sqlDb.replaceData('pending', {
      'oId': oId,
      'wayBillId': wayBillId,
      'statusType': statusType,
      'dropdownValue': dropdownValue,
      'dropdownValue2': dropdownValue2,
      'cod': cod,
      'rescheduleDate': rescheduleDate
    });

    if (res == 1) {
      notification().info(context,
          'data saved  The data has successfully returned to the online system and will be updated.');
    }
    print(oId);
    List data = await sqlDb.readData('select * from pending');
//
    // logger.e(data.toString());

    var t = await sqlDb.updateData(
        'UPDATE delivery_oder SET type = "$statusType" WHERE  oId ="$oId"');
    List dataa = await sqlDb.readData('select * from delivery_oder');
    Navigator.pop(context);
    logger.d(dataa.toString());
    getData(false);
  }

  offlineDeliveryupdateApi() async {
    print(
        'ddddddddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    List data = await sqlDb.readData('select * from pending');
    if (data.isNotEmpty) {
      List.generate(data.length, (index) async {
        int status = int.parse(data[index]['statusType'].toString());
        var res = await CustomApi().oderData(
          status,
          data[index]['wayBillId'].toString(),
          context,
          data[index]['dropdownValue'].toString(),
          data[index]['dropdownValue2'].toString(),
          data[index]['cod'].toString(),
          data[index]['rescheduleDate'].toString(),
          data[index]['oId'].toString(),
        );
        if (res == 1) {
          var ress = await sqlDb.deleteData(
              'delete from pending where oId = "${data[index]['oId'].toString()}"');
        } else {
          var ress = await sqlDb.replaceData('deliver_error', {
            'oId': data[index]['oId'].toString(),
            'msg': res.toString(),
          });
          if (ress == 1) {
            var ress = await sqlDb.deleteData(
                'delete from pending where oId = "${data[index]['oId'].toString()}"');
          }
          List datas = await sqlDb.readData('select * from deliver_error');
          logger.f(datas);
        }
      });
    }
    getData(true);
  }

  itemDetails(String waybill, bool updateBTN, String cod, String oId,
      String oderType, String exchangeWayBill, String pWaybill) {
    double codValue = double.parse(cod);

    dropdownvalue = null;
    dropdownvalue2 = null;
    remarkValue = null;

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
            backgroundColor:
                Color.fromARGB(255, 238, 240, 241).withOpacity(0.95),
            scrollable: true,
            contentPadding: EdgeInsets.all(0),
            actionsPadding: EdgeInsets.all(10),
            insetPadding: EdgeInsets.all(30),
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
                          if (oderType == '1') {
                            if (x == 3 || x == 2) {
                              if (dropdownvalue != null ||
                                  remarkValue != null ||
                                  dropdownvalue2 != null ||
                                  x == 1) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Exchange(
                                        exchangeBagWaybill: exchangeWayBill,
                                        pWaybill: pWaybill,
                                        backDataLoad: backDataLoad,
                                        statusTyp: x,
                                        waybill: waybill,
                                        dropdownvalueItem: dropdownvalueItem,
                                        dropdownvalueItem2: x == 4
                                            ? remarkValue.toString()
                                            : dropdownvalueItem2,
                                        codController: codController.text,
                                        date: provider.fomatedDate,
                                        oderId: oId,
                                      ),
                                    ));
                              } else {
                                notification().warning(
                                    context, 'please select the reason');
                              }
                            } else {
                              if (isOffline) {
                                offlineDeliveryUpdate(
                                    oId,
                                    waybill,
                                    x.toString(),
                                    dropdownvalueItem,
                                    x == 4
                                        ? remarkValue.toString()
                                        : dropdownvalueItem2.toString(),
                                    codController.text,
                                    provider.fomatedDate);

                                codController.clear();
                              } else {
                                var res = await CustomApi().oderData(
                                    x,
                                    waybill,
                                    context,
                                    dropdownvalueItem.toString(),
                                    x == 4
                                        ? remarkValue.toString()
                                        : dropdownvalueItem2.toString(),
                                    codController.text,
                                    provider.fomatedDate,
                                    oId);

                                if (res == 200) {
                                  getData(false);
                                  codController.clear();
                                }
                              }
                            }
                          } else {
                            ;
                            if (dropdownvalue != null ||
                                remarkValue != null ||
                                dropdownvalue2 != null ||
                                x == 1) {
                              if (isOffline) {
                                offlineDeliveryUpdate(
                                    oId,
                                    waybill,
                                    x.toString(),
                                    dropdownvalueItem,
                                    x == 4
                                        ? remarkValue.toString()
                                        : dropdownvalueItem2.toString(),
                                    codController.text,
                                    provider.fomatedDate);

                                codController.clear();
                              } else {
                                var res = await CustomApi().oderData(
                                    x,
                                    waybill,
                                    context,
                                    dropdownvalueItem.toString(),
                                    x == 4
                                        ? remarkValue.toString()
                                        : dropdownvalueItem2.toString(),
                                    codController.text,
                                    provider.fomatedDate,
                                    oId);

                                if (res == 200) {
                                  getData(false);
                                  codController.clear();
                                }
                              }
                            } else {
                              notification()
                                  .warning(context, 'please select the reason');
                            }
                          }
                        }
                        setstate(() {
                          itemLoading = false;
                        });
                      }
                    : () {},
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
                              color: oderType == '1'
                                  ? Color.fromARGB(255, 189, 145, 0)
                                  : Colors.black38,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10))),
                          child: Row(
                            children: [
                              Text("  $waybill  ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: oderType == '1'
                                        ? Color.fromARGB(255, 5, 57, 147)
                                        : black,
                                    fontSize: 14.dp,
                                  )),
                              oderType == '1'
                                  ? Text("  Exchange  ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: white,
                                        fontSize: 14.dp,
                                      ))
                                  : SizedBox(),
                            ],
                          ),
                        ),
                        Container(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                onPressed: () {
                                  setstate(() {
                                    newImage = '';
                                    dropdownvalue = null;
                                    dropdownvalueItem = '';
                                    remarkValue = null;
                                    dropdownvalueItem2 = '';
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
                          if (x == 1 &&
                              codValue >= 100.00 &&
                              newImage.isEmpty) {
                            updateBTN = true;
                          }
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
                    Divider(
                      height: 0,
                    ),
                    InkWell(
                      onTap: () {
                        setstate(() {
                          x = 4;
                          updateBTN = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        height: h / 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Remark',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: black2,
                                  fontSize: 15.dp,
                                )),
                            Icon(
                              x == 4
                                  ? Icons.check_circle_rounded
                                  : Icons.remove_circle_outline,
                              color: x == 4
                                  ? Color.fromARGB(255, 74, 143, 136)
                                  : black3,
                            )
                          ],
                        ),
                      ),
                    ),
                    x == 2
                        ? Padding(
                            padding: const EdgeInsets.all(1.0),
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
                                      itemHeight: 70,
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
                                      items: pdliveryList.map((itemone) {
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
                            padding: const EdgeInsets.all(1.0),
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
                                      itemHeight: 70,
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
                                      items: rescheduleList.map((itemone) {
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
                    x == 4
                        ? Card(
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
                                    itemHeight: 70,
                                    autofocus: true,
                                    underline: Divider(
                                      color: white,
                                      height: 6,
                                    ),
                                    elevation: 20,
                                    isExpanded: true,
                                    padding: EdgeInsets.all(10),
                                    alignment: AlignmentDirectional.centerStart,
                                    hint: Text('Select Reason'),

                                    value: remarkValue,

                                    //implement initial value or selected value
                                    onChanged: (value) {
                                      setstate(() {
                                        //set state will update UI and State of your App
                                        remarkValue = value.toString();
                                        if (remarkValue!.isNotEmpty) {
                                          updateBTN = true;
                                        } //change selectval to new value
                                      });
                                    },
                                    items: remarkList.map((itemone) {
                                      return DropdownMenuItem(
                                          alignment: Alignment.centerLeft,
                                          onTap: () {
                                            setstate(() {
                                              dropdownvalueItem2 =
                                                  itemone['reason'].toString();
                                            });
                                          },
                                          value: itemone["reason_id"],
                                          child: Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                child: Text(
                                                  '${itemone["reason"]}',
                                                  style: TextStyle(
                                                    color: black2,
                                                  ),
                                                  overflow:
                                                      TextOverflow.visible,
                                                  softWrap: true,
                                                ),
                                              ),
                                            ),
                                          ));
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(),
                    Divider(
                      height: 0,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    x == 1 || x == 2 || x == 3
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
                                              x == 2 || codValue <= 100.00
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
                                      imageProgress();

                                      var connectivityResult =
                                          await (Connectivity()
                                              .checkConnectivity());
                                      if (connectivityResult ==
                                              ConnectivityResult.mobile ||
                                          connectivityResult ==
                                              ConnectivityResult.wifi) {
                                        var res = await CustomApi()
                                            .immageUpload(
                                                context, image, waybill, false);

                                        if (res != 1) {
                                          setstate(() {
                                            // newImage = '';
                                            provider.progress = 0;
                                          });
                                        }
                                      } else {
                                        pickAndSaveImageToFolder(
                                            image, waybill);
                                      }
                                      setstate(() {
                                        updateBTN = true;
                                      });
                                      Navigator.pop(context);
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
                                      imageProgress();

                                      var connectivityResult =
                                          await (Connectivity()
                                              .checkConnectivity());
                                      if (connectivityResult ==
                                              ConnectivityResult.mobile ||
                                          connectivityResult ==
                                              ConnectivityResult.wifi) {
                                        await CustomApi().immageUpload(
                                            context, image, waybill, false);
                                      } else {
                                        pickAndSaveImageToFolder(
                                            image, waybill);
                                      }

                                      setstate(() {
                                        updateBTN = true;
                                      });
                                      Navigator.pop(context);
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

  pickAndSaveImageToFolder(XFile? pickedFile, String waybill) async {
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      // Get the directory for the application's documents directory
      final directory = await getApplicationDocumentsDirectory();
      // Create a custom folder (if it doesn't already exist)
      final customDir = Directory('${directory.path}/MyImages');
      if (!(await customDir.exists())) {
        await customDir.create(recursive: true);
      }
      // Construct the file path to save the image
      final fileName = path.basename(pickedFile.path);
      final savedImagePath = '${customDir.path}/$fileName';
      // Save the image to the specified folder
      await imageFile.copy(savedImagePath);
      var res = await sqlDb.replaceData('pending_image', {
        'waybill': waybill,
        'image': savedImagePath,
      });
      List data = await sqlDb.readData('select * from pending_image');
      notification().info(context,
          'Image saved  The data has successfully returned to the online system and will be updated.');
    }
  }

  offlineImageUpload() async {
    List data = await sqlDb.readData('select * from pending_image');
    logger.d(data);
    if (data.isNotEmpty) {
      List.generate(data.length, (index) async {
        final customDir = Directory(data[index]['image']);
        print(customDir.path);
        var res = await CustomApi().immageUpload(context, XFile(customDir.path),
            data[index]['waybill'].toString(), true);

        if (res.toString() == '1') {
          print('ddddddddddddddddddddddddddddddddddddddddddd');
          deleteImage(customDir.path);
          var ress = await sqlDb.deleteData(
              'delete from pending_image where waybill = "${data[index]['waybill']}"');

          print(ress);
        } else {}
      });
    }
  }

  Future<void> deleteImage(String path) async {
    final File file = File(path);

    try {
      if (await file.exists()) {
        await file.delete();
        print("File deleted successfully.");
      } else {
        print("File not found.");
      }
    } catch (e) {
      print("Error occurred while deleting the file: $e");
    }
  }

  imageProgress() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      barrierDismissible: true,
      showConfirmBtn: false,
      showCancelBtn: false,
      widget: Consumer<ProviderS>(
        builder: (context, provider, child) => Column(
          children: [
            Text('Image Uploading...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black38,
                  fontSize: 12.dp,
                )),
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
      ),
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
    List results = [];
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
                  1 == 2 ? getData(true) : oderDataSerch(value);
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
}
