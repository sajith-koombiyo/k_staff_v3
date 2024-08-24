import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';
import '../../../../../app_details/color.dart';
import '../../../../widget/nothig_found.dart';
import '../../../navigation/navigation.dart';

class FindBranch extends StatefulWidget {
  const FindBranch({super.key});

  @override
  State<FindBranch> createState() => _FindBranchState();
}

class _FindBranchState extends State<FindBranch> {
  int accessGroupId = 1;
  TextEditingController dateController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? selectval;
  List<File> loadImages = [];
  List userBranchList = [
    {'dname': 'All', 'did': '10000'}
  ];
  bool isOpen = false;
  String visitBranchId = '';
  String riderId = '';
  int selectedIndex = 0;
  String newImage = '';
  File? myImage;
  late ScrollController mycontroller = ScrollController();
  List dataList = [];
  List dataListTemp = [];
  bool isLoading = false;
  String branchListID = '';
  bool isActive = true;
  bool active = true;
  List destinationList = [];
  String? selectDId;
  var destinationId;
  void initState() {
    getUserBranch();

    super.initState();
  }

  getUserBranch() async {
    setState(() {
      isLoading = true;
    });
    Provider.of<ProviderS>(context, listen: false);
    List brancheList = await CustomApi().userActiveBranches(context);
    log(brancheList.toString());
    getData('');

    setState(() {
      userBranchList.addAll(brancheList);

      // isLoading = false;
    });
  }

  getData(String branch) async {}

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
        body: Column(
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
                                                onTap: () {
                                                  getData(itemone['did']);
                                                  print(itemone['did']);
                                                  // branchId = itemone['did'];
                                                  // getData(
                                                  //     branchId,
                                                  //     destinationId,
                                                  //     isActive ? '1' : '0');
                                                },
                                                value: itemone['dname'],
                                                child: Text(
                                                  itemone['dname'],
                                                  style:
                                                      TextStyle(color: black2),
                                                ));
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
                                          alignment:
                                              AlignmentDirectional.centerEnd,
                                          hint: Container(
                                            //and here
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Designation",
                                              style: TextStyle(color: black1),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          value:
                                              selectDId, //implement initial value or selected value
                                          onChanged: (value) {
                                            setState(() {
                                              // _runFilter(value.toString());
                                              //set state will update UI and State of your App
                                              selectDId = value
                                                  .toString(); //change selectval to new value
                                            });
                                          },
                                          items: destinationList.map((itemone) {
                                            return DropdownMenuItem(
                                                onTap: () {
                                                  setState(() {
                                                    destinationId =
                                                        itemone['id'];
                                                  });
                                                  // getData(
                                                  //     branchId,
                                                  //     destinationId,
                                                  //     isActive
                                                  //         ? '1'
                                                  //         : '0');
                                                },
                                                value: itemone['dName'],
                                                child: Text(
                                                  itemone['dName'],
                                                  style:
                                                      TextStyle(color: black2),
                                                ));
                                          }).toList(),
                                        ),
                                      ),
                                    ),
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
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  alignment: Alignment.centerRight,
                                  width: w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(
                                        color: black3,
                                        style: BorderStyle.solid,
                                        width: 0.80),
                                  ),
                                  child: DropdownButton(
                                    isExpanded: true,
                                    alignment: AlignmentDirectional.centerEnd,
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
                                          onTap: () {
                                            getData(itemone['did']);
                                            print(itemone['did']);
                                            // branchId = itemone['did'];
                                            // getData(
                                            //     branchId,
                                            //     destinationId,
                                            //     isActive ? '1' : '0');
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
                          ],
                        )
                      : SizedBox()
                ],
              ),
            ),
            Flexible(
              child: Stack(
                children: [
                  dataList.isEmpty && isLoading == false
                      ? SizedBox(
                          height: h,
                          width: w,
                          child: Column(
                            children: [
                              Center(child: NoData()),
                            ],
                          ))
                      : ListView.builder(
                          itemCount: 5,
                          controller: mycontroller,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Route Name',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedIndex = index;
                                                      isOpen = !isOpen;
                                                    });
                                                  },
                                                  icon: Icon(isOpen &&
                                                          selectedIndex == index
                                                      ? Icons
                                                          .keyboard_arrow_down_sharp
                                                      : Icons
                                                          .keyboard_arrow_right_rounded))
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Card(
                                                color: Colors.red,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                                  child: Text(
                                                    'Active',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: black,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Text(
                                                '50KM',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: black,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          isOpen && selectedIndex == index
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.black12,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  height: h / 7,
                                                  width: w,
                                                )
                                              : SizedBox()
                                        ]),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                  provider.isanotherUserLog ? UserLoginCheck() : SizedBox()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
