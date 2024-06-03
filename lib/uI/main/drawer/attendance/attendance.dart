import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_picker/image_picker.dart';
import '../../../widget/diloag_button.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  String startMeter = '';
  String endMeter = '';
  bool isStart = false;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appliteBlue,
        title: Text(
          'Attendance',
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
      backgroundColor: white,
      body: Card(
        child: SizedBox(
          width: w,
          height: h,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Stack(
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          'Please upload your start meter image and end meter image ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18.dp,
                          )),
                      Spacer(),
                      InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        onTap: () {
                          bottomDialog(true);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 25,
                            ),
                            Container(
                              child: Card(
                                elevation: 20,
                                child: DottedBorder(
                                  dashPattern: [1, 5],
                                  color: Colors.black,
                                  strokeWidth: 1,
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(12),
                                  padding: EdgeInsets.all(6),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: h / 5.5,
                                    width: w / 2.3,
                                    child: startMeter.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            child: Container(
                                                height: h / 5.5,
                                                width: w / 2.3,
                                                child: Image.file(
                                                  File(startMeter),
                                                  fit: BoxFit.cover,
                                                )))
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.cloud_upload,
                                                size: 45,
                                                color: Color.fromARGB(
                                                    95, 37, 112, 133),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  'Please upload your \n start meter image \nclick here +',
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
                            ),
                            startMeter.isNotEmpty
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : SizedBox(
                                    width: 25,
                                  ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Divider(
                        height: 0,
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 25,
                          ),
                          InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            onTap: () {
                              bottomDialog(false);
                            },
                            child: Container(
                              child: Card(
                                elevation: 20,
                                child: DottedBorder(
                                  dashPattern: [1, 5],
                                  color: Colors.black,
                                  strokeWidth: 1,
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(12),
                                  padding: EdgeInsets.all(6),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: h / 5.5,
                                    width: w / 2.3,
                                    child: endMeter.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            child: Container(
                                                height: h / 5.5,
                                                width: w / 2.3,
                                                child: Image.file(
                                                  File(endMeter),
                                                  fit: BoxFit.cover,
                                                )))
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.cloud_upload,
                                                size: 45,
                                                color: Color.fromARGB(
                                                    95, 37, 112, 133),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  'Please upload your \n end meter image \nclick here +',
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
                            ),
                          ),
                          endMeter.isNotEmpty
                              ? Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : SizedBox(
                                  width: 25,
                                ),
                        ],
                      ),
                      Spacer(),
                      DialogButton(
                        buttonHeight: h / 14,
                        width: w / 1.4,
                        text: 'Save',
                        color: Color.fromARGB(255, 8, 152, 219),
                        onTap: () {},
                      ),
                      Spacer(),
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bottomDialog(bool isStart) {
    showModalBottomSheet(
        showDragHandle: true,
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: new Icon(Icons.camera_alt),
                title: Text('From Camera',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 14.dp,
                    )),
                onTap: () {
                  fromCamera(isStart);
                  Navigator.pop(context);
                },
              ),
              Divider(
                height: 0,
              ),
              ListTile(
                leading: new Icon(Icons.photo),
                title: Text('From Gallery',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 14.dp,
                    )),
                onTap: () {
                  fromGallery(isStart);

                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  fromGallery(bool isStart) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (isStart) {
        startMeter = image!.path;
      } else {
        endMeter = image!.path;
      }
    });
  }

  fromCamera(bool isStart) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (isStart) {
        startMeter = image!.path;
      } else {
        endMeter = image!.path;
      }
    });
  }
}
