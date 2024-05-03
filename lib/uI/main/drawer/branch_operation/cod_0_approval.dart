import 'package:flutter/material.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:quickalert/quickalert.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CODZeroApproval extends StatefulWidget {
  const CODZeroApproval({super.key});

  @override
  State<CODZeroApproval> createState() => _CODZeroApprovalState();
}

class _CODZeroApprovalState extends State<CODZeroApproval> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> depositList = [
    {'date': '2023/01/23'},
    {'date': '2023/11/23'},
    {'date': '2023/02/23'},
    {'date': '2023/01/21'},
    {'date': '2023/01/23'},
    {'date': '2023/01/24'}
  ];
  List listitems = [
    'All',
    'Gampaha',
    'Nittmbuwa',
    'Colombo',
    'Nugegoda',
  ];
  String? selectval;
  List<Map<String, dynamic>> depositListTemp = [];
  @override
  void initState() {
    setState(() {
      depositListTemp = depositList;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
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
                          color: black3, style: BorderStyle.solid, width: 0.80),
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
                          selectval, //implement initial value or selected value
                      onChanged: (value) {
                        setState(() {
                       

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
            )),
        title: Text(
          'COD (0) Zero Approval',
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
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: depositList.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
            onTap: () {
              codApproval();
            },
            child: Card(
              // color: Color.fromARGB(255, 217, 238, 255),
              elevation: 20,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          "- 0711672439",
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
                        Text(
                          "- Darshana",
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
                            "Address",
                            style: TextStyle(
                              fontSize: 12.dp,
                              color: black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: w / 2,
                          child: Text(
                            "- 106/ 5 ihalagame Kirindiwela ",
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
                            "Receiver phone",
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
                        Text(
                          "- Kurunegala",
                          style: TextStyle(
                            fontSize: 12.dp,
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
                          child: Text(
                            "Remark",
                            style: TextStyle(
                              fontSize: 12.dp,
                              color: black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: Text(
                            "- 0711672439 sjnjna ajb ajba jabj a ajbd",
                            style: TextStyle(
                              fontSize: 12.dp,
                              color: black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Card(
                      margin: EdgeInsets.zero,
                      elevation: 20,
                      child: Divider(
                        color: Color.fromARGB(255, 138, 163, 192),
                        thickness: 10,
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
    );
  }

  codApproval() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      barrierDismissible: true,
      confirmBtnText: 'Confirm',
      customAsset: 'assets/3.PNG',
      widget: Container(
          alignment: Alignment.center,
          child: Text(
            'Confirm your order',
            style: TextStyle(fontSize: 18),
          )),
      showCancelBtn: true,
      onConfirmBtnTap: () async {
        await Future.delayed(const Duration(milliseconds: 1000));
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Order successfully confirmed !.",
        );
        Navigator.pop(context);
      },
    );
  }
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
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
