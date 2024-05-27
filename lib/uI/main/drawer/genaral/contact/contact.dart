import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../../../../app_details/color.dart';
import 'Contact_details.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  TapDownDetails? tapNumber;
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
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
      body: ListView.builder(
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
                      builder: (context) => ContactDetails(),
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
                        backgroundColor: Color.fromARGB(255, 212, 228, 236),
                        radius: 25,
                        child: Text(
                          'c',
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'chamara',
                            style: TextStyle(
                              fontSize: 16.dp,
                              color: Color.fromARGB(255, 4, 37, 65),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            '0716232004',
                            style: TextStyle(
                              fontSize: 10.dp,
                              color: Color.fromARGB(255, 4, 37, 65),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
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
    );
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
                onChanged: (value) {},
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
