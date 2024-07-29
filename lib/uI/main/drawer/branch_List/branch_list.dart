import 'dart:async';
import 'dart:developer';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class BranchList extends StatefulWidget {
  const BranchList({super.key, required this.isDower});
  final int isDower;

  @override
  State<BranchList> createState() => _BranchListState();
}

class _BranchListState extends State<BranchList> {
  TextEditingController quantity = TextEditingController();
  Position? position;
  List branchList = [];
  MapController mapController = MapController();
  bool isDelivery = false;
  double lat = 0.0;
  double lon = 0.0;
  List<Marker> _marker = [];
  String branchName = '';
  String MarkerTempId = '';
  bool isLoading = false;
  List<Marker> markerList = <Marker>[];
  int lIndex = 0;
  String bName = '';

  userLocation() async {
    var temp = await CustomApi().branchList(context);

    if (!mounted) return;
    setState(() {
      branchList = temp;
    });

    List.generate(branchList.length, (index) {
      lat = double.parse(branchList[index]['lati']);
      lon = double.parse(branchList[index]['longt']);
      lIndex = index;
      final _markertemp = <Marker>[
        Marker(
          height: 50,
          width: 50,
          // key: Key(pickupLocation[index]['pickr_id']),
          point: LatLng(lat, lon),

          child: InkWell(
              onTap: () {
                print(
                    'sssssssssssssssssssssssssssssssssssssssssssssssssssssssss');
                setState(() {
                  setState(() {
                    lat = double.parse(branchList[index]['lati']);
                    lon = double.parse(branchList[index]['longt']);
                    bName = branchList[index]['branch_name'];
                  });
                });
              },
              child: Image.asset(
                'assets/location_d.png',
                height: 50,
                width: 50,
              )),
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
        backgroundColor: Color.fromARGB(255, 229, 232, 238),
        body: SizedBox(
          height: h,
          child: Stack(
            children: [
              position == null
                  ? Loader().loader(context)
                  : FlutterMap(
                      options: MapOptions(
                        enableScrollWheel: false,
                        keepAlive: false,
                        applyPointerTranslucencyToLayers: false,
                        initialCenter: LatLng(7.8731, 80.7718),
                        minZoom: 6,
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
              widget.isDower == 1
                  ? lat != 0.0
                      ? Positioned(
                          right: 12,
                          top: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Card(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(bName),
                              )),
                              InkWell(
                                onTap: () async {
                                  await FlutterShare.share(
                                      title: bName,
                                      text: 'share $bName branch location',
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
                                      color: Color.fromARGB(255, 207, 17, 39),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ))
                      : SizedBox()
                  : SizedBox(),
              isLoading ? Loader().loader(context) : SizedBox(),
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
