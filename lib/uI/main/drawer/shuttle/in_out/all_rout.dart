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
  DateTime selectedDate = DateTime.now();
  TextEditingController date = TextEditingController();
  Position? position;
  bool isOpen = false;
  bool lConfirm = false;
  String newImage = '';
  String branchName = '';
  String visitBranchId = '';
  bool isLoading = false;
  bool routLoading = false;
  bool isTapMarker = false;
  String lat = '';
  String long = '';
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
  String branchId = '';
  String routName = '';
  String inTime = '';
  String outTime = '';
  final List<LatLng> _polylineCoordinates = [];
  // Polylines for the map.
  final Set<Polyline> _polylines = {};
  _createMarker(List data) async {
    BitmapDescriptor markerBitMap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(30, 30)),
      "assets/markerp.png",
    );
    BitmapDescriptor markerBitMap2 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(30, 30)),
      "assets/1.png",
    );
    BitmapDescriptor markerBitMap3 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(30, 30)),
      "assets/3.png",
    );
    Set<Marker> _markertemp = {};
    List.generate(data.length, (index) {
      double lat = double.parse(data[index]['lati'].toString());
      double long = double.parse(data[index]['longt'].toString());
      print('bbbbbbbbbbb');
      print(data[index]['shv_status']);
      print('bbbbbbbbbbb');
      Set<Marker> _markertemp = {
        Marker(
            onTap: () {
              setState(() {
                isTapMarker = true;
                routName = data[index]['dname'].toString();
                inTime = data[index]['shv_in'].toString() == 'null'
                    ? ''
                    : data[index]['shv_in'].toString();
                outTime = data[index]['shv_out'].toString() == 'null'
                    ? ''
                    : data[index]['shv_out'].toString();
              });
            },
            infoWindow: InfoWindow(),
            icon: data[index]['shv_status'].toString() == 'null'
                ? markerBitMap
                : data[index]['shv_status'].toString() == '1'
                    ? markerBitMap2
                    : markerBitMap3,
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

  @override
  void initState() {
    allROutData();

    super.initState();
    fLatLong = LatLng(7.8731, 80.7718);
  }

  allROutData() async {
    setState(() {
      isLoading = true;
    });
    List res = await CustomApi().shutteleAllRoutData(context);

    routList = res;
    log(routList.toString());
    setState(() {
      isLoading = false;
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
            ),
            backgroundColor: appliteBlue,
            body: Padding(
              padding: EdgeInsets.only(bottom: isOpen ? 70 : 0),
              child: Stack(
                children: [
                  isLoading || fLatLong == null
                      ? Loader().loader(context)
                      : SizedBox(
                          height: h,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  alignment: Alignment.centerRight,
                                  width: w,
                                  decoration: BoxDecoration(
                                    color: white,
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
                                      color: white,
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
                                              branchId = itemone['sh_id'];
                                              _polylines.clear();
                                              _polylineCoordinates.clear();
                                              _marker.clear();
                                              selectval = null;
                                            });

                                            if (date.text.isNotEmpty) {
                                              loadRout();
                                            }
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
                              SizedBox(
                                  child:
                                      customTextFieldDate('select Date', date)),
                              Flexible(
                                child: GoogleMap(
                                  polylines: _polylines,
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
                  isTapMarker
                      ? Positioned(
                          top: h / 7,
                          right: 0,
                          child: Card(
                            elevation: 20,
                            color: white,
                            child: SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Rout Name - $routName",
                                      style: TextStyle(
                                          color: black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text("In - $inTime",
                                        style: TextStyle(
                                            color: black,
                                            fontWeight: FontWeight.w500)),
                                    Text("out - $outTime",
                                        style: TextStyle(
                                            color: black,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                  isLoading ? Loader().loader(context) : SizedBox(),
                  routLoading ? Loader().loader(context) : SizedBox(),
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

  Future<void> _selectDate() async {
    String formattedDate = '';
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1940, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        date.text = formattedDate.toString();
      });
      if (branchId == '') {
        notification().warning(context, 'Please select the branch');
      } else {
        setState(() {
          _polylines.clear();
          _polylineCoordinates.clear();
          _marker.clear();
        });
        loadRout();
      }
    }
  }

  loadRout() async {
    setState(() {
      routLoading = true;
    });
    var res = await CustomApi()
        .shutteleSelectRout(context, branchId, date.text.toString());

    log(res.toString());
    await _createMarker(res);
    setState(() {
      routLoading = false;
    });
  }

  Widget customTextFieldDate(
    String hint,
    TextEditingController controller,
  ) {
    var w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: TextField(
          readOnly: true,
          controller: date,
          onTap: () {
            _selectDate();
          },
          decoration: InputDecoration(

              // // labelText: hint,
              // focusedBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color: Colors.black),
              //   borderRadius: BorderRadius.circular(10),
              // ),
              // enabledBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color: Colors.black12),
              //   borderRadius: BorderRadius.circular(10),
              // ),
              // border: OutlineInputBorder(
              //   borderSide: BorderSide(width: 0.2, color: Colors.black12),
              //   borderRadius: BorderRadius.circular(10.0),
              // ),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: Icon(Icons.calendar_month),
              hintText: 'dd/mm/yyy'),
        ),
      ),
    );
  }
}
