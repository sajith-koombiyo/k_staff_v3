import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/uI/main/drawer/genaral/branch_visit/branch_visit_history.dart';
import 'package:flutter_application_2/uI/main/navigation/navigation.dart';
import 'package:flutter_application_2/uI/widget/diloag_button.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class InOutUpdateGoogleMap extends StatefulWidget {
  const InOutUpdateGoogleMap({super.key});

  @override
  State<InOutUpdateGoogleMap> createState() => _InOutUpdateGoogleMapState();
}

class _InOutUpdateGoogleMapState extends State<InOutUpdateGoogleMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Polyline> _polylines = {};
  Position? position;
  bool isOpen = false;
  bool lConfirm = false;
  String newImage = '';
  String branchName = '';
  String visitBranchId = '';
  bool isLoading = false;
  String routName = '';
  String visitStatus = '';
  String lat = '';
  String long = '';
  String image64 = '';
  LatLng? fLatLong;
  double mapZoom = 9;
  bool isBranchIn = false;
  // List userBranchList = [];
  String? selectval;
  List userBranchList = [];
  List branchList = [];
  List todayVisitBranchList = [];
  List<LatLng> _latLong = [];
  @override
  void initState() {
    // getLocation();
    userLocation();
    // TODO: implement initState
    super.initState();
  }

  getLocation() async {
    setState(() {
      isLoading = true;
    });
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.deniedForever) {
      _checkLocationPermission();
      permission = await Geolocator.requestPermission();
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (isBranchIn) {
      log('vvvvvvxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');
      var res = await CustomApi().shuttleExit(
        context,
        visitBranchId,
        visitStatus,
        position!.latitude.toString(),
        position!.longitude.toString(),
      );

      log(visitBranchId);
      log(visitStatus);
      log(position!.latitude.toString());
      log(position!.longitude.toString());
    } else {
      log('bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb');
      var res = await CustomApi().shuttleVisitConfirm(
        context,
        visitBranchId,
        position!.latitude.toString(),
        position!.longitude.toString(),
      );
    }

    setState(() {
      _marker.clear();
      position;
      isLoading = false;
    });
    await userLocation();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  String MarkerTempId = '';

  List<Marker> markerList = <Marker>[];
  Set<Marker> _marker = {};

  userLocation() async {
    BitmapDescriptor markerBitMap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(30, 30)),
      "assets/1.png",
    );
    BitmapDescriptor markerBitMap2 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(30, 30)),
      "assets/2.png",
    );
    BitmapDescriptor markerBitMap3 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(30, 30)),
      "assets/3.png",
    );
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    // var temp = await CustomApi().branchVisitHistroy(context);
    var temp2 = await CustomApi().shutteleVisitBrnchesList(context, '');
    log(temp2.toString());
    if (!mounted) return;

    setState(() {
      // branchList = temp;
      if (temp2['branches'] == null) {
        log('vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');
        todayVisitBranchList = [];

        isLoading = false;
        fLatLong = LatLng(7.8731, 80.7718);
        mapZoom = 7;
      } else {
        mapZoom = 9;
        todayVisitBranchList = temp2['branches'];
        double lat = double.parse(todayVisitBranchList[0]['lati']);
        double long = double.parse(todayVisitBranchList[0]['longt']);
        fLatLong = LatLng(lat, long);
        routName = temp2['route_name'];
        setState(() {
          _polylines.clear();
          _latLong.clear();
          List.generate(todayVisitBranchList.length, (index) async {
            double lat = double.parse(todayVisitBranchList[index]['lati']);
            double long = double.parse(todayVisitBranchList[index]['longt']);
            log(todayVisitBranchList[index]['shv_status'].toString());
            List<LatLng> _latLongTemp = [LatLng(lat, long)];

            Set<Marker> _markertemp = {
              Marker(
                  onTap: () {
                    setState(() {
                      isOpen = true;
                      branchName = todayVisitBranchList[index]['dname'];
                      visitBranchId = todayVisitBranchList[index]['did'];
                      visitStatus =
                          todayVisitBranchList[index]['shv_id'].toString();
                      if (todayVisitBranchList[index]['shv_status']
                              .toString() ==
                          "null") {
                        isBranchIn = false;

                        log('vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');
                      } else {
                        log('vvvvvvvvvvvvvvvvvvvvvvvvvvxxxxxxxxxxxxxxxxxxxxxxxvvvvvvvvvvvvvvvvv');
                        isBranchIn = true;
                      }
                    });
                  },
                  // icon: BitmapDescriptor.defaultMarkerWithHue(0.4),
                  icon: await todayVisitBranchList[index]['shv_status']
                              .toString() ==
                          "2"
                      ? markerBitMap3
                      : await todayVisitBranchList[index]['shv_status']
                                  .toString() ==
                              "0"
                          ? markerBitMap2
                          : markerBitMap,
                  infoWindow: InfoWindow(
                    onTap: () {
                      setState(() {
                        branchName = todayVisitBranchList[index]['dname'];
                        isOpen = true;
                      });
                    },
                    title: "     ${todayVisitBranchList[index]['dname']}     ",
                  ),
                  markerId: MarkerId(todayVisitBranchList[index]['did']),
                  position: LatLng(lat, long))
            };

            _polylines = {
              Polyline(
                polylineId: PolylineId(todayVisitBranchList[index]['did']),
                points: _latLong,
                color: Color.fromARGB(255, 238, 3, 73),
                width: 5,
                endCap: Cap.roundCap,
                geodesic: false,
              )
            };

            _latLong.addAll(_latLongTemp);
            _marker.addAll(_markertemp);
          });
          _polylines;
          _latLong;
          _marker;
          log(_marker.toString());
          isLoading = false;
        });
      }
    });
  }

  Future<void> _checkLocationPermission() async {
    setState(() {
      isLoading = true;
    });
    PermissionStatus permissionStatus = await Permission.location.status;
    if (permissionStatus == PermissionStatus.denied) {
      await openAppSettings().then((value) => getLocation());
    } else if (permissionStatus == PermissionStatus.granted) {}
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
        text: isBranchIn
            ? 'Dou you want to Exit branch'
            : 'Do you want to confirm branch visit',
        onConfirmBtnTap: () {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.loading,
            title: 'Loading',
            text: 'Fetching your data',
          );
          getLocation();
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
              title: Text(
                'Shuttle In Out',
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
              child: Stack(
                children: [
                  isLoading || fLatLong == null
                      ? Loader().loader(context)
                      : GoogleMap(
                          polylines: _polylines,
                          zoomGesturesEnabled: true,
                          markers: _marker,
                          onCameraMoveStarted: () {},
                          padding: EdgeInsets.only(top: h / 2.0, bottom: 0),
                          // on below line specifying map type.
                          mapType: MapType.normal,
                          // on below line setting user location enabled.
                          myLocationEnabled: true,
                          // on below line setting compass enabled.
                          // zoomControlsEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: fLatLong!,
                            zoom: mapZoom,
                          ),
                          onTap: (argument) {
                            argument.latitude;
                            argument.longitude;
                            // MapUtils.openMap(
                            //     argument.latitude, argument.longitude);
                          },

                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        ),
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
                  provider.isanotherUserLog ? UserLoginCheck() : SizedBox()
                ],
              ),
            ),
            bottomSheet: isOpen
                ? Padding(
                    padding: const EdgeInsets.only(
                        bottom: 30, left: 8, right: 8, top: 10),
                    child: Container(
                      color: Colors.transparent,
                      height: h / 13,
                      alignment: Alignment.center,
                      width: w,
                      child: DialogButton(
                          buttonHeight: h / 17,
                          text: isBranchIn ? 'Branch Out' : 'Branch In',
                          onTap: () async {
                            info();
                          },
                          // buttonHeight: h / 16,
                          width: w / 1.5,
                          color: isBranchIn
                              ? Color.fromARGB(255, 10, 194, 4)
                              : appButtonColorLite),
                    ),
                  )
                : null));
  }
}
