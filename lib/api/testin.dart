// import 'package:connectivity_plus/connectivity_plus.dart';

// class d{


//   data()async{   
//                                                       var connectivityResult =
//                                                           await (Connectivity()
//                                                               .checkConnectivity());
//                                                       if (connectivityResult ==
//                                                               ConnectivityResult
//                                                                   .mobile ||
//                                                           connectivityResult ==
//                                                               ConnectivityResult
//                                                                   .wifi) {
//                                                         if (_character ==
//                                                             SingingCharacter
//                                                                 .Delivered) {
//                                                           var url =
//                                                               'https://api.koombiyodelivery.lk/staffapi/v2/delivery/Delivered/users';
//                                                           var responses =
//                                                               await https.post(
//                                                                   Uri.parse(
//                                                                       url),
//                                                                   body: {
//                                                                 'owner': widget
//                                                                     .userid,
//                                                                 'waybill_id':
//                                                                     myorders[
//                                                                             index]
//                                                                         [
//                                                                         'waybill_id'],
//                                                                 'status': '17'
//                                                               });
//                                                           String rawJson =
//                                                               responses.body
//                                                                   .toString();
//                                                           final newString =
//                                                               rawJson
//                                                                   .replaceAll(
//                                                                       '"', '');
//                                                           ScaffoldMessenger.of(
//                                                                   context)
//                                                               .showSnackBar(SnackBar(
//                                                                   content: Text(
//                                                                       newString
//                                                                           .toString())));
//                                                         } else if (_character ==
//                                                             SingingCharacter
//                                                                 .PDelivered) {
//                                                           if (dropdownvalue !=
//                                                               '') {
//                                                             if (pcod.text !=
//                                                                 '') {
//                                                               var url =
//                                                                   'https://api.koombiyodelivery.lk/staffapi/v2/delivery/Pdelivery/users';
//                                                               var responses =
//                                                                   await https.post(
//                                                                       Uri.parse(
//                                                                           url),
//                                                                       body: {
//                                                                     'owner': widget
//                                                                         .userid,
//                                                                     'waybill_id':
//                                                                         myorders[index]
//                                                                             [
//                                                                             'waybill_id'],
//                                                                     'status':
//                                                                         '19',
//                                                                     'reason':
//                                                                         dropdownvalue
//                                                                             .toString(),
//                                                                     'pcod': pcod
//                                                                         .text,
//                                                                   });
//                                                               String rawJson =
//                                                                   responses.body
//                                                                       .toString();
//                                                               final newString =
//                                                                   rawJson
//                                                                       .replaceAll(
//                                                                           '"',
//                                                                           '');
//                                                               ScaffoldMessenger
//                                                                       .of(
//                                                                           context)
//                                                                   .showSnackBar(
//                                                                       SnackBar(
//                                                                           content:
//                                                                               Text(newString.toString())));
//                                                             } else {
//                                                               ScaffoldMessenger
//                                                                       .of(
//                                                                           context)
//                                                                   .showSnackBar(
//                                                                       SnackBar(
//                                                                           content:
//                                                                               Text('Collected COD ?')));
//                                                             }
//                                                           } else {
//                                                             ScaffoldMessenger
//                                                                     .of(context)
//                                                                 .showSnackBar(
//                                                                     SnackBar(
//                                                                         content:
//                                                                             Text('Please Select a Reason')));
//                                                             setState(
//                                                               () {
//                                                                 updateBTN =
//                                                                     true;
//                                                               },
//                                                             );
//                                                           }
//                                                         } else if (_character ==
//                                                             SingingCharacter
//                                                                 .Re) {
//                                                           if (dropdownvalue2 !=
//                                                               '') {
//                                                             var url =
//                                                                 'https://api.koombiyodelivery.lk/staffapi/v2/delivery/Reshedule/users';
//                                                             var responses =
//                                                                 await https.post(
//                                                                     Uri.parse(
//                                                                         url),
//                                                                     body: {
//                                                                   'owner': widget
//                                                                       .userid,
//                                                                   'waybill_id':
//                                                                       myorders[
//                                                                               index]
//                                                                           [
//                                                                           'waybill_id'],
//                                                                   'status': '7',
//                                                                   'reason':
//                                                                       dropdownvalue2
//                                                                           .toString(),
//                                                                   'rdate':
//                                                                       resheduleddate
//                                                                           .text,
//                                                                 });
//                                                             String rawJson =
//                                                                 responses.body
//                                                                     .toString();
//                                                             final newString =
//                                                                 rawJson
//                                                                     .replaceAll(
//                                                                         '"',
//                                                                         '');
//                                                             ScaffoldMessenger
//                                                                     .of(context)
//                                                                 .showSnackBar(SnackBar(
//                                                                     content: Text(
//                                                                         newString
//                                                                             .toString())));
//                                                           } else {
//                                                             ScaffoldMessenger
//                                                                     .of(context)
//                                                                 .showSnackBar(
//                                                                     SnackBar(
//                                                                         content:
//                                                                             Text('Please Select the Update Type')));
//                                                             setState(
//                                                               () {
//                                                                 updateBTN =
//                                                                     true;
//                                                               },
//                                                             );
//                                                           }
//                                                         } else {
//                                                           ScaffoldMessenger.of(
//                                                                   context)
//                                                               .showSnackBar(SnackBar(
//                                                                   content: Text(
//                                                                       'Please Select the Reason')));
//                                                           setState(
//                                                             () {
//                                                               updateBTN = true;
//                                                             },
//                                                           );
//                                                         }
//                                                       } else {
//                                                         setState(
//                                                           () {
//                                                             updateBTN = false;
//                                                           },
//                                                         );

//                                                         ScaffoldMessenger.of(
//                                                                 context)
//                                                             .showSnackBar(SnackBar(
//                                                                 content: Text(
//                                                                     'No Internet')));
//                                                         setState(
//                                                           () {
//                                                             updateBTN = true;
//                                                           },
//                                                         );
//                                                       }}
// }