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
  List getBranch = [];
  List todayVisitBranchList = [];
  List<LatLng> _latLong = [];
  String MarkerTempId = '';
  List districtList = [];
  List<Marker> markerList = <Marker>[];
  Set<Marker> _marker = {};
  List routList = [];
  final List<LatLng> _polylineCoordinates = [];

  // Polylines for the map.
  final Set<Polyline> _polylines = {};
  _createMarker(List data) async {
    BitmapDescriptor markerBitMap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(30, 30)),
      "assets/markp.png",
    );
    BitmapDescriptor markerBitMap2 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(30, 30)),
      "assets/2.png",
    );
    Set<Marker> _markertemp = {};

    List.generate(data.length, (index) {
      double lat = double.parse(data[index]['lati'].toString());
      double long = double.parse(data[index]['longt'].toString());
      Set<Marker> _markertemp = {
        Marker(
            infoWindow: InfoWindow(title: data[index]['dname'].toString()),
            icon:
                data[index]['shv_id'] == 'null' ? markerBitMap2 : markerBitMap,
            position: LatLng(lat, long),
            markerId: MarkerId(data[index]['shb_branch'].toString()))
      };
      _marker.addAll(_markertemp);

      _polylineCoordinates.add(LatLng(lat, long));
      _polylines.add(Polyline(
        polylineId: PolylineId('polyline'),
        points: _polylineCoordinates,
        color: Colors.blue,
        width: 5,
      ));
    });
    setState(() {
      _polylines;
    });
  }

  // List<Polyline> _createPolylines(List data) {
  //   List<Polyline> polylines = [];

  //   List.generate(data.length, (index) {
  //     polylines.add(
  //       Polyline(
  //         points: LatLng(lat, longitude),
  //         color: Color.fromARGB(255, 130, 134, 130),
  //         width: 5,
  //       ),
  //     );
  //   });

  //   return polylines;
  // }

  @override
  void initState() {
    allROutData();

    super.initState();
    fLatLong = LatLng(7.8731, 80.7718);
  }

  allROutData() async {
    List res = await CustomApi().shutteleAllRoutData(context);

    routList = res;
    log(routList.toString());
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Consumer<ProviderS>(
        builder: (context, provider, child) => Scaffold(
            appBar: AppBar(
              bottom: PreferredSize(
                preferredSize: Size(w, h / 17),
                child: Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Card(
                      child: Container(
                        height: h / 17,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        alignment: Alignment.centerRight,
                        width: w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                              color: black3,
                              style: BorderStyle.solid,
                              width: 0.80),
                        ),
                        child: DropdownButton(
                          isExpanded: true,
                          alignment: AlignmentDirectional.centerEnd,
                          hint: Container(
                            //and here
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "All Route",
                              style: TextStyle(color: black1),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          value: selectval,
                          //implement initial value or selected value
                          onChanged: (value) {
                            setState(() {
                              selectval = value
                                  .toString(); //change selectval to new value
                            });
                          },
                          items: routList.map((itemone) {
                            return DropdownMenuItem(
                                onTap: () async {
                                  setState(() {
                                    _polylines.clear();
                                    _polylineCoordinates.clear();
                                    _marker.clear();
                                    selectval = null;
                                  });

                                  var res = await CustomApi()
                                      .shutteleSelectRout(
                                          context, itemone['sh_id']);

                                  log(res.toString());
                                  _createMarker(res);
                                },
                                value: itemone['sh_id'],
                                child: Text(
                                  itemone['sh_name'],
                                  style: TextStyle(color: black2),
                                ));
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
