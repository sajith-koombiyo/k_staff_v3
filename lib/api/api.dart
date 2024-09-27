import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:app_install_date/app_install_date.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/app_details/color.dart';
import 'package:flutter_application_2/class/class.dart';
import 'package:flutter_application_2/provider/provider.dart';
import 'package:flutter_application_2/sql_db/db.dart';
import 'package:flutter_application_2/uI/app_agreement/agreement.dart';
import 'package:flutter_application_2/uI/login_and_signup/otp.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as https;
import '../app_details/const.dart';
import '../uI/login_and_signup/login.dart';
import '../uI/main/navigation/navigation.dart';

class CustomApi {
//user location read
  SqlDb sqlDb = SqlDb();
  userLocation(String userid, String lat, String long) async {
    Map<String, String> headers = {
      'userkey': '$userid',
    };
    var urll = '${ApiUrl}/Riderlocation/users';
    await https.post(
        headers: headers, Uri.parse(urll), body: {'lati': lat, 'longt': long});
  }

// splash screen api  this api checking user first time login and after login detail ,if user
  checkFirstSeen(BuildContext context) async {
    Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = await Permission.location.request();
    Provider.of<ProviderS>(context, listen: false).permission = status;
    bool _seen = (prefs.getBool('seen') ?? false);
    if (_seen) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        var urll = '${ApiUrl}/Version/users';
        var res = await https.post(Uri.parse(urll), body: {});
        var responce = jsonDecode(res.body);
        print(responce);
        if (res.statusCode == 500) {
          Provider.of<ProviderS>(context, listen: false).isServerDown = true;
        } else {
          Provider.of<ProviderS>(context, listen: false).isServerDown = false;
        }

        if (responce == "3.0") {
          late String installDate;
          final DateTime date = await AppInstallDate().installDate;
          installDate = date.toString();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var rKey = await prefs.getString('rKey');
          String key = rKey.toString();
          var name = await prefs.getString('uName');
          String userName = name.toString();

          if (key != 'null' && userName != 'null') {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            final String? userKey = await prefs.getString('userkey');

            late String installDate;
            final DateTime date = await AppInstallDate().installDate;
            installDate = date.toString();
            Map<String, String> headers = {
              'userkey': '$userKey',
            };

            var urll = '${ApiUrl}/Remember/users';
            var res = await https.post(
                headers: headers,
                Uri.parse(urll),
                body: {'imei': key, 'app_date': installDate});
            var responce = jsonDecode(res.body);
            print(responce.toString());

            if (responce['userkey'] == userKey) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NavigationScreen(
                            staffId: userName,
                            userId: responce['userkey'],
                          )));
            } else {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Login()));
            }
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Login()));
          }
        } else {
          notification().info(context, 'Please Download The New Version');
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              actions: [
                TextButton(
                    onPressed: () {
                      exit(0);
                    },
                    child: Text('IGNORE')),
                TextButton(onPressed: () {}, child: Text('UPDATE NOW'))
              ],
              content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Update App ?',
                      style: TextStyle(
                          fontSize: 22,
                          color: black1,
                          // fontFamily: 'KodeMono',
                          fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'A New version of upgrade available',
                      style: TextStyle(
                          fontSize: 17,
                          color: black1,
                          // fontFamily: 'KodeMono',
                          fontWeight: FontWeight.normal),
                    ),
                  ]),
            ),
          );
        }
      } else {
        notification().warning(context, 'No Internet');
      }
    } else {
      await prefs.setBool('seen', true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Condition()));
    }
  }

  // user login

  login(
    String userNameController,
    BuildContext context,
  ) async {
    String? fCMTocken;
    final firebaseMessaging = FirebaseMessaging.instance;

    await firebaseMessaging.requestPermission();

    fCMTocken = await firebaseMessaging.getToken();
    print(fCMTocken.toString());

    fCMTocken;
// fZSfYewBT_S74v4mLnO48q:APA91bH2M307Ndk-LjqV9PrV3oXA2vUN5UZxnGwzIH1fhMiRqEARQVma3m9o8SD6oWWiSwbjkiMDz5uXJnfFUkAvjeTPvehr37l8odg4s0LkflWCToiESgRQbJs11b2RQgV239mw4jaN
    String username = userNameController;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var urll = '${ApiUrl}Loginn/users';

      var response = await https.post(Uri.parse(urll),
          body: {'username': username, 'noti_key': fCMTocken.toString()});

      if (response.statusCode != 500) {
        Map<String, dynamic> map = jsonDecode(response.body);
        print(map);
        if (map['status'] == 200) {
          String userkey = map['userkey'].toString();
          int accessesKey = int.parse(map['access_group'].toString());
          String phone = map['phone_no'].toString();

          print(phone);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userkey', userkey);
          await prefs.setInt('accessesKey', accessesKey);

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OTP(userId: userkey, userName: username, number: phone),
              ));
        } else if (map['status'] == 400) {
          notification().info(context, 'Bad Request: Error Occurred');
        } else if (map['status'] == 403) {
          notification().info(context, 'Forbidden: Deactivated Account');
        } else if (map['status'] == 404) {
          notification().info(context, 'Invalid Username');
        }
      } else {
        notification().warning(context, 'technical error');
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

//  otp screen otp api call function
  setOtp(String otp, String userKey, BuildContext context) async {
    String otpnumber = otp;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Verifyotp/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$userKey',
      };
      // Make POST request
      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {
        'otp': '$otpnumber',
      });

      Map<String, dynamic> map = jsonDecode(res.body);

      if (map['status'] == 202) {
        Map<String, dynamic> userData = map['userdata'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String username = userData['username'].toString();
        String pickupDevice = userData['pickup_device'].toString();
        String userId = userData['user_id'].toString();
        var res = await prefs.setString("user_id", userId);
        var res2 = await prefs.setString("pickup_device", pickupDevice);
        late String installDate;
        final DateTime date = await AppInstallDate().installDate;
        installDate = date.toString();
        const _chars =
            'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
        Random _rnd = Random();
        String getRandomString(int length) =>
            String.fromCharCodes(Iterable.generate(
                length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
        var randomKey = await getRandomString(50);
        var temp = await DateTime.now().toString();
        await prefs.setString('rKey', randomKey + temp);
        await prefs.setString('uName', username);
        final apiUrl = '${ApiUrl}/Saveid/users';
        var resp = await https.post(headers: headers, Uri.parse(apiUrl), body: {
          "imei": randomKey + temp,
          "app_date": "$installDate",
        });
        String staffName = userData['staff_name'];
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => NavigationScreen(
                      staffId: staffName,
                      userId: userKey,
                    )));
      } else {
        notification().info(context, 'Invalid OTP');
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

// new notification count

  Future notificationCount(String userId) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final apiUrl = '${ApiUrl}NotifictionCount/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$userId',
      };
      // Make POST request
      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {});
      List map = jsonDecode(res.body);

      var noti_count = map[0]['noticount'].toString();
      if (noti_count == "null") {
        noti_count = "0";
      } else if (noti_count == '0.0') {
        noti_count = "0";
      }

      var ncount = noti_count;
      return ncount;
    }
  }

// notification screen data
  Future getMyNotification(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}Notification/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request
      var resp =
          await https.post(headers: headers, Uri.parse(apiUrl), body: {});
      var data = jsonDecode(resp.body);
      if (data["status"] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;

        return [];
      } else if (data["status"] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;
        return data['notifications'];
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

// notification  read
  Future<void> notificationMarkAsRead(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}Readnotifi/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request
      var resp =
          await https.post(headers: headers, Uri.parse(apiUrl), body: {});
    } else {
      notification().warning(context, 'No Internet');
    }
  }

// dash board custom data

  Future dashboardData(String userId, BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}Pickup_dashboard/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$userId',
      };
      // Make POST request
      var resp =
          await https.post(headers: headers, Uri.parse(apiUrl), body: {});

      var map = jsonDecode(resp.body);

      if (map["status"] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return [];
      } else if (map["status"] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;
        return map['pickups'];
      }
    }
  }

// oder screen data calling

  getmyorders(String sWaybill, String userID, BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? id = await prefs.getString('userkey');
      Map<String, String> headers = {
        'userkey': '$id',
      };

      if (sWaybill == '') {
        final apiUrl = '${ApiUrl}Pendings/users';

        // Headers

        // Make POST request
        var resp =
            await https.post(headers: headers, Uri.parse(apiUrl), body: {});

        if (resp.statusCode == 500) {
          return 1;
        }
        var data = jsonDecode(resp.body);

        if (data['status'] == 403) {
          Provider.of<ProviderS>(context, listen: false).isanotherUserLog =
              true;
          return [];
        } else if (data['status'] == 200) {
          Provider.of<ProviderS>(context, listen: false).isanotherUserLog =
              false;
          return data['pendings'];
        }
      } else {
        final apiUrl = '${ApiUrl}/Singleorder/users';
        // Headers

        // Make POST request
        var resp = await https.post(
            headers: headers,
            Uri.parse(apiUrl),
            body: {'status': '5,7', 'search': sWaybill});

        var data = jsonDecode(resp.body);

        if (data['status'] == 403) {
          return [];
        } else if (data['status'] == 200) {
          return data['order'];
        }
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

// my all orders screen data
  getAllOrders(String sWaybill, String userID, BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? id = await prefs.getString('userkey');
      if (sWaybill == '') {
        final apiUrl = '${ApiUrl}/Allorders/users';
        // Headers
        Map<String, String> headers = {
          'userkey': '$id',
        };
        // Make POST request
        var resp =
            await https.post(headers: headers, Uri.parse(apiUrl), body: {});
        var data = jsonDecode(resp.body);
        if (data['status'] == 200) {
          Provider.of<ProviderS>(context, listen: false).isanotherUserLog =
              false;
          return data['users'];
        } else if (data['status'] == 403) {
          Provider.of<ProviderS>(context, listen: false).isanotherUserLog =
              true;
          return [];
        }
      } else {
        final apiUrl = '${ApiUrl}/Singleorder/users';
        // Headers
        Map<String, String> headers = {
          'userkey': '$id',
        };
        // Make POST request
        var resp = await https.post(
            headers: headers,
            Uri.parse(apiUrl),
            body: {'status': '5,7', 'search': sWaybill});
        var data = jsonDecode(resp.body);
        if (data['status'] == 200) {
          return data['order'];
        } else if (data['status'] == 403) {
          return [];
        }
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }
//user account data

  Future getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    final apiUrl = '${ApiUrl}/Profile/users';
    // Headers
    Map<String, String> headers = {
      'userkey': '$id',
    };
    // Make POST request
    var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {});
    List map = jsonDecode(res.body);

    return map;
  }

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');

    return id;
  }
// image upload  my delivery screen

  // uploadssImage(BuildContext context, XFile? image, String waybillId) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String? id = await prefs.getString('userkey');
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile ||
  //       connectivityResult == ConnectivityResult.wifi) {
  //     if (image != null) {
  //       var headers = {'userkey': id};

  //       Dio dio = Dio();
  //       // progress = 0.0;
  //       final apiUrl = '${ApiUrl}/Image/users';
  //       // String uploadURL =
  //       //     "https://api.koombiyodelivery.lk/staffapi/v2/delivery/Image/users"; // Replace with your server's upload URL

  //       FormData formData = FormData.fromMap({
  //         "image": await MultipartFile.fromFile(image.path),
  //         "user_id": id,
  //         "waybill_id": waybillId,
  //       });
  //       try {
  //         await dio.post(
  //           options: Options(
  //             method: 'POST',
  //             headers: headers,
  //           ),
  //           apiUrl,
  //           data: formData,
  //           onSendProgress: (sent, total) {
  //             Provider.of<ProviderS>(context, listen: false).progress =
  //                 sent / total;
  //           },
  //         );

  //         //Fluttertoast.showToast(msg: 'Image uploaded successfully');
  //       } catch (error) {
  //         // Fluttertoast.showToast(msg: 'Error uploading image');
  //       }
  //     }
  //   } else {
  //     notification().warning(context, 'No Internet');
  //   }
  // }
// delivery orders screen dropdown data

  Future dropdownDataMyDelivery(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Reasons/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      var resp =
          await https.post(headers: headers, Uri.parse(apiUrl), body: {});
      return jsonDecode(resp.body);
    } else {
      notification().warning(context, 'No Internet');
    }
  }

// delivery  oder data this function use 3 api for same dialog   ,and use image upload
  oderData(
      int statusType,
      String wayBillId,
      BuildContext context,
      String dropdownValue,
      String dropdownValue2,
      String cod,
      String rescheduleDate,
      String oId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print('${statusType.toString()} ddddddddddddddddddddddddddddddd');
      Map<String, String> headers = {
        'userkey': '$id',
      };
      if (statusType == 1) {
        final apiUrl = '${ApiUrl}/Delivered/users';
        // Headers

        // Make POST request
        var res = await https.post(
            headers: headers,
            Uri.parse(apiUrl),
            body: {'owner': id, 'waybill_id': wayBillId, 'status': '17'});
        print(res.statusCode);
        var data = jsonDecode(res.body);

        print(data);

        if (data['status'] == 200) {
          notification().info(context, 'Order Delivered Successfully');
        } else if (data['status'] == 400) {
          notification().info(context, 'Bad Request: Error Occurred');
        } else if (data['status'] == 403) {
          Provider.of<ProviderS>(context, listen: false).isanotherUserLog =
              true;
        } else if (data['status'] == 406) {
          notification().info(context, 'Not Acceptable: Please Upload the POD');
        }

        return data['status'];
      } else if (statusType == 2) {
        if (dropdownValue != '') {
          if (cod != '') {
            print('dbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb');
            final apiUrl = '${ApiUrl}Pdelivery/users';
            print(apiUrl);
            var responses =
                await https.post(headers: headers, Uri.parse(apiUrl), body: {
              'owner': id,
              'waybill_id': wayBillId,
              'status': '19',
              'reason': dropdownValue,
              'pcod': cod
            });
            print(responses.statusCode);
            var data = jsonDecode(responses.body);
            print(data);

            if (data['status'] == 200) {
              notification().info(context, 'Order Update Successfully');
              Navigator.pop(context);
            } else if (data['status'] == 400) {
              notification().info(context, 'Bad Request: Order Update Failed');
            } else if (data['status'] == 403) {
              Provider.of<ProviderS>(context, listen: false).isanotherUserLog =
                  true;
            } else if (data['status'] == 406) {
              notification()
                  .info(context, 'Not Acceptable: Please Upload the POD');
            }

            return data['status'];
          } else {
            notification().info(context, 'Collected COD ?');
          }
        } else {
          notification().info(context, 'Please Select a Reason');
        }
      } else if (statusType == 3) {
        if (dropdownValue2 != '') {
          final apiUrl = '${ApiUrl}/Reshedule/users';
          var responses =
              await https.post(headers: headers, Uri.parse(apiUrl), body: {
            'waybill_id': wayBillId,
            'status': '7',
            'reason': dropdownValue2.toString(),
            'rdate': rescheduleDate,
          });
          print(responses.statusCode);
          var data = jsonDecode(responses.body);
          if (data['status'] == 200) {
            notification().info(context, 'Order Delivered Successfully');
          } else if (data['status'] == 403) {
            Provider.of<ProviderS>(context, listen: false).isanotherUserLog =
                true;
          } else if (data['status'] == 400) {
            notification().info(context, 'Bad Request: Order Update Failed');
          } else if (data['status'] == 406) {
            notification()
                .info(context, 'Not Acceptable: Please Try Again on Tomorrow');
          } else if (data['status'] == 409) {
            notification()
                .info(context, 'Conflict: Please Submit the Correct Date');
          } else if (data['status'] == 410) {
            notification().info(context, 'Gone: Error Occurred ');
          }

          return data['status'];
        } else {
          notification().info(context, 'Please Select the Update Type');
        }
      } else if (statusType == 4) {
        if (dropdownValue2 != '') {
          final apiUrl = '${ApiUrl}/Allorders/remark';
          var responses =
              await https.post(headers: headers, Uri.parse(apiUrl), body: {
            "order_id": oId,
            "remarks": dropdownValue2.toString(),
            "internal": "",
            "branch_id": Provider.of<ProviderS>(context, listen: false).bId,
          });
          var data = jsonDecode(responses.body);

          print(responses.statusCode);
          if (data['status'] == 200) {
            notification().info(context, 'Remark successfully Updated');
          } else if (data['status'] == 403) {
            Provider.of<ProviderS>(context, listen: false).isanotherUserLog =
                true;
          } else if (data['status'] == 406) {
            notification().info(context, 'Not Acceptable: Please Try Again');
          }

          return data['status'];
        } else {
          notification().info(context, 'Please Select the Update Type');
        }
      } else {
        notification().info(context, 'Please Select the Reason');
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  // map screen api

  // get map pickup location list   // map Screen
// this api use for get pickup list and it show in map
  Future getmypickups(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Pickupmap/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      var resp =
          await https.post(headers: headers, Uri.parse(apiUrl), body: {});
      return jsonDecode(resp.body);
    } else {
      notification().warning(context, 'No Internet');
    }
  }

// after calling above api user to send msg  and above map marker hide
// send msg api for customer
  sendSms(String phone, String pickId, BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? id = await prefs.getString('userkey');
      final apiUrl = '${ApiUrl}/Smspickup/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      var response = await https.post(
          headers: headers,
          Uri.parse(apiUrl),
          body: {'phone': phone, 'pick_id': pickId});
      var res = jsonDecode(response.body);
      if (res['status'] == 200) {
        notification().info(context, 'SMS Sent To Client..');
      } else {}
      return response.body;
    } else {
      notification().warning(context, 'No Internet');
    }
  }

// map Screen
  // this api use  after pickup and rider accept it
  // this api use for  after accept pickup location show in map
  Future getMyPDeliveryMap(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Deliverymap/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };

      var response =
          await https.post(headers: headers, Uri.parse(apiUrl), body: {});
      return jsonDecode(response.body);
    } else {
      notification().warning(context, 'No Internet');
    }
  }
  // if rider collect delivery   and update quantity  then after hide marker from map
  // oder complete api

  pickupComplete(BuildContext context, String pickId, String qty, String phone,
      String lat, String long, String pickup_items) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? id = await prefs.getString('userkey');
      final apiUrl = '${ApiUrl}/Picked/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      var resp = await https.post(headers: headers, Uri.parse(apiUrl), body: {
        'pick_id': pickId,
        'qty': qty,
        'phone': phone,
        'lati': lat,
        'longt': long,
        'pickup_items': pickup_items
      });

      // testingddddddddddddddddddddd   ddddddddddddddddddddddddddddddddddddd
      var res = jsonDecode(resp.body);
      if (res['status'] == 200) {
        var res = await sqlDb
            .deleteData('delete from scanData where pick_id = $pickId;');
        notification().info(context, 'Pickup Collected Successfully');
      }
      // notification().info(context, newString);
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  Future pendingPickup(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    final apiUrl = '${ApiUrl}/Allpickups/users';
    // Headers
    Map<String, String> headers = {
      'userkey': '$id',
    };
    var resp = await https.post(headers: headers, Uri.parse(apiUrl), body: {});
    var data = jsonDecode(resp.body);

    if (data['status'] == 403) {
      Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
      return [];
    } else if (data['status'] == 200) {
      Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;
      return data['users'];
    }
  }

  Future pickup(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    final apiUrl = '${ApiUrl}/Allpicked/users';
    // Headers
    Map<String, String> headers = {
      'userkey': '$id',
    };
    var resp = await https.post(headers: headers, Uri.parse(apiUrl), body: {});

    var data = jsonDecode(resp.body);

    if (data['status'] == 403) {
      Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
      return [];
    } else if (data['status'] == 200) {
      Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;
      return data['users'];
    }
  }
// my deposit screen data

  Future getMyDeposit(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Deposit/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      print(id);
      // Make POST request
      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {});

      return List<Map<String, dynamic>>.from(jsonDecode(res.body));
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  //re sheduled screen

  getReScheduleData(String sWaybill, BuildContext context, String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Myrechedued/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request
      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {
        'nextdate': date,
      });
      var data = jsonDecode(res.body);
      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return [];
      } else if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;
        return data['users'];
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  // image upload my delivery screen

  immageUpload(BuildContext context, XFile? image, String waybill,
      bool isOffline) async {
    var logger = Logger();
    logger.e(image!.path.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Image/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      if (image != null) {
        Dio dio = Dio();
        // progress = 0.0;

        String uploadURL = apiUrl; // Replace with your server's upload URL

        var formData = FormData.fromMap({
          "image": await MultipartFile.fromFile(image.path),
          "user_id": id,
          "waybill_id": waybill,
        });

        try {
          var responce = await dio.post(
            options: Options(headers: headers),
            uploadURL,
            data: formData,
            onSendProgress: (sent, total) {
              Provider.of<ProviderS>(context, listen: false).progress =
                  sent / total;
            },
          );
          notification().info(
              context,
              isOffline
                  ? 'offline Image uploaded successfully'
                  : 'Image uploaded successfully');
          return responce;
        } catch (error) {
          notification().info(context, 'Error uploading image');
        }
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  // getYoutubeData() async {
  //   List _ids = [];
  //   var url = 'https://koombiyodelivery.net/hr2/appVideo';
  //   var res = await https.post(Uri.parse(url), body: {});

  //   var yId = jsonDecode(res.body);

  //   List.generate(yId.length, (index) {
  //     _ids.add(yId[index]['link']);
  //   });

  //   //   _ids;
  //   return _ids;
  // }

  getYoutubeDetails(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Appvideos/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      var url =
          // http://koombiyodelivery.net/api.koombiyodelivery.lk/staffapi/v3/delivery/
          'http://koombiyodelivery.net/api.koombiyodelivery.lk/staffapi/v3/delivery/Appvideos/users';
      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {});

      var yId = jsonDecode(res.body);
      print(yId.toString());
      //   _ids;
      if (yId["status"] == 200) {
        return yId['app_videos'];
      } else {
        return [];
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

// assign pickup

  assignPickupList(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      Map<String, String> headers = {
        'userkey': '$id',
      };
      var url = '${ApiUrl}/Userpickuprequests/users';
      var res = await https.post(headers: headers, Uri.parse(url), body: {});

      var list = jsonDecode(res.body);
      if (list['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;
        return list['users'];
      }
      if (list['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
      } else {
        return [];
      }
      //   _ids;
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  assignRiderList(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? id = await prefs.getString('userkey');

      Map<String, String> headers = {
        'userkey': '$id',
      };
      var url = '${ApiUrl}/Riderlist/users';
      var res = await https.post(headers: headers, Uri.parse(url), body: {});
      var list = jsonDecode(res.body);
      // Headers

      if (list['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

        return list['users'];
      }
      if (list['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
      } else {
        return [];
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  assignToRider(
    BuildContext context,
    String riderId,
    String vehicleNo,
    String riderPhone,
    String pickId,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Assignrider/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };

      // Make POST request
      var list = await https.post(headers: headers, Uri.parse(apiUrl), body: {
        "rider_id": riderId,
        "vehicle_no": vehicleNo,
        "rider_phone": riderPhone,
        "pick_id": pickId
      });
      // var list;
      var data = jsonDecode(list.body);
      if (data['status'] == 200) {
        notification().info(context, 'Rider assigned successfully.');
        Navigator.pop(context);
      }
      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;

        notification().warning(context, 'Something went wrong');
      }
      return list;
      //   _ids;
    } else {
      notification().warning(context, 'No Internet');
    }
  }
  // add user screen data

  addUser(
    BuildContext context,
    String name,
    String address,
    String personal_contact,
    String ofc_contact,
    String emp_emg_no,
    String emp_gender,
    String birthdate,
    String nic,
    String reg_date,
    String designation_id,
    String branch_id,
    String emp_type_id,
    String salary_type,
    String basic_salary,
    String bond_type,
    String vehicle_type,
    String vehicle_no,
    String vehicle_amount,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var urll = 'https://koombiyodelivery.net/hr2/save_temp_emp';
      var responsee = await https.post(Uri.parse(urll), body: {
        'type': 'add',
        'full_name': name,
        'address': address,
        'personal_contact': personal_contact,
        'ofc_contact': ofc_contact,
        'emp_emg_no': emp_emg_no,
        'emp_gender': emp_gender,
        'birthdate': birthdate,
        'nic': nic,
        'reg_date': reg_date,
        'div_id': '2',
        'designation_id': designation_id,
        'branch_id': branch_id,
        'emp_type_id': emp_type_id,
        'salary_type': salary_type,
        'basic_salary': basic_salary,
        'bond_type': bond_type,
        'vehicle_type': vehicle_type,
        'vehicle_no': vehicle_no,
        'vehicle_amount': vehicle_amount,
        'added_user_id': id
      });
      return responsee.body;
    } else {
      notification().warning(context, 'No Internet');
    }
  }
// add user images upload

  addUserImages(
    BuildContext context,
    String tempId,
    String bond_type,
    String idFrontIsEmpty,
    String idBackIsEmpty,
    String vBkIsEmpty,
    String vhCHIsEmpty,
    String vhLicenceIsEmpty,
    String vhFrontIsEmpty,
    String vhLeftIsEmpty,
    String vhRightIsEmpty,
    String vhBackIsEmpty,
    String id_front,
    String id_front_thumb,
    String id_back,
    String id_back_thumb,
    String vehicle_book,
    String vchassis,
    String vehicle_license,
    String vehicle_front,
    String vehicle_right,
    String vehicle_back,
    String valuation_report,
    String valReportIsEmpty,
    String chkByAM,
    String chkByAMIsEmpty,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userId');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var urll = 'https://koombiyodelivery.net/hr2/sveTempEmpImg';
      var responsee = await https.post(Uri.parse(urll), body: {
        'temp_id': tempId,
        'type': 'add',
        'bond_type': bond_type,
        'idFrontIsEmpty': idFrontIsEmpty,
        'idBackIsEmpty': idBackIsEmpty,
        'vBkIsEmpty': vBkIsEmpty,
        'vhCHIsEmpty': vhCHIsEmpty,
        'vhLicenceIsEmpty': vhLicenceIsEmpty,
        'vhFrontIsEmpty': vhFrontIsEmpty,
        'vhLeftIsEmpty': vhLeftIsEmpty,
        'vhRightIsEmpty': vhRightIsEmpty,
        'vhBackIsEmpty': vhBackIsEmpty,
        'id_front': id_front,
        'id_front_thumb': id_front_thumb,
        'id_back': id_back,
        'id_back_thumb': id_back_thumb,
        'vehicle_book': vehicle_book,
        'vchassis': vchassis,
        'vehicle_license': vehicle_license,
        'vehicle_front': vehicle_front,
        'vehicle_right': vehicle_right,
        'vehicle_back': vehicle_back,
        'valuation_report': valuation_report,
        'valReportIsEmpty': valReportIsEmpty,
        'chkByAM': chkByAM,
        'chkByAMIsEmpty': chkByAMIsEmpty
      });

      return responsee.body;
    }
  }

  nicValidate(String nic) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var urll = 'https://koombiyodelivery.net/hr2/empIDValidation';
      var responsee = await https.post(Uri.parse(urll), body: {'NIC': nic});

      return responsee.body;
    }
  }

  // dd aprovel screen

  ddApprovalScreen(BuildContext context, String bId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Pending_dd/users';
      // Headers
      Map<String, String> headers = {'userkey': '$id', 'dispatch': bId};
      // Make POST request
      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {});
      var data = jsonDecode(res.body);

      if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;
        return data['users'];
      }
      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return [];
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  ddUpdate(
    BuildContext context,
    String oderId,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}Pending_dd/confirm';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request
      var res = await https.post(
          headers: headers, Uri.parse(apiUrl), body: {"order_id": oderId});
      var data = jsonDecode(res.body);

      if (data['status'] == 200) {
        notification().info(context, 'Pending DD successfully Confirmed');
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

        return data['branches'];
      }
      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return [];
      }
      if (data['status'] == 406) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;
        notification()
            .warning(context, 'Not Applicable: Database operation faile');
        return [];
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }
// manage user data

  manageUserScreen(
      BuildContext context, String bId, String aGroup, String is_active) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Manageusers/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request
      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {
        "branch_id": bId,
        "access_group": aGroup,
        "is_active": is_active
      });
      var data = jsonDecode(res.body);

      if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

        return data['my_users'];
      }
      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return [];
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }
// Koombiyo contact nomber

  koombiyoContact(
      BuildContext context, String bId, String start, String last) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Contacts/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request
      var res = await https.post(
          headers: headers,
          Uri.parse(apiUrl),
          body: {"search": bId, "limit": last, "start": start});
      var data = jsonDecode(res.body);

      if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

        return data['contacts'];
      }
      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return [];
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }
// branch visit screen

  branchVisit(BuildContext context, String bId, String lat, String long,
      String img) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Branchvisit/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request
      var res = await https.post(
          headers: headers,
          Uri.parse(apiUrl),
          body: {"branch_id": bId, "lati": lat, "longt": long, "image": img});
      var data = jsonDecode(res.body);

      if (data['status'] == 200) {
        notification().info(context, 'Data Saved Successfully');
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

        return data['contacts'];
      }
      if (data['status'] == 400) {
        notification().warning(context, 'Invalid branch locations');
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

        return data['contacts'];
      }
      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return [];
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  branchVisitToday(
    BuildContext context,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Branchvisit/visit_today';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request
      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {});
      var data = jsonDecode(res.body);
      print(data);
      print('ddddddddddddddddddddddddddddd');
      if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

        return data['branches'];
      }
      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return [];
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }
  //branch visit data histry

  branchVisitHistroy(
    BuildContext context,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Branchvisit/history';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request
      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {});
      var data = jsonDecode(res.body);
      print(data);
      print('ddddddddddddddddddddddddddddd');
      if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

        return data['my_visits'];
      }
      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return [];
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

// branch exit data
  branchExit(
    BuildContext context,
    String bId,
    String bv_id,
    String lati,
    String longt,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Branchvisit/exit';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      print(lati);
      print(bId);
      print(bv_id);
      print(longt);
      // Make POST request
      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {
        "branch_id": bId,
        "bv_id": bv_id,
        "lati": lati,
        "longt": longt
      });
      var data = jsonDecode(res.body);
      print(data);
      if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;
        notification().info(context, 'Branch exit successfully completed');
        Navigator.pop(context);
      }
      if (data['status'] == 400) {
        notification().warning(context, 'Invalid branch location');
        Navigator.pop(context);
        return [];
      }
      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return [];
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  userActiveBranches(
    BuildContext context,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Mybranches/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request
      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {});
      var data = jsonDecode(res.body);

      if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

        return data['branches'];
      }
      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return [];
      }
      if (data['status'] == 404) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;
        notification().warning(context, 'No branches found');
        return [];
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }
  // atendance screen data

  Future attendanceStartMeter(BuildContext context, String img) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Vehicle_meter/start';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      var resp = await https.post(
          headers: headers,
          Uri.parse(apiUrl),
          body: {"start": "1234", "start_img": "$img"});

      return jsonDecode(resp.body);
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  Future attendanceEndMeter(BuildContext context, String img, String mid,
      String end, String donKm) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Vehicle_meter/end';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      var resp = await https.post(headers: headers, Uri.parse(apiUrl), body: {
        "mid": "$mid",
        "end": "$end",
        "end_img": "$img",
        "done_km": "$donKm"
      });
      return jsonDecode(resp.body);
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  attendanceVehicleMeter(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Vehicle_meter';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      var resp =
          await https.post(headers: headers, Uri.parse(apiUrl), body: {});
      print(resp.statusCode);
      if (resp.statusCode == 500) {
        return 500;
      }
      var res = jsonDecode(resp.body);
      print(res);

      if (res['status'] == 404) {
        return 1;
      }
      if (res['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return 0;
      } else if (res['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;
        List data = res['latest_meter'];

        return data;
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  //shuttle screen data

  Future shuttelBinList(BuildContext context, String root_id, String search_bin,
      String select_branch, String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Shuttle/bins';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      var resp = await https.post(headers: headers, Uri.parse(apiUrl), body: {
        "root_id": root_id,
        "search_bin": search_bin,
        "select_branch": select_branch,
        "status": status
//  in bins =3, return bins =4"
      });

      var data = jsonDecode(resp.body);
      if (data['status'] == 200) {
        return data['bins'];
      } else if (data['status'] == 403) {}
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  //gggggggggg

  Future shuttelBinLists(BuildContext context, String root_id,
      String search_bin, String select_branch, String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Shuttle/bins';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      var resp = await https.post(headers: headers, Uri.parse(apiUrl), body: {
        "root_id": root_id,
        "search_bin": search_bin,
        "select_branch": select_branch,
        "status": status
//  in bins =3, return bins =4"
      });

      var data = jsonDecode(resp.body);
      if (data['status'] == 200) {
        return data['bins'];
      } else if (data['status'] == 403) {}
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  // employee list

  Future employeList(
    BuildContext context,
    String bId,
    String start,
    String length,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = 'https://hr.koombiyodelivery.lk/appEmpList';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      var resp = await https.post(headers: headers, Uri.parse(apiUrl), body: {
        "branch_id": bId,
        "start": start,
        "length": length,

//  in bins =3, return bins =4"
      });
      var data = jsonDecode(resp.body);
      if (data['status'] == 1) {
        return data['data']['list'];
      } else if (data['status'] == 204) {
        notification().warning(context, 'No Empty Data');
        return [];
      } else {
        notification().warning(context, data['message']);
        return [];
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  // All branch list

  Future branchList(
    BuildContext context,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Branchlocation/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      var resp =
          await https.post(headers: headers, Uri.parse(apiUrl), body: {});
      print(resp);
      var data = jsonDecode(resp.body);
      if (data['status'] == 200) {
        return data['branches'];
      } else if (data['status'] == 204) {
        notification().warning(context, 'No Empty Data');
        return [];
      } else {
        notification().warning(context, data['message']);
        return [];
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  // track order above superviser data

  Future oderDetailAndTimeLine(BuildContext context, String waybill) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Timeline/users';
      // Headers
      print(
          'fqqqqqqqqqqqqqfffffffffffffffffdddddddddddddddddddddddddddddfffffffffffffffffffff');
      Map<String, String> headers = {
        'userkey': '$id',
      };
      var resp = await https.post(
          headers: headers, Uri.parse(apiUrl), body: {"waybill_id": waybill});

      var data = jsonDecode(resp.body);
      print(data);
      if (data['status'] == 200) {
        return data['data'];
      } else if (data['status'] == 204) {
        notification().warning(context, 'No Empty Data');
        return {};
      } else {
        notification().warning(context, data['message']);
        return {};
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  // acount profile image

  profileImage(BuildContext context, String img) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}Profile/update';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request
      var res = await https
          .post(headers: headers, Uri.parse(apiUrl), body: {"image": img});
      var data = jsonDecode(res.body);

      if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

        return data['contacts'];
      }
      if (data['status'] == 400) {
        notification().warning(context, 'Invalid branch locations');
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

        return data['contacts'];
      }
      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return [];
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  // deleveryExchangeitem(
  //     BuildContext context, String img, String exWaybill) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String? id = await prefs.getString('userkey');
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile ||
  //       connectivityResult == ConnectivityResult.wifi) {
  //     final apiUrl = '${ApiUrl}Updateexchange/users';
  //     // Headers
  //     Map<String, String> headers = {
  //       'userkey': '$id',
  //     };
  //     // Make POST request

  //     var res = await https.post(
  //         headers: headers,
  //         Uri.parse(apiUrl),
  //         body: {"image": img, "ex_waybill": exWaybill});
  //     var data = jsonDecode(res.body);

  //     if (data['status'] == 200) {
  //       Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

  //       return 1;
  //     }
  //     if (data['status'] == 400) {
  //       notification().warning(context, 'Invalid branch locations');
  //       Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

  //       return 0;
  //     }
  //     if (data['status'] == 403) {
  //       Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
  //       return 0;
  //     }
  //   } else {
  //     notification().warning(context, 'No Internet');
  //   }
  // }

  deliveryimageExchange(BuildContext context, XFile? image, String waybill,
      bool isOffline) async {
    var logger = Logger();
    logger.e(image!.path.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}/Updateexchange/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      if (image != null) {
        Dio dio = Dio();
        // progress = 0.0;

        String uploadURL = apiUrl; // Replace with your server's upload URL

        var formData = FormData.fromMap({
          "image": await MultipartFile.fromFile(image.path),
          "ex_waybill": '33334445',
        });

        try {
          var responce = await dio.post(
            options: Options(headers: headers),
            uploadURL,
            data: formData,
            onSendProgress: (sent, total) {
              Provider.of<ProviderS>(context, listen: false).progress =
                  sent / total;
            },
          );
          notification().info(
              context,
              isOffline
                  ? 'offline Image uploaded successfully'
                  : 'Image uploaded successfully');
          return responce;
        } catch (error) {
          notification().info(context, 'Error uploading image');
        }
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  Collectexchange(
    BuildContext context,
    String wayBill,
    String ordrId,
    String exbag_waybill,
    String prev_waybill,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}Collectexchange/users';

      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request
      print(id);
      print('99999999999999999999999999999');

      print(wayBill);
      print('99999999999999999999999999999');
      print(ordrId);
      print('9999aaaa9999999999999999999999999');
      print(exbag_waybill);
      print('99999aaaaa999999999999999999999999');
      print(prev_waybill);
      print('99999999999999999999999999999');
      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {
        "ex_waybill": wayBill,
        "oid": ordrId,
        "exbag_waybill": exbag_waybill,
        "prev_waybill": prev_waybill
      });
      print(res.statusCode);
      var data = jsonDecode(res.body);

      print(data);

      if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

        return data['status'];
      }

      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return data['status'];
      } else {
        return data['status'];
      }
      ;
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  branchDeposit(BuildContext context, String limit, String offset,
      String branch, String status, String fromDate, String toDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print(id);
      final apiUrl = '${ApiUrl}Riderdeposit/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request
      print(apiUrl);
      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {
        "limit": limit,
        "offset": offset,
        "branch": branch,
        "status": status,
        "fromDate": fromDate,
        "toDate": toDate
      });
      print(res.statusCode);
      var data = jsonDecode(res.body);

      print(data);

      if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

        return data['deposits']['branch_deposit'];
      }

      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return 0;
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  newDepositRemark(
      BuildContext context, String dpst_id, String type, String remark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print(id);
      final apiUrl = '${ApiUrl}Newdepositremark/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request
      print(apiUrl);
      var res = await https.post(
          headers: headers,
          Uri.parse(apiUrl),
          body: {"dpst_id": dpst_id, "type": type, "remark": remark});
      print(res.statusCode);
      var data = jsonDecode(res.body);

      print(data);

      if (data['status'] == 200) {
        notification().info(context, 'Remark update successfully');
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

        return 1;
      }

      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return 0;
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  depositAgentslip(BuildContext context, String dpst_id, String rider_id,
      String branh_id, String dslip_image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print(id);
      final apiUrl = '${ApiUrl}Deposit_agentslip/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request
      print(apiUrl);
      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {
        "dpst_id": dpst_id,
        "rider_id": rider_id,
        "branh_id": branh_id,
        "dslip_image": dslip_image
      });
      print(res.statusCode);
      var data = jsonDecode(res.body);

      print(data);

      if (data['status'] == 200) {
        notification().info(context, 'Slip detail successfully');
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

        return 1;
      }

      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return 0;
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  depositremarkHistry(BuildContext context, String dpst_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print(id);
      final apiUrl = '${ApiUrl}Depositremarks/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request
      print(apiUrl);
      var res = await https.post(
          headers: headers, Uri.parse(apiUrl), body: {"dpst_id": dpst_id});
      print(res.statusCode);
      var data = jsonDecode(res.body);

      print(data);

      if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

        return data['remarks'];
      }

      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return 0;
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  depositRiderList(BuildContext context, String branchId, String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}Depositriderlist/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request

      var res = await https.post(
          headers: headers,
          Uri.parse(apiUrl),
          body: {"branch_id": branchId, "date": date});

      var data = jsonDecode(res.body);

      if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

        return data['users'];
      }

      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return 0;
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  depositSlipImages(BuildContext context, String dpst_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}Depositslipimages/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request

      var res = await https.post(
          headers: headers, Uri.parse(apiUrl), body: {"dpst_id": dpst_id});
      var data = jsonDecode(res.body);
      print(data);
      if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;
        return data['deposit_images'];
      }

      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return 0;
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  pickupCansel(BuildContext context, String pick_id, String rider_remark,
      String longt, String lati, String img) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}Pickup_cancel/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request

      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {
        "pick_id": pick_id,
        "rider_remark": rider_remark,
        "longt": longt,
        "lati": lati,
        "img": img,
      });
      var data = jsonDecode(res.body);
      print(data);
      if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).pickupCansel = true;
        notification().info(context, 'Pickup cansel successfully updated.');
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

        return 1;
      }

      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

// delivery approvell screen data loading
  deliveryApprovals(BuildContext context, String rider_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}Deliveryapprovals/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request

      var res = await https.post(
          headers: headers, Uri.parse(apiUrl), body: {"rider_id": rider_id});
      var data = jsonDecode(res.body);
      print(data);
      if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;
        return data['delivery_approvals'];
      }

      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return 0;
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  deliveryApprovalsRiderList(
    BuildContext context,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}Branchriders/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request

      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {
        "branch_id": Provider.of<ProviderS>(context, listen: false).bId
      });
      var data = jsonDecode(res.body);
      print(data);
      if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;
        return data['branch_riders'];
      }

      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return 0;
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  deliveryApprovalsConfirm(BuildContext context, String wayBillId, String pod,
      String reason, int confirmType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print(wayBillId);
      print(pod);
      print(reason);
      print(confirmType);
      final apiUrl = '${ApiUrl}Deliveredconfirm/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request

      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {
        "waybill_id": wayBillId,
        "status": confirmType == 1 ? '17' : '8',
        'pres ': confirmType == 1 ? '' : reason,
        "pod": confirmType == 1 ? '' : pod,
      });
      var data = jsonDecode(res.body);
      print('vvvvvvvvvv');
      print(data);
      print('sssssssssssssssssssss');
      if (data['status'] == 200) {
        notification().info(context, 'Delivery Confirm Successfully');
        Navigator.pop(context);
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;
      }

      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  deliveryApprovalsImageList(BuildContext context, String wayBillId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}Deliveryapprovals/images';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request

      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {
        "waybill_id": wayBillId,
      });
      var data = jsonDecode(res.body);
      print(data);
      if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;
        print(data['images']);
        return data['images'];
      }

      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return 0;
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  branchRoute(BuildContext context, String branchId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}Demacation/branchroute';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request

      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {
        "branch_id": branchId,
      });
      var data = jsonDecode(res.body);
      print(data);
      if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;
        print(data['branchroute']);
        return data['branchroute'];
      }

      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return [];
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  demacationDistrict(
    BuildContext context,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}Demacation/district_sl';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request

      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {});
      var data = jsonDecode(res.body);
      print(data);
      if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

        return data['district_sl'];
      }

      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return [];
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  demacationCity(BuildContext context, String dId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}Demacation/city';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request

      var res = await https.post(
          headers: headers, Uri.parse(apiUrl), body: {"district_id": dId});
      var data = jsonDecode(res.body);
      print(data);
      if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

        return data['city'];
      }

      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return [];
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  demacation(BuildContext context, String districtId, String cityName,
      String branchId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}Demacation/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request
      print(districtId + cityName);
      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {
        "district_id": districtId,
        "city_name": cityName,
        "branch_id": branchId
      });
      var data = jsonDecode(res.body);
      print(data);
      if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;

        return data['demacation'];
      }

      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return [];
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  shutteleVisitBrnchesList(BuildContext context, String branchId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}Shuttlevisit/my_route';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request
      print('dddddddddddd');
      print(branchId);
      print('dddddddddddd');
      var res = await https.post(
          headers: headers, Uri.parse(apiUrl), body: {"branch_id": branchId});
      var data = jsonDecode(res.body);
      print(
          'xxxdddddddddddddddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
      print(data);
      print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');

      if (data['status'] == 200) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;
        if (data['route_name'] == "null") {
          return [];
        } else {
          return data;
        }
      }

      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        return '';
      }
      if (data['status'] == 400) {
        print('xxxxxxxxxxxxxxxxxxxx');
        return '';
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  shuttleVisitConfirm(
      BuildContext context, String branchId, String lat, String long) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}Shuttlevisit/users';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request
      print(branchId);
      print(lat);
      print(long);
      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {
        "branch_id": branchId,
        "lati": lat,
        "longt": long,
      });
      var data = jsonDecode(res.body);
      print(
          'xxxxxxxxxxxxxxxxxxxxxxxxxxxxssssssssssssssssxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
      print(data);

      if (data['status'] == 200) {
        print(
            'xxxxxxxxxxxxxxxxqqqqqqqqqqqqqqqqqqqxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;
        notification().info(context, 'Branch Visit Successfully Updated');
        return 1;
      }

      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        notification().warning(context, 'Somthing went wrong');
        return 0;
      }
      if (data['status'] == 400) {
        notification().warning(context, data['message']);
        return 0;
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }

  shuttleExit(BuildContext context, String branchId, String shvId, String lat,
      String long) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = await prefs.getString('userkey');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final apiUrl = '${ApiUrl}Shuttlevisit/exit';
      // Headers
      Map<String, String> headers = {
        'userkey': '$id',
      };
      // Make POST request
      print(branchId);
      print(lat);
      print(long);
      var res = await https.post(headers: headers, Uri.parse(apiUrl), body: {
        "branch_id": branchId,
        "shv_id": shvId,
        "lati": lat,
        "longt": long,
      });
      var data = jsonDecode(res.body);
      print(
          'xxxxxxxxxxxxxxxxxxxxxxxxxxxxssssssssssssssssxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
      print(data['status']);

      if (data['status'] == 200) {
        print(
            'xxxxxxxxxxxxxxxxqqqqqqqqqqqqqqqqqqqxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = false;
        notification().info(context, data['message']);
        return 1;
      }

      if (data['status'] == 403) {
        Provider.of<ProviderS>(context, listen: false).isanotherUserLog = true;
        notification().warning(context, 'Somthing went wrong');
        return 0;
      }
      if (data['status'] == 400) {
        print('dddddddddddddddddddccccccccccccccccd');
        notification().warning(context, data['message']);
        return 0;
      }
    } else {
      notification().warning(context, 'No Internet');
    }
  }
}
