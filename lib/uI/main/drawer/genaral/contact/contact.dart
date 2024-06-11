import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/uI/main/navigation/navigation.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';

import '../../../../../app_details/color.dart';
import 'Contact_details.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  TapDownDetails? tapNumber;
  late ScrollController mycontroller = ScrollController();
  List contactList = [];
  List contactListTemp = [];
  bool isLoading = false;
  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;
  bool _isLoadMoreRuning = false;
  int _page = 0;
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
    mycontroller.addListener(() {
      if (mycontroller.position.maxScrollExtent ==
          mycontroller.position.pixels) {
        log('hhhhhhhh');
        _loadeMore();
      }
    });
  }

  void _loadeMore() async {
    if (_hasNextPage == true &&
        isLoading == false &&
        _isLoadMoreRuning == false) {
      setState(() {
        _isLoadMoreRuning = true;
      });
      _page += 20;
      print('222222222222222222222');
      log(_page.toString());
      print('222222222222222222222');
      var res = await CustomApi()
          .koombiyoContact(context, '', _page.toString(), '20');
      print(res);
      List data = res;
      if (data.isNotEmpty) {
        setState(() {
          contactList.addAll(data);
          contactListTemp.addAll(res);
        });
      } else {
        setState(() {
          _hasNextPage = false;
        });
      }
      setState(() {
        _isLoadMoreRuning = false;
      });
      // setState(() {
      //   _page += 20;
      //   _isLoadMoreRuning = false;
      //   contactList;

      //   contactList.addAll(res);
      //   log(contactList.toString());
      //   contactListTemp.addAll(res);
      //   print(contactListTemp);
      //   print(contactListTemp.length);
      // });
    }
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    var res = await CustomApi().koombiyoContact(context, '', '0', '20');
    print(res);

    setState(() {
      isLoading = false;
      contactList = res;
      contactListTemp = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Consumer<ProviderS>(
      builder: (context, provider, child) => Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: appliteBlue,
          bottom: PreferredSize(
              preferredSize: Size(w, 70),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: serchBar(context),
              )),
          title: Text(
            'Contact',
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
            ListView.builder(
              controller: mycontroller,
              itemCount: contactList.length,
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactDetails(
                              land: contactList[index]['phone'],
                              address: contactList[index]['address'],
                              destination: contactList[index]['designation'],
                              email: contactList[index]['email'],
                              name: contactList[index]['name'],
                              phone: contactList[index]['mobile'],
                            ),
                          ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 8,
                            ),
                            CircleAvatar(
                              backgroundColor:
                                  Color.fromARGB(255, 212, 228, 236),
                              radius: 25,
                              child: Text(
                                '${contactList[index]['name'][0]}',
                                style: TextStyle(
                                  fontSize: 25.dp,
                                  color: Color.fromARGB(255, 13, 62, 91),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            SizedBox(
                              width: w / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${contactList[index]['contact_id']}',
                                        style: TextStyle(
                                          fontSize: 25.dp,
                                          color:
                                              Color.fromARGB(255, 13, 62, 91),
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        '---${index.toString()}',
                                        style: TextStyle(
                                          fontSize: 25.dp,
                                          color:
                                              Color.fromARGB(255, 13, 62, 91),
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${contactList[index]['name']}',
                                    style: TextStyle(
                                      fontSize: 16.dp,
                                      color: Color.fromARGB(255, 4, 37, 65),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    '${contactList[index]['phone']}',
                                    style: TextStyle(
                                      fontSize: 10.dp,
                                      color: Color.fromARGB(255, 4, 37, 65),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.call,
                                  color: Color.fromARGB(255, 118, 26, 22),
                                )),
                            GestureDetector(
                                onTapDown: (TapDownDetails details) {
                                  setState(() {
                                    tapNumber = details;
                                    showMemberMenu(context, tapNumber!);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(Icons.more_vert),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 8,
                  )
                ]),
              ),
            ),
            if (_isLoadMoreRuning)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            isLoading ? Loader().loader(context) : SizedBox(),
            provider.isanotherUserLog ? UserLoginCheck() : SizedBox()
          ],
        ),
      ),
    );
  }

  void _runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = contactListTemp;
    } else if (contactListTemp
        .where((user) =>
            user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
        .toList()
        .isNotEmpty) {
      results = contactListTemp
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    // Refresh the UI
    setState(() {
      contactList = results;
    });
  }

  void showMemberMenu(BuildContext context, TapDownDetails tap) async {
    double left = tap.globalPosition.dx;
    double top = tap.globalPosition.dy;

    final List<String> popList = ['ROHIT', 'REKHA', 'DHRUV'];
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 50, 0),
      items: List.generate(
        popList.length,
        (index) => PopupMenuItem(
          value: 1,
          child: Text(
            popList[index],
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ),
      elevation: 8.0,
    ).then((value) {
      if (value != null) print(value);
    });
  }

  Widget serchBar(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: h / 15,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (value) {
                  _runFilter(value.toString());
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
                  hintText: 'Scan or Search',
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
