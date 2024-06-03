import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/class/location.dart';
import 'package:flutter_application_2/uI/widget/nothig_found.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  ScrollController _controller = ScrollController();
  TextEditingController search = TextEditingController();
  TextEditingController waybill = TextEditingController();
  TextEditingController codController = TextEditingController();
  List product = [];
  List allProduct = [];
  String newImage = '';
  String formattedDate = '';
  List dataList = [];
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  double progress = 0.0;

  List item = [];
  int x = 0;
  List<String> listitems = [
    "Tokyo",
    "London",
    "New York",
    "Sanghaicsbzchbhbhabhbdhbc  s bchbscx s scsc s scbsac acnja",
    "Moscow",
    "Hong Kong"
  ];
  String? dropdownvalue;
  String? dropdownvalue2;

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
    final String? id = await prefs.getString('userId');

    var temp =
        await CustomApi().getAllOrders(search.text, id.toString(), context);
    setState(() {
      dataList = temp;

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      onRefresh: () {
        return getData(false);
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: appliteBlue,
          bottom: PreferredSize(
              preferredSize: Size(w, 70),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: serchBar(),
              )),
          title: Text(
            'My Orders',
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
            dataList.isEmpty && isLoading == false
                ? NoData()
                : SizedBox(
                    height: h,
                    child: ListView.builder(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
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
                                  onTap: () {},
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
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(
                                                        Icons
                                                            .delivery_dining_sharp,
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            '${dataList[index]['waybill_id']}',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: black,
                                                              fontSize: 14.dp,
                                                            )),
                                                        Text(
                                                            'Client:-${dataList[index]['cust_name']}',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 14.dp,
                                                            )),
                                                        Text(
                                                            '${dataList[index]['address']}',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 12.dp,
                                                            )),
                                                        Text(
                                                            'COD:-${dataList[index]['cod_final']}',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color
                                                                  .fromARGB(
                                                                      221,
                                                                      31,
                                                                      116,
                                                                      152),
                                                              fontSize: 14.dp,
                                                            )),
                                                        Text(
                                                            'Phone:-${dataList[index]['phone']}',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: Color
                                                                  .fromARGB(
                                                                      221,
                                                                      220,
                                                                      44,
                                                                      44),
                                                              fontSize: 14.dp,
                                                            )),
                                                        Text(
                                                            'Remark:-${dataList[index]['cust_internal']}',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 12.dp,
                                                            )),
                                                        Card(
                                                          elevation: 20,
                                                          margin:
                                                              EdgeInsets.all(0),
                                                          color: Color.fromARGB(
                                                              255, 62, 13, 130),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                                '${dataList[index]['status']}',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: white,
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
                                                          onPressed: () async {
                                                            final call = Uri.parse(
                                                                'tel:${dataList[index]['phone']}');
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
                                                      // Card(
                                                      //   elevation: 20,
                                                      //   shape: RoundedRectangleBorder(
                                                      //       borderRadius:
                                                      //           BorderRadius
                                                      //               .circular(
                                                      //                   100)),
                                                      //   child: IconButton(
                                                      //       onPressed:
                                                      //           () async {
                                                      //         MapUtils.openMap(
                                                      //             -3.823216,
                                                      //             -38.481700);
                                                      //       },
                                                      //       icon: Image.asset(
                                                      //           'assets/icons8-google-maps-old-30.png')),
                                                      // ),
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
            isLoading ? Loader().loader(context) : SizedBox()
          ],
        ),
      ),
    );
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
