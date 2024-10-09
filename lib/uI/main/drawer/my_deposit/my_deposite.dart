import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';

import '../../../../provider/provider.dart';
import '../../../widget/nothig_found.dart';

class MyDeposit extends StatefulWidget {
  const MyDeposit({super.key});

  @override
  State<MyDeposit> createState() => _MyDepositState();
}

class _MyDepositState extends State<MyDeposit> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> tempDeposit = [];
  List<Map<String, dynamic>> deposit = [];
  List<Map<String, dynamic>> depositList = [
    {'date': '2023/01/23'},
    {'date': '2023/11/23'},
    {'date': '2023/02/23'},
    {'date': '2023/01/21'},
    {'date': '2023/01/23'},
    {'date': '2023/01/24'}
  ];
  List<Map<String, dynamic>> depositListTemp = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDat();
  }

  getDat() async {
    // var temp = await CustomAPi().getMyDeposit(context);

    setState(() {
      deposit = Provider.of<ProviderS>(context, listen: false).deposit;
      ;
      tempDeposit = Provider.of<ProviderS>(context, listen: false).deposit;
      ;
    });
  }

  refeshData() async {
    if (!mounted) return;
    Provider.of<ProviderS>(context, listen: false).deposit =
        await CustomApi().getMyDeposit(context);

    setState(() {
      deposit = Provider.of<ProviderS>(context, listen: false).deposit;
      ;
      tempDeposit = Provider.of<ProviderS>(context, listen: false).deposit;
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      onRefresh: () {
        return refeshData();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: white,
              )),
          backgroundColor: appliteBlue,
          title: Text(
            'My Deposit',
            style: TextStyle(
              fontSize: 18.dp,
              color: white,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: PreferredSize(
              preferredSize: Size(w, h / 17), child: serchBarr(context)),
        ),
        backgroundColor: white,
        body: Consumer<ProviderS>(
          builder: (context, provider, child) => deposit.isEmpty
              ? NoData()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: deposit.length,
                  itemBuilder: (context, index) {
                    var amount = deposit[index]['amount'] == null
                        ? '0'
                        : deposit[index]['amount'];
                    double variance =
                        double.parse(deposit[index]['cod'].toString()) -
                            double.parse(amount);
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        color: backgroundColor2,
                        elevation: 20,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: w / 2.4,
                                    child: Row(
                                      children: [
                                        Icon(Icons.add_card_rounded),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "COD Amount",
                                          style: TextStyle(
                                            fontSize: 17.dp,
                                            color: black1,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "- ${deposit[index]['cod']}",
                                    style: TextStyle(
                                      fontSize: 12.dp,
                                      color: black1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: w / 2.4,
                                    child: Text(
                                      "Deposit Amount",
                                      style: TextStyle(
                                        fontSize: 12.dp,
                                        color: black1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    deposit[index]['amount'] == null
                                        ? '- 0'
                                        : "- ${deposit[index]['amount']}",
                                    style: TextStyle(
                                      fontSize: 12.dp,
                                      color: black1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: w / 2.4,
                                    child: Text(
                                      "Variance",
                                      style: TextStyle(
                                        fontSize: 12.dp,
                                        color: black1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "- $variance",
                                    style: TextStyle(
                                      fontSize: 12.dp,
                                      color: black1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "${deposit[index]['create_date']}",
                                  style: TextStyle(
                                    fontSize: 12.dp,
                                    color: black3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = tempDeposit;
    } else if (tempDeposit
        .where((user) => user["create_date"]
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()))
        .toList()
        .isNotEmpty) {
      results = tempDeposit
          .where((user) => user["create_date"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    // Refresh the UI
    setState(() {
      deposit = results;
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
            Expanded(
              child: TextFormField(
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
                  hintText: 'Search by date (2024-02-02)',
                  fillColor: white2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
