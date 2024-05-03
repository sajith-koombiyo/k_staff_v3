import 'package:flutter/material.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/uI/widget/diloag_button.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:toggle_switch/toggle_switch.dart';

class DDApproval extends StatefulWidget {
  const DDApproval({super.key});

  @override
  State<DDApproval> createState() => _DDApprovalState();
}

class _DDApprovalState extends State<DDApproval> {
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
                          "Select branch                                                         ",
                          style: TextStyle(color: black1),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      value:
                          selectval, //implement initial value or selected value
                      onChanged: (value) {
                        setState(() {
                      
                          _runFilter(value.toString());
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
          'DD Approval',
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
                          "- 0711672439 sjnjna ajb ajba jabj a ajbdja da djajba ajdbjad ajdja d aj ja  adbaj d adaj d ad J D",
                          style: TextStyle(
                            fontSize: 12.dp,
                            color: black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Container(
                    alignment: Alignment.centerRight,
                    child: ToggleSwitch(
                      changeOnTap: true,
                      customWidths: [90.0, 50.0],
                      cornerRadius: 10.0,
                      activeBgColors: [
                        [Colors.cyan],
                        [Colors.redAccent]
                      ],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      totalSwitches: 2,
                      labels: ['Confirm', ''],
                      icons: [null, Icons.close],
                      onToggle: (index) {
                        
                      },
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
    );
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = depositListTemp;
    } else if (depositListTemp
        .where((user) =>
            user["date"].toLowerCase().contains(enteredKeyword.toLowerCase()))
        .toList()
        .isNotEmpty) {
      results = depositListTemp
          .where((user) =>
              user["date"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    // Refresh the UI
    setState(() {
      depositList = results;
      
    });
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
              onChanged: (value) {
                _runFilter(value);
              },
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
