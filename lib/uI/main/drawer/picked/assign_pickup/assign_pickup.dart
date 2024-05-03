import 'package:flutter/material.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/uI/widget/diloag_button.dart';
import 'package:flutter_application_2/uI/widget/nothig_found.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'dart:math';

class AssignPickup extends StatefulWidget {
  const AssignPickup({super.key});

  @override
  State<AssignPickup> createState() => _AssignPickupState();
}

class _AssignPickupState extends State<AssignPickup> {
  List<Map<String, dynamic>> pickup = [];
  List<Map<String, dynamic>> pendingPickup = [];
  bool isLoading = false;
  List listitems = [
    'All',
    'Gampaha',
    'Nittmbuwa',
    'Colombo',
    'Nugegoda',
  ];
  String? selectval;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appliteBlue,
        bottom: PreferredSize(
            preferredSize: Size(w, 70),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: serchBarr(context),
            )),
        title: Text(
          'Assign Pickup',
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
      body: Stack(
        children: [
          isLoading == true && pickup.isNotEmpty
              ? NoData()
              : ListView.builder(
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
                                            children: [
                                              Card(
                                                elevation: 1,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons
                                                        .local_shipping_outlined,
                                                    size: 40,
                                                    color: Color(Random()
                                                            .nextInt(
                                                                0xffffffff))
                                                        .withAlpha(0xff),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: w / 2.4,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'Kalyana lanka pvt (LTD)',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: black,
                                                          fontSize: 14.dp,
                                                        )),
                                                    Text(
                                                        'Pick Up Address:- Kalyana lanka pvt (LTD)}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black87,
                                                          fontSize: 12.dp,
                                                        )),
                                                    Text(
                                                        'Address:- Kalyana lanka pvt (LTD)}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black87,
                                                          fontSize: 12.dp,
                                                        )),
                                                    Text('Phone:-071601502',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Color.fromARGB(
                                                              221, 220, 44, 44),
                                                          fontSize: 14.dp,
                                                        )),
                                                    Text('Vehicle:-Byk',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Color.fromARGB(
                                                              221, 44, 65, 220),
                                                          fontSize: 14.dp,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Spacer(),
                                              Card(
                                                elevation: 20,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100)),
                                                child: IconButton(
                                                  onPressed: () async {
                                                    oderInformation();
                                                  },
                                                  icon: Icon(Icons.add,
                                                      size: 35,
                                                      color: Color.fromARGB(
                                                          255, 11, 9, 147)),
                                                ),
                                              ),
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
          isLoading ? Loader().loader(context) : SizedBox()
        ],
      ),
    );
  }

  oderInformation() {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(0),
        insetPadding: EdgeInsets.all(12),
        actions: [
          DialogButton(
              text: 'CANCEL',
              onTap: () {
                Navigator.pop(context);
              },
              buttonHeight: h / 15,
              width: w / 3,
              color: const Color.fromARGB(255, 140, 178, 210)),
          DialogButton(
              text: 'ASSIGN',
              onTap: () {},
              buttonHeight: h / 15,
              width: w / 3,
              color: Color.fromARGB(255, 57, 138, 55))
        ],
        content: SizedBox(
          width: w,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Oder Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: black,
                    fontSize: 18.dp,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Card(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.broadcast_on_personal_outlined),
                          )),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "Online Store:-",
                            style: TextStyle(
                                color: black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "Kalyana Lanka Pvt Lt()",
                                style:
                                    TextStyle(color: black1, fontSize: 12.dp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Row(
                      children: [
                        Card(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.delivery_dining))),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "Rider  ",
                          style: TextStyle(
                            color: black1,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            alignment: Alignment.centerRight,
                            height: h / 15,
                            width: w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                  color: Colors.black12,
                                  style: BorderStyle.solid,
                                  width: 0.80),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: DropdownButton(
                                underline: SizedBox(),
                                isExpanded: true,
                                alignment: AlignmentDirectional.centerEnd,
                                hint: Container(
                                  //and here
                                  child: Text(
                                    "Select Rider                                                         ",
                                    style: TextStyle(
                                        color: black1,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12.dp),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                value:
                                    selectval, //implement initial value or selected value
                                onChanged: (value) {
                                  setState(() {
                                 
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
                                        style: TextStyle(
                                            color: black1,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12.dp),
                                      ));
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(
                      width: w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Card(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.call))),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "phone",
                            style: TextStyle(
                                color: black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: SizedBox(
                              height: h / 15,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                        fontSize: 12.dp,
                                        fontWeight: FontWeight.normal),
                                    hintText: 'type here',
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black12)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black12)),
                                    filled: true),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget serchBarr(BuildContext con) {
    var h = MediaQuery.of(con).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: h / 15,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (value) {
                  _runFilter(value);
                },
                // controller: search,
                style: TextStyle(color: black, fontSize: 13.sp),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  border: OutlineInputBorder(
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
                  hintText: 'Search by id or client name',
                  fillColor: white2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = pendingPickup;
    } else if (pendingPickup
        .where((user) => user["pickr_id"]
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()))
        .toList()
        .isNotEmpty) {
      results = pendingPickup
          .where((user) => user["pickr_id"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    } else if (pendingPickup
        .where((user) => user["cust_name"]
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()))
        .toList()
        .isNotEmpty) {
      results = pendingPickup
          .where((user) => user["cust_name"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    // Refresh the UI
    setState(() {
      pickup = results;
    });
  }
}
