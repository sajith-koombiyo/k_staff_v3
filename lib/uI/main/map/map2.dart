import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/class/location.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/uI/main/map/barcode_scanner/barcode_scanner.dart';
import 'package:flutter_application_2/uI/widget/diloag_button.dart';
import 'package:flutter_application_2/uI/widget/map/details.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Map2 extends StatefulWidget {
  const Map2({super.key});

  @override
  State<Map2> createState() => _Map2State();
}

class _Map2State extends State<Map2> {
  String? _barcode;
  late bool visible;
  Position? position;
  List pickupLocation = [];
  List deliveryLocation = [];
  int status0Count = 0;
  int status1Count = 0;
  MapController mapController = MapController();

  TextEditingController quantity = TextEditingController();
  TextEditingController SacanQuantity = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int qnt = 0;
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
  String MarkerTempId = '';
  List sacanList = [];
  bool isLoading = false;
  List<Marker> markerList = <Marker>[];
  // Set<Marker> _marker = {};
  List<Marker> _marker = [];
  List barcodeScanData = [];
  bool sign = false;
  String pickupDevice = '';

  userLoaction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await prefs.getString('pickup_device');
    Provider.of<ProviderS>(context, listen: false).scanQnt.clear();

    setState(() {
      isLoading = true;
      pickupDevice = res.toString();
      log(pickupDevice);
    });
    status0Count = 0;
    status1Count = 0;

    print('111122222222222222222222222222222222222222222222222');
    var temp = await CustomApi().getmypickups(context);
    var temp2 = await CustomApi().getMyPDeliveryMap(context);
    log('sssssssssssssssssssaaaaaaaaaaaaaasss');
    log(temp.toString());
    log('sssssssssssssssssssfffffffsss');
    log(temp2.toString());
    log('ssssssssssssssssssssdddddddddddddddss');
    if (mounted) {
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
    }

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
      final _markertemp = <Marker>[
        Marker(
          // key: Key(pickupLocation[index]['pickr_id']),
          point: LatLng(lat, long),
          width: 100,
          height: 80,
          child: InkWell(
              onTap: () {
                print(
                    'vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvdddddvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');
                if (mounted) {
                  setState(() {
                    Provider.of<ProviderS>(context, listen: false)
                        .isAppbarsheerOpen = true;

                    isDelivery = false;
                    name = pickupLocation[index]['cust_name'];
                    address = pickupLocation[index]['address'];
                    phone = pickupLocation[index]['phone'];
                    pickId = pickupLocation[index]['pickr_id'];
                    accept = pickupLocation[index]['accept'];
                    // MapUtils.openMap(list[index]['lat'], list[index]['lon']);
                  });
                }
              },
              child: Image.asset(pickupLocation[index]['accept'] == '0'
                  ? 'assets/location_pin_gradient_set-red.png'
                  : 'assets/location_d.png')),
        )
      ];
      _marker.addAll(_markertemp);
    });

    List.generate(deliveryLocation.length, (index) {
      double lat = double.parse(deliveryLocation[index]['latitude']);
      double long = double.parse(deliveryLocation[index]['longitude']);
      final _markertemp = <Marker>[
        Marker(
          // key: Key(pickupLocation[index]['pickr_id']),
          point: LatLng(6.9271, 79.8612),
          width: 100,
          height: 80,
          child: InkWell(
              onTap: () {
                if (mounted) {
                  setState(() {
                    Provider.of<ProviderS>(context, listen: false)
                        .isAppbarsheerOpen = true;

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
                }
              },
              child: Image.asset(pickupLocation[index]['accept'] == '0'
                  ? 'assets/location_pin_gradient_set-red.png'
                  : 'assets/location_d.png')),
        )
      ];
      _marker.addAll(_markertemp);
    });
    _marker.isEmpty
        ? notification().warning(
            context, 'Any delivery location is not available at this moment.')
        : null;
    setState(() {
      isLoading = false;
    });

    log(_marker.toString());
  }

  @override
  void initState() {
    getLocation();
    // userLoaction();
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    // Add a listener to keep the TextField focused
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _focusNode.requestFocus();
      }
    });
    // SystemChannels.textInput.invokeMethod('TextInput.hide');
    // FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  void dispose() {
    SacanQuantity.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return
        // isLoading
        // ? Loader().loader(context)
        // :

        Consumer<ProviderS>(
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
                          initialCenter:
                              LatLng(position!.latitude, position!.longitude),
                          minZoom: 8,
                          maxZoom: 40,
                          zoom: 14,
                          keepAlive: true,
                          onMapReady: () {
                            //
                          },
                          onPositionChanged: (position, hasGesture) {
                            //
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: ['a', 'b', 'c'],
                          ),
                          MarkerLayer(markers: _marker),
                          MarkerLayer(markers: [
                            Marker(
                                point: LatLng(
                                    position!.latitude, position!.longitude),
                                child: Icon(
                                  Icons.person_pin_circle_rounded,
                                  size: 20,
                                  color: Color.fromARGB(255, 240, 27, 4),
                                ))
                          ]),
                        ],
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
                Positioned(
                  bottom: 100,
                  right: 12,
                  child: Padding(
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
                ),
                Provider.of<ProviderS>(context, listen: false).isAppbarsheerOpen
                    ? appbarSheet()
                    : SizedBox(),
                isLoading ? Loader().loader(context) : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  appbarSheet() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    log(pickupDevice);
    pickupDevice == '0'
        ? SystemChannels.textInput.invokeMethod('TextInput.hide')
        : SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Consumer<ProviderS>(
      builder: (context, pValue, child) => AnimationLimiter(
        child: AnimationConfiguration.synchronized(
          child: SlideAnimation(
            verticalOffset: -300,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
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
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).padding.top,
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
                                          color:
                                              Color.fromARGB(255, 138, 101, 7),
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
                              ? pickupDevice == '1'
                                  ? Stack(
                                      children: [
                                        Card(
                                          child: TextFormField(
                                              focusNode: _focusNode,
                                              textInputAction: TextInputAction
                                                  .search,
                                              autofocus: true,
                                              showCursor: true,
                                              // readOnly: true,
                                              onChanged: (value) async {
                                                log('$value vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvdddd');

                                                if (await barcodeScanData
                                                    .contains(value)) {
                                                  setState(() {
                                                    SacanQuantity.clear();
                                                  });
                                                  notification().warning(
                                                      context,
                                                      'Scan item $value already exists in the list.');
                                                } else {
                                                  if (SacanQuantity
                                                      .text.isNotEmpty) {
                                                    if (SacanQuantity
                                                            .text.length >
                                                        4) {
                                                      setState(() {
                                                        notification().info(
                                                            context,
                                                            'Scan item $value successfully saved');
                                                        barcodeScanData
                                                            .add(value);
                                                        quantity.text =
                                                            barcodeScanData
                                                                .length
                                                                .toString();
                                                        SacanQuantity.clear();
                                                        log(barcodeScanData
                                                            .toString());
                                                      });
                                                    }
                                                  }
                                                }
                                              },
                                              onTap: () {},
                                              controller: SacanQuantity,
                                              keyboardType: TextInputType
                                                  .number,
                                              decoration: InputDecoration(
                                                  hintText: 'Scan your pickups',
                                                  contentPadding:
                                                      EdgeInsets.all(8),
                                                  prefixIcon: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Icon(
                                                      Icons.edit,
                                                      size: 47,
                                                    ),
                                                  ),
                                                  fillColor: white3,
                                                  filled: true,
                                                  suffixIcon: IconButton(
                                                      onPressed: () async {
                                                        scanBarcodeNormal();
                                                      },
                                                      icon: Icon(Icons
                                                          .qr_code_scanner_sharp)),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      11)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      11)))),
                                        ),
                                        SlideAnimation(
                                          horizontalOffset: -200,
                                          duration: Duration(milliseconds: 700),
                                          child: FadeInAnimation(
                                            child: Detail2(
                                              icon: Icons.qr_code_scanner,
                                              color: Color.fromARGB(
                                                  255, 3, 93, 111),
                                              title2: barcodeScanData.isEmpty
                                                  ? "Scan your item"
                                                  : barcodeScanData.toString(),
                                              title:
                                                  "Scan quantity [ ${barcodeScanData.isEmpty ? "0" : quantity.text} ]",
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Card(
                                      child: TextField(
                                          controller: pValue.scanQnt,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              hintText: 'Scan your pickups',
                                              contentPadding: EdgeInsets.all(8),
                                              prefixIcon: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 47,
                                                ),
                                              ),
                                              fillColor: white3,
                                              filled: true,
                                              suffixIcon: IconButton(
                                                  onPressed: () async {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              BarcodeScanDeliveryItem(
                                                            isDevice:
                                                                pickupDevice,
                                                          ),
                                                        ));
                                                  },
                                                  icon: Icon(Icons
                                                      .qr_code_scanner_sharp)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          11)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          11)))),
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
                                      text: accept == '0'
                                          ? 'Accept'
                                          // : sign == false
                                          //     ? 'Signature'
                                          : "Pickup",
                                      onTap: accept == '0'
                                          ? () async {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              await CustomApi().sendSms(
                                                  phone, pickId, context);
                                              await userLoaction();
                                              setState(() {
                                                Provider.of<ProviderS>(context,
                                                        listen: false)
                                                    .isAppbarsheerOpen = false;

                                                isLoading = false;
                                              });
                                            }
                                          // : sign == false
                                          //     ? () {
                                          //         print('ffffffffffffffffffffff');
                                          //         siganature();
                                          //       }
                                          : () async {
                                              if (quantity.text.isNotEmpty ||
                                                  pValue.scanQnt.text
                                                      .isNotEmpty) {
                                                log('sssssssssssssssssssssssss');
                                                int qnt = int.parse(
                                                    pickupDevice == '1'
                                                        ? quantity.text
                                                        : pValue.scanQnt.text);
                                                if (qnt < 5000) {
                                                  print(
                                                      'qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq');
                                                  if (qnt != 0) {
                                                    print('fffffffffffffff');
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                    Position? position;
                                                    LocationPermission
                                                        permission;
                                                    permission = await Geolocator
                                                        .requestPermission();
                                                    position = await Geolocator
                                                        .getCurrentPosition(
                                                            desiredAccuracy:
                                                                LocationAccuracy
                                                                    .high);
                                                    log(position.toString());
                                                    await CustomApi()
                                                        .pickupComplete(
                                                      context,
                                                      pickId,
                                                      pickupDevice == '0'
                                                          ? pValue.scanQnt.text
                                                          : quantity.text,
                                                      phone,
                                                      position!.latitude
                                                          .toString(),
                                                      position!.longitude
                                                          .toString(),
                                                      [
                                                        19194704,
                                                        80005200,
                                                        17808346,
                                                        123456
                                                      ].toString(),
                                                    );
                                                    setState(() {
                                                      _marker.clear();
                                                    });
                                                    log('narker');
                                                    log(_marker.toString());
                                                    // await CustomApi().sendSms(
                                                    //     phone, pickId, context);
                                                    await userLoaction();
                                                    print(
                                                        '4444444444444444444');
                                                    setState(() {
                                                      Provider.of<ProviderS>(
                                                                  context,
                                                                  listen: false)
                                                              .isAppbarsheerOpen =
                                                          false;

                                                      isLoading = false;
                                                    });
                                                  } else {
                                                    notification().info(context,
                                                        'Invalid Quantity');
                                                  }
                                                } else {
                                                  notification().info(context,
                                                      'Invalid Quantity');
                                                }
                                              } else {
                                                notification().info(context,
                                                    'Quantity is required');
                                              }
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
                                SacanQuantity.clear();
                                quantity.clear();
                                barcodeScanData = [];
                                // _signController.clear();
                                Provider.of<ProviderS>(context, listen: false)
                                    .isAppbarsheerOpen = false;
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
          ),
        ),
      ),
    );
  }

  barcodeDataCount() {
    setState(() {});
  }

  void getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.deniedForever) {
      await openAppSettings().then((value) => getLocation());
      print('sssssssssssssssssssssssssssssssssssss');
      _checkLocationPermission();
      permission = await Geolocator.requestPermission();
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (!mounted) return;
    Future.delayed(const Duration(milliseconds: 200), () async {
      setState(() {
        position;
        log(position.toString());
      });
      userLoaction();
    });
  }

  Future<void> _checkLocationPermission() async {
    PermissionStatus permissionStatus = await Permission.location.status;
    if (permissionStatus == PermissionStatus.denied) {
      await openAppSettings().then((value) => getLocation());
    } else if (permissionStatus == PermissionStatus.granted) {}
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      var _scanBarcode = barcodeScanRes;
      if (_scanBarcode == "-1") {
        quantity.text = "";
      } else {
        barcodeScanData.add(_scanBarcode.toString());
        print(barcodeScanData);
        quantity.text = " Quantity ${barcodeScanData.length.toString()}";
      }
    });
  }
}
