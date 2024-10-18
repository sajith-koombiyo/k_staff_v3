import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/uI/widget/custom_textField.dart';
import 'package:flutter_application_2/uI/widget/diloag_button.dart';
import 'package:flutter_application_2/uI/widget/nothig_found.dart';
import 'package:flutter_application_2/uI/widget/textField.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../navigation/navigation.dart';

class CODZeroApproval extends StatefulWidget {
  const CODZeroApproval({super.key});

  @override
  State<CODZeroApproval> createState() => _CODZeroApprovalState();
}

class _CODZeroApprovalState extends State<CODZeroApproval> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController remarkController = TextEditingController();
  int x = 0;
  List pdliveryList = [];
  String? dropdownvalue;
  List<Map<String, dynamic>> depositList = [
    {'date': '2023/01/23'},
    {'date': '2023/11/23'},
    {'date': '2023/02/23'},
    {'date': '2023/01/21'},
    {'date': '2023/01/23'},
    {'date': '2023/01/24'}
  ];
  String img =
      '/9j/4QGvRXhpZgAATU0AKgAAAAgABwEQAAIAAAAUAAAAYgEAAAQAAAABAAAFoAEBAAQAAAABAAAHgAEyAAIAAAAUAAAAdgESAAMAAAABAAEAAIdpAAQAAAABAAAAkQEPAAIAAAAHAAAAigAAAABzZGtfZ3Bob25lNjRfeDg2XzY0ADIwMjQ6MDg6MDIgMTM6Mjk6NTEAR29vZ2xlAAAQgp0ABQAAAAEAAAFXgpoABQAAAAEAAAFfkpIAAgAAAAQyNzIAkpEAAgAAAAQyNzIAkpAAAgAAAAQyNzIAkgoABQAAAAEAAAFnkgkAAwAAAAEAAAAAiCcAAwAAAAEAZAAAkAQAAgAAABQAAAFvkAMAAgAAABQAAAGDoAMABAAAAAEAAAeApAMAAwAAAAEAAAAAoAIABAAAAAEAAAWgkgIABQAAAAEAAAGXkgEACgAAAAEAAAGfkAAABwAAAAQwMjIwAAAAAAAAAK0AAABkACKgxzuaygAAABEcAAAD6DIwMjQ6MDg6MDIgMTM6Mjk6NTEAMjAyNDowODowMiAxMzoyOTo1MQAAAACeAAAAZAAAIk8AAAPo/+AAEEpGSUYAAQEAAAEAAQAA/9sAQwACAQEBAQECAQEBAgICAgIEAwICAgIFBAQDBAYFBgYGBQYGBgcJCAYHCQcGBggLCAkKCgoKCgYICwwLCgwJCgoK/9sAQwECAgICAgIFAwMFCgcGBwoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoK/8AAEQgHgAWgAwEiAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVl';
  List dataList = [];
  List listitems = [
    'All',
    'Gampaha',
    'Nittmbuwa',
    'Colombo',
    'Nugegoda',
  ];
  List branchRiders = [];
  String? rider;
  bool isLoading = false;
  List<Map<String, dynamic>> depositListTemp = [];
  @override
  void initState() {
    branchRider();
    dropDownData();
    data('3');
    setState(() {
      depositListTemp = depositList;
    });
    // TODO: implement initState
    super.initState();
  }

  branchRider() async {
    setState(() {
      isLoading = true;
    });
    var res = await CustomApi().deliveryApprovalsRiderList(context);

    setState(() {
      branchRiders = res;
      isLoading = false;
    });
  }

  dropDownData() async {
    setState(() {
      isLoading = true;
    });
    List res = await CustomApi().dropdownDataMyDelivery(context);

    setState(() {
      List.generate(res.length, (index) {
        if (res[index]['type'] == '3') {
          pdliveryList.add({
            "reason_id": "${res[index]['reason_id']}",
            "reason": "${res[index]['reason']}"
          });
        }
      });
      isLoading = false;
    });
  }

  data(String id) async {
    setState(() {
      isLoading = true;
    });
    var res = await CustomApi().deliveryApprovals(context, id);
  
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
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: appliteBlue,
          bottom: PreferredSize(
              preferredSize: Size(w, 70),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    child: Container(
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
                        underline: SizedBox(),
                        isExpanded: true,
                        alignment: AlignmentDirectional.centerEnd,
                        hint: Container(
                          //and here
                          child: Text(
                            "Select Rider                                                         ",
                            style: TextStyle(color: black1),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        value:
                            rider, //implement initial value or selected value
                        onChanged: (value) {
                          setState(() {
                            //set state will update UI and State of your App
                            rider = value.toString();
                            data(rider
                                .toString()); //change selectval to new value
                          });
                        },
                        items: branchRiders.map((itemone) {
                          return DropdownMenuItem(
                              value: itemone['user_id'],
                              child: Text(
                                itemone['staff_name'],
                                style: TextStyle(color: black2),
                              ));
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              )),
          title: Text(
            'Delivery Approval',
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
                    shrinkWrap: true,
                    itemCount: dataList.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () async {
                          Provider.of<ProviderS>(context, listen: false)
                              .dImages64 = [];
                          codApproval(dataList[index]['waybill_id']);
                          await getImages(dataList[index]['waybill_id']);
                        },
                        child: Card(
                          color: Color.fromARGB(255, 179, 196, 210),
                          elevation: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: w / 3,
                                      child: Text(
                                        "Status",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          color: black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Card(
                                        color:
                                            Color.fromARGB(255, 198, 162, 203),
                                        elevation: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "${dataList[index]['status']}",
                                            style: TextStyle(
                                              fontSize: 12.dp,
                                              color: black,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: w / 3,
                                      child: Row(
                                        children: [
                                          Text(
                                            "ID",
                                            style: TextStyle(
                                              fontSize: 17.dp,
                                              color: black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "- ${dataList[index]['waybill_id']}",
                                      style: TextStyle(
                                        fontSize: 17.dp,
                                        color: black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: w / 3,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Customer name",
                                            style: TextStyle(
                                              fontSize: 12.dp,
                                              color: black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "- ${dataList[index]['cust_name']}",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          color: black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: w / 3,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Receiver name",
                                            style: TextStyle(
                                              fontSize: 12.dp,
                                              color: black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "- ${dataList[index]['name']}",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          color: black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: w / 3,
                                      child: Text(
                                        "Address",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          color: black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: SizedBox(
                                        width: w / 2,
                                        child: Text(
                                          "- ${dataList[index]['address']}",
                                          style: TextStyle(
                                            fontSize: 12.dp,
                                            color: black,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: w / 3,
                                      child: Text(
                                        "Receiver phone",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          color: black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "- ${dataList[index]['phone']}",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          color:
                                              Color.fromARGB(255, 46, 19, 196),
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: w / 3,
                                      child: Text(
                                        "From Branch",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          color: black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "- Kurunegala",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          color: black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: w / 3,
                                      child: Text(
                                        "To branch",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          color: black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "- 0711672439",
                                      style: TextStyle(
                                        fontSize: 12.dp,
                                        color: black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: w / 3,
                                      child: Text(
                                        "Remark",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          color: black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "- ${dataList[index]['cutomer_remarks']}",
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          color: black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Card(
                                  margin: EdgeInsets.zero,
                                  elevation: 10,
                                  child: Divider(
                                    color: Color.fromARGB(255, 127, 156, 190),
                                    thickness: 15,
                                  ),
                                ),
                                SizedBox(
                                  height: 0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            isLoading ? Loader().loader(context) : SizedBox(),
            provider.isanotherUserLog ? UserLoginCheck() : SizedBox()
          ],
        ),
      ),
    );
  }

  getImages(String dId) async {
    setState(() {});
    Provider.of<ProviderS>(context, listen: false).dataLoad = true;
    var res = await CustomApi().deliveryApprovalsImageList(context, dId);
    remarkController.clear();
    dropdownvalue = null;
    Provider.of<ProviderS>(context, listen: false).dImages64 = res;
    Provider.of<ProviderS>(context, listen: false).dataLoad = false;
  }

  codApproval(String wayBillId) {
    Provider.of<ProviderS>(context, listen: false).dImages64 = [];
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    x = 0;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.all(12),
        content: StatefulBuilder(builder: (context, setState) {
          return Consumer<ProviderS>(
            builder: (context, pValue, child) => Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'Rider Approval',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          )),
                      Divider(),
                      Provider.of<ProviderS>(context, listen: false)
                                  .dImages64
                                  .isEmpty &&
                              Provider.of<ProviderS>(context, listen: false)
                                      .dataLoad ==
                                  false
                          ? Container(
                              height: h / 2,
                              width: w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported_sharp,
                                    size: 100,
                                    color: const Color.fromARGB(96, 77, 76, 76),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('empty image')
                                ],
                              ),
                            )
                          : Container(
                              height: h / 2.5,
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      // _current = index;
                                    });
                                  },
                                  enableInfiniteScroll: false,
                                  animateToClosest: false,
                                  autoPlay: true,
                                  aspectRatio: 1.0,
                                  enlargeCenterPage: true,
                                  enlargeStrategy:
                                      CenterPageEnlargeStrategy.height,
                                ),
                                items: pValue.dImages64
                                    .map((item) => ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            height: h / 2.5,
                                            width: w,
                                            child: Image.memory(
                                                base64Decode(item['image']),
                                                fit: BoxFit.fitHeight),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            x = 1;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Oder Confirm',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  )),
                              Icon(
                                x == 1
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: x == 1
                                    ? Colors.green
                                    : const Color.fromARGB(255, 136, 161, 203),
                                size: 27,
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            x = 2;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Partially Delivery',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  )),
                              Icon(
                                x == 2
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: x == 2
                                    ? Colors.green
                                    : const Color.fromARGB(255, 136, 161, 203),
                                size: 27,
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      x == 2
                          ? Column(
                              children: [
                                DropdownButton(
                                  itemHeight: 70,
                                  underline: Divider(
                                    color: white,
                                    height: 0,
                                  ),
                                  isExpanded: true,
                                  padding: EdgeInsets.only(right: 10),
                                  alignment: AlignmentDirectional.centerEnd,
                                  hint: Text(
                                      'Select Reason                                                                   '),
                                  value: dropdownvalue,
                                  //implement initial value or selected value
                                  onChanged: (value) {
                                    setState(() {
                                      //set state will update UI and State of your App
                                      dropdownvalue = value.toString();
                                      //change selectval to new value
                                    });
                                  },
                                  items: pdliveryList.map((itemone) {
                                    return DropdownMenuItem(
                                        onTap: () {
                                          setState(() {
                                            // dropdownvalueItem =
                                            //     itemone['reason']
                                            //         .toString();
                                          });
                                        },
                                        value: itemone['reason_id'],
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              itemone['reason'].toString(),
                                              style: TextStyle(color: black2),
                                            ),
                                          ),
                                        ));
                                  }).toList(),
                                ),
                                CustomTextField3(
                                  controller: remarkController,
                                ),
                              ],
                            )
                          : SizedBox(),
                      DialogButton(
                          text: 'SAVE',
                          onTap: () async {
                            if (x != 0) {
                              if (x == 1) {
                                pValue.dataLoad = true;
                                await CustomApi().deliveryApprovalsConfirm(
                                    context, wayBillId, '', '', x);
                                pValue.dataLoad = false;
                              } else if (x == 2) {
                                if (dropdownvalue != null) {
                                  if (remarkController.text.isNotEmpty) {
                                    pValue.dataLoad = true;
                                    await CustomApi().deliveryApprovalsConfirm(
                                        context,
                                        wayBillId,
                                        remarkController.text,
                                        dropdownvalue.toString(),
                                        x);
                                    pValue.dataLoad = false;
                                  } else {
                                    notification().warning(
                                        context, 'Please type your reason');
                                  }
                                } else {
                                  notification().warning(
                                      context, 'Please select the reason');
                                }
                              }
                            } else {
                              notification().warning(
                                  context, 'Please select the Approval option');
                            }
                          },
                          buttonHeight: h / 17,
                          width: w,
                          color: Colors.blue)
                    ],
                  ),
                ),
                pValue.dataLoad
                    ? SizedBox(
                        height: h / 1.5,
                        child: Center(
                          child: Loader().loader(context),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget serchBarr(BuildContext con) {
    var h = MediaQuery.of(con).size.height;
    var w = MediaQuery.of(con).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: h / 15,
        child: Row(
          children: [
            TextFormField(
              onChanged: (value) {},
              // controller: search,
              style: TextStyle(color: black, fontSize: 13.sp),
              validator: (value) {},
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: black3),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      // color: pink.withOpacity(0.1),
                      ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                filled: true,
                hintStyle: TextStyle(fontSize: 13.dp),
                hintText: 'Search by date',
                fillColor: white2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
