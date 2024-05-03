// import 'dart:io';

// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/api/api.dart';
// import 'package:flutter_application_2/app_details/color.dart';
// import 'package:flutter_application_2/provider/provider.dart';
// import 'package:flutter_application_2/uI/widget/diloag_button.dart';
// import 'package:flutter_sizer/flutter_sizer.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class ItemDetail {
//   String newImage = '';
//   final ImagePicker _picker = ImagePicker();
//   DateTime selectedDate = DateTime.now();
//   final List<Map> _pdelivery = [
//     {
//       "reason_id": "34",
//       "reason": "Customer has already paid partially in advance"
//     },
//     {"reason_id": "35", "reason": "Requested by online store"},
//     {"reason_id": "36", "reason": "Damaged item"},
//     {"reason_id": "37", "reason": "Waybill and system data mismatch"},
//     {"reason_id": "38", "reason": "COD already paid in total"}
//   ];
//   final List<Map> _recheduled = [
//     {"reason_id": "1", "reason": "Customer rescheduled"},
//     {"reason_id": "2", "reason": "Customer phone switched off"},
//     {"reason_id": "3", "reason": "Customer phone no answer"},
//     {"reason_id": "4", "reason": "Customer out of city"},
//     {"reason_id": "5", "reason": "Customer unable to pay"},
//     {"reason_id": "6", "reason": "Different location"},
//     {"reason_id": "7", "reason": "Customer request to open the package"},
//     {"reason_id": "8", "reason": "Requested  online store"},
//     {"reason_id": "9", "reason": "Wrong quantity"},
//     {"reason_id": "10", "reason": "Bad weather (Floods)"},
//     {"reason_id": "11", "reason": "Rescheduled Due to COVID-19"}
//   ];
//   String? dropdownvalue;
//   String? dropdownvalue2;
//   itemDetails(
//     BuildContext context,
//     String waybill,
//     String cod,
//     bool updateBTN,
//     int x,
//   ) {
//     Provider.of<ProviderS>(context, listen: false).progress = 0.0;
//     Provider.of<ProviderS>(context, listen: false).fomatedDate =
//         DateFormat.yMMMEd().format(DateTime.now());
//     var h = MediaQuery.of(context).size.height;
//     var w = MediaQuery.of(context).size.width;
//     x = 0;
//     return showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(builder: (context, setstate) {
//         return Consumer<ProviderS>(
//           builder: (context, provider, child) => AlertDialog(
//             scrollable: true,
//             contentPadding: EdgeInsets.all(0),
//             actionsPadding: EdgeInsets.all(20),
//             actionsAlignment: MainAxisAlignment.spaceBetween,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             actions: [
//               DialogButton(
//                 buttonHeight: h / 14,
//                 width: w,
//                 text: 'Save',
//                 color:
//                     updateBTN ? Color.fromARGB(255, 8, 152, 219) : Colors.grey,
//                 onTap: updateBTN
//                     ? () {
//                         CustomApi().oderData(
//                             x,
//                             waybill,
//                             context,
//                             dropdownvalue.toString(),
//                             dropdownvalue2.toString(),
//                             cod,
//                             provider.fomatedDate);
//                       }
//                     : () {},
//               )
//             ],
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                     alignment: Alignment.centerRight,
//                     child: IconButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         icon: Icon(
//                           Icons.close,
//                           color: black2,
//                         ))),
//                 Text('ITEM DETAILS',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       color: black,
//                       fontSize: 18.dp,
//                     )),
//                 Text(waybill + ' - Rs.' + cod,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       color: black,
//                       fontSize: 14.dp,
//                     )),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Divider(
//                   height: 0,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     setstate(() {
//                       x = 1;
//                     });
                 
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 15),
//                     height: h / 16,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Delivered',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               color: black2,
//                               fontSize: 15.dp,
//                             )),
//                         Icon(
//                           x == 1
//                               ? Icons.check_circle_rounded
//                               : Icons.remove_circle_outline,
//                           color: x == 1
//                               ? Color.fromARGB(255, 7, 138, 125)
//                               : black3,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 Divider(
//                   height: 0,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     setstate(() {
//                       x = 2;
//                     });
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 15),
//                     height: h / 16,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Partially Delivered',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               color: black2,
//                               fontSize: 15.dp,
//                             )),
//                         Icon(
//                           x == 2
//                               ? Icons.check_circle_rounded
//                               : Icons.remove_circle_outline,
//                           color: x == 2
//                               ? Color.fromARGB(255, 7, 138, 125)
//                               : black3,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 Divider(
//                   height: 0,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     setstate(() {
//                       x = 3;
//                     });
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 15),
//                     height: h / 16,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Rescheduled',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               color: black2,
//                               fontSize: 15.dp,
//                             )),
//                         Icon(
//                           x == 3
//                               ? Icons.check_circle_rounded
//                               : Icons.remove_circle_outline,
//                           color: x == 3
//                               ? Color.fromARGB(255, 74, 143, 136)
//                               : black3,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 x == 2
//                     ? Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Card(
//                           child: Container(
//                             padding: EdgeInsets.symmetric(horizontal: 15),
//                             alignment: Alignment.centerRight,
//                             width: w,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5.0),
//                               border: Border.all(
//                                   color: black3,
//                                   style: BorderStyle.solid,
//                                   width: 0.80),
//                             ),
//                             child: Column(
//                               children: [
//                                 DropdownButton(
//                                   underline: Divider(
//                                     color: white,
//                                     height: 0,
//                                   ),
//                                   isExpanded: true,
//                                   padding: EdgeInsets.only(right: 10),
//                                   alignment: AlignmentDirectional.centerEnd,
//                                   hint: Text(
//                                       'Select Reason                                                                   '),

//                                   value: dropdownvalue,

//                                   //implement initial value or selected value
//                                   onChanged: (value) {
//                                     setstate(() {
//                                       //set state will update UI and State of your App
//                                       dropdownvalue = value
//                                           .toString(); //change selectval to new value
//                                     });
//                                   },
//                                   items: _pdelivery.map((itemone) {
//                                     return DropdownMenuItem(
//                                         value: itemone['reason_id'],
//                                         child: Card(
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Text(
//                                               itemone['reason'].toString(),
//                                               style: TextStyle(color: black2),
//                                             ),
//                                           ),
//                                         ));
//                                   }).toList(),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       )
//                     : SizedBox(),
//                 x == 3
//                     ? Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Card(
//                           child: Container(
//                             padding: EdgeInsets.symmetric(horizontal: 15),
//                             alignment: Alignment.centerRight,
//                             width: w,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5.0),
//                               border: Border.all(
//                                   color: black3,
//                                   style: BorderStyle.solid,
//                                   width: 0.80),
//                             ),
//                             child: Column(
//                               children: [
//                                 DropdownButton(
//                                   underline: Divider(
//                                     color: white,
//                                     height: 0,
//                                   ),
//                                   isExpanded: true,
//                                   padding: EdgeInsets.only(right: 10),
//                                   alignment: AlignmentDirectional.centerEnd,
//                                   hint: Text(
//                                       'Select Reason                                                                   '),

//                                   value: dropdownvalue2,

//                                   //implement initial value or selected value
//                                   onChanged: (value) {
//                                     setstate(() {
//                                       //set state will update UI and State of your App
//                                       dropdownvalue2 = value
//                                           .toString(); //change selectval to new value
//                                     });
//                                   },
//                                   items: _recheduled.map((itemone) {
//                                     return DropdownMenuItem(
//                                         value: itemone["reason_id"],
//                                         child: Card(
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Text(
//                                               itemone["reason"],
//                                               style: TextStyle(color: black2),
//                                             ),
//                                           ),
//                                         ));
//                                   }).toList(),
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(provider.fomatedDate,
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.w500,
//                                           color: black2,
//                                           fontSize: 15.dp,
//                                         )),
//                                     IconButton(
//                                         padding: EdgeInsets.all(0),
//                                         onPressed: () {
//                                           _selectDate(context);
//                                         },
//                                         icon: Icon(Icons.date_range_rounded))
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       )
//                     : SizedBox(),
//                 Divider(
//                   height: 0,
//                 ),
//                 SizedBox(
//                   height: 12,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     newImage.isNotEmpty
//                         ? ClipRRect(
//                             borderRadius: BorderRadius.all(Radius.circular(12)),
//                             child: Container(
//                                 height: h / 7,
//                                 width: w / 2.2,
//                                 child: Image.file(
//                                   File(newImage),
//                                   fit: BoxFit.cover,
//                                 )))
//                         : DottedBorder(
//                             color: Colors.black38,
//                             borderType: BorderType.RRect,
//                             radius: Radius.circular(12),
//                             padding: EdgeInsets.all(6),
//                             child: ClipRRect(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(12)),
//                               child: Container(
//                                 alignment: Alignment.center,
//                                 height: h / 7,
//                                 width: w / 2,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.cloud_upload_outlined,
//                                       size: 40,
//                                       color:
//                                           const Color.fromARGB(96, 77, 76, 76),
//                                     ),
//                                     Text('Please upload \nyour image',
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.black38,
//                                           fontSize: 12.dp,
//                                         )),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         InkWell(
//                           onTap: () async {
//                             provider.progress = 0.0;
                          
//                             final XFile? image = await _picker.pickImage(
//                                 source: ImageSource.camera);

//                             setstate(() {
//                               newImage = image!.path;
//                             });

//                             CustomApi().uploadImage(context, image, waybill);

//                             // setState(() {
//                             //   updateBTN = true;
//                             // });
//                           },
//                           child: Card(
//                               elevation: 5,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(12.0),
//                                 child: Icon(
//                                   color: Colors.black38,
//                                   Icons.camera_alt,
//                                 ),
//                               )),
//                         ),
//                         InkWell(
//                           borderRadius: BorderRadius.circular(20),
//                           onTap: () async {
//                             provider.progress = 0.0;
//                             final XFile? image = await _picker.pickImage(
//                                 source: ImageSource.gallery);

//                             setstate(() {
//                               newImage = image!.path;
//                             });

//                             CustomApi().uploadImage(context, image, waybill);

//                             // setState(() {
//                             //   updateBTN = true;
//                             // });
//                             // source
//                           },
//                           child: Card(
//                               elevation: 5,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(12.0),
//                                 child: Icon(
//                                   color: Colors.black38,
//                                   Icons.photo,
//                                 ),
//                               )),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//                 LinearProgressIndicator(
//                   borderRadius: BorderRadius.circular(10),
//                   semanticsValue: provider.progress.toString(),
//                   value: provider.progress,
//                   minHeight: 7.0,
//                   backgroundColor: Colors.grey[300],
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                       const Color.fromARGB(255, 21, 107, 177)),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   Future _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//         barrierColor: black.withOpacity(0.6),
//         context: context,
//         initialDate: selectedDate,
//         firstDate: DateTime(2015, 8),
//         lastDate: DateTime(2101));
//     if (picked != null && picked != selectedDate) {
//       selectedDate = picked;
//       Provider.of<ProviderS>(context, listen: false).fomatedDate =
//           DateFormat.yMMMEd().format(picked);
//       Provider.of<ProviderS>(context, listen: false).fomatedDate =
//           DateFormat.yMMMEd().format(picked);
//       var formattedDate = DateFormat.yMMMEd().format(picked);
     
//     }
//   }
// }
