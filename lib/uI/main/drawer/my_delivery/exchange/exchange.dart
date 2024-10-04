import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../../../../sql_db/db.dart';
import '../../../../widget/home_screen_widget/home_button.dart';
import '../../../../widget/textField.dart';

class Exchange extends StatefulWidget {
  const Exchange(
      {super.key,
      required this.pWaybill,
      required this.exchangeBagWaybill,
      required this.waybill,
      required this.codController,
      required this.date,
      required this.dropdownvalueItem,
      required this.dropdownvalueItem2,
      required this.oderId,
      required this.statusTyp,
      required this.backDataLoad});
  final String waybill;
  final int statusTyp;
  final String dropdownvalueItem;
  final String dropdownvalueItem2;
  final String codController;
  final String date;
  final String oderId;
  final Function backDataLoad;
  final String exchangeBagWaybill;
  final String pWaybill;

  @override
  State<Exchange> createState() => _ExchangeState();
}

class _ExchangeState extends State<Exchange> {
  var logger = Logger();
  SqlDb sqlDb = SqlDb();
  bool check = false;
  XFile? image;
  TextEditingController pWayBill = TextEditingController();
  TextEditingController exWayBill = TextEditingController();
  TextEditingController exBagWayBill = TextEditingController();
  String newImage = '';
  String Image64 = '';
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  bool isOffline = true;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    setState(() {
      pWayBill.text = widget.pWaybill;
      exWayBill.text = widget.waybill;
      exBagWayBill.text = widget.exchangeBagWaybill;
    });
    internet();

    // TODO: implement initState
    super.initState();
  }

  internet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        print('ddddddddddddddddddddddddddddddddddddddddd');
        isOffline = false;
      });
    } else {
      print(
          'dddddddxxxxxxxxxxxxxxdddddddddddddddddffffffffffffffffddddddddddddddddd');
      setState(() {
        isOffline = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 220, 247, 255),
      appBar: AppBar(
          iconTheme: IconThemeData(color: white),
          backgroundColor: appliteBlue,
          title: Text(
            'exchange',
            style: TextStyle(color: white),
          ),
          bottom: isOffline
              ? PreferredSize(
                  preferredSize: Size(w, 20),
                  child: Container(
                    alignment: Alignment.center,
                    width: w,
                    height: 20,
                    color: Colors.red,
                    child: Text(
                      'Offline',
                      style: TextStyle(color: white),
                    ),
                  ))
              : null),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text('Previous Waybill',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: black2,
                          fontSize: 15.dp,
                        )),
                    SizedBox(
                      height: 8,
                    ),
                    CustomTextField(
                      controller: pWayBill,
                      icon: Icons.access_time_filled,
                      text: 'type here',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Exchange Waybill',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: black2,
                          fontSize: 15.dp,
                        )),
                    SizedBox(
                      height: 8,
                    ),
                    CustomTextField(
                      controller: exWayBill,
                      icon: Icons.account_tree_sharp,
                      text: 'type here',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Exchange Bag Waybill',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: black2,
                          fontSize: 15.dp,
                        )),
                    SizedBox(
                      height: 8,
                    ),
                    CustomTextField(
                      controller: exBagWayBill,
                      icon: Icons.add_home,
                      text: 'type here',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Image Upload',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: black2,
                          fontSize: 15.dp,
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        newImage.isNotEmpty
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                child: Container(
                                    height: h / 7,
                                    width: w / 2.2,
                                    child: Image.file(
                                      File(newImage),
                                      fit: BoxFit.cover,
                                    )))
                            : DottedBorder(
                                color: Colors.black38,
                                borderType: BorderType.RRect,
                                radius: Radius.circular(12),
                                padding: EdgeInsets.all(6),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: h / 7,
                                    width: w / 2,
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
                                        Text('Please upload \nyour image',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black38,
                                              fontSize: 12.dp,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () async {
                                image = await _picker.pickImage(
                                    imageQuality: 25,
                                    source: ImageSource.camera);

                                setState(() {
                                  image;
                                  newImage = image!.path;
                                });
                                await imageUpdate();
                              },
                              child: Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Icon(
                                      color: Colors.black38,
                                      Icons.camera_alt,
                                    ),
                                  )),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () async {
                                image = await _picker.pickImage(
                                    imageQuality: 25,
                                    source: ImageSource.camera);

                                setState(() {
                                  image;
                                  newImage = image!.path;
                                });

                                imageUpdate();
                                setState(() {
                                  image;
                                });

                                // source
                              },
                              child: Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Icon(
                                      color: Colors.black38,
                                      Icons.photo,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: white,
                          value: check,
                          onChanged: (value) {
                            setState(() {
                              check = value!;
                            });
                          },
                        ),
                        Text(
                          "I've collected the delivery item.",
                          style: TextStyle(color: appButtonColorLite),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: check
                          ? HomeButton(
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                exchangeUpdate();
                                setState(() {
                                  isLoading = false;
                                });
                              },
                              text: 'COLLECT',
                            )
                          : SizedBox(),
                    ),
                  ]),
            ),
          ),
          isLoading ? Loader().loader(context) : SizedBox(),
        ],
      ),
    );
  }

  imageUpdate() async {
    if (isOffline) {
      var res = await pickAndSaveImageToFolder(image, exWayBill.text);
    } else {
      print('/////////////////////////');
      var res = await CustomApi()
          .deliveryimageExchange(context, image, exWayBill.text, false);
    }
  }

  exchangeUpdate() async {
    var re = DateTime.now().toString();
    print(re);
    if (isOffline) {
      print('gggggggggggggggggggggggggggggggggg');
      var res = await sqlDb.replaceData('exchange_order', {
        'oId': widget.oderId,
        'wayBill': widget.waybill,
        'ex_bag_waybill': widget.exchangeBagWaybill,
        'prev_waybill': widget.pWaybill,
        'date': DateTime.now().toString()
      });
      print(res);
      var r = await sqlDb.readData('select * from exchange_order');
      print(r);
      if (res.toString() == widget.oderId) {
        var res = await sqlDb.replaceData('pending', {
          'oId': widget.oderId,
          'wayBillId': widget.waybill,
          'statusType': widget.statusTyp,
          'dropdownValue': widget.dropdownvalueItem,
          'dropdownValue2': widget.dropdownvalueItem2,
          'cod': widget.codController,
          'rescheduleDate': widget.date,
          'err': '0',
          'date': DateTime.now().toString()
        });
        var r = await sqlDb.readData('select * from pending');
        print(r);
        print(res);
        if (res.toString() == widget.oderId) {
          var t = await sqlDb.updateData(
              'UPDATE delivery_oder SET type = "$widget.statusTyp}" WHERE  oId ="${widget.oderId}"');
          notification().info(context,
              'data saved  The data has successfully returned to the online system and will be updated.');
          widget.backDataLoad();
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          notification().info(context, 'Something went wrong try again');
        }
      }
    } else {
      var res = await CustomApi().Collectexchange(
          context,
          widget.waybill,
          widget.oderId,
          widget.exchangeBagWaybill,
          widget.pWaybill,
          DateTime.now().toString());

      if (res == 200) {
        var res = await CustomApi().oderData(
            widget.statusTyp,
            widget.waybill,
            context,
            widget.dropdownvalueItem.toString(),
            widget.dropdownvalueItem2.toString(),
            widget.codController,
            widget.date,
            widget.date,
            DateTime.now().toString());

        if (res == 200) {
          widget.backDataLoad();
          Navigator.pop(context);
          Navigator.pop(context);
        }
      } else {
        notification().warning(context, 'Update failed please try again');
      }
    }
  }

  pickAndSaveImageToFolder(XFile? pickedFile, String waybill) async {
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      // Get the directory for the application's documents directory
      final directory = await getApplicationDocumentsDirectory();
      // Create a custom folder (if it doesn't already exist)
      final customDir = Directory('${directory.path}/MyImages');
      if (!(await customDir.exists())) {
        await customDir.create(recursive: true);
      }
      // Construct the file path to save the image
      final fileName = path.basename(pickedFile.path);
      final savedImagePath = '${customDir.path}/$fileName';
      // Save the image to the specified folder
      await imageFile.copy(savedImagePath);
      var res = await sqlDb.replaceData('exchange_image', {
        'waybill': waybill,
        'image': savedImagePath,
      });
      List data = await sqlDb.readData('select * from pending_image');
      notification().info(context,
          'Image saved  The data has successfully returned to the online system and will be updated.');
      return res;
    }
  }
}
