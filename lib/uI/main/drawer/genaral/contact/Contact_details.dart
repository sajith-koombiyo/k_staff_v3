import 'package:flutter/material.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ContactDetails extends StatelessWidget {
  const ContactDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor2,
      appBar: AppBar(
        backgroundColor: backgroundColor2,
        // title: Text(
        //   'Contact Details',
        //   style: TextStyle(
        //     fontSize: 18.dp,
        //     color: white,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: black,
            )),
      ),
      body: SizedBox(
        width: w,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
              height: 25,
            ),
            CircleAvatar(
              backgroundColor: Color.fromARGB(255, 159, 188, 203),
              radius: 50,
              child: Text(
                'c',
                style: TextStyle(
                  fontSize: 35.dp,
                  color: Color.fromARGB(255, 13, 62, 91),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Text(
              'Srinath',
              style: TextStyle(
                fontSize: 25.dp,
                color: Color.fromARGB(255, 13, 62, 91),
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              'HR Manager',
              style: TextStyle(
                fontSize: 12.dp,
                color: Color.fromARGB(255, 13, 62, 91),
                fontWeight: FontWeight.normal,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.call)),
                      Text(
                        'Call',
                        style: TextStyle(
                          fontSize: 14.dp,
                          color: Color.fromARGB(255, 13, 62, 91),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.email)),
                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 14.dp,
                          color: Color.fromARGB(255, 13, 62, 91),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black12,
            ),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.call)),
                Text(
                  '0716232004',
                  style: TextStyle(
                    fontSize: 14.dp,
                    color: Color.fromARGB(255, 13, 62, 91),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            // Divider(
            //   color: Colors.black12,
            // ),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.email)),
                Text(
                  'archchi0908@gmail.com',
                  style: TextStyle(
                    fontSize: 14.dp,
                    color: Color.fromARGB(255, 13, 62, 91),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            // Divider(
            //   color: Colors.black12,
            // ),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.home_filled)),
                Text(
                  '105/05 Ihalagama,Kirindiwela',
                  style: TextStyle(
                    fontSize: 14.dp,
                    color: Color.fromARGB(255, 13, 62, 91),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            // Divider(
            //   color: Colors.black12,
            // ),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.call_end_sharp)),
                Text(
                  '0332234567',
                  style: TextStyle(
                    fontSize: 14.dp,
                    color: Color.fromARGB(255, 13, 62, 91),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            // Divider(
            //   color: Colors.black12,
            // ),
            Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.developer_board_outlined)),
                Text(
                  'Call center',
                  style: TextStyle(
                    fontSize: 14.dp,
                    color: Color.fromARGB(255, 13, 62, 91),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            // Divider(
            //   color: Colors.black12,
            // ),
            Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.broadcast_on_personal_outlined)),
                Text(
                  'Kurunagala',
                  style: TextStyle(
                    fontSize: 14.dp,
                    color: Color.fromARGB(255, 13, 62, 91),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.black12,
            ),
          ]),
        ),
      ),
    );
  }
}
