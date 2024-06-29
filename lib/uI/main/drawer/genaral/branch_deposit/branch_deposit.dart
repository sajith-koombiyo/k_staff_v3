import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/uI/widget/diloag_button.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../../app_details/color.dart';

class BranchDeposit extends StatefulWidget {
  const BranchDeposit({super.key});

  @override
  State<BranchDeposit> createState() => _BranchDepositState();
}

class _BranchDepositState extends State<BranchDeposit> {
  TextEditingController dateController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  DateTime selectedDate = DateTime.now();
  String? selectval;
  List userBranchList = [];
  String visitBranchId = '';
  String newImage = '';
  List<File> imagesList = [];
  int x = 0;
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appliteBlue,
        // bottom: PreferredSize(
        //     preferredSize: Size(w, 70),
        //     child: Padding(
        //       padding: const EdgeInsets.only(bottom: 12),
        //       child: serchBarr(context),
        //     )),
        title: Text(
          'Branch Deposit',
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
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            height: h,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 20,
                    borderOnForeground: true,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 144, 174, 179),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7)),
                                color: Colors.amber,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    'Status',
                                    style: TextStyle(
                                      fontSize: 14.dp,
                                      color: black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.photo,
                                        color: Color.fromARGB(255, 65, 68, 67),
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        addData();
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: Color.fromARGB(255, 9, 3, 97),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              border: Border.all(color: bacground)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: w / 2.3,
                                    child: Text(
                                      'Date',
                                      style: TextStyle(
                                        fontSize: 14.dp,
                                        color: black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: w / 2.3,
                                    child: Column(
                                      children: [
                                        Text(
                                          '2024/04/05',
                                          style: TextStyle(
                                            fontSize: 12.dp,
                                            color: black2,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Container(
                                    width: w / 2.3,
                                    child: Text(
                                      'COD Amount',
                                      style: TextStyle(
                                        fontSize: 14.dp,
                                        color: black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: w / 2.3,
                                    child: Column(
                                      children: [
                                        Text(
                                          '1000',
                                          style: TextStyle(
                                            fontSize: 14.dp,
                                            color: black2,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.black26,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: w / 2.3,
                                    child: Text(
                                      'Deposit Amount',
                                      style: TextStyle(
                                        fontSize: 14.dp,
                                        color: black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: w / 2.3,
                                    child: Column(
                                      children: [
                                        Text(
                                          '100',
                                          style: TextStyle(
                                            fontSize: 14.dp,
                                            color: black2,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.black26,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: w / 2.3,
                                    child: Text(
                                      'Expenses',
                                      style: TextStyle(
                                        fontSize: 14.dp,
                                        color: black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: w / 2.3,
                                    child: Column(
                                      children: [
                                        Text(
                                          '1000',
                                          style: TextStyle(
                                            fontSize: 14.dp,
                                            color: black2,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.black26,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: w / 2.3,
                                    child: Text(
                                      'Commission',
                                      style: TextStyle(
                                        fontSize: 14.dp,
                                        color: black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: w / 2.3,
                                    child: Column(
                                      children: [
                                        Text(
                                          '1000',
                                          style: TextStyle(
                                            fontSize: 14.dp,
                                            color: black2,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.black26,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: w / 2.3,
                                    child: Text(
                                      'Variance',
                                      style: TextStyle(
                                        fontSize: 14.dp,
                                        color: black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: w / 2.3,
                                    child: Column(
                                      children: [
                                        Text(
                                          '100',
                                          style: TextStyle(
                                            fontSize: 14.dp,
                                            color: black2,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Divider(
                                          height: 8,
                                          color: black,
                                        ),
                                        Divider(
                                          height: 0,
                                          color: black,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(
                                      'Remark',
                                      style: TextStyle(
                                        fontSize: 14.dp,
                                        color: black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all()),
                                    width: w / 1.5,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Text(
                                            'snjsnjdns dsdjnsdjwd dnwjndw wdbwd w bwdjwbdbw wd wd ww wbdwd',
                                            style: TextStyle(
                                              fontSize: 14.dp,
                                              color: black2,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ]),
      ),
    );
  }

  addData() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setstate) {
        return AlertDialog(
          actions: [
            DialogButton(
                text: 'SAVE',
                onTap: () {},
                buttonHeight: h / 17,
                width: w,
                color: Colors.blue)
          ],
          scrollable: true,
          content: SizedBox(
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            onPressed: () {
                              setstate(() {
                                imagesList = [];
                              });

                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close))),
                    Text(
                      'Date',
                      style: TextStyle(
                        fontSize: 14.dp,
                        color: black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    serchBarr(context),
                    Text(
                      'Agent',
                      style: TextStyle(
                        fontSize: 14.dp,
                        color: black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    drop(),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () async {
                          // final XFile? image = await _picker.pickImage(
                          //     imageQuality: 25, source: ImageSource.camera);

                          // setstate(() {
                          //   newImage = image!.path;
                          // });
                          final pickedFile = await _picker.pickImage(
                              source: ImageSource.camera);

                          if (pickedFile != null) {
                            imagesList.add(File(pickedFile.path));
                            setstate(() {
                              imagesList;
                            });
                          }
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
                              width: w / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 40,
                                    color: const Color.fromARGB(96, 77, 76, 76),
                                  ),
                                  Text('Please upload \nyour image',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black38,
                                        fontSize: 12.dp,
                                      )),
                                  x == 2
                                      ? Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'image required',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        )
                                      : SizedBox()
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
                    imagesList.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            child: Text(
                              'No any Image ',
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        : SizedBox(
                            width: double.maxFinite,
                            height: 70,
                            child: ListView.builder(
                              padding: EdgeInsets.all(0),
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  imagesList.isEmpty ? 5 : imagesList.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                      color: Colors.black12,
                                      width: 50,
                                      height: 50,
                                      child: imagesList.isEmpty
                                          ? SizedBox()
                                          : Image.file(
                                              imagesList[index],
                                              fit: BoxFit.cover,
                                            )),
                                ),
                              ),
                            ),
                          ),
                  ]),
            ),
          ),
        );
      }),
    );
  }

  Widget drop() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Card(
      child: Container(
        height: h / 17,
        padding: EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.centerRight,
        width: w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
              color: Colors.black12, style: BorderStyle.solid, width: 0.80),
        ),
        child: DropdownButton(
          focusColor: white1,
          dropdownColor: white1,
          isExpanded: true,
          alignment: AlignmentDirectional.centerEnd,
          hint: Container(
            //and here
            alignment: Alignment.centerLeft,
            child: Text(
              "Select agent",
              style: TextStyle(color: black1),
              textAlign: TextAlign.end,
            ),
          ),
          value: selectval, //implement initial value or selected value
          onChanged: (value) {
            setState(() {
              // _runFilter(value.toString());
              //set state will update UI and State of your App
              selectval = value.toString(); //change selectval to new value
            });
          },
          items: userBranchList.map((itemone) {
            return DropdownMenuItem(
                onTap: () {
                  setState(() {
                    visitBranchId = itemone['did'];
                  });
                  // getData(itemone['did']);
                },
                value: itemone['dname'],
                child: Text(
                  itemone['dname'],
                  style: TextStyle(color: black2),
                ));
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Widget serchBarr(BuildContext con) {
    var h = MediaQuery.of(con).size.height;
    var w = MediaQuery.of(con).size.width;
    return SizedBox(
      height: h / 15,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              onTap: () {
                _selectDate(context);
              },
              readOnly: true,
              onChanged: (value) {},
              controller: dateController,
              style: TextStyle(color: black, fontSize: 13.sp),
              validator: (value) {},
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.calendar_month),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                filled: true,
                hintStyle: TextStyle(fontSize: 13.dp),
                hintText: 'Select date',
                fillColor: Colors.white38,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      imagesList.add(File(pickedFile.path));
    }
  }
}
