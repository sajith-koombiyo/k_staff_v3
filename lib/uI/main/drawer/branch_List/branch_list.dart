import 'dart:async';
import 'dart:developer';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/api/api.dart';

import 'package:flutter_application_2/provider/provider.dart';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class BranchList extends StatefulWidget {
  const BranchList({super.key});

  @override
  State<BranchList> createState() => _BranchListState();
}

class _BranchListState extends State<BranchList> {
  TextEditingController quantity = TextEditingController();
  Position? position;
  List branchList = [];
  MapController mapController = MapController();
  bool isDelivery = false;
  String lat = '';
  String lon = '';
  List<Marker> _marker = [];
  String branchName = '';
  String MarkerTempId = '';
  bool isLoading = false;
  List<Marker> markerList = <Marker>[];

  userLocation() async {
    var temp = await CustomApi().branchList(context);

    if (!mounted) return;
    setState(() {
      branchList = temp;
    });

    List.generate(branchList.length, (index) {
      double lat = double.parse(branchList[index]['lati']);
      double long = double.parse(branchList[index]['longt']);

      final _markertemp = <Marker>[
        Marker(
          // key: Key(pickupLocation[index]['pickr_id']),
          point: LatLng(lat, long),

          child: InkWell(
              onTap: () {}, child: Image.asset('assets/location_d.png')),
        )
      ];

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
                    : FlutterMap(
                        mapController: mapController,
                        // mapController: mapController,
                        options: MapOptions(
                          initialCenter: LatLng(7.8731, 80.7718),
                          minZoom: 8,
                          maxZoom: 40,
                          zoom: 7.5,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: ['a', 'b', 'c'],
                          ),
                          MarkerLayer(markers: _marker),
                        ],
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
