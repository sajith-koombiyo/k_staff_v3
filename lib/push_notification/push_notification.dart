import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';

Future<void> handleBckgroundMessage(RemoteMessage message) async {
  print(message);
  log('ddddddddddddddddddddddddddddddddddddddddddddd');
}

Future<void> img() async {}

class notify {
  final fire = FirebaseMessaging.instance.requestPermission();

  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission(
        alert: true, badge: true, provisional: false, sound: true);

    final fCMTocken = await firebaseMessaging.getToken();

    log(fCMTocken.toString());

    // Provider.of<ProviderS>(context, listen: false).fcmKey =
    //     fCMTocken.toString();
    // initLocalNotificatons();
    FirebaseMessaging.onBackgroundMessage(handleBckgroundMessage);

    FirebaseMessaging.onMessage.listen((message) async {
      final notification = message.notification;

      print(notification);

      var url = message.notification?.android?.imageUrl;
      // String imgurl = await url.toString();
      // https://via.placeholder.com/150/FF0000/FFFFFF?Text=yttags.com
      // final bigimg = await Utils.downloadFile(imgurl, "icon1");
      // final styleimg = BigPictureStyleInformation(
      //   FilePathAndroidBitmap(bigimg),
      //   largeIcon: FilePathAndroidBitmap(bigimg),
      // );
      log(notification.toString());
      if (notification != null) {
        log('my notiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii');
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                notificationLayout: NotificationLayout.BigPicture,
                //actionType : ActionType.DismissAction,
                color: Colors.black,
                backgroundColor: Colors.black,
                bigPicture: notification.android!.imageUrl,
                id: notification.hashCode,
                channelKey: 'call_channel',
                title: notification.title,
                body: notification.body));

        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          // This will be called when the app is opened from a notification click
          print(
              'dddddddddddddddddzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzddddddddddd');
        });

        // localNotificationsPlugin.show(
        //     notification.hashCode,
        //     notification.title,
        //     notification.body,
        //     NotificationDetails(
        //         android: AndroidNotificationDetails(
        //       channel.id, channel.name,
        //       channelDescription: channel.description,
        //       icon: "appicon",
        //       playSound: true,
        //       // styleInformation: styleimg,

        //       // other properties...
        //     )),
        //     payload: jsonEncode(message.notification?.android?.imageUrl));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // This will be called when the app is opened from a notification click
      log('vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');
    });

    listenActionStream() {
      AwesomeNotifications()
          .getAllActiveNotificationIdsOnStatusBar()
          .then((value) {
        log(value.toString());
      });
    }
  }

  listenActionStream() {
    AwesomeNotifications()
        .getAllActiveNotificationIdsOnStatusBar()
        .then((value) {
      // This will be called when the app is opened from a notification click
      log('vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');

      log(value.toString());
    });
  }
}

class Utils {
  static Future<String> downloadFile(String url, String filename) async {
    final directory = await getApplicationSupportDirectory();

    final filepath = "${directory.path}/$filename";

    final responce = await http.get(Uri.parse(url));

    final file = File(filepath);
    await file.writeAsBytes(responce.bodyBytes);

    return filepath;
  }
}
