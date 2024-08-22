import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/uI/main/navigation/navigation.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';

import '../../../../widget/nothig_found.dart';

class EmployeeDetails extends StatefulWidget {
  const EmployeeDetails({super.key});

  @override
  State<EmployeeDetails> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  bool isLoading = false;
  List userBranchList = [];
  String? selectval;
  List empList = [];
  getData(String id) async {
    setState(() {
      isLoading = true;
    });
    List res = await CustomApi().employeList(context, id, '0', '150');
    setState(() {
      empList = res;
      isLoading = false;
    });
  }

  getUserBranch() async {
    setState(() {
      isLoading = true;
    });
    var brancheList = await CustomApi().userActiveBranches(context);

    setState(() {
      userBranchList.addAll(brancheList);

      isLoading = false;
    });
  }

  @override
  void initState() {
    getUserBranch();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Consumer<ProviderS>(
      builder: (context, provider, child) => Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: appliteBlue,
          title: Text(
            'Employee Details',
            style: TextStyle(
              fontSize: 18.dp,
              color: white,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size(w, h / 12),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                child: Container(
                  height: h / 17,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.centerRight,
                  width: w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                        color: black3, style: BorderStyle.solid, width: 0.80),
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    alignment: AlignmentDirectional.centerEnd,
                    hint: Container(
                      //and here
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select employee",
                        style: TextStyle(color: black1),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    value:
                        selectval, //implement initial value or selected value
                    onChanged: (value) {
                      setState(() {
                        selectval =
                            value.toString(); //change selectval to new value
                      });
                    },
                    items: userBranchList.map((itemone) {
                      return DropdownMenuItem(
                          onTap: () async {
                            getData(itemone['did']);
                          },
                          value: itemone['dname'],
                          child: Text(
                            itemone['dname'],
                            style: TextStyle(color: black2),
                          ));
                    }).toList(),
                  ),
                ),
              ),
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
        body: Stack(
          children: [
            empList.isEmpty && isLoading == false
                ? Stack(children: [
                    SizedBox(
                        height: h,
                        width: w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: h / 2, child: NoData()),
                            Card(
                              child: Text('Please select your branch',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18.dp,
                                  )),
                            ),
                          ],
                        ))
                  ])
                : ListView.builder(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    itemCount: empList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                splashColor: blue,
                                onTap: () {
                                  // itemDetails();
                                },
                                onLongPress: () {},
                                child: Card(
                                  margin: EdgeInsets.only(left: 0),
                                  color: appliteBlue,
                                  child: Card(
                                    elevation: 50,
                                    margin: EdgeInsets.only(left: 3),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: w,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Card(
                                                  elevation: 1,
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Icon(
                                                        Icons
                                                            .person_add_alt_sharp,
                                                        size: 40,
                                                        color: Color(Random()
                                                                .nextInt(
                                                                    0xffffffff))
                                                            .withAlpha(0xff),
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                SizedBox(
                                                  width: w / 1.6,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          'Name:- ${empList[index]['full_name']}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 12.dp,
                                                          )),
                                                      Text(
                                                          'Employee Number:- ${empList[index]['emp_epf_no']}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 12.dp,
                                                          )),
                                                      Text(
                                                          'Address:- ${empList[index]['address']}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 12.dp,
                                                          )),
                                                      Text(
                                                          'Type:- ${empList[index]['emp_type_name']}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 12.dp,
                                                          )),
                                                      Text(
                                                          'Designation:- ${empList[index]['designation_name']}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 12.dp,
                                                          )),
                                                      Text(
                                                          'Personal contact:- ${empList[index]['personal_contact']}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Color.fromARGB(
                                                                    221,
                                                                    220,
                                                                    44,
                                                                    44),
                                                            fontSize: 14.dp,
                                                          )),
                                                      Text(
                                                          'Office contact:- ${empList[index]['ofc_contact']}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Color.fromARGB(
                                                                    221,
                                                                    11,
                                                                    155,
                                                                    76),
                                                            fontSize: 14.dp,
                                                          )),
                                                      statusRow(
                                                          'Active',
                                                          empList[index]
                                                              ['resign_status'],
                                                          empList[index][
                                                              'resigned_st_txt'],
                                                          Color.fromARGB(
                                                              255, 5, 175, 56),
                                                          Color.fromARGB(255,
                                                              244, 10, 57)),
                                                      statusRow(
                                                          'Clearance',
                                                          empList[index]
                                                              ['clearance_st'],
                                                          empList[index][
                                                              'clearence_st_txt'],
                                                          Color.fromARGB(
                                                              255, 150, 167, 3),
                                                          Color.fromARGB(255,
                                                              13, 149, 222)),
                                                      statusRow(
                                                          'Agreement Sign',
                                                          empList[index][
                                                              'agreement_signed_st'],
                                                          empList[index][
                                                              'agreement_signed_txt'],
                                                          Color.fromARGB(255,
                                                              13, 160, 173),
                                                          Color.fromARGB(
                                                              255, 186, 60, 7)),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
            isLoading ? Loader().loader(context) : SizedBox(),
            provider.isanotherUserLog ? UserLoginCheck() : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget statusRow(String typeName, String isActive, String statusText,
      Color color, Color color2) {
    return Row(
      children: [
        Text('$typeName:-',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Color.fromARGB(221, 44, 65, 220),
              fontSize: 14.dp,
            )),
        Container(
          alignment: Alignment.centerRight,
          child: Card(
            elevation: 30,
            color: isActive == '0' ? color : color2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text(statusText,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: white,
                    fontSize: 14.dp,
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
