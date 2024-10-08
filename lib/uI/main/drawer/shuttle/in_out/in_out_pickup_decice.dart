import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/uI/main/drawer/genaral/branch_visit/branch_visit_history.dart';
import 'package:flutter_application_2/uI/main/navigation/navigation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:geolocator/geolocator.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../../widget/diloag_button.dart';

class InOutPickupDevice extends StatefulWidget {
  const InOutPickupDevice({super.key});

  @override
  State<InOutPickupDevice> createState() => _InOutPickupDeviceState();
}

class _InOutPickupDeviceState extends State<InOutPickupDevice> {
  MapController mapController = MapController();
  Position? position;
  bool isOpen = false;
  bool lConfirm = false;
  String newImage = '';
  String visitBranchId = '';
  bool isLoading = false;
  String lat = '';
  String long = '';
  String? selectval;
  List userBranchList = [];
  List branchList = [];
  String branchName = '';
  String MarkerTempId = '';
  List<Marker> markerList = <Marker>[];
  List<Marker> _marker = [];
  List<Polyline>? polylines = [];
  List<LatLng> _latLong = [];
  String routName = '';
  @override
  void initState() {
    getLocation();
    userLocation();

    // TODO: implement initState
    super.initState();
  }

  void getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.deniedForever) {
      _checkLocationPermission();
      permission = await Geolocator.requestPermission();
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      position;
    });
  }

  void update() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.deniedForever) {
      _checkLocationPermission();
      permission = await Geolocator.requestPermission();
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var res = await CustomApi().shuttleVisitConfirm(
      context,
      visitBranchId,
      position!.latitude.toString(),
      position!.longitude.toString(),
    );

    Navigator.pop(context);
    Navigator.pop(context);
    setState(() {
      position;
      isLoading = false;
    });
  }

  userLocation() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    var temp2 = await CustomApi().shutteleVisitBrnchesList(context, '');
    log(temp2.toString());
    if (!mounted) return;
    setState(() {
      if (temp2['branches'] == null) {
        branchList = [];
        log('ccccccccccccccvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');
      } else {
        routName = temp2['route_name'];
        branchList = temp2['branches'];
        List.generate(branchList.length, (index) {
          double lat = double.parse(branchList[index]['lati']);
          double long = double.parse(branchList[index]['longt']);
          List<LatLng> _latLongTemp = [LatLng(lat, long)];

          Polyline(
            points: [],
            strokeWidth: 4.0,
            color: Colors.blue,
          );
          final _markertemp = <Marker>[
            Marker(
              // key: Key(pickupLocation[index]['pickr_id']),
              point: LatLng(lat, long),

              child: InkWell(
                  onTap: () {
                    setState(() {
                      branchName = branchList[index]['dname'];
                      isOpen = true;
                      visitBranchId = branchList[index]['did'];
                    });
                  },
                  child: Image.asset('assets/red.png')),
            )
          ];
          _latLong.addAll(_latLongTemp);
          _marker.addAll(_markertemp);
        });
      }
    });

    // setState(() {
    //   _latLong;
    //   _marker;
    // });
  }

  Future<void> _checkLocationPermission() async {
    PermissionStatus permissionStatus = await Permission.location.status;
    if (permissionStatus == PermissionStatus.denied) {
      await openAppSettings().then((value) => getLocation());
    } else if (permissionStatus == PermissionStatus.granted) {}
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Consumer<ProviderS>(
        builder: (context, provider, child) => Scaffold(
            floatingActionButton: lConfirm
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: FloatingActionButton.small(
                        backgroundColor: white.withOpacity(0.5),
                        child: Icon(Icons.location_searching_rounded),
                        onPressed: () {
                          Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.high)
                              .then((pickedCurrentLocation) {
                            setState(() {
                              position = pickedCurrentLocation;
                            });
                            mapController.move(
                                LatLng(position!.latitude, position!.longitude),
                                2);
                          });
                        }),
                  ),
            appBar: AppBar(
              backgroundColor: appliteBlue,
              title: Text(
                'In Out',
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
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BranchVisitHistory(),
                          ));
                    },
                    icon: Icon(
                      Icons.history,
                      color: white,
                    ))
              ],
            ),
            backgroundColor: Color.fromARGB(255, 229, 232, 238),
            body: Padding(
              padding: EdgeInsets.only(bottom: isOpen ? 70 : 0),
              child: position == null
                  ? Loader().loader(context)
                  : Stack(
                      children: [
                        SizedBox(
                          height: h,
                          width: w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: FlutterMap(
                                  mapController: mapController,
                                  // mapController: mapController,
                                  options: MapOptions(
                                    initialCenter: LatLng(7.8731, 80.7718),
                                    minZoom: 8,
                                    maxZoom: 40,
                                    zoom: 7.9,
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      subdomains: ['a', 'b', 'c'],
                                    ),
                                    PolylineLayer(polylines: [
                                      Polyline(
                                        points: _latLong,
                                        strokeWidth: 4.0,
                                        color: Colors.blue,
                                      ),
                                    ]),
                                    MarkerLayer(markers: _marker),
                                    MarkerLayer(markers: [
                                      Marker(
                                          point: LatLng(position!.latitude,
                                              position!.longitude),
                                          child: Icon(
                                            Icons.person_pin_circle_rounded,
                                            size: 40,
                                            color:
                                                Color.fromARGB(255, 240, 27, 4),
                                          ))
                                    ]),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        branchName != ""
                            ? Positioned(
                                right: 12,
                                top: 12,
                                child: Card(
                                    elevation: 20,
                                    color: Color.fromARGB(255, 248, 252, 250),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        branchName,
                                        style: TextStyle(color: black),
                                      ),
                                    )),
                              )
                            : SizedBox(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              elevation: 20,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Route Name "),
                                    Text("-$routName",
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 175, 13, 13),
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Card(
                            elevation: 20,
                            color: Colors.black38,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 70,
                                        child: Text("Start",
                                            style: TextStyle(
                                                color: white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Image.asset(
                                        'assets/1.png',
                                        height: 25,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 70,
                                        child: Text("On Time",
                                            style: TextStyle(
                                                color: white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Image.asset(
                                        'assets/2.png',
                                        height: 25,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 70,
                                        child: Text("Late",
                                            style: TextStyle(
                                                color: white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Image.asset(
                                        'assets/3.png',
                                        height: 25,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        isLoading ? Loader().loader(context) : SizedBox(),
                        provider.isanotherUserLog
                            ? UserLoginCheck()
                            : SizedBox()
                      ],
                    ),
            ),
            bottomSheet: isOpen
                ? Padding(
                    padding: const EdgeInsets.only(
                        bottom: 30, left: 8, right: 8, top: 10),
                    child: Container(
                      height: h / 16 + 10,
                      alignment: Alignment.center,
                      width: w,
                      child: DialogButton(
                          text: 'Confirm My Location',
                          onTap: () async {
                            info();
                          },
                          buttonHeight: h / 16,
                          width: w / 1.5,
                          color: appButtonColorLite),
                    ),
                  )
                : null));
  }

  info() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    QuickAlert.show(
        onCancelBtnTap: () {
          setState(() {
            isLoading = false;
            ;
          });
          Navigator.pop(context);
        },
        context: context,
        type: QuickAlertType.confirm,
        barrierDismissible: true,
        confirmBtnText: 'Confirm',
        widget: Provider.of<ProviderS>(context, listen: false).isAppbarsheerOpen
            ? Loader().loader(context)
            : SizedBox(),
        title: branchName,
        text: 'Do you want to confirm branch visit',
        onConfirmBtnTap: () async {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.loading,
            title: 'Loading',
            text: 'Fetching your data',
          );
          update();
        });
  }
}
