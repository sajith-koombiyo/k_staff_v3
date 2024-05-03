import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class EmployeeDetails extends StatefulWidget {
  const EmployeeDetails({super.key});

  @override
  State<EmployeeDetails> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  List listitems = [
    'All',
    'Gampaha',
    'Nittmbuwa',
    'Colombo',
    'Nugegoda',
  ];
  String? selectval;
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
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
                  value: selectval, //implement initial value or selected value
                  onChanged: (value) {
                    setState(() {
                      // _runFilter(value.toString());
                      //set state will update UI and State of your App
                      selectval =
                          value.toString(); //change selectval to new value
                    });
                  },
                  items: listitems.map((itemone) {
                    return DropdownMenuItem(
                        value: itemone,
                        child: Text(
                          itemone,
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
      body: ListView.builder(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        itemCount: 10,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Card(
                                      elevation: 1,
                                      child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.person_add_alt_sharp,
                                            size: 40,
                                            color: Color(Random()
                                                    .nextInt(0xffffffff))
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
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('name:- Kalyana nemesh',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                                fontSize: 12.dp,
                                              )),
                                          Text('User Name:- nemesh',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                                fontSize: 12.dp,
                                              )),
                                          Text(
                                              'Address:- Kalyana lanka pvt (LTD)}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                                fontSize: 12.dp,
                                              )),
                                          Text('Type:- permanent',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                                fontSize: 12.dp,
                                              )),
                                          Text('Designation:- Manager',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                                fontSize: 12.dp,
                                              )),
                                          Text('Phone:-071601502',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    221, 220, 44, 44),
                                                fontSize: 14.dp,
                                              )),
                                          Text('branch:-Gampaha',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Color.fromARGB(
                                                    221, 44, 65, 220),
                                                fontSize: 14.dp,
                                              )),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            child: Card(
                                              elevation: 30,
                                              color: Color.fromARGB(
                                                  255, 228, 225, 12),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4),
                                                child: Text('Active',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Color.fromARGB(
                                                          221, 3, 12, 83),
                                                      fontSize: 14.dp,
                                                    )),
                                              ),
                                            ),
                                          ),
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
    );
  }
}
