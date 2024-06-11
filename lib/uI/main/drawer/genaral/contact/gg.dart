// import 'dart:convert';
// import 'dart:developer';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';

// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:pitarata_job/Screen/home/single_job/single_job.dart';
// import 'package:pitarata_job/Screen/name_screen/name_screen.dart';
// import 'package:pitarata_job/db/sqldb.dart';
// import 'package:pitarata_job/providers/all_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:sizer/sizer.dart';
// import '../../api/api_deatails.dart';
// import '../../color/colors.dart';
// import '../../widget/custom_list.dart';
// import '../../widget/custom_text.dart';
// import 'package:http/http.dart' as http;
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:logger/logger.dart';
// import '../../widget/fade_category.dart';
// import '../../widget/fade_home.dart';
// import '../../widget/fade_walpaper.dart';
// import '../../widget/radius_button.dart';

// class CustomHome extends StatefulWidget {
//   const CustomHome({super.key, required this.customerId, required this.userStatus});
//   final String customerId;
//   final bool userStatus;

//   @override
//   State<CustomHome> createState() => _CustomHomeState();
// }

// class _CustomHomeState extends State<CustomHome> {
//   // ItemScrollController _scrollController = ItemScrollController();
//   var logger = Logger();
//   String selected = '0';
//   String selectedCharacter = '100';
//   bool color = false;
//   List wallPaper = [];
//   List jobCategory = [];
//   List jobCategoryName = [];
//   bool isLoading = false;
//   bool joblist = false;
//   bool userStatus = false;
//   int _current = 0;
//   final CarouselController _controller = CarouselController();
//   int _page = 0;

//   bool _isFirstLoadRunning = false;
//   // bool _hasNextPage = true;
//   bool _isLoadMoreRuning = false;
//   late ScrollController mycontroller = ScrollController();
//   ScrollController categoryController = ScrollController();
//   SqlDb sqlDb = SqlDb();
//   String addId = '';
//   List favoritesList = [];
//   bool x = false;
//   String verification = '';
//   String customer_id = '';
//   bool setJob = false;
//   String job_id = "";
//   bool loadFavorites = false;
//   bool noData = false;
//   bool _fromTop = true;
//   List jobCategoryList = [];
//   List temp = [];
//   List character = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "O", "P", "Q", "R", "S", "T", "U", "V", "X", "Y", "Z"];
//   @override
//   void initState() {
//     // getCategory();
//     // getJobCategory();

//     userLogin();

//     // TODO: implement initState
//     super.initState();

//     mycontroller.addListener(() {
//       if (mycontroller.position.maxScrollExtent == mycontroller.position.pixels) {
//         log('hhhhhhhh');
//         _loadeMore();
//       }
//     });
//   }

//   userLogin() async {
//     setState(() {
//       // isLoading = true;
//     });
//     bool result = await InternetConnectionChecker().hasConnection;
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

//     var z = sharedPreferences.getString('verification');
//     var y = sharedPreferences.getString('customer_id');
//     setState(() {
//       verification = z.toString();
//       customer_id = y.toString();
//       isLoading = false;
//     });
//     logger.d(verification);
//     logger.d(customer_id);

//     log("verificatio" + verification);
//     setState(() {});
//     if (verification != '0' && verification != 'null') {
//       if (result == true) {
//         print('ddddddddddddddddddddd');

//         await getFavouriteJobs();
//         setState(() {
//           userStatus = true;
//         });
//       } else {
//         var snackBar = SnackBar(
//             duration: Duration(seconds: 20),
//             content: Text(
//               'No internet connecteion',
//               style: TextStyle(color: red),
//             ));
//         ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       }
//     } else {
//       logger.d('ccccccccccccccccccccccccc');
//       setState(() {
//         isLoading = true;
//         userStatus = false;
//       });
//     }

//     getWallpaper();
//   }

//   getWallpaper() async {
//     setState(() {
//       isLoading = false;
//     });
//     wallPaper = await sqlDb.readData("select * from wallpaper");

//     if (Provider.of<AppProvider>(context, listen: false).wallPaper.isEmpty) {
//       bool result = await InternetConnectionChecker().hasConnection;
//       if (result == true) {
//         var headers = {'Content-Type': 'application/json'};
//         var response =
//             await http.post(Uri.parse('$apiUrl/getHomeWallpapers'), headers: headers, body: json.encode({"app_id": "nzone_4457Was555@qsd_job"}));
//         var res = jsonDecode(response.body.toString());
//         List img = res['data'];

//         if (img.isNotEmpty) {
//           var data = jsonEncode(img);
//           if (wallPaper.isEmpty) {
//             var r = await sqlDb.insertData("insert into wallpaper ('data') values('$data')");
//           } else {
//             await sqlDb.updateData("update wallpaper set 'data' = '$data' where id ='1' ");
//           }
//           wallPaper = await sqlDb.readData("select * from wallpaper");
//           print(wallPaper);

//           var newData = jsonDecode(wallPaper[0]['data']);
//           print(newData);

//           setState(() {
//             // wallPaper = img;
//             print(wallPaper);

//             log('1');
//             // isLoading = false;
//           });

//           Provider.of<AppProvider>(context, listen: false).wallPaper = newData;
//         }
//       } else {
//         wallPaper = await sqlDb.readData("select * from wallpaper");
//         var newData = jsonDecode(wallPaper[0]['data']);
//         print(wallPaper);
//         if (wallPaper.isNotEmpty) {
//           Provider.of<AppProvider>(context, listen: false).wallPaper = newData;
//         }
//       }
//     }
//     getCategory(true);
//     setState(() {
//       isLoading = false;
//     });
//   }

//   getCategory(bool load) async {
//     if (Provider.of<AppProvider>(context, listen: false).categoryList.isEmpty ||
//         Provider.of<AppProvider>(context, listen: false).serchCategory.isEmpty) {
//       setState(() {
//         isLoading = true;
//       });
//       var headers = {'Content-Type': 'application/json'};

//       // request.headers.addAll(headers);
//       var response = await http.post(Uri.parse('$apiUrl/getCategory'), headers: headers, body: json.encode({"app_id": "nzone_4457Was555@qsd_job"}));
//       var res = jsonDecode(response.body.toString());

//       List cat = [
//         {"category_id": "0", "category_name": "All"}
//       ];

//       setState(() {
//         jobCategoryList = res['data'];
//         print(res['data']);
//         cat.addAll(res['data']);
//         jobCategoryName = cat;
//         Provider.of<AppProvider>(context, listen: false).categoryList = cat;
//         Provider.of<AppProvider>(context, listen: false).serchCategory = jobCategoryList;
//         log('2');
//         isLoading = false;
//       });
//     }
//     await getJobCategory();
//     setState(() {
//       // isLoading = false;
//     });
//   }

//   void _loadeMore() async {
//     log('jjjjjjjjjjjj');
//     if (_hasNextPage == true && _isFirstLoadRunning == false && _isLoadMoreRuning == false) {
//       setState(() {
//         _isLoadMoreRuning = true;
//       });
//       _page += 50;
//       var headers = {'Content-Type': 'application/json'};
//       // request.headers.addAll(headers);
//       var response = await http.post(Uri.parse('$apiUrl/getJobsToHome'),
//           headers: headers, body: json.encode({"app_id": "nzone_4457Was555@qsd_job", "category_id": selected, "from": _page.toString(), "to": "50"}));
//       var res = jsonDecode(response.body);
//       List job = res['data'];
//       if (job.isNotEmpty) {
//         setState(() {
//           Provider.of<AppProvider>(context, listen: false).getJobs.addAll(job);
//         });
//       } else {
//         setState(() {
//           _hasNextPage = false;
//         });
//       }
//       // job.addAll(res['data']);
//       setState(() {
//         _isLoadMoreRuning = false;
//       });
//     }
//   }

//   getJobCategory() async {
//     logger.d(Provider.of<AppProvider>(context, listen: false).getJobs);

//     setState(() {
//       // isLoading = true;
//       _isFirstLoadRunning = true;
//     });
//     var headers = {'Content-Type': 'application/json'};
//     // request.headers.addAll(headers);
//     var response = await http.post(Uri.parse('$apiUrl/getJobsToHome'),
//         headers: headers, body: json.encode({"app_id": "nzone_4457Was555@qsd_job", "category_id": selected, "from": 0, "to": "50"}));
//     var res = jsonDecode(response.body.toString());

//     if (res['data'].toString() == "[]") {
//       setState(() {
//         noData = true;
//       });
//     } else {
//       setState(() {
//         noData = false;
//       });
//     }
//     setState(() {
//       jobCategory = res['data'];
//       Provider.of<AppProvider>(context, listen: false).getJobs = jobCategory;
//       isLoading = false;
//       _isFirstLoadRunning = false;
//     });
//   }

//   setFavorite() async {
//     log('bbbbbbbbbbbbbbbb');
//     setState(() {
//       loadFavorites = true;
//     });
//     var headers = {'Content-Type': 'application/json'};
//     // request.headers.addAll(headers);
//     var response = await http.post(Uri.parse('$apiUrl/setFavourite'),
//         headers: headers,
//         body: json.encode({"verification": verification, "app_id": "nzone_4457Was555@qsd_job", "customer_id": customer_id, "job_id": addId}));
//     var res = jsonDecode(response.body.toString());
//     setState(() {
//       loadFavorites = false;
//       getFavouriteJobs();
//     });
//   }

//   getFavouriteJobs() async {
//     setState(() {
//       loadFavorites = true;
//     });
//     var headers = {'Content-Type': 'application/json'};
//     // request.headers.addAll(headers);
//     var response = await http.post(Uri.parse('$apiUrl/getFavouriteJobs'),
//         headers: headers, body: json.encode({"app_id": "nzone_4457Was555@qsd_job", "verification": verification, "customer_id": customer_id}));
//     var res = jsonDecode(response.body.toString());

//     if (res['data'].toString() != "null") {
//       setState(() {
//         if (res['data'].toString().isNotEmpty) {
//           favoritesList = res['data'];
//         }
//         loadFavorites = false;
//         // _isFirstLoadRunning = false;
//       });
//     }
//   }

//   updateFavorites() {
//     setState(() {
//       FocusManager.instance.primaryFocus?.unfocus();
//       getFavouriteJobs();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isLoading
//         ? FadeHome()
//         : SingleChildScrollView(
//             controller: mycontroller,
//             child: SizedBox(
//               child: Column(
//                 children: [
//                   SizedBox(
//                     child: Stack(
//                       children: [
//                         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                           isLoading
//                               ? Container(
//                                   height: MediaQuery.of(context).size.height / 3,
//                                   width: MediaQuery.of(context).size.width,
//                                   child: Center(child: CircularProgressIndicator()))
//                               : Container(
//                                   width: MediaQuery.of(context).size.width,
//                                   margin: EdgeInsets.symmetric(horizontal: 1.0),
//                                   decoration: BoxDecoration(color: black),
//                                   child: Provider.of<AppProvider>(context, listen: false).wallPaper.isEmpty
//                                       ? FadeWallpaper()
//                                       : Consumer<AppProvider>(
//                                           builder: (context, value, child) => CarouselSlider.builder(
//                                             itemBuilder: (context, index, realIndex) {
//                                               String img = Provider.of<AppProvider>(context, listen: false).wallPaper[index]['image_path'].toString();

//                                               return Container(
//                                                 child:
//                                                     // Image.network(
//                                                     //   "https://pitaratajobs.novasoft.lk/$img",
//                                                     //   // i[index]['image_path'],
//                                                     //   fit: BoxFit.scaleDown,
//                                                     // ),
//                                                     CachedNetworkImage(
//                                                   imageUrl: "$domain/$img",
//                                                   progressIndicatorBuilder: (context, url, downloadProgress) => Center(
//                                                     child: SizedBox(
//                                                       height: 50,
//                                                       width: 50,
//                                                       child: CircularProgressIndicator(value: downloadProgress.progress),
//                                                     ),
//                                                   ),
//                                                   errorWidget: (context, url, error) {
//                                                     return Image.asset(
//                                                       'assets/no-image-icon-23500.jpg',
//                                                       fit: BoxFit.cover,
//                                                     );
//                                                   },
//                                                   fit: BoxFit.scaleDown,
//                                                 ),
//                                               );
//                                             },
//                                             options: CarouselOptions(
//                                                 padEnds: false,
//                                                 viewportFraction: 1,
//                                                 autoPlayInterval: Duration(seconds: 4),
//                                                 autoPlay: true,
//                                                 enlargeCenterPage: true,
//                                                 aspectRatio: 2.0,
//                                                 autoPlayAnimationDuration: const Duration(milliseconds: 2000),
//                                                 onPageChanged: (index, reason) {
//                                                   // setState(() {
//                                                   //   _current = index;
//                                                   // });
//                                                 }),
//                                             itemCount: (Provider.of<AppProvider>(context, listen: false).wallPaper.length / 2).floor(),
//                                           ),
//                                         ),
//                                 ),

//                           // ),
//                           Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: Provider.of<AppProvider>(context, listen: false).wallPaper.asMap().entries.map((entry) {
//                                 return GestureDetector(
//                                   onTap: () => _controller.animateToPage(entry.key),
//                                   child: Container(
//                                     width: 12.0,
//                                     height: 12.0,
//                                     margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.white)
//                                             .withOpacity(_current == entry.key ? 0.9 : 0.4)),
//                                   ),
//                                 );
//                               }).toList()),

//                           SizedBox(
//                             height: 10,
//                           ),
//                           isLoading
//                               ? FadeCategory()
//                               : Column(
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 8,
//                                       ),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           CustomText(
//                                               text: 'Job Categories',
//                                               fontSize: 17,
//                                               fontFamily: 'Comfortaa-VariableFont_wght',
//                                               color: white,
//                                               fontWeight: FontWeight.normal),
//                                           IconButton(
//                                               onPressed: () {
//                                                 SearchCategory();
//                                                 setState(() {
//                                                   temp = [];
//                                                 });
//                                               },
//                                               icon: Icon(
//                                                 Icons.search,
//                                                 color: white,
//                                                 size: 27,
//                                               ))
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 10,
//                                     ),

//                                     // category name list
//                                     Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 8,
//                                         ),
//                                         child: isLoading
//                                             ? Center(
//                                                 child: SizedBox(
//                                                 height: 15,
//                                                 width: 15,
//                                                 child: CircularProgressIndicator(
//                                                   color: Colors.white30,
//                                                 ),
//                                               ))
//                                             : Container(
//                                                 height: 70,
//                                                 child: Consumer<AppProvider>(
//                                                   builder: (context, value, child) => ListView.builder(
//                                                       controller: categoryController,
//                                                       itemCount: value.categoryList.length,
//                                                       scrollDirection: Axis.horizontal,
//                                                       itemBuilder: (BuildContext context, int index) {
//                                                         String catName = value.categoryList[index]['category_name'].toString();

//                                                         return InkWell(
//                                                           borderRadius: BorderRadius.circular(20),
//                                                           onTap: () {
//                                                             categoryController.animateTo(index * 100,
//                                                                 duration: Duration(milliseconds: 50), curve: Curves.ease);
//                                                             setState(() {
//                                                               selected = value.categoryList[index]['category_id'];
//                                                             });
//                                                             if (selected == value.categoryList[index]['category_id']) {
//                                                               log(selected);

//                                                               getJobCategory();

//                                                               setState(() {
//                                                                 selected;
//                                                                 color = true;
//                                                               });
//                                                             }
//                                                           },
//                                                           child: Padding(
//                                                             padding: const EdgeInsets.all(6.0),
//                                                             child: Container(
//                                                               alignment: Alignment.center,
//                                                               width: 100,
//                                                               decoration: BoxDecoration(
//                                                                   boxShadow: <BoxShadow>[
//                                                                     BoxShadow(color: Colors.white54, blurRadius: 3.0, offset: Offset(0.7, 0.7))
//                                                                   ],
//                                                                   borderRadius: BorderRadius.circular(15),
//                                                                   color: selected == value.categoryList[index]['category_id']
//                                                                       ? background_green
//                                                                       : light_dark),
//                                                               child: CustomText(
//                                                                   text: catName,
//                                                                   fontSize: 15,
//                                                                   fontFamily: 'Viga',
//                                                                   color: white,
//                                                                   fontWeight: FontWeight.normal),
//                                                             ),
//                                                           ),
//                                                         );
//                                                       }),
//                                                 ),
//                                               )

//                                         //  CustomList(cat: jobCategory),
//                                         ),
//                                   ],
//                                 ),

//                           // jub category all

//                           _isFirstLoadRunning
//                               ? SizedBox(
//                                   height: 500,
//                                   child: Center(
//                                       child:
//                                           LoadingAnimationWidget.staggeredDotsWave(color: Colors.grey, size: MediaQuery.of(context).size.width / 6)),
//                                 )
//                               : Provider.of<AppProvider>(context, listen: false).getJobs.isEmpty
//                                   ? SizedBox(
//                                       height: 500,
//                                     )
//                                   : Consumer<AppProvider>(
//                                       builder: (context, value, child) => ListView.builder(
//                                           physics: NeverScrollableScrollPhysics(),
//                                           shrinkWrap: true,
//                                           itemCount: value.getJobs.length,
//                                           itemBuilder: (BuildContext context, int index) {
//                                             return noData
//                                                 ? Container(height: MediaQuery.of(context).size.height)
//                                                 : InkWell(
//                                                     borderRadius: BorderRadius.circular(20),
//                                                     onTap: () async {
//                                                       if (userStatus == true) {
//                                                         if (favoritesList.any((element) =>
//                                                                 element["ads_id"].toString() == value.getJobs[index]["ads_id"].toString()) ==
//                                                             true) {
//                                                           setState(() {
//                                                             x = true;
//                                                           });
//                                                         } else {
//                                                           setState(() {
//                                                             x = false;
//                                                           });
//                                                         }
//                                                       }
//                                                       log(value.getJobs[index]['job_category_id'].toString());
//                                                       await Navigator.push(
//                                                           context,
//                                                           MaterialPageRoute(
//                                                               builder: (context) => SingleJob(
//                                                                     update: updateFavorites,
//                                                                     x: x,
//                                                                     // categoryId: jobCategory[index]['job_category_id'].toString(),
//                                                                     // whatapp: jobCategory[index]['job_whatsapp'].toString(),
//                                                                     // mobile: jobCategory[index]['job_mobile'].toString(),
//                                                                     // email: jobCategory[index]['job_email'].toString(),
//                                                                     // salary: jobCategory[index]['job_salary'].toString(),
//                                                                     // categoryName: jobCategory[index]['biz_category_name'].toString(),
//                                                                     addId: value.getJobs[index]['ads_id'].toString(),
//                                                                     // description: jobCategory[index]['description'].toString(),
//                                                                     // img: 'https://pitaratajobs.novasoft.lk/${jobCategory[index]['main_image']}',
//                                                                   )));
//                                                     },
//                                                     child: Padding(
//                                                       padding: const EdgeInsets.all(8.0),
//                                                       child: Container(
//                                                         decoration: BoxDecoration(
//                                                           color: light_dark,
//                                                           border: Border.all(color: Colors.green, width: 0.8),
//                                                           borderRadius: BorderRadius.only(
//                                                               topRight: Radius.circular(20),
//                                                               topLeft: Radius.circular(20),
//                                                               bottomLeft: Radius.circular(15),
//                                                               bottomRight: Radius.circular(15)),
//                                                         ),
//                                                         height: MediaQuery.of(context).size.height / 2.8,
//                                                         child: joblist
//                                                             ? Center(child: CircularProgressIndicator())
//                                                             : Stack(children: [
//                                                                 Positioned(
//                                                                   bottom: 0,
//                                                                   left: 0,
//                                                                   right: 0,
//                                                                   child: Container(
//                                                                     alignment: Alignment.bottomLeft,
//                                                                     decoration: BoxDecoration(
//                                                                         color: light_dark,
//                                                                         borderRadius: BorderRadius.only(
//                                                                             bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
//                                                                     height: MediaQuery.of(context).size.height / 4.2,
//                                                                     width: double.infinity,
//                                                                     child: Row(
//                                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                       children: [
//                                                                         Padding(
//                                                                           padding: const EdgeInsets.all(8.0),
//                                                                           child: CustomText(
//                                                                               text: value.getJobs[index]['biz_category_name'],
//                                                                               fontSize: 12,
//                                                                               fontFamily: 'Comfortaa-VariableFont_wght',
//                                                                               color: white,
//                                                                               fontWeight: FontWeight.w600),
//                                                                         ),
//                                                                         Padding(
//                                                                           padding: const EdgeInsets.all(8.0),
//                                                                           child: CustomText(
//                                                                               text: "#${value.getJobs[index]['ads_id'].toString()}",
//                                                                               fontSize: 10,
//                                                                               fontFamily: 'Comfortaa-VariableFont_wght',
//                                                                               color: white,
//                                                                               fontWeight: FontWeight.w300),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                                 Positioned(
//                                                                   right: 0,
//                                                                   left: 0,
//                                                                   top: 0,
//                                                                   child: Container(
//                                                                     height: MediaQuery.of(context).size.height / 3.2,
//                                                                     width: double.infinity,
//                                                                     decoration:
//                                                                         BoxDecoration(color: light_dark, borderRadius: BorderRadius.circular(20)),
//                                                                     child: ClipRRect(
//                                                                       borderRadius: BorderRadius.circular(20),
//                                                                       child: CachedNetworkImage(
//                                                                         alignment: Alignment(-1, -1),
//                                                                         imageUrl: "$domain/${value.getJobs[index]['main_image']}",
//                                                                         progressIndicatorBuilder: (context, url, downloadProgress) => Center(
//                                                                           child: SizedBox(
//                                                                             height: 50,
//                                                                             width: 50,
//                                                                             child: CircularProgressIndicator(value: downloadProgress.progress),
//                                                                           ),
//                                                                         ),
//                                                                         errorWidget: (context, url, error) {
//                                                                           return Image.asset(
//                                                                             'assets/no-image-icon-23500.jpg',
//                                                                             fit: BoxFit.cover,
//                                                                           );
//                                                                         },
//                                                                         fit: BoxFit.cover,
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                                 Positioned(
//                                                                   right: 8,
//                                                                   child: IconButton(
//                                                                       onPressed: () {
//                                                                         logger.w(userStatus);
//                                                                         if (userStatus == true) {
//                                                                           setState(() {
//                                                                             addId = value.getJobs[index]['ads_id'].toString();
//                                                                             print(addId);
//                                                                             logger.w("Logger is working!");
//                                                                           });
//                                                                           favoritesList.any((element) =>
//                                                                                   element["ads_id"].toString() ==
//                                                                                   value.getJobs[index]["ads_id"].toString())
//                                                                               ? alert(
//                                                                                   'You have already added this job to your favorite list!',
//                                                                                   true,
//                                                                                   true,
//                                                                                 )
//                                                                               : setFavorite();

//                                                                           setState(() {
//                                                                             favoritesList;
//                                                                           });
//                                                                         } else {
//                                                                           alert(
//                                                                             'Please login to your account to add this job to your favorite list!',
//                                                                             false,
//                                                                             false,
//                                                                           );
//                                                                         }
//                                                                       },
//                                                                       icon: loadFavorites == true &&
//                                                                               value.getJobs[index]['ads_id'].toString() == addId.toString()
//                                                                           ? CircularProgressIndicator(
//                                                                               color: red,
//                                                                             )
//                                                                           : ShaderMask(
//                                                                               shaderCallback: (Rect bounds) {
//                                                                                 return LinearGradient(
//                                                                                   begin: Alignment.topCenter,
//                                                                                   end: Alignment.bottomCenter,
//                                                                                   colors: [Colors.red, Colors.orange],
//                                                                                 ).createShader(bounds);
//                                                                               },
//                                                                               child: Icon(
//                                                                                 userStatus == true &&
//                                                                                         favoritesList.any((element) =>
//                                                                                             element["ads_id"].toString() ==
//                                                                                             value.getJobs[index]["ads_id"].toString())
//                                                                                     ? Icons.favorite
//                                                                                     : Icons.favorite_border,
//                                                                                 color: userStatus == true &&
//                                                                                         favoritesList.any((element) =>
//                                                                                             element["ads_id"].toString() ==
//                                                                                             value.getJobs[index]["ads_id"].toString())
//                                                                                     ? red
//                                                                                     : white,
//                                                                               ),
//                                                                             )),
//                                                                 ),
//                                                               ]),
//                                                       ),
//                                                     ),
//                                                   );
//                                           }),
//                                     )
//                         ]),
//                         if (_isLoadMoreRuning == true)
//                           Positioned(
//                             bottom: 100,
//                             left: 0,
//                             right: 0,
//                             child: Padding(
//                               padding: const EdgeInsets.only(
//                                 bottom: 0,
//                               ),
//                               child: Center(
//                                   child: CircularProgressIndicator(
//                                 color: red,
//                               )),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//   }

//   alert(
//     String text,
//     bool item,
//     bool save,
//   ) async {
//     return await showDialog(
//         context: context,
//         builder: (context) {
//           var h = MediaQuery.of(context).size.height;
//           return AlertDialog(
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
//             contentPadding: EdgeInsets.only(top: 10.0),
//             backgroundColor: black,
//             content: Container(
//               height: 300,
//               width: double.infinity,
//               decoration: BoxDecoration(color: black, borderRadius: BorderRadius.circular(15)),
//               child: Column(
//                 children: [
//                   Container(
//                     alignment: Alignment.topRight,
//                     child: IconButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         icon: Icon(
//                           Icons.close,
//                           color: Colors.white70,
//                         )),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child:
//                         CustomText(text: text, fontSize: 20, fontFamily: 'Comfortaa-VariableFont_wght', color: white, fontWeight: FontWeight.normal),
//                   ),
//                   SizedBox(
//                     height: 35,
//                   ),
//                   save
//                       ? Container()
//                       : Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             RadiusButton(
//                               onTap: () {
//                                 Navigator.pop(context);
//                                 log('ggggg');
//                               },
//                               colortext: black,
//                               color: Colors.white60,
//                               height: h / 15,
//                               width: 32.w,
//                               text: item ? 'NO' : "Cancel",
//                             ),
//                             RadiusButton(
//                               onTap: () async {
//                                 if (item == true) {
//                                   Navigator.pop(context);
//                                 } else {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(builder: (context) => NameScreen()),
//                                   );
//                                 }
//                               },
//                               colortext: black,
//                               color: font_green,
//                               height: h / 15,
//                               width: 32.w,
//                               text: item ? 'YES' : "Login",
//                             ),
//                           ],
//                         )
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   void _runFilter(String enteredKeyword) {
//     var results = [];
//     if (enteredKeyword.isEmpty) {
//       // if the search field is empty or only contains white-space, we'll display all users
//       results = Provider.of<AppProvider>(context, listen: false).serchCategory;
//     } else if (Provider.of<AppProvider>(context, listen: false)
//         .serchCategory
//         .where((user) => user["category_name"][0].toLowerCase().contains(enteredKeyword.toLowerCase()))
//         .toList()
//         .isNotEmpty) {
//       results = Provider.of<AppProvider>(context, listen: false)
//           .serchCategory
//           .where((user) => user["category_name"][0].toLowerCase().contains(enteredKeyword.toLowerCase()))
//           .toList();
//     }

//     // Refresh the UI
//     setState(() {
//       temp = results;
//       print(temp);
//     });
//   }

//   void _runFilter2(String enteredKeyword) {
//     var results = [];
//     if (enteredKeyword.isEmpty) {
//       // if the search field is empty or only contains white-space, we'll display all users
//       results = Provider.of<AppProvider>(context, listen: false).serchCategory;
//     } else if (Provider.of<AppProvider>(context, listen: false)
//         .serchCategory
//         .where((user) => user["category_name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
//         .toList()
//         .isNotEmpty) {
//       results = Provider.of<AppProvider>(context, listen: false)
//           .serchCategory
//           .where((user) => user["category_name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
//           .toList();
//     }

//     // Refresh the UI
//     setState(() {
//       temp = results;
//       print(temp);
//     });
//   }

//   SearchCategory() {
//     TextEditingController controller = TextEditingController();
//     int Item = 100;
//     ScrollController scrollController = ScrollController();
//     showDialog(
//       context: context,
//       builder: (context) {
//         var h = MediaQuery.of(context).size.height;
//         var w = MediaQuery.of(context).size.width;
//         return StatefulBuilder(builder: (context, setState) {
//           return AlertDialog(
//             scrollable: true,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: font_green)),
//             contentPadding: EdgeInsets.all(0),
//             insetPadding: EdgeInsets.all(12),
//             actionsAlignment: MainAxisAlignment.start,
//             content: Container(
//               height: h,
//               width: w,
//               padding: EdgeInsets.all(12),
//               color: black,
//               child: SingleChildScrollView(
//                 controller: scrollController,
//                 child: Column(children: [
//                   Container(
//                       alignment: Alignment.centerRight,
//                       child: IconButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           icon: Icon(
//                             Icons.close,
//                             color: white,
//                           ))),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: CustomText(text: "Job Category", fontSize: 15.sp, fontFamily: 'Viga', color: white, fontWeight: FontWeight.normal),
//                   ),
//                   TextFormField(
//                     style: TextStyle(color: white, fontSize: 13.sp),
//                     controller: controller,
//                     onChanged: (value) {
//                       _runFilter2(value);
//                       setState(() {
//                         Item = 2000;
//                       });
//                     },
//                     decoration: InputDecoration(
//                         counterStyle: TextStyle(color: Colors.white),
//                         suffixIcon: IconButton(
//                           onPressed: () {},
//                           icon: Icon(
//                             Icons.search,
//                             color: background_green,
//                           ),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(15.0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(15.0),
//                         ),
//                         contentPadding: EdgeInsets.all(8),
//                         filled: true,
//                         hintStyle: TextStyle(color: Colors.grey[600]),
//                         hintText: 'search job category',
//                         fillColor: light_dark),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     child: GridView.builder(
//                       physics: NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: character.length,
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 8,
//                       ),
//                       itemBuilder: (context, index) => TextButton(
//                         onPressed: () {
//                           categoryController.animateTo(100, duration: Duration(milliseconds: 50), curve: Curves.ease);
//                           _runFilter(character[index]);
//                           setState(() {
//                             controller.text = character[index];
//                             Item = index;
//                           });
//                         },
//                         child: Text(
//                           character[index],
//                           style: TextStyle(color: Item == index ? white : Colors.blue, fontSize: 18),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     child: GridView.builder(
//                       padding: EdgeInsets.only(bottom: 100),
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: temp.length,
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3,
//                         mainAxisExtent: 100,
//                       ),
//                       itemBuilder: (context, index) {
//                         print(temp[index]);
//                         return TextButton(
//                           onPressed: () {
//                             setState(() {
//                               selected = temp[index]['category_id'];
//                               getJobCategory();
//                               Item = 100;
//                             });

//                             Navigator.pop(context);
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(6.0),
//                             child: Container(
//                               alignment: Alignment.center,
//                               width: 100,
//                               decoration: BoxDecoration(
//                                   boxShadow: <BoxShadow>[BoxShadow(color: Colors.white54, blurRadius: 3.0, offset: Offset(0.7, 0.7))],
//                                   borderRadius: BorderRadius.circular(15),
//                                   color: selected == temp[index]['category_id'] ? background_green : light_dark),
//                               child: CustomText(
//                                   text: temp[index]["category_name"], fontSize: 15, fontFamily: 'Viga', color: white, fontWeight: FontWeight.normal),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   )
//                 ]),
//               ),
//             ),
//           );
//         });
//       },
//     );
//   }
// }