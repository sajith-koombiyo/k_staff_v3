import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';
import '../../../../../app_details/color.dart';
import '../../../../../class/class.dart';
import '../../../../widget/nothig_found.dart';
import '../../../navigation/navigation.dart';

class BranchRoute extends StatefulWidget {
  const BranchRoute({
    super.key,
  });

  @override
  State<BranchRoute> createState() => _BranchRouteState();
}

class _BranchRouteState extends State<BranchRoute> {
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
  int selectedIndex = 1000;
  String newImage = '';
  File? myImage;
  late ScrollController mycontroller = ScrollController();
  List dataList = [];

  bool isLoading = false;
  String branchListID = '';

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

    getData('');

    setState(() {
      userBranchList.addAll(brancheList);

      // isLoading = false;
    });
  }

  getData(String branchId) async {
    setState(() {
      isLoading = true;
    });
    var res = await CustomApi().branchRoute(context, branchId);
    log(res.toString());
    setState(() {
      dataList = res;
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
                        "Select branch",
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
                        selectval =
                            value.toString(); //change selectval to new value
                      });
                    },
                    items: userBranchList.map((itemone) {
                      return DropdownMenuItem(
                          onTap: () {
                            setState(() {
                              visitBranchId = itemone['did'];
                              branchListID = visitBranchId;
                            });
                            if (visitBranchId == '10000') {
                              getData('');
                            } else {
                              getData(branchListID);
                            }
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
          title: Text(
            'Branch Route',
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
                    itemCount: dataList.length,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          dataList[index]['br_name'],
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                if (selectedIndex != index) {
                                                  isOpen = true;
                                                  selectedIndex = index;
                                                } else {
                                                  selectedIndex = index;
                                                  isOpen = !isOpen;
                                                }
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
                                          color: dataList[index]['br_status'] ==
                                                  '1'
                                              ? Color.fromARGB(255, 24, 179, 50)
                                              : Colors.red,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: Text(
                                              dataList[index]['br_status'] ==
                                                      '1'
                                                  ? 'Active'
                                                  : 'Pending',
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
                                          '${dataList[index]['length']}KM',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: black,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    isOpen && selectedIndex == index
                                        ? Container(
                                            decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    31, 51, 129, 162),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            width: w,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'City List',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: black),
                                                  ),
                                                  Text(
                                                    '${dataList[index]['city_names']}',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : SizedBox()
                                  ]),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            isLoading
                ? Center(
                    child: Loader().loader(context),
                  )
                : SizedBox(),
            provider.isanotherUserLog ? UserLoginCheck() : SizedBox()
          ],
        ),
      ),
    );
  }
}
