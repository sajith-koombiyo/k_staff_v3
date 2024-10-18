import 'dart:async';
import 'dart:developer';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../app_details/color.dart';

class BranchListGoogleMap extends StatefulWidget {
  const BranchListGoogleMap({super.key, required this.isDower});
  final int isDower;

  @override
  State<BranchListGoogleMap> createState() => _BranchListGoogleMapState();
}

class _BranchListGoogleMapState extends State<BranchListGoogleMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  TextEditingController quantity = TextEditingController();
  Position? position;
  List BranchListGoogleMap = [];

  bool isDelivery = false;
  double lat = 0.0;
  double lon = 0.0;
  String bName = '';

  String branchName = '';
  String MarkerTempId = '';
  bool isLoading = false;
  List<Marker> markerList = <Marker>[];
  Set<Marker> _marker = {};

  userLocation() async {
    var temp = await CustomApi().branchList(context);

    if (!mounted) return;
    setState(() {
      BranchListGoogleMap = temp;
    });

    BitmapDescriptor markerBitMap2 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(5, 5), devicePixelRatio: 10),
      "assets/location_d.png",
    );

    List.generate(BranchListGoogleMap.length, (index) {
      lat = double.parse(BranchListGoogleMap[index]['lati']);
      lon = double.parse(BranchListGoogleMap[index]['longt']);
      bName = BranchListGoogleMap[index]['branch_name'];
      Set<Marker> _markertemp = {
        Marker(
            onTap: () {
              setState(() {
                lat = double.parse(BranchListGoogleMap[index]['lati']);
                lon = double.parse(BranchListGoogleMap[index]['longt']);
                bName = BranchListGoogleMap[index]['branch_name'];
              });
            },
            icon: BitmapDescriptor.defaultMarkerWithHue(0.4),
            // icon: markerBitMap2,
            infoWindow: InfoWindow(
              title: BranchListGoogleMap[index]['branch_name'],
            ),
            markerId: MarkerId(BranchListGoogleMap[index]['branch_id']),
            position: LatLng(lat, lon))
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
        backgroundColor: backgroundColor2,
        appBar: widget.isDower == 1
            ? AppBar(
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
              )
            : null,
        body: SizedBox(
          height: h,
          child: Stack(
            children: [
              position == null
                  ? Loader().loader(context)
                  : Stack(
                      children: [
                        GoogleMap(
                          zoomControlsEnabled: widget.isDower == 1,
                          padding: EdgeInsets.only(top: h / 2, bottom: 10),
                          initialCameraPosition: CameraPosition(
                            target: LatLng(7.8731, 80.7718),
                            zoom: 7.5,
                          ),
                          markers: _marker,
                          onMapCreated: (GoogleMapController _controller) {},
                        ),
                        widget.isDower == 1
                            ? lat != 0.0
                                ? Positioned(
                                    right: 12,
                                    top: 12,
                                    child: InkWell(
                                      onTap: () async {
                                        await FlutterShare.share(
                                            title: bName,
                                            text:
                                                'share $bName branch location',
                                            linkUrl:
                                                'https://www.google.com/maps/search/?api=1&query=${lat},${lon}',
                                            chooserTitle: bName);
                                      },
                                      child: Card(
                                        margin: EdgeInsets.all(4),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.share,
                                            color: Color.fromARGB(
                                                255, 207, 17, 39),
                                          ),
                                        ),
                                      ),
                                    ))
                                : SizedBox()
                            : SizedBox()
                      ],
                    ),
              isLoading ? Loader().loader(context) : SizedBox()
            ],
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
