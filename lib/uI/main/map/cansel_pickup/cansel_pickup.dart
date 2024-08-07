import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../app_details/color.dart';
import '../../../../class/class.dart';
import '../../../widget/diloag_button.dart';

class CanselPickup {
  String newImage = '';
  Position? _currentPosition;
  List youTube = [];
  int backTime = 0;
  String base64Image = '';
  String pickupDevice = '';
  final ImagePicker _picker = ImagePicker();
  TextEditingController remarkController = TextEditingController();
  bool isPickupRequest = false;
  pickupCancel(BuildContext context) {
    Provider.of<ProviderS>(context, listen: false).isAppbarsheerOpen = false;
    SystemChannels.textInput.invokeMethod('TextInput.show');
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    // FocusScope.of(context).requestFocus(_focusNode);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setstate) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(12),
          content: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close)),
                    ),
                    Text(
                      'Cancel pickup',
                      style: TextStyle(
                          fontSize: 18.dp,
                          color: black,
                          fontWeight: FontWeight.normal),
                    ),
                    Divider(),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        final pickedFile =
                            await _picker.pickImage(source: ImageSource.camera);
                        if (pickedFile != null) {
                          setstate(() {
                            newImage = pickedFile.path;
                            final bytes =
                                File(pickedFile!.path).readAsBytesSync();
                            base64Image = base64Encode(bytes);
                          });
                        }
                      },
                      child: Center(
                        child: DottedBorder(
                          color: Colors.black38,
                          borderType: BorderType.RRect,
                          radius: Radius.circular(12),
                          padding: EdgeInsets.all(6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            child: Container(
                              alignment: Alignment.center,
                              height: h / 7,
                              width: w / 2,
                              child: newImage != ''
                                  ? Image.file(
                                      height: h / 7,
                                      width: w / 2,
                                      File(
                                        newImage,
                                      ),
                                      fit: BoxFit.fill,
                                    )
                                  : Column(
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
                                            'Please upload \nyour image \n -Click here-',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black38,
                                              fontSize: 11.dp,
                                            )),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      autofocus: true,
                      showCursor: true,
                      controller: remarkController,
                      style: TextStyle(color: black, fontSize: 13.sp),
                      validator: (value) {},
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.edit),
                        // contentPadding:
                        //     EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.black12,
                              // color: pink.withOpacity(0.1),
                            )),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black12,
                            // color: pink.withOpacity(0.1),
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        hintText: 'add your remark',
                        filled: true,
                        hintStyle: TextStyle(fontSize: 13.dp),
                        fillColor: white.withOpacity(0.3),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DialogButton(
                      onTap: () async {
                        if (newImage != '') {
                          if (remarkController.text.isNotEmpty) {
                            setstate(() {
                              isPickupRequest = true;
                            });
                            await _getCurrentLocation(context);
                            setstate(() {
                              isPickupRequest = false;
                            });
                          } else {
                            notification()
                                .warning(context, 'remark is required');
                          }
                        } else {
                          notification().warning(context, 'image is required');
                        }
                      },
                      buttonHeight: h / 17,
                      width: w / 1.5,
                      color: Colors.blue,
                      text: 'SAVE',
                    )
                  ],
                ),
              ),
              isPickupRequest
                  ? Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      top: 0,
                      child: Loader().loader(context))
                  : SizedBox()
            ],
          ),
        );
      }),
    );
  }

  _getCurrentLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle this scenario
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Permissions are denied, handle this scenario
        return;
      }
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    _currentPosition = position;
    log(_currentPosition.toString());

    var res = await CustomApi().pickupCansel(
        context,
        Provider.of<ProviderS>(context, listen: false).pickId,
        remarkController.text,
        _currentPosition!.latitude.toString(),
        _currentPosition!.longitude.toString(),
        base64Image);
    if (res == 1) {
      newImage = '';
      Navigator.pop(context);
      remarkController.clear();
    }
  }
}
