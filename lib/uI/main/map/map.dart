import 'dart:async';
import 'dart:developer';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/location.dart';
import 'package:flutter_application_2/provider/provider.dart';

import 'package:flutter_application_2/uI/widget/diloag_button.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../class/class.dart';
import '../../widget/map/details.dart';
import 'pdf/pdf.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
      
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  TextEditingController quantity = TextEditingController();
  Position? position;
  List pickupLocation = [];
  List deliveryLocation = [];
  int qnt = 0;
  bool isDelivery = false;
  String accept = '';
  int x = 0;
  String lat = '';
  String lon = '';
  double dLat = 0.0;
  double dLong = 0.0;
  String name = '';
  String address = '';
  String phone = '';
  String pickId = '';
  String COD = '';
  String MarkerTempId = '';
  int status0Count = 0;
  int status1Count = 0;
  bool isLoading = false;
  List<Marker> markerList = <Marker>[];
  Set<Marker> _marker = {};
  List barcodeScanData = [];
  bool sign = false;
  final SignatureController _signController = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.red,
    exportBackgroundColor: Colors.transparent,
    exportPenColor: Colors.black,
    onDrawStart: () => log('onDrawStart called!'),
    onDrawEnd: () => log('onDrawEnd called!'),
  );
  userLocation() async {
    setState(() {
      isLoading = true;
    });
    status0Count = 0;
    status1Count = 0;
    var temp = await CustomApi().getmypickups(context);
    var temp2 = await CustomApi().getMyPDeliveryMap(context);
    print(temp);
    log(temp2.toString());
    if (!mounted) return;
    setState(() {
      pickupLocation = temp;
      deliveryLocation = temp2;
      for (var item in pickupLocation) {
        if (item['accept'] == 0) {
        } else if (item['accept'] == 1) {
          status1Count++;
        }
      }
    });
    BitmapDescriptor markerBitMap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(40, 40)),
      "assets/location_pin_gradient_set-red.png",
    );
    BitmapDescriptor markerBitMap2 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(40, 40)),
      "assets/location_d.png",
    );
    BitmapDescriptor markerBitMap3 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(40, 40)),
      "assets/delivey2.png",
    );

    List.generate(pickupLocation.length, (index) {
      if (pickupLocation[index]['accept'] == '0') {
        status0Count++;
        setState(() {
          status0Count;
        });
      } else if (pickupLocation[index]['accept'] == '1') {
        status1Count++;
        setState(() {
          status1Count;
        });
      }
      double lat = double.parse(pickupLocation[index]['lati']);
      double long = double.parse(pickupLocation[index]['longt']);
      Set<Marker> _markertemp = {
        Marker(
            onTap: () async {
              if (!mounted) return;
              setState(() {
                Provider.of<ProviderS>(context, listen: false)
                    .isAppbarsheerOpen = true;

                isDelivery = false;
                name = pickupLocation[index]['cust_name'];
                address = pickupLocation[index]['address'];
                phone = pickupLocation[index]['phone'];
                pickId = pickupLocation[index]['pickr_id'];
                accept = pickupLocation[index]['accept'];
                // MapUtils.openMap(list[index]['lat'], list[index]['lon']);
              });
            },
            visible: true,
            icon: pickupLocation[index]['accept'] == '0'
                ? markerBitMap
                : markerBitMap2,
            infoWindow: InfoWindow(
                title: pickupLocation[index]['staff_name'],
                snippet: pickupLocation[index]['cust_name'],
                onTap: () {}),
            markerId: MarkerId(pickupLocation[index]['pickr_id']),
            position: LatLng(lat, long)),
      };
      _marker.addAll(_markertemp);
    });
    List.generate(deliveryLocation.length, (index) {
      double lat = double.parse(deliveryLocation[index]['latitude']);
      double long = double.parse(deliveryLocation[index]['longitude']);

      Set<Marker> _markertemp2 = {
        Marker(
            onTap: () async {
              if (!mounted) return;
              setState(() {
                Provider.of<ProviderS>(context, listen: false)
                    .isAppbarsheerOpen = true;

                isDelivery = true;
                name = deliveryLocation[index]['name'];
                address = deliveryLocation[index]['address'];
                phone = deliveryLocation[index]['phone'];
                pickId = deliveryLocation[index]['waybill_id'];
                COD = deliveryLocation[index]['cod_final'];
                dLat = double.parse(deliveryLocation[index]['latitude']);
                dLong = double.parse(deliveryLocation[index]['longitude']);
                // accept = deliveryLocation[index]['accept'];
                // MapUtils.openMap(dLat, dLong);
              });
            },
            visible: true,
            icon: markerBitMap3,
            infoWindow: InfoWindow(
                title: deliveryLocation[index]['name'],
                snippet: deliveryLocation[index]['address'],
                onTap: () {}),
            markerId: MarkerId(deliveryLocation[index]['waybill_id']),
            position: LatLng(lat, long)),
      };
      _marker.addAll(_markertemp2);
    });

    _marker.isEmpty
        ? notification().warning(
            context, 'Any delivery location is not available at this moment.')
        : null;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    userLocation();
    getLocation();
    _signController.addListener(() {
      log('Value changed');
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller;
    _signController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Consumer<ProviderS>(
      builder: (context, provider, child) => Scaffold(
        backgroundColor: Color.fromARGB(255, 229, 232, 238),
        body: SingleChildScrollView(
          child: SizedBox(
            height: h,
            child: Stack(
              children: [
                // position == null
                //     ? Loader().loader(context)
                //     :
                GoogleMap(
                  padding: EdgeInsets.only(top: h / 2, bottom: 100),
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(7.8731, 80.7718),
                    // LatLng(position!.latitude, position!.longitude),
                    zoom: 8,
                  ),
                  markers: _marker,
                  onMapCreated: (GoogleMapController _controller) {},
                ),
                Positioned(
                  top: 100,
                  left: 10,
                  child: Card(
                    shape: Border.all(color: Colors.transparent),
                    elevation: 20,
                    color: black.withOpacity(0.6),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  height: 15,
                                  child: Image.asset(
                                      'assets/location_pin_gradient_set-red.png')),
                              SizedBox(
                                width: 4,
                              ),
                              SizedBox(
                                width: 55,
                                child: Text(
                                  'Pending',
                                  style: TextStyle(color: white, fontSize: 12),
                                ),
                              ),
                              Text(
                                '${status0Count.toString()}',
                                style: TextStyle(color: white, fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  height: 15,
                                  child: Image.asset('assets/location_d.png')),
                              SizedBox(
                                width: 4,
                              ),
                              SizedBox(
                                width: 55,
                                child: Text(
                                  'Accept',
                                  style: TextStyle(color: white, fontSize: 12),
                                ),
                              ),
                              Text(
                                '${status1Count.toString()}',
                                style: TextStyle(color: white, fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  height: 15,
                                  child: Image.asset('assets/delivey2.png')),
                              SizedBox(
                                width: 4,
                              ),
                              SizedBox(
                                width: 55,
                                child: Text(
                                  'Delivery',
                                  style: TextStyle(color: white, fontSize: 12),
                                ),
                              ),
                              Text(
                                '${deliveryLocation.length}',
                                style: TextStyle(color: white, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Provider.of<ProviderS>(context, listen: false).isAppbarsheerOpen
                    ? appbarSheet()
                    : SizedBox(),
                isLoading ? Loader().loader(context) : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  siganature() {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, SetState) {
        return AlertDialog(
          scrollable: true,
          insetPadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.zero,
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: CircleAvatar(
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                      ),
                    ),
                  ),
                ),
                Text(
                  'Customer Signature',
                  style: TextStyle(color: black, fontSize: 17),
                ),
                SizedBox(
                  height: 10,
                ),
                Signature(
                  key: const Key('signature'),
                  controller: _signController,
                  height: 300,
                  backgroundColor: Color.fromARGB(255, 9, 1, 51)!,
                ),

                Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.undo),
                        color: Colors.blue,
                        onPressed: () {
                          setState(() => _signController.undo());
                        },
                        tooltip: 'Undo',
                      ),
                      IconButton(
                        icon: const Icon(Icons.redo),
                        color: Colors.blue,
                        onPressed: () {
                          setState(() => _signController.redo());
                        },
                        tooltip: 'Redo',
                      ),
                      //CLEAR CANVAS
                      IconButton(
                        key: const Key('clear'),
                        icon: const Icon(Icons.clear),
                        color: Colors.blue,
                        onPressed: () {
                          setState(() => _signController.clear());
                        },
                        tooltip: 'Clear',
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: DialogButton(
                      text: 'Save',
                      onTap: () {
                        exportImage(context);
                      },
                      buttonHeight: h / 17,
                      width: w / 1.5,
                      color: Colors.green),
                ),
                // IconButton(
                //   key: const Key('exportSVG'),
                //   icon: const Icon(Icons.share),
                //   color: Colors.blue,
                //   onPressed: () => exportSVG(context),
                //   tooltip: 'Export SVG',
                // ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> exportImage(BuildContext context) async {
    if (_signController.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          key: Key('snackbarPNG'),
          content: Text('No content'),
        ),
      );
      return;
    }

    final Uint8List? data = await _signController.toPngBytes(
      height: 300,
    );
    if (data == null) {
      return;
    }

    if (!mounted) return;
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      print(format);
      return PDFView().makePdf(context, data);
    });
    setState(() {
      sign = true;
    });
    Navigator.pop(context);
  }

  void getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.deniedForever) {
      await openAppSettings().then((value) => getLocation());
      print('sssssssssssssssssssssssssssssssssssss');
      // _checkLocationPermission();
      permission = await Geolocator.requestPermission();
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (!mounted) return;
    Future.delayed(const Duration(milliseconds: 200), () async {
      setState(() {
        position;
        log(position.toString());
      });
      userLocation();
    });
  }

  Future<void> _checkLocationPermission() async {
    PermissionStatus permissionStatus = await Permission.location.status;
    if (permissionStatus == PermissionStatus.denied) {
      await openAppSettings().then((value) => getLocation());
    } else if (permissionStatus == PermissionStatus.granted) {}
  }

  appbarSheet() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return AnimationLimiter(
      child: AnimationConfiguration.synchronized(
        child: SlideAnimation(
          verticalOffset: -300,
          child: Card(
            color: black.withOpacity(0.9),
            elevation: 20,
            child: SlideAnimation(
              verticalOffset: 300,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                    isDelivery
                        ? Stack(
                            children: [
                              SlideAnimation(
                                horizontalOffset: -200,
                                duration: Duration(milliseconds: 900),
                                child: FadeInAnimation(
                                  child: Detail(
                                    onTap: () {},
                                    icon: Icons.info,
                                    color: Color.fromARGB(255, 138, 101, 7),
                                    title2: pickId,
                                    title: 'Waybill Id',
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                right: 8,
                                child: IconButton(
                                    onPressed: () {
                                      Clipboard.setData(
                                              ClipboardData(text: pickId))
                                          .then((_) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Waybill Id copied to clipboard")));
                                      });
                                    },
                                    icon: Icon(
                                      Icons.copy,
                                      color: appliteBlue2,
                                    )),
                              )
                            ],
                          )
                        : SizedBox(),
                    SlideAnimation(
                      horizontalOffset: 200,
                      duration: Duration(milliseconds: 900),
                      child: FadeInAnimation(
                        child: Detail(
                          onTap: () {},
                          icon: Icons.person,
                          color: Color.fromARGB(255, 11, 53, 124),
                          title2: name,
                          title: 'Name',
                        ),
                      ),
                    ),
                    SlideAnimation(
                      horizontalOffset: -200,
                      duration: Duration(milliseconds: 500),
                      child: FadeInAnimation(
                        child: Detail(
                          onTap: () {},
                          icon: Icons.home,
                          color: Color.fromARGB(255, 20, 143, 29),
                          title2: address,
                          title: 'Address',
                        ),
                      ),
                    ),
                    isDelivery
                        ? SlideAnimation(
                            horizontalOffset: 200,
                            duration: Duration(milliseconds: 900),
                            child: FadeInAnimation(
                              child: Detail(
                                onTap: () {},
                                icon: Icons.monetization_on,
                                color: Color.fromARGB(255, 93, 2, 107),
                                title2: COD,
                                title: 'COD',
                              ),
                            ),
                          )
                        : SizedBox(),
                    SlideAnimation(
                      horizontalOffset: -200,
                      duration: Duration(milliseconds: 700),
                      child: FadeInAnimation(
                        child: Detail(
                          onTap: () async {
                            final call = Uri.parse('tel:$phone');
                            if (await canLaunchUrl(call)) {
                              launchUrl(call);
                            } else {
                              throw 'Could not launch $call';
                            }
                          },
                          icon: Icons.call,
                          color: Color.fromARGB(255, 255, 20, 20),
                          title2: phone,
                          title: 'Phone',
                        ),
                      ),
                    ),
                    isDelivery == false && accept == '1'
                        ? Card(
                            child: TextField(
                                // readOnly: true,
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   PageTransition(
                                  //       type: PageTransitionType.leftToRight,
                                  //       duration: Duration(milliseconds: 600),
                                  //       child: BarcodeScanDeliveryItem(),
                                  //       inheritTheme: true,
                                  //       ctx: context),
                                  // );
                                },
                                controller: quantity,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: 'Scan your pickups',
                                    contentPadding: EdgeInsets.all(8),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.edit,
                                        size: 47,
                                      ),
                                    ),
                                    fillColor: white3,
                                    filled: true,
                                    suffixIcon: IconButton(
                                        onPressed: () async {
                                          scanBarcodeNormal();
                                        },
                                        icon:
                                            Icon(Icons.qr_code_scanner_sharp)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(11)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(11)))),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 10,
                    ),
                    isDelivery
                        ? SizedBox()
                        : SlideAnimation(
                            verticalOffset: 200,
                            duration: Duration(milliseconds: 900),
                            child: DialogButton(
                                text: accept == '0'
                                    ? 'Accept'
                                    // : sign == false
                                    //     ? 'Signature'
                                    : "Pickup",
                                onTap: accept == '0'
                                    ? () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        await CustomApi()
                                            .sendSms(phone, pickId, context);
                                        await userLocation();
                                        setState(() {
                                          Provider.of<ProviderS>(context,
                                                  listen: false)
                                              .isAppbarsheerOpen = false;

                                          isLoading = false;
                                        });
                                      }
                                    // : sign == false
                                    //     ? () {
                                    //         print('ffffffffffffffffffffff');
                                    //         siganature();
                                    //       }
                                    : () async {
                                   
                                        if (quantity.text.isNotEmpty) {
                                          int qnt = int.parse(quantity.text);
                                          if (qnt < 5000) {
                                            if (qnt != 0) {
                                              setState(() {
                                                isLoading = true;
                                              });

                                              await CustomApi().pickupComplete(
                                                  context,
                                                  pickId,
                                                  quantity.text,
                                                  phone);
                                              print(
                                                  '444444444444eeeeeeeeeee4444444');
                                              _marker.clear();
                                              await userLocation();
                                              // _marker.remove(value)
                                              await CustomApi().sendSms(
                                                  phone, pickId, context);
                                              print('4444444444444444444');
                                              setState(() {
                                                Provider.of<ProviderS>(context,
                                                        listen: false)
                                                    .isAppbarsheerOpen = false;

                                                isLoading = false;
                                              });
                                            } else {
                                              notification().info(
                                                  context, 'Invalid Quantity');
                                            }
                                          } else {
                                            notification().info(
                                                context, 'Invalid Quantity');
                                          }
                                        } else {
                                          notification().info(
                                              context, 'Quantity is required');
                                        }
                                      },
                                buttonHeight: h / 14,
                                width: w / 1.5,
                                color: accept == '0'
                                    ? appBlue
                                    : Color.fromARGB(255, 186, 122, 12)),
                          ),
                    isDelivery
                        ? SlideAnimation(
                            verticalOffset: 200,
                            duration: Duration(milliseconds: 900),
                            child: Stack(
                              children: [
                                DialogButton(
                                  buttonHeight: h / 15,
                                  color: Colors.green,
                                  onTap: () {
                                    MapUtils.openMap(dLat, dLong);
                                  },
                                  text: 'Get Direction',
                                  width: w / 1.5,
                                ),
                                Positioned(
                                    child: Image.asset(
                                        'assets/icons8-google-maps-old-48.png'))
                              ],
                            ))
                        : SizedBox(),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _signController.clear();
                          Provider.of<ProviderS>(context, listen: false)
                              .isAppbarsheerOpen = false;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 204, 201, 201),
                              borderRadius: BorderRadius.circular(5)),
                          height: 5,
                          width: 70,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
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
        quantity.text = "";
      } else {
        barcodeScanData.add(_scanBarcode.toString());
        print(barcodeScanData);
        quantity.text = " Quantity ${barcodeScanData.length.toString()}";
      }
    });
  }

  Future<void> scanBarcodeNormal2() async {
    // QrImageView(
    //   data: 'This QR code will show the error state instead',
    //   version: 1,
    //   size: 320,
    //   gapless: false,
    //   errorStateBuilder: (cxt, err) {
    //     return Container(
    //       child: Center(
    //         child: Text(
    //           'Uh oh! Something went wrong...',
    //           textAlign: TextAlign.center,
    //         ),
    //       ),
    //     );
    //   },
    // );

    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      var _scanBarcode = barcodeScanRes;
      if (_scanBarcode == "-1") {
        // search.text = "";
      } else {
        // search.text = _scanBarcode.toString();
        // getData(true);
      }
    });
  }
}
