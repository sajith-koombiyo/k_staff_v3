import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/uI/widget/diloag_button.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class BranchVisitHistory extends StatefulWidget {
  const BranchVisitHistory({super.key});

  @override
  State<BranchVisitHistory> createState() => _BranchVisitHistoryState();
}

class _BranchVisitHistoryState extends State<BranchVisitHistory> {
  List branchVisit = [];
  Position? position;
  @override
  void initState() {
    ;
    getDat();
    // TODO: implement initState

    super.initState();
  }

  getDat() async {
    List res = await CustomApi().branchVisitHistroy(context);

    setState(() {
      print(res);
      branchVisit = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appliteBlue,
        title: Text(
          'Branch Visit History',
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
      backgroundColor: Color.fromARGB(255, 229, 232, 238),
      body: SizedBox(
        height: h,
        child: ListView.builder(
          itemCount: branchVisit.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Color.fromARGB(255, 215, 225, 232),
                child: SizedBox(
                  width: w - 16,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              branchVisit[index]['dname'],
                              style: TextStyle(color: black, fontSize: 14.dp),
                            ),
                            Text(
                              '${branchVisit[index]['date']}',
                              style: TextStyle(color: black2, fontSize: 14),
                            ),
                          ],
                        ),
                        Spacer(),
                        DialogButton(
                            text: 'Exit',
                            onTap: () async {
                              CustomDialog().alert(context, 'Info',
                                  'Do you want to exit the ${branchVisit[index]['dname']} branch',
                                  () {
                                getLocation();

                                exitBranch();
                              });
                            },
                            buttonHeight: h / 20,
                            width: w / 4,
                            color: Color.fromARGB(255, 2, 174, 91)),
                      ],
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

  void getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.deniedForever) {
      _checkLocationPermission();
      permission = await Geolocator.requestPermission();
    }
    double distance = 100.00;
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var res = await Geolocator.distanceBetween(
        37.4229988, -122.084, 37.4219983, -122.084);
    if (distance < res) {
      QuickAlert.show(
        onConfirmBtnTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        },
        context: context,
        type: QuickAlertType.warning,
        text: 'Branch Location And your current location does not match.',
        title: 'Warning ',
        confirmBtnText: 'try Again',
        confirmBtnColor: Colors.green,
      );
    } else {}
    setState(() {
      print(res);
      //  Latitude: 37.4219983, Longitude: -122.084
      print(position);
      position;
    });
  }

  Future<void> _checkLocationPermission() async {
    PermissionStatus permissionStatus = await Permission.location.status;
    if (permissionStatus == PermissionStatus.denied) {
      await openAppSettings().then((value) => getLocation());
    } else if (permissionStatus == PermissionStatus.granted) {}
  }

  exitBranch() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          content: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: w / 2,
              child: Text(
                'We are collecting some information, like your current location',
                style: TextStyle(color: black, fontSize: 14.dp),
              ),
            ),
          ],
        ),
      ])),
    );
  }
}
