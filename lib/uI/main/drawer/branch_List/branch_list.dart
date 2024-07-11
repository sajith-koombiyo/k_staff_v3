import 'dart:async';
import 'dart:developer';
import 'package:flutter_application_2/class/class.dart';
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
  List branchList = [];

  bool isDelivery = false;
  String lat = '';
  String lon = '';

  String branchName = '';
  String MarkerTempId = '';
  bool isLoading = false;
  List<Marker> markerList = <Marker>[];
  Set<Marker> _marker = {};

  userLocation() async {
    var temp = await CustomApi().branchList(context);

    if (!mounted) return;
    setState(() {
      branchList = temp;
    });

    BitmapDescriptor markerBitMap2 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(5, 5), devicePixelRatio: 10),
      "assets/location_d.png",
    );

    List.generate(branchList.length, (index) {
      double lat = double.parse(branchList[index]['lati']);
      double long = double.parse(branchList[index]['longt']);

      Set<Marker> _markertemp = {
        Marker(
            icon: BitmapDescriptor.defaultMarkerWithHue(0.4),
            // icon: markerBitMap2,
            infoWindow: InfoWindow(title: branchList[index]['branch_name']),
            markerId: MarkerId(branchList[index]['branch_id']),
            position: LatLng(lat, long))
      };
      _marker.addAll(_markertemp);
    });
    setState(() {
      _marker;
    });
    
  }

  @override
  void initState() {
    getLocation();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller;

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
                position == null
                    ? Loader().loader(context)
                    : GoogleMap(
                        padding: EdgeInsets.only(top: h / 2, bottom: 100),
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(7.8731, 80.7718),
                          zoom: 7.4746,
                        ),
                        markers: _marker,
                        //  {
                        //   Marker(
                        //       markerId: MarkerId('5'),
                        //       position: LatLng(6.9271, 79.8612))
                        // },
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
