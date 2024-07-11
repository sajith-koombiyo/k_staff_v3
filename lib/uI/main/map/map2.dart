import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class Map2 extends StatefulWidget {
  const Map2({super.key});

  @override
  State<Map2> createState() => _Map2State();
}

class _Map2State extends State<Map2> {
  List pickupLocation = [];
  List deliveryLocation = [];
  int status0Count = 0;
  int status1Count = 0;
 List<Marker> markerList = <Marker>[];
  Set<Marker> _marker = {};

  userLoaction() async {
    status0Count = 0;
    status1Count = 0;

    print('111122222222222222222222222222222222222222222222222');
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

    List.generate(pickupLocation.length, (index) {



    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  final markersList = <Marker>[
    Marker(
      child: Container(
        color: bacground,
        height: 20,
        width: 20,
      ),
      width: 50,
      height: 50,
      point: LatLng(35.505733, 23.427344),
      rotate: false,
    ),
    Marker(
      child: Container(
        color: bacground,
        height: 20,
        width: 20,
      ),
      width: 50,
      height: 50,
      point: LatLng(35.166754, 24.109758),
      rotate: false,
    ),
    Marker(
      child: Container(
        color: bacground,
        height: 20,
        width: 20,
      ),
      width: 50,
      height: 50,
      point: LatLng(35.387568, 25.091811),
      rotate: false,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: MapController(),
      // mapController: mapController,
      options: MapOptions(
        initialCenter: LatLng(7.8731, 80.7718),
        minZoom: 2,
        maxZoom: 19,
        zoom: 8,
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
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(30, 40),
              // width: 100,
              // height: 80,
              child: InkWell(
                  onTap: () {
                    print(
                        'vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvdddddvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');
                  },
                  child: Image.asset('assets/location_d.png')),
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 80,
              height: 80,
              point: LatLng(6.9271, 79.8612),
              child: InkWell(
                  onTap: () {
                    print(
                        'vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');
                  },
                  child: Image.asset('assets/location_d.png')),
            )
          ],
          rotate: false,
        ),
      ],
    );
  }
}
