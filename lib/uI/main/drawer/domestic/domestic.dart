import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../../../../app_details/color.dart';
import '../../../../../class/class.dart';

import '../../../widget/nothig_found.dart';
import '../../navigation/navigation.dart';

class Domestic extends StatefulWidget {
  const Domestic({super.key});

  @override
  State<Domestic> createState() => _DomesticState();
}

class _DomesticState extends State<Domestic> {
  int accessGroupId = 1;
  TextEditingController dateController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
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
  String branchListID = '';
  bool isActive = true;
  bool active = true;
  List destinationList = [];
  String? selectDId;
  var destinationId;
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
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: appliteBlue,
                  child: Column(
                    children: [
                      Divider(),
                      Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Card(
                                    child: Container(
                                      height: h / 17,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      alignment: Alignment.centerRight,
                                      width: w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        border: Border.all(
                                            color: black3,
                                            style: BorderStyle.solid,
                                            width: 0.80),
                                      ),
                                      child: DropdownButton(
                                        isExpanded: true,
                                        alignment:
                                            AlignmentDirectional.centerEnd,
                                        hint: Container(
                                          //and here
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Pickup Rider",
                                            style: TextStyle(color: black1),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                        value:
                                            selectDistrict, //implement initial value or selected value
                                        onChanged: (value) {
                                          setState(() {
                                            selectDistrict = value
                                                .toString(); //change selectval to new value
                                          });
                                        },
                                        items: districtList.map((itemone) {
                                          return DropdownMenuItem(
                                              onTap: () async {
                                                setState(() {
                                                  selectval = null;
                                                  selectCity = null;
                                                  districtId =
                                                      itemone['district_sl_id'];
                                                });
                                                await getCity(
                                                    itemone['district_sl_id']);

                                                demarcationData(
                                                    districtId, '', '');
                                              },
                                              value: itemone['district_name'],
                                              child: Text(
                                                itemone['district_name'],
                                                style: TextStyle(color: black2),
                                              ));
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Card(
                                        child: Container(
                                          height: h / 17,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          alignment: Alignment.centerRight,
                                          width: w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            border: Border.all(
                                                color: black3,
                                                style: BorderStyle.solid,
                                                width: 0.80),
                                          ),
                                          child: DropdownButton(
                                            isExpanded: true,
                                            alignment:
                                                AlignmentDirectional.centerEnd,
                                            hint: Container(
                                              //and here
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Pickup Id",
                                                style: TextStyle(color: black1),
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                            value:
                                                selectCity, //implement initial value or selected value
                                            onChanged: (value) {
                                              setState(() {
                                                // _runFilter(value.toString());
                                                //set state will update UI and State of your App
                                                selectCity = value
                                                    .toString(); //change selectval to new value
                                              });
                                            },
                                            items: cityList.map((itemone) {
                                              return DropdownMenuItem(
                                                  onTap: () {
                                                    setState(() {
                                                      selectval = null;
                                                      destinationId =
                                                          itemone['cid'];
                                                      cityName =
                                                          itemone['cname'];
                                                    });
                                                    demarcationData(districtId,
                                                        cityName, '');
                                                  },
                                                  value: itemone['cname'],
                                                  child: Text(
                                                    itemone['cname'],
                                                    style: TextStyle(
                                                        color: black2),
                                                  ));
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    cityLoading
                                        ? Center(
                                            child: SizedBox(
                                            height: h / 16,
                                            child: LoadingAnimationWidget
                                                .prograssiveDots(
                                              color: Color.fromARGB(
                                                  255, 198, 187, 186),
                                              size: 40,
                                            ),
                                          ))
                                        : SizedBox()
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'DELIVERY CHARGE TYPE',
                        style: TextStyle(
                            color: black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                redioWidget()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget redioWidget() {
    int selectedOption = 0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Row(
                children: [
                  Radio(value: 1, groupValue: 'null', onChanged: (index) {}),
                  Expanded(
                    child: Text('Radio button 1'),
                  )
                ],
              ),
              flex: 1,
            ),
            Expanded(
              child: Row(
                children: [
                  Radio(value: 1, groupValue: 'null', onChanged: (index) {}),
                  Expanded(child: Text('Radio 2'))
                ],
              ),
              flex: 1,
            ),
            Expanded(
              child: Row(
                children: [
                  Radio(value: 1, groupValue: 'null', onChanged: (index) {}),
                  Expanded(child: Text('Test'))
                ],
              ),
              flex: 1,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Radio(value: 1, groupValue: 'null', onChanged: (index) {}),
                  Expanded(child: Text('RB 1'))
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Radio(value: 1, groupValue: 'null', onChanged: (index) {}),
                  Expanded(child: Text('Btn Radio 2'))
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Radio(value: 1, groupValue: 'null', onChanged: (index) {}),
                  Expanded(
                    child: Text('Rad 3'),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
