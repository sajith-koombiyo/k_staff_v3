import 'dart:async';
import 'dart:developer';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/uI/main/map/pdf/pdf.dart';
import 'package:flutter_application_2/uI/widget/map/details.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/location.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/uI/main/map/sign.dart';
import 'package:flutter_application_2/uI/widget/diloag_button.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:url_launcher/url_launcher.dart';

class BranchList extends StatefulWidget {
  const BranchList({super.key});

  @override
  State<BranchList> createState() => _BranchListState();
}

class _BranchListState extends State<BranchList> {
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
    status0Count = 0;
    status1Count = 0;
    print('111122222222222222222222222222222222222222222222222');
    var temp = await CustomApi().getmypickups(context);
    var temp2 = await CustomApi().getMyPDeliveryMap(context);
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
    print(
        '111122sssssssssssssssssssssssssssssssssssssssssssssssssssss222222222222222222222222222222222222222222222');
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
  }

  @override
  void initState() {
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
        appBar: AppBar(
          backgroundColor: appliteBlue,
          title: Text(
            'Branch List',
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
        backgroundColor: Color.fromARGB(255, 229, 232, 238),
        body: SingleChildScrollView(
          child: SizedBox(
            height: h,
            child: Stack(
              children: [
                position == null
                    ? Loader().loader(context)
                    : GoogleMap(
                        padding: EdgeInsets.only(top: h / 2, bottom: 100),
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target:
                              LatLng(position!.latitude, position!.longitude),
                          zoom: 14.4746,
                        ),
                        markers: _marker,
                        onMapCreated: (GoogleMapController _controller) {},
                      ),
                isLoading ? Loader().loader(context) : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
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
}
