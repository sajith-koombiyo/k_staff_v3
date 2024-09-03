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
import 'package:flutter_application_2/uI/widget/diloag_button.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
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
  Position? position;
  bool isOpen = false;
  bool lConfirm = false;
  String newImage = '';
  String branchName = '';
  String visitBranchId = '';
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();
  String lat = '';
  String long = '';
  String image64 = '';
  // List userBranchList = [];
  String? selectval;
  List userBranchList = [];
  List branchList = [];
  List todayVisitBranchList = [];

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

  String MarkerTempId = '';

  List<Marker> markerList = <Marker>[];
  Set<Marker> _marker = {};

  userLocation() async {
    BitmapDescriptor markerBitMap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(40, 40)),
      "assets/green.png",
    );
    BitmapDescriptor markerBitMap2 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(40, 40)),
      "assets/blue.png",
    );
    BitmapDescriptor markerBitMap3 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(40, 40)),
      "assets/red.png",
    );
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    // var temp = await CustomApi().branchVisitHistroy(context);
    var temp2 = await CustomApi().shutteleVisitBrnchesList(context, '');
    log(temp2.toString());
    if (!mounted) return;
    setState(() {
      // branchList = temp;
      todayVisitBranchList = temp2;
      log(todayVisitBranchList.toString());
    });
    setState(() {
      List.generate(todayVisitBranchList.length, (index) {
        double lat = double.parse(todayVisitBranchList[index]['lati']);
        double long = double.parse(todayVisitBranchList[index]['longt']);

        Set<Marker> _markertemp = {
          Marker(
              onTap: () {
                setState(() {
                  isOpen = true;
                  branchName = todayVisitBranchList[index]['dname'];
                });
              },
              // icon: BitmapDescriptor.defaultMarkerWithHue(0.4),
              icon: markerBitMap3,
              infoWindow: InfoWindow(
                onTap: () {
                  setState(() {
                    branchName = todayVisitBranchList[index]['dname'];
                    isOpen = true;
                  });
                },
                title: todayVisitBranchList[index]['dname'],
              ),
              markerId: MarkerId(todayVisitBranchList[index]['did']),
              position: LatLng(lat, long))
        };

        _marker.addAll(_markertemp);
      });

      _marker;
      log(_marker.toString());
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
        text: 'Do you want to confirm branch visit',
        onConfirmBtnTap: () async {
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
              child: Stack(
                children: [
                  SizedBox(
                    height: h,
                    width: w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(),
                        lConfirm
                            ? Container(
                                color: Colors.blueGrey,
                                child: provider.lImage.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        child: Container(
                                            height: h / 2,
                                            width: w,
                                            child: Image.file(
                                              File(provider.lImage),
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
                                            height: h / 2,
                                            width: w,
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
                                                Text(
                                                    'Please upload \nyour image',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black38,
                                                      fontSize: 12.dp,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                              )
                            : Expanded(
                                child: GoogleMap(
                                  zoomGesturesEnabled: true,
                                  markers: _marker,
                                  onCameraMoveStarted: () {},
                                  padding:
                                      EdgeInsets.only(top: h / 2.0, bottom: 0),
                                  // on below line specifying map type.
                                  mapType: MapType.normal,
                                  // on below line setting user location enabled.
                                  myLocationEnabled: true,
                                  // on below line setting compass enabled.
                                  // zoomControlsEnabled: false,
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(7.8731, 80.7718),
                                    zoom: 8,
                                  ),
                                  onTap: (argument) {
                                    argument.latitude;
                                    argument.longitude;
                                    // MapUtils.openMap(
                                    //     argument.latitude, argument.longitude);
                                  },

                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _controller.complete(controller);
                                  },
                                ),
                              ),
                      ],
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
                          text: 'Confirm My Location',
                          onTap: () async {
                            info();
                          },
                          // buttonHeight: h / 16,
                          width: w / 1.5,
                          color: appButtonColorLite),
                    ),
                  )
                : null));
  }
}
