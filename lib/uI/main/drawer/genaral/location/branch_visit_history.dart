import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class BranchVisitHistory extends StatefulWidget {
  const BranchVisitHistory({super.key});

  @override
  State<BranchVisitHistory> createState() => _BranchVisitHistoryState();
}

class _BranchVisitHistoryState extends State<BranchVisitHistory> {
  List branchVisit = [];
  @override
  void initState() {
    ;
    getDat();
    // TODO: implement initState

    super.initState();
  }

  getDat() async {
    List res = await CustomApi().branchVisitHistroy(context);

    setState(() {
      print(res);
      branchVisit = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appliteBlue,
        title: Text(
          'Branch Visit History',
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
      backgroundColor: Color.fromARGB(255, 229, 232, 238),
      body: SizedBox(
        height: h,
        child: ListView.builder(
          itemCount: branchVisit.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Color.fromARGB(255, 215, 225, 232),
                child: SizedBox(
                  width: w - 16,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              branchVisit[index]['dname'],
                              style: TextStyle(color: black, fontSize: 14.dp),
                            ),
                            Text(
                              '${branchVisit[index]['date']}',
                              style: TextStyle(color: black2, fontSize: 14),
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.arrow_forward_ios_rounded))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
