import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/uI/widget/add_user_textfeald/add_user_textfeald.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:html/parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../widget/diloag_button.dart';
import 'work_details.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key, required this.branchId});
  final String branchId;

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  ScrollController _scrollController = ScrollController();
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController pConNumber = TextEditingController();
  TextEditingController oConNumber = TextEditingController();
  TextEditingController eConNumber = TextEditingController();
  TextEditingController birthday = TextEditingController();
  TextEditingController nic = TextEditingController();
  String genderValue = '';
  DateTime selectedDate = DateTime.now();
  final ImagePicker _picker = ImagePicker();
  String newImage = '';
  String newImage2 = '';
  String frontImage = '';
  String backImage = '';

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      persistentFooterButtons: [
        DialogButton(
            text: 'Next',
            onTap: () async {
              if (name.text.isNotEmpty &&
                  address.text.isNotEmpty &&
                  address.text.isNotEmpty &&
                  oConNumber.text.isNotEmpty &&
                  eConNumber.text.isNotEmpty &&
                  pConNumber.text.isNotEmpty &&
                  birthday.text.isNotEmpty &&
                  nic.text.isNotEmpty) {
                if (oConNumber.text.length == 10 &&
                    eConNumber.text.length == 10 &&
                    pConNumber.text.length == 10) {
                  if (genderValue.isNotEmpty) {
                    if (newImage.isNotEmpty) {
                      if (newImage2.isNotEmpty) {
                        if (nic.text.length >= 10 && nic.text.length <= 12) {
                          var res = await CustomApi().nicValidate(nic.text);

                          var response = jsonDecode(res);
                      
                          if (response['status'] == 1) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkDetails(
                                      branchId: widget.branchId,
                                      addres: address.text,
                                      birthday: birthday.text,
                                      eConNumber: eConNumber.text,
                                      gender: genderValue,
                                      nFront: frontImage,
                                      nbacke: backImage,
                                      name: name.text,
                                      nic: nic.text,
                                      oConnumber: oConNumber.text,
                                      pConNumber: pConNumber.text),
                                ));
                          } else {
                            // api response html tag remove
                            RegExp exp = RegExp(r"<[^>]*>",
                                multiLine: true, caseSensitive: true);
                            var freeHtml = response['msg'].replaceAll(exp, '');
                            notification().warning(context, freeHtml);
                          }
                        } else {
                          notification().warning(context,
                              "This NIC No already using  employee \nNIC No length should 10 or 12");
                        }
                      } else {
                        notification()
                            .warning(context, "Please upload NIC back image");
                      }
                    } else {
                      notification()
                          .warning(context, "Please upload NIC front image");
                    }
                  } else {
                    notification().warning(context, "Please select the gender");
                  }
                } else {
                  notification()
                      .warning(context, "Please input valid phone number");
                }
              } else {
                notification().warning(context, "Value Can't Be Empty");
              }
            },
            buttonHeight: h / 15,
            width: w,
            color: appButtonColorLite)
      ],
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: appliteBlue,
        title: Text(
          'Personal Details',
          style: TextStyle(color: white),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: w,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      width: 0.7, color: Color.fromARGB(31, 24, 22, 22))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddUserTextFelid(
                    controller: name,
                    hint: 'Full Name',
                    icon: Icons.person,
                    type: TextInputType.multiline,
                  ),
                  AddUserTextFelid(
                    controller: address,
                    hint: 'Address Name',
                    icon: Icons.home,
                    type: TextInputType.multiline,
                  ),
                  AddUserTextFelid(
                    controller: pConNumber,
                    hint: 'Personal Contact Number',
                    icon: Icons.call,
                    type: TextInputType.number,
                  ),
                  AddUserTextFelid(
                    controller: oConNumber,
                    hint: 'Office Contact number',
                    icon: Icons.call,
                    type: TextInputType.number,
                  ),
                  AddUserTextFelid(
                    controller: eConNumber,
                    hint: 'Emergency Contact Number',
                    icon: Icons.emergency,
                    type: TextInputType.number,
                  ),
                  customTextFieldDate(
                    'Birthday',
                    birthday,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Gender',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      addRadioButton(0, 'Female'),
                      addRadioButton(1, 'Male'),
                      addRadioButton(2, 'Others'),
                    ],
                  ),
                  customTextField(
                    'Nic',
                    Icons.account_box_outlined,
                    nic,
                    TextInputType.number,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Upload Nic Image',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          show(true);
                        },
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
                              width: w / 2.4,
                              child: newImage.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      child: Container(
                                          height: h / 7,
                                          width: w / 2.4,
                                          child: Image.file(
                                            File(newImage),
                                            fit: BoxFit.cover,
                                          )))
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
                                        Text('Please upload \nNIC Front Side',
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
                      InkWell(
                        onTap: () {
                          show(false);
                        },
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
                              width: w / 2.4,
                              child: newImage2.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      child: Container(
                                          height: h / 7,
                                          width: w / 2.4,
                                          child: Image.file(
                                            File(newImage2),
                                            fit: BoxFit.cover,
                                          )))
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
                                        Text('Please upload \nNIC Back Side',
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
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 120,
          )
        ]),
      ),
    );
  }

  ddd() {}

  List gender = ["Male", "Female", "Other"];

  String select = '';

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (value) {
            genderValue;

            setState(() {
              if (value == 'Female') {
                genderValue = '0';
              } else if (value == 'Male') {
                genderValue = '1';
              } else if (value == 'Other') {
                genderValue = '3';
              }
              select = value;
            });
          },
        ),
        Text(title)
      ],
    );
  }

  cameraImage(bool front) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    List<int> imageBytes = await image!.readAsBytes();
    // Encode the bytes to base64
    String base64Image = base64Encode(imageBytes);

    if (front) {
      setState(() {
        frontImage = "data:image/jpeg;base64,$base64Image";
     
        newImage = image!.path;
      });
    } else {
      setState(() {
        backImage = "data:image/jpeg;base64,$base64Image";
      
        newImage2 = image!.path;
      });
    }
  }

  galleryImage(bool front) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    List<int> imageBytes = await image!.readAsBytes();
    // Encode the bytes to base64
    String base64Image = base64Encode(imageBytes);
    setState(() {
      if (front) {
        frontImage = "data:image/jpeg;base64,$base64Image";
       
        newImage = image!.path;
      } else {
        backImage = "data:image/jpeg;base64,$base64Image";
       
        newImage2 = image!.path;
      }
    });
  }

  void show(bool isFront) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext cont) {
          return CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  cameraImage(isFront);
                  Navigator.pop(context);
               
                },
                child: Text('Use Camera'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  galleryImage(isFront);
                  Navigator.pop(context);
                },
                child: Text('Upload from files'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
          );
        });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        birthday.text = formattedDate.toString();
      });
    }
  }

  Widget customTextField(
    String hint,
    IconData icon,
    TextEditingController controller,
    TextInputType type,
  ) {
    var w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        // height: h / 10,
        child: TextField(
          keyboardType: type,
          controller: controller,
          onChanged: (value) {
            setState(() {
              controller;
            });
          },
          // maxLines: 5,
          // minLines: 1,
          decoration: InputDecoration(
              errorText:
                  controller.text.isEmpty ? "Value Can't Be Empty" : null,
              label: Text(
                hint,
                style: TextStyle(color: black3),
              ),
              // labelText: hint,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 0.2, color: Colors.black12),
                borderRadius: BorderRadius.circular(10.0),
              ),
              filled: true,
              fillColor: Colors.black12,
              prefixIcon: Icon(icon),
              hintText: 'Type here'),
        ),
      ),
    );
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
          controller: birthday,
          maxLines: 5,
          minLines: 1,
          onTap: () {
            _selectDate();
          },
          decoration: InputDecoration(
              errorText: birthday.text.isEmpty ? "Value Can't Be Empty" : null,
              label: Text(
                hint,
                style: TextStyle(color: black3),
              ),
              // labelText: hint,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 0.2, color: Colors.black12),
                borderRadius: BorderRadius.circular(10.0),
              ),
              filled: true,
              fillColor: Colors.black12,
              suffixIcon: Icon(Icons.calendar_month),
              hintText: 'dd/mm/yyy'),
        ),
      ),
    );
  }
}
