import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../../app_details/color.dart';
import '../../../widget/shuttle/customList.dart';

class Shuttle extends StatefulWidget {
  const Shuttle({Key? key}) : super(key: key);
  @override
  State<Shuttle> createState() => _ShuttleState();
}

class _ShuttleState extends State<Shuttle> {
  var list = Iterable<int>.generate(100).toList();
  List allBinList = [];
  List<Map<String, dynamic>> product = [
    {'branch': 'Gampaha'},
    {'branch': 'Nittmbuwa'},
    {'branch': 'Colombo'},
    {'branch': 'Nugegoda'},
  ];
  List<Map<String, dynamic>> allProduct = [];
  List listitems = [
    'All',
    'Gampaha',
    'Nittmbuwa',
    'Colombo',
    'Nugegoda',
  ];
  String? selectval;
  int? num;
  int x = 0;
  @override
  void initState() {
    allProduct = product;
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    List res = await CustomApi().shuttelBinList(context, '1', '', '', '');

    setState(() {
      allBinList = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 6, 101, 148),
            title: Text(
              'Shuttle',
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
            bottom: TabBar(
              onTap: (value) {
                setState(() {
                  x = value;
                });
              },
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: white2,
              labelColor: white,
              tabs: <Tab>[
                new Tab(
                  text: "Shutter In",
                  icon: new Icon(Icons.access_time_filled),
                ),
                new Tab(
                  text: "Branch Out",
                  icon: new Icon(Icons.add_home_work_sharp),
                ),
                Tab(
                  text: "WareHouse Out",
                  icon: new Icon(Icons.warehouse_outlined),
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
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
                                  isExpanded: true,
                                  alignment: AlignmentDirectional.centerEnd,
                                  hint: Container(
                                    alignment: Alignment.centerLeft,
                                    //and here
                                    child: Text(
                                      "Select branch ...........",
                                      style: TextStyle(color: black1),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  value:
                                      selectval, //implement initial value or selected value
                                  onChanged: (value) {
                                    setState(() {
                                      ;
                                      _runFilter(value.toString());
                                      //set state will update UI and State of your App
                                      selectval = value
                                          .toString(); //change selectval to new value
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
                        // Expanded(
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(12.0),
                        //     child: Card(
                        //       child: Container(
                        //         padding: EdgeInsets.symmetric(horizontal: 15),
                        //         alignment: Alignment.centerRight,
                        //         width: w,
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(5.0),
                        //           border: Border.all(
                        //               color: black3,
                        //               style: BorderStyle.solid,
                        //               width: 0.80),
                        //         ),
                        //         child: DropdownButton(
                        //           isExpanded: true,
                        //           alignment: AlignmentDirectional.centerEnd,
                        //           hint: Container(
                        //             //and here
                        //             child: Text(
                        //               "Total bin",
                        //               style: TextStyle(color: black),
                        //               textAlign: TextAlign.end,
                        //             ),
                        //           ),
                        //           value:
                        //               num, //implement initial value or selected value
                        //           onChanged: (int? value) {
                        //             setState(() {
                        //               //set state will update UI and State of your App
                        //               num = value!.toInt();

                        //               //change selectval to new value
                        //             });
                        //           },
                        //           items: list.map((itemone) {
                        //             return DropdownMenuItem(
                        //                 value: itemone,
                        //                 child: Text(
                        //                   itemone.toString(),
                        //                   style: TextStyle(color: black2),
                        //                 ));
                        //           }).toList(),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          x == 0
                              ? CustomList(
                                  list: product,
                                  icon: Icons.add_circle,
                                )
                              : x == 1
                                  ? CustomList(
                                      list: product,
                                      icon: Icons.check_circle,
                                    )
                                  : CustomList(
                                      list: product,
                                      icon: Icons.check_circle,
                                    )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // Container(
              //   color: white.withOpacity(0.7),
              //   child: Center(
              //     child: SizedBox(
              //         height: h / 4,
              //         child: Image.asset('assets/page-under-maintenance.png')),
              //   ),
              // )
            ],
          )),
    );
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = allProduct;
    } else if (allProduct
        .where((user) =>
            user["branch"].toLowerCase().contains(enteredKeyword.toLowerCase()))
        .toList()
        .isNotEmpty) {
      results = allProduct
          .where((user) => user["branch"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    // Refresh the UI
    setState(() {
      if (enteredKeyword == 'All') {
        product = allProduct;
      } else {
        product = results;
      }
    });
  }
}
