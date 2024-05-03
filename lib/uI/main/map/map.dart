import 'dart:async';
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
import 'package:url_launcher/url_launcher.dart';
import '../../../class/class.dart';
import '../../widget/map/details.dart';
import 'pdf/pdf.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  TextEditingController quantity = TextEditingController();
  Position? position;
  List pickupLocation = [];
  List deliveryLocation = [];
  bool isOpen = false;
  bool isDelivery = false;
  String accept = '';
  int x = 0;
  String lat = '';
  String lon = '';
  double dLat = 0.0;
  double dLong = 0.0;
  String name = '';
  String address = '';
  String phone = '';
  String pickId = '';
  String COD = '';
  int status0Count = 0;
  int status1Count = 0;
  bool isLoading = false;
  List<Marker> markerList = <Marker>[];
  Set<Marker> _marker = {};
  userLocation() async {
    status0Count = 0;
    status1Count = 0;
    var temp = await CustomApi().getmypickups(context);
    var temp2 = await CustomApi().getMyPDeliveryMap(context);
    if (!mounted) return;
    setState(() {
      pickupLocation = temp;
      deliveryLocation = temp2;
      for (var item in pickupLocation) {
        if (item['accept'] == 0) {
        } else if (item['accept'] == 1) {
          status1Count++;
        }
      }
    });

    BitmapDescriptor markerBitMap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(40, 40)),
      "assets/location_pin_gradient_set-red.png",
    );
    BitmapDescriptor markerBitMap2 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(40, 40)),
      "assets/location_d.png",
    );
    BitmapDescriptor markerBitMap3 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(40, 40)),
      "assets/delivey2.png",
    );

    List.generate(pickupLocation.length, (index) {
      if (pickupLocation[index]['accept'] == '0') {
        status0Count++;
        setState(() {
          status0Count;
        });
      } else if (pickupLocation[index]['accept'] == '1') {
        status1Count++;
        setState(() {
          status1Count;
        });
      }
      double lat = double.parse(pickupLocation[index]['lati']);
      double long = double.parse(pickupLocation[index]['longt']);
      Set<Marker> _markertemp = {
        Marker(
            onTap: () async {
              if (!mounted) return;
              setState(() {
                isOpen = true;
                isDelivery = false;
                name = pickupLocation[index]['cust_name'];
                address = pickupLocation[index]['address'];
                phone = pickupLocation[index]['phone'];
                pickId = pickupLocation[index]['pickr_id'];
                accept = pickupLocation[index]['accept'];
                // MapUtils.openMap(list[index]['lat'], list[index]['lon']);
              });
            },
            visible: true,
            icon: pickupLocation[index]['accept'] == '0'
                ? markerBitMap
                : markerBitMap2,
            infoWindow: InfoWindow(
                title: pickupLocation[index]['staff_name'],
                snippet: pickupLocation[index]['cust_name'],
                onTap: () {}),
            markerId: MarkerId(pickupLocation[index]['pickr_id']),
            position: LatLng(lat, long)),
      };
      _marker.addAll(_markertemp);
    });
    List.generate(deliveryLocation.length, (index) {
      double lat = double.parse(deliveryLocation[index]['latitude']);
      double long = double.parse(deliveryLocation[index]['longitude']);

      Set<Marker> _markertemp2 = {
        Marker(
            onTap: () async {
              if (!mounted) return;
              setState(() {
                isOpen = true;
                isDelivery = true;
                name = deliveryLocation[index]['name'];
                address = deliveryLocation[index]['address'];
                phone = deliveryLocation[index]['phone'];
                pickId = deliveryLocation[index]['waybill_id'];
                COD = deliveryLocation[index]['cod_final'];
                dLat = double.parse(deliveryLocation[index]['latitude']);
                dLong = double.parse(deliveryLocation[index]['longitude']);
                // accept = deliveryLocation[index]['accept'];
                // MapUtils.openMap(dLat, dLong);
              });
            },
            visible: true,
            icon: markerBitMap3,
            infoWindow: InfoWindow(
                title: deliveryLocation[index]['name'],
                snippet: deliveryLocation[index]['address'],
                onTap: () {}),
            markerId: MarkerId(deliveryLocation[index]['waybill_id']),
            position: LatLng(lat, long)),
      };
      _marker.addAll(_markertemp2);
    });
    _marker.isEmpty
        ? notification().warning(
            context, 'Any delivery location is not available at this moment.')
        : null;
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
                          target:
                              LatLng(position!.latitude, position!.longitude),
                          zoom: 14.4746,
                        ),
                        markers: _marker,
                        onMapCreated: (GoogleMapController _controller) {},
                      ),
                Positioned(
                  top: 100,
                  left: 10,
                  child: Card(
                    shape: Border.all(color: Colors.transparent),
                    elevation: 20,
                    color: black.withOpacity(0.6),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  height: 15,
                                  child: Image.asset(
                                      'assets/location_pin_gradient_set-red.png')),
                              SizedBox(
                                width: 4,
                              ),
                              SizedBox(
                                width: 55,
                                child: Text(
                                  'Pending',
                                  style: TextStyle(color: white, fontSize: 12),
                                ),
                              ),
                              Text(
                                '${status0Count.toString()}',
                                style: TextStyle(color: white, fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  height: 15,
                                  child: Image.asset('assets/location_d.png')),
                              SizedBox(
                                width: 4,
                              ),
                              SizedBox(
                                width: 55,
                                child: Text(
                                  'Accept',
                                  style: TextStyle(color: white, fontSize: 12),
                                ),
                              ),
                              Text(
                                '${status1Count.toString()}',
                                style: TextStyle(color: white, fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  height: 15,
                                  child: Image.asset('assets/delivey2.png')),
                              SizedBox(
                                width: 4,
                              ),
                              SizedBox(
                                width: 55,
                                child: Text(
                                  'Delivery',
                                  style: TextStyle(color: white, fontSize: 12),
                                ),
                              ),
                              Text(
                                '${deliveryLocation.length}',
                                style: TextStyle(color: white, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: InkWell(
                    onTap: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return Sign();
                          },
                        ),
                      );
                    },
                    child: Container(
                      color: black,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                isOpen ? appbarSheet() : SizedBox(),
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

  appbarSheet() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return AnimationLimiter(
      child: AnimationConfiguration.synchronized(
        child: SlideAnimation(
          verticalOffset: -300,
          child: Card(
            color: black.withOpacity(0.9),
            elevation: 20,
            child: SlideAnimation(
              verticalOffset: 300,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).padding.top + 50,
                    ),
                    isDelivery
                        ? Stack(
                            children: [
                              SlideAnimation(
                                horizontalOffset: -200,
                                duration: Duration(milliseconds: 900),
                                child: FadeInAnimation(
                                  child: Detail(
                                    onTap: () {},
                                    icon: Icons.info,
                                    color: Color.fromARGB(255, 138, 101, 7),
                                    title2: pickId,
                                    title: 'Waybill Id',
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                right: 8,
                                child: IconButton(
                                    onPressed: () {
                                      Clipboard.setData(
                                              ClipboardData(text: pickId))
                                          .then((_) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Waybill Id copied to clipboard")));
                                      });
                                    },
                                    icon: Icon(
                                      Icons.copy,
                                      color: appliteBlue2,
                                    )),
                              )
                            ],
                          )
                        : SizedBox(),
                    SlideAnimation(
                      horizontalOffset: 200,
                      duration: Duration(milliseconds: 900),
                      child: FadeInAnimation(
                        child: Detail(
                          onTap: () {},
                          icon: Icons.person,
                          color: Color.fromARGB(255, 11, 53, 124),
                          title2: name,
                          title: 'Name',
                        ),
                      ),
                    ),
                    SlideAnimation(
                      horizontalOffset: -200,
                      duration: Duration(milliseconds: 500),
                      child: FadeInAnimation(
                        child: Detail(
                          onTap: () {},
                          icon: Icons.home,
                          color: Color.fromARGB(255, 20, 143, 29),
                          title2: address,
                          title: 'Address',
                        ),
                      ),
                    ),
                    isDelivery
                        ? SlideAnimation(
                            horizontalOffset: 200,
                            duration: Duration(milliseconds: 900),
                            child: FadeInAnimation(
                              child: Detail(
                                onTap: () {},
                                icon: Icons.monetization_on,
                                color: Color.fromARGB(255, 93, 2, 107),
                                title2: COD,
                                title: 'COD',
                              ),
                            ),
                          )
                        : SizedBox(),
                    SlideAnimation(
                      horizontalOffset: -200,
                      duration: Duration(milliseconds: 700),
                      child: FadeInAnimation(
                        child: Detail(
                          onTap: () async {
                            final call = Uri.parse('tel:$phone');
                            if (await canLaunchUrl(call)) {
                              launchUrl(call);
                            } else {
                              throw 'Could not launch $call';
                            }
                          },
                          icon: Icons.call,
                          color: Color.fromARGB(255, 255, 20, 20),
                          title2: phone,
                          title: 'Phone',
                        ),
                      ),
                    ),
                    isDelivery == false && accept == '1'
                        ? Card(
                            child: TextField(
                                controller: quantity,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: 'Type your Quantity',
                                    contentPadding: EdgeInsets.all(8),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.edit,
                                        size: 47,
                                      ),
                                    ),
                                    fillColor: white3,
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(11)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(11)))),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 10,
                    ),
                    isDelivery
                        ? SizedBox()
                        : SlideAnimation(
                            verticalOffset: 200,
                            duration: Duration(milliseconds: 900),
                            child: DialogButton(
                                text: accept == '0' ? 'Accept' : "Pickup",
                                onTap: accept == '0'
                                    ? () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        var res = await CustomApi()
                                            .sendSms(phone, pickId, context);
                                        await userLocation();
                                        setState(() {
                                          isOpen = false;
                                          isLoading = false;
                                        });
                                      }
                                    : () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        await CustomApi().pickupComplete(
                                            context, pickId, quantity.text);
                                        await userLocation();
                                        setState(() {
                                          isOpen = false;
                                          isLoading = false;
                                        });
                                      },
                                buttonHeight: h / 14,
                                width: w / 1.5,
                                color: accept == '0'
                                    ? appBlue
                                    : Color.fromARGB(255, 186, 122, 12)),
                          ),
                    isDelivery
                        ? SlideAnimation(
                            verticalOffset: 200,
                            duration: Duration(milliseconds: 900),
                            child: Stack(
                              children: [
                                DialogButton(
                                  buttonHeight: h / 15,
                                  color: Colors.green,
                                  onTap: () {
                                    MapUtils.openMap(dLat, dLong);
                                  },
                                  text: 'Get Direction',
                                  width: w / 1.5,
                                ),
                                Positioned(
                                    child: Image.asset(
                                        'assets/icons8-google-maps-old-48.png'))
                              ],
                            ))
                        : SizedBox(),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isOpen = false;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 204, 201, 201),
                              borderRadius: BorderRadius.circular(5)),
                          height: 5,
                          width: 70,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
