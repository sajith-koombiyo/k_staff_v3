import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/uI/widget/add_user_textfeald/add_user_textfeald.dart';
import 'package:flutter_application_2/uI/widget/diloag_button.dart';
import 'package:flutter_application_2/uI/widget/home_screen_widget/home_button.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';
import '../../../../../app_details/color.dart';

class Domestic extends StatefulWidget {
  const Domestic({super.key});

  @override
  State<Domestic> createState() => _DomesticState();
}

class _DomesticState extends State<Domestic> {
  int accessGroupId = 1;
  TextEditingController Name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController nic = TextEditingController();
  TextEditingController oderDestination = TextEditingController();
  TextEditingController actualeValue = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController toWaybill = TextEditingController();
  TextEditingController toName = TextEditingController();
  TextEditingController toAddress = TextEditingController();
  TextEditingController toPhone = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? selectval;

  String? selectBranch;
  String? selectToBranchBranch;
  List<File> loadImages = [];
  List userBranchList = [
    {'dname': 'All', 'did': '10000'}
  ];
  bool isOpen = false;
  String visitBranchId = '';
  String districtId = '';
  String cityName = '';
  int selectedIndex = 0;
  List riderList = [];
  bool cityLoading = false;
  late ScrollController mycontroller = ScrollController();

  bool isLoading = false;

  void initState() {
    getUserBranch();
    getRider();
    super.initState();
  }

  getUserBranch() async {
    setState(() {
      isLoading = true;
    });
    Provider.of<ProviderS>(context, listen: false);
    List brancheList = await CustomApi().userActiveBranches(context);
    log(brancheList.toString());

    setState(() {
      userBranchList = brancheList;

      isLoading = false;
    });
  }

  getRider() async {
    setState(() {
      isLoading = true;
    });

    List rider = await CustomApi().assignRiderList(context);
    log(rider.toString());
    setState(() {
      riderList = rider;
      isLoading = false;
    });
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
            'Domestic',
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
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Card(
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      text(
                        'PICKED BY',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          dropDown(
                              'Select Rider',
                              riderList,
                              () {},
                              riderList.map((itemone) {
                                return DropdownMenuItem(
                                    onTap: () {
                                      setState(() {
                                        selectval = null;

                                        selectval = itemone['staff_name'];
                                      });
                                    },
                                    value: itemone['staff_name'],
                                    child: Text(
                                      itemone['staff_name'],
                                      style: TextStyle(color: black2),
                                    ));
                              }).toList(),
                              selectval),
                          dropDown(
                              'Pickup Note ID',
                              riderList,
                              () {},
                              riderList.map((itemone) {
                                return DropdownMenuItem(
                                    onTap: () {
                                      setState(() {
                                        selectval = null;

                                        selectval = itemone['staff_name'];
                                      });
                                    },
                                    value: itemone['staff_name'],
                                    child: Text(
                                      itemone['staff_name'],
                                      style: TextStyle(color: black2),
                                    ));
                              }).toList(),
                              selectval),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      text(
                        'Delivery Charge Type',
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          pickedBy(0, 'Charge On pickup'),
                          pickedBy(1, 'Charge On Delivery'),
                        ],
                      ),
                      text(
                        'DELIVERY TYPE',
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          dTypeRadio(0, 'Parcel(Max 99Kg)'),
                          dTypeRadio(1, 'Letter'),
                          dTypeRadio(2, 'Bulk'),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          dropDown(
                              'From Branch',
                              userBranchList,
                              () {},
                              userBranchList.map((itemone) {
                                return DropdownMenuItem(
                                    onTap: () async {
                                      setState(() {
                                        selectToBranchBranch = itemone['dname'];
                                      });
                                    },
                                    value: itemone['dname'],
                                    child: Text(
                                      itemone['dname'],
                                      style: TextStyle(color: black2),
                                    ));
                              }).toList(),
                              selectToBranchBranch),
                          // dropDown(
                          //   'To Branch',
                          //   riderList,
                          //   () {},
                          //   riderList.map((itemone) {
                          //     return DropdownMenuItem(
                          //         onTap: () async {
                          //           setState(() {
                          //             selectval = null;
                          //             selectCity = null;
                          //             districtId = itemone['district_sl_id'];
                          //           });
                          //         },
                          //         value: itemone['district_name'],
                          //         child: Text(
                          //           itemone['district_name'],
                          //           style: TextStyle(color: black2),
                          //         ));
                          //   }).toList(),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                elevation: 20,
                color: Color.fromARGB(255, 216, 233, 247),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      text(
                        'FROM',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AddUserTextFelid(
                        controller: Name,
                        hint: 'Name',
                        icon: Icons.person,
                        type: TextInputType.multiline,
                      ),
                      AddUserTextFelid(
                        controller: address,
                        hint: 'Address',
                        icon: Icons.home,
                        type: TextInputType.multiline,
                      ),
                      AddUserTextFelid(
                        controller: phone,
                        hint: 'Phone',
                        icon: Icons.call,
                        type: TextInputType.number,
                      ),
                      customTextField(
                        'Nic',
                        Icons.account_box_outlined,
                        nic,
                        TextInputType.number,
                      ),
                      AddUserTextFelid(
                        controller: actualeValue,
                        hint: 'Actual Value',
                        icon: Icons.emergency,
                        type: TextInputType.number,
                      ),
                      AddUserTextFelid(
                        controller: weight,
                        hint: 'Weight',
                        icon: Icons.accessibility_new_rounded,
                        type: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                  color: Color.fromARGB(255, 221, 226, 221),
                  elevation: 10,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            text(
                              'TO',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            AddUserTextFelid(
                              controller: toWaybill,
                              hint: 'Waybill ID',
                              icon: Icons.adb,
                              type: TextInputType.number,
                            ),
                            AddUserTextFelid(
                              controller: toName,
                              hint: 'Name',
                              icon: Icons.person_3,
                              type: TextInputType.number,
                            ),
                            AddUserTextFelid(
                              controller: toAddress,
                              hint: 'Address',
                              icon: Icons.home,
                              type: TextInputType.number,
                            ),
                            AddUserTextFelid(
                              controller: toPhone,
                              hint: 'Phone',
                              icon: Icons.emergency,
                              type: TextInputType.number,
                            ),
                          ]))),
              SizedBox(
                height: 12,
              ),
              SizedBox(
                width: w / 1.5,
                child: HomeButton(
                  text: 'Save',
                  onTap: () {},
                ),
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget text(String text) {
    return Text(
      text,
      style: TextStyle(color: black, fontWeight: FontWeight.bold),
    );
  }

  Widget dropDown(String title, List dataList, VoidCallback onTap,
      List<DropdownMenuItem> mapList, String? select) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
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
                      title,
                      style: TextStyle(color: black1),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  value: select, //implement initial value or selected value
                  onChanged: (value) {
                    setState(() {
                      // _runFilter(value.toString());
                      //set state will update UI and State of your App
                      select = value.toString(); //change selectval to new value
                    });
                  },
                  items: mapList),
            ),
          ],
        ),
      ),
    );
  }

  List picked = ["Charge On pickup", "Female", "Other"];
  String select = '';
  String pickedValue = '';
  Row pickedBy(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: picked[btnValue],
          groupValue: select,
          onChanged: (value) {
            pickedValue;

            setState(() {
              if (value == 'pickedBy') {
                pickedValue = '0';
              } else if (value == 'Male') {
                pickedValue = '1';
              }
              select = value;
            });
          },
        ),
        Text(title)
      ],
    );
  }

  List dType = ["Parcel(Max 99Kg)", "Letter", "Bulk"];
  String dTypeSelect = '';
  String dTypeValue = '';
  Row dTypeRadio(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: dType[btnValue],
          groupValue: dTypeSelect,
          onChanged: (value) {
            dTypeValue;

            setState(() {
              if (value == 'Parcel(Max 99Kg)') {
                dTypeValue = '0';
              } else if (value == 'Letter') {
                dTypeValue = '1';
              } else if (value == 'Bulk') {
                dTypeValue = '3';
              }
              dTypeSelect = value;
            });
          },
        ),
        Text(title)
      ],
    );
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
}
