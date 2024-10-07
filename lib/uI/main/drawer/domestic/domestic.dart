import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/uI/widget/add_user_textfeald/add_user_textfeald.dart';
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
  String? selectDistrict;
  String? selectCity;
  List<File> loadImages = [];
  List userBranchList = [
    {'dname': 'All', 'did': '10000'}
  ];
  bool isOpen = false;
  String visitBranchId = '';
  String districtId = '';
  String cityName = '';
  int selectedIndex = 0;
  bool cityLoading = false;
  late ScrollController mycontroller = ScrollController();
  List demarcationList = [];
  List districtList = [];
  List cityList = [];
  bool isLoading = false;

  void initState() {
    getUserBranch();
    getDistrict();

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
      userBranchList.addAll(brancheList);

      // isLoading = false;
    });
  }

  getDistrict() async {
    setState(() {
      isLoading = true;
      cityLoading = true;
    });

    var res = await CustomApi().demacationDistrict(context);
    log(res.toString());

    setState(() {
      districtList = res;
      cityLoading = false;
      isLoading = false;
    });
  }

  getCity(String districtId) async {
    log(districtId);
    setState(() {
      isLoading = true;
    });

    var res = await CustomApi().demacationCity(context, districtId);
    log(res.toString());

    setState(() {
      cityList = res;

      // isLoading = false;
    });
  }

  demarcationData(String districtId, String cityName, String branchId) async {
    setState(() {
      isLoading = true;
    });
    var res =
        await CustomApi().demacation(context, districtId, cityName, branchId);

    setState(() {
      demarcationList = res;
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
                      text(
                        'Picked By',
                      ),
                      Row(
                        children: [
                          dropDown(
                            'Pick ID',
                            cityList,
                            () {},
                            cityList!.map((itemone) {
                              return DropdownMenuItem(
                                  onTap: () {
                                    setState(() {
                                      selectval = null;

                                      cityName = itemone['cname'];
                                    });
                                  },
                                  value: itemone['cname'],
                                  child: Text(
                                    itemone['cname'],
                                    style: TextStyle(color: black2),
                                  ));
                            }).toList(),
                          ),
                          dropDown(
                            'Pick ID',
                            cityList,
                            () {},
                            cityList!.map((itemone) {
                              return DropdownMenuItem(
                                  onTap: () {
                                    setState(() {
                                      selectval = null;

                                      cityName = itemone['cname'];
                                    });
                                  },
                                  value: itemone['cname'],
                                  child: Text(
                                    itemone['cname'],
                                    style: TextStyle(color: black2),
                                  ));
                            }).toList(),
                          ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Radio(
                                    value: 1,
                                    groupValue: 'null',
                                    onChanged: (index) {}),
                                Expanded(
                                  child: Text('Charge On pickup'),
                                )
                              ],
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Radio(
                                    value: 2,
                                    groupValue: 'null',
                                    onChanged: (index) {}),
                                Expanded(child: Text('Charge On Delivery'))
                              ],
                            ),
                            flex: 1,
                          ),
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
                          Expanded(
                            child: Row(
                              children: [
                                Radio(
                                    value: 1,
                                    groupValue: 'null',
                                    onChanged: (index) {}),
                                Expanded(
                                  child: Text('Parcel(Max 99Kg)'),
                                )
                              ],
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Radio(
                                    value: 2,
                                    groupValue: 'null',
                                    onChanged: (index) {}),
                                Expanded(child: Text('Letter'))
                              ],
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Radio(
                                    value: 2,
                                    groupValue: 'null',
                                    onChanged: (index) {}),
                                Expanded(child: Text('Bulk'))
                              ],
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          dropDown(
                            'From Branch',
                            cityList,
                            () {},
                            districtList.map((itemone) {
                              return DropdownMenuItem(
                                  onTap: () async {
                                    setState(() {
                                      selectval = null;
                                      selectCity = null;
                                      districtId = itemone['district_sl_id'];
                                    });
                                    await getCity(itemone['district_sl_id']);
                                  },
                                  value: itemone['district_name'],
                                  child: Text(
                                    itemone['district_name'],
                                    style: TextStyle(color: black2),
                                  ));
                            }).toList(),
                          ),
                          dropDown(
                            'From Branch',
                            cityList,
                            () {},
                            districtList.map((itemone) {
                              return DropdownMenuItem(
                                  onTap: () async {
                                    setState(() {
                                      selectval = null;
                                      selectCity = null;
                                      districtId = itemone['district_sl_id'];
                                    });
                                    await getCity(itemone['district_sl_id']);
                                  },
                                  value: itemone['district_name'],
                                  child: Text(
                                    itemone['district_name'],
                                    style: TextStyle(color: black2),
                                  ));
                            }).toList(),
                          ),
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
                      text(
                        'FROM',
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
                  color: Color.fromARGB(255, 230, 252, 226),
                  elevation: 20,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text(
                              'TO',
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
                          ])))
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
      List<DropdownMenuItem> mapList) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          height: h / 17,
          padding: EdgeInsets.symmetric(horizontal: 15),
          alignment: Alignment.centerRight,
          width: w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            // border: Border.all(
            //     color: black3, style: BorderStyle.solid, width: 0.80),
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
              value: selectCity, //implement initial value or selected value
              onChanged: (value) {
                setState(() {
                  // _runFilter(value.toString());
                  //set state will update UI and State of your App
                  selectCity = value.toString(); //change selectval to new value
                });
              },
              items: mapList),
        ),
      ),
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
