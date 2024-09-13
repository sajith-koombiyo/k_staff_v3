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

class AllRout extends StatefulWidget {
  const AllRout({super.key});

  @override
  State<AllRout> createState() => _AllRoutState();
}

class _AllRoutState extends State<AllRout> {
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
  String lat = '';
  String long = '';
  String image64 = '';
  LatLng? fLatLong;
  double mapZoom = 9;
  // List userBranchList = [];
  String? selectval;
  List userBranchList = [];
  List branchList = [];
  List todayVisitBranchList = [];
  List<LatLng> _latLong = [];
  String MarkerTempId = '';

  List<Marker> markerList = <Marker>[];
  Set<Marker> _marker = {};

  var data = {
    "r1": [
      {
        "shb_branch": "88",
        "shb_order": "2",
        "dname": "Katupotha",
        "did": "88",
        "lati": "7.534472",
        "longt": "80.185883",
        "shv_status": "null"
      },
      {
        "shb_branch": "28",
        "shb_order": "2",
        "dname": "Galgamuwa",
        "did": "28",
        "lati": "7.931694",
        "longt": "80.242803",
        "shv_status": "null"
      }
    ],
    "r2": [
      {
        "shb_branch": "94",
        "shb_order": "3",
        "dname": "Thambuththegama",
        "did": "94",
        "lati": "8.151445",
        "longt": "80.293798",
        "shv_status": "null"
      },
      {
        "shb_branch": "14",
        "shb_order": "3",
        "dname": "Anuradhapura",
        "did": "14",
        "lati": "8.322275",
        "longt": "80.403984",
        "shv_status": "null"
      }
    ]
  };

  _createMarker() async {
    BitmapDescriptor markerBitMap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(30, 30)),
      "assets/1.png",
    );
    BitmapDescriptor markerBitMap2 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(30, 30)),
      "assets/2.png",
    );
    Set<Marker> _markertemp = {};

    data.forEach((key, points) {
      List.generate(points.length, (index) {
        double lat = double.parse(points[index]['lati'].toString());
        double long = double.parse(points[index]['longt'].toString());
        Set<Marker> _markertemp = {
          Marker(
              icon: points[index]['shb_order'] == '2'
                  ? markerBitMap
                  : markerBitMap2,
              position: LatLng(lat, long),
              markerId: MarkerId(points[index]['shb_branch'].toString()))
        };
        _marker.addAll(_markertemp);
      });
      setState(() {});

      log(_marker.toString());
      // Marker(markerId:'' )
    });
    log(_marker.toString());
  }

  List<Polyline> _createPolylines() {
    List<Polyline> polylines = [];

    data.forEach((key, points) {
      List<LatLng> coordinates = points.map((point) {
        return LatLng(
          double.parse(point["lati"]!),
          double.parse(point["longt"]!),
        );
      }).toList();

      polylines.add(
        Polyline(
          polylineId: PolylineId(key),
          points: coordinates,
          color: key == "r1"
              ? Color.fromARGB(255, 216, 15, 136)
              : const Color.fromARGB(255, 57, 244, 54),
          width: 5,
        ),
      );
    });

    return polylines;
  }

  @override
  void initState() {
    _createMarker();
    super.initState();
    fLatLong = LatLng(7.8731, 80.7718);
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
                'All Rout',
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
                          polylines: Set<Polyline>.of(_createPolylines()),
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
                            target: LatLng(7.8731, 80.7718),
                            zoom: 8,
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
                          onTap: () async {},
                          // buttonHeight: h / 16,
                          width: w / 1.5,
                          color: appButtonColorLite),
                    ),
                  )
                : null));
  }
}
