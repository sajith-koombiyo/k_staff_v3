import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../class/class.dart';
import '../../../widget/diloag_button.dart';
import '../../navigation/navigation.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  bool isLoading = false;
  String startMeter = '';
  String endMeter = '';
  String start64 = '';
  String end64 = '';
  String apiMidId = '';
  bool isStart = false;
  int startKM = 0;
  int end = 0;
  Uint8List? start64ConvertData;
  Uint8List? end64ConvertData;
  final ImagePicker _picker = ImagePicker();
  List meterMtData = [];
  bool mt = false;
  bool serverErr = false;
  bool sMeter = false;
  bool eMeter = false;
  bool isClickStart = false;
  bool isClickEnd = false;
  @override
  void initState() {
    data();
    // TODO: implement initState
    super.initState();
  }

  data() async {
    setState(() {
      isLoading = true;
    });
    var res = await CustomApi().attendanceVehicleMeter(context);
    print(res);

    if (res == 500) {
      setState(() {
        serverErr = true;
        isLoading = false;
      });
    }
    if (res == 0) {
      setState(() {
        isLoading = false;
      });
    }
    if (res == 1) {
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        apiMidId = res[0]['mid'];

        startKM = int.parse(res[0]['start']);

        if (res[0]['start_img'] != null) {
          sMeter = true;
          start64ConvertData = base64Decode(res[0]['start_img']);

          startController.text = res[0]['start'];
        }
        if (res[0]['end_img'] != null) {
          end64ConvertData = base64Decode(res[0]['end_img']);
          endController.text = res[0]['end'];
          eMeter = true;
        }
        isLoading = false;
      });
    }
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
            'Attendance',
            style: TextStyle(
              fontSize: 18.dp,
              color: white,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: serverErr
              ? PreferredSize(
                  preferredSize: Size(w, 20),
                  child: Container(
                      width: w,
                      color: const Color.fromARGB(255, 250, 70, 57),
                      child: Text('server error')))
              : null,
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
                  SingleChildScrollView(
                    child: Column(
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
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            onTap: sMeter
                                ? () {
                                    notification().warning(
                                        context, 'Image Already uploaded');
                                  }
                                : () {
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
                                        child: startMeter.isNotEmpty ||
                                                start64ConvertData != null
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                                child: Container(
                                                    height: h / 5.5,
                                                    width: w / 2.3,
                                                    child: start64ConvertData !=
                                                            null
                                                        ? Image.memory(
                                                            start64ConvertData!,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.file(
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
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black38,
                                                        fontSize: 12.dp,
                                                      )),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                startMeter.isNotEmpty || sMeter
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
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextField(
                                controller: startController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  // border: OutlineInputBorder(
                                  //   borderRadius: BorderRadius.circular(10.0),
                                  // ),
                                  label: Text('meter data'),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                  hintText: "type meter value",
                                  fillColor: Color.fromARGB(179, 232, 229, 229),
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: 0,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 25,
                              ),
                              InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                onTap: eMeter
                                    ? () {
                                        notification().warning(
                                            context, 'Image Already uploaded');
                                      }
                                    : () {
                                        if (start64.isNotEmpty) {
                                          bottomDialog(false);
                                        } else {
                                          notification().warning(context,
                                              'Please Upload start meter details Image');
                                        }
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
                                        child: endMeter.isNotEmpty ||
                                                end64ConvertData != null
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                                child: Container(
                                                    height: h / 5.5,
                                                    width: w / 2.3,
                                                    child: end64ConvertData !=
                                                            null
                                                        ? Image.memory(
                                                            end64ConvertData!,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.file(
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
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
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
                              SizedBox(
                                height: 20,
                              ),
                              endMeter.isNotEmpty || eMeter
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                  : SizedBox(
                                      width: 25,
                                    ),
                            ],
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextField(
                                controller: endController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  // border: OutlineInputBorder(
                                  //   borderRadius: BorderRadius.circular(10.0),
                                  // ),
                                  label: Text('meter data'),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                  hintText: "type meter value",
                                  fillColor: Color.fromARGB(179, 232, 229, 229),
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: 0,
                          ),
                          DialogButton(
                            buttonHeight: h / 14,
                            width: w / 1.4,
                            text: 'Save',
                            color: eMeter && sMeter
                                ? Color.fromARGB(255, 73, 76, 78)
                                : Color.fromARGB(255, 8, 152, 219),
                            onTap: eMeter && sMeter
                                ? () {
                                    notification().warning(context,
                                        'You already submitted attendance data');
                                  }
                                : () async {
                                    if (start64.isNotEmpty) {
                                      if (startController.text.isNotEmpty) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        var res = await CustomApi()
                                            .attendanceStartMeter(
                                                context, start64);
                                        data();
                                      } else {
                                        notification().warning(context,
                                            'Please provide your vehicle meter details');
                                      }
                                    } else if (end64.isNotEmpty) {
                                      if (start64.isNotEmpty) {
                                        if (endController.text.isNotEmpty) {
                                          end = int.parse(
                                              endController.text.toString());
                                          if (end > startKM) {
                                            int doneKm = end - startKM;

                                            setState(() {
                                              isLoading = true;
                                            });
                                            var res = await CustomApi()
                                                .attendanceEndMeter(
                                              context,
                                              end64,
                                              apiMidId,
                                              endController.text,
                                              doneKm.toString(),
                                            );
                                            data();
                                          } else {
                                            notification().warning(context,
                                                'Please provide valid details');
                                          }
                                        } else {
                                          notification().warning(context,
                                              'Please provide your vehicle meter details');
                                        }
                                      } else {
                                        notification().warning(context,
                                            'Please provide your vehicle start meter detail');
                                      }
                                    }
                                  },
                            //0765639176
                          ),
                        ]),
                  ),
                  isLoading ? Loader().loader(context) : SizedBox(),
                  provider.isanotherUserLog ? UserLoginCheck() : SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String convertIntoBase64(File file) {
    List<int> imageBytes = file.readAsBytesSync();
    String base64File = base64Encode(imageBytes);
    return base64File;
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

  MeterKmDialog() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            ' Add your vehicle Meter deatils',
            style: TextStyle(fontSize: 17),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: startController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Type in your text",
                  fillColor: Colors.white70,
                ),
              ),
            ),
          ),
          Divider(
            height: 0,
          ),
          DialogButton(
            onTap: () {
              if (startController.text.isNotEmpty) {
                end = int.parse(startController.text.toString());
                if (end > startKM) {
                  Navigator.pop(context);
                } else {
                  notification()
                      .warning(context, 'Please provide valid details');
                }
              } else {
                notification().warning(
                    context, 'Please provide your vehicle meter details');
              }
            },
            buttonHeight: h / 14,
            width: w / 1.4,
            text: 'Save',
            color: Color.fromARGB(255, 8, 152, 219),
          )
        ],
      )),
    );
  }

  fromGallery(bool isStart) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (isStart) {
        final bytes = File(image!.path).readAsBytesSync();
        String base64Image = base64Encode(bytes);

        startMeter = image!.path;
        start64 = base64Image;
        end64 = '';
      } else {
        final bytes = File(image!.path).readAsBytesSync();
        String base64Image = base64Encode(bytes);

        startMeter = image!.path;
        end64 = base64Image;
        start64 = '';
        endMeter = image!.path;
      }
    });
  }

  fromCamera(bool isStart) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (isStart) {
        final bytes = File(image!.path).readAsBytesSync();
        String base64Image = base64Encode(bytes);

        startMeter = image!.path;
        start64 = base64Image;
        end64 = '';
      } else {
        final bytes = File(image!.path).readAsBytesSync();
        String base64Image = base64Encode(bytes);

        end64 = base64Image;
        start64 = '';
        endMeter = image!.path;
      }
    });
  }
}
