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
import '../../../../widget/nothig_found.dart';
import '../../../navigation/navigation.dart';

class FindDemarcation extends StatefulWidget {
  const FindDemarcation({super.key});

  @override
  State<FindDemarcation> createState() => _FindDemarcationState();
}

class _FindDemarcationState extends State<FindDemarcation> {
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
            'Find Demarcation',
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
            SingleChildScrollView(
              child: SizedBox(height: h,
                child: Column(
                  children: [
                    Container(
                      color: appliteBlue,
                      child: Column(
                        children: [
                          Divider(),
                          Container(
                            height: h / 17,
                            width: w,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Filter",
                                    style: TextStyle(color: white),
                                    textAlign: TextAlign.end,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isActive = !isActive;
                                        });
                                      },
                                      icon: Icon(
                                        isActive
                                            ? Icons.keyboard_arrow_down_outlined
                                            : Icons.keyboard_arrow_up_outlined,
                                        color: white,
                                      ))
                                ],
                              ),
                            ),
                          ),
                          isActive
                              ? Column(
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Padding(
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
                                                  alignment: AlignmentDirectional
                                                      .centerEnd,
                                                  hint: Container(
                                                    //and here
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      "District",
                                                      style:
                                                          TextStyle(color: black1),
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
                                                  items:
                                                      districtList.map((itemone) {
                                                    return DropdownMenuItem(
                                                        onTap: () async {
                                                          setState(() {
                                                            selectval = null;
                                                            selectCity = null;
                                                            districtId = itemone[
                                                                'district_sl_id'];
                                                          });
                                                          await getCity(itemone[
                                                              'district_sl_id']);
                
                                                          demarcationData(
                                                              districtId, '', '');
                                                        },
                                                        value: itemone[
                                                            'district_name'],
                                                        child: Text(
                                                          itemone['district_name'],
                                                          style: TextStyle(
                                                              color: black2),
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
                                                    alignment:
                                                        Alignment.centerRight,
                                                    width: w,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      border: Border.all(
                                                          color: black3,
                                                          style: BorderStyle.solid,
                                                          width: 0.80),
                                                    ),
                                                    child: DropdownButton(
                                                      isExpanded: true,
                                                      alignment:
                                                          AlignmentDirectional
                                                              .centerEnd,
                                                      hint: Container(
                                                        //and here
                                                        alignment:
                                                            Alignment.centerLeft,
                                                        child: Text(
                                                          "City",
                                                          style: TextStyle(
                                                              color: black1),
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
                                                      items:
                                                          cityList.map((itemone) {
                                                        return DropdownMenuItem(
                                                            onTap: () {
                                                              setState(() {
                                                                selectval = null;
                                                                destinationId =
                                                                    itemone['cid'];
                                                                cityName = itemone[
                                                                    'cname'];
                                                              });
                                                              demarcationData(
                                                                  districtId,
                                                                  cityName,
                                                                  '');
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
                                    Padding(
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
                                                "Location",
                                                style: TextStyle(color: black1),
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                            value:
                                                selectval, //implement initial value or selected value
                                            onChanged: (value) {
                                              setState(() {
                                                // _runFilter(value.toString());
                                                //set state will update UI and State of your App
                                                selectval = value
                                                    .toString(); //change selectval to new value
                                              });
                                            },
                                            items: userBranchList.map((itemone) {
                                              return DropdownMenuItem(
                                                  onTap: () async {
                                                    setState(() {
                                                      selectDistrict = null;
                                                      selectCity = null;
                                                    });
                                                    print(itemone['did']);
                                                    // branchId = itemone['did'];
                
                                                    await demarcationData(
                                                        '', '', itemone['did']);
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
                                    SizedBox(
                                      height: 5,
                                    )
                                  ],
                                )
                              : SizedBox()
                        ],
                      ),
                    ),
                    Flexible(
                      child: Stack(
                        children: [
                          demarcationList.isEmpty && isLoading == false
                              ? SizedBox(
                                  // height: h,
                                  width: w,
                                  child: Column(
                                    children: [
                                      Center(child: NoData()),
                                    ],
                                  ))
                              : ListView.builder(
                                  itemCount: demarcationList.length,
                                  controller: mycontroller,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        color: Color.fromARGB(255, 209, 219, 228),
                                        elevation: 20,
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: w / 3,
                                                            child: Text(
                                                              'District',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Text(
                                                            demarcationList[index]
                                                                ['dname'],
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: black1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: w / 3,
                                                            child: Text(
                                                              'City',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Text(
                                                            demarcationList[index]
                                                                ['cname'],
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: black1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: w / 3,
                                                            child: Text(
                                                              'Branch',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Text(
                                                            demarcationList[index]
                                                                ['bname'],
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: black1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: w / 3,
                                                            child: Text(
                                                              'Updated By',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Text(
                                                            demarcationList[index]
                                                                ['staff_name'],
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: black1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: w / 3,
                                                            child: Text(
                                                              'Last Updated On',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Text(
                                                            demarcationList[index]
                                                                ['update_date'],
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: black1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                          isLoading ? Loader().loader(context) : SizedBox(),
                          provider.isanotherUserLog ? UserLoginCheck() : SizedBox()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
