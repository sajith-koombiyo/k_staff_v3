import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<void> handleBckgroundMessage(RemoteMessage message) async {
  print("title: ${message.notification?.title}");
  print("body: ${message.notification?.body}");
  print("payload: ${message.notification?.android?.imageUrl}");
}

Future<void> img() async {}

class notify {
  final firebaseMessaging = FirebaseMessaging.instance;

  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    // description
    description: "this chanl used",
    importance: Importance.max,
    showBadge: true,
  );

  final localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Future initLocalNotificatons() async {
    const android = AndroidInitializationSettings('appicon');
    const settings = InitializationSettings(android: android);
    await localNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        print(details);
        final message = RemoteMessage.fromMap(jsonDecode(details.toString()));

        handleBckgroundMessage(message);
      },
    );
    final platform =
        localNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(channel);
  }

  Future<void> initNotifications() async {
    print('sssssssssssssssssssssssssssssssssssssssssssssssss');
    await firebaseMessaging.requestPermission();
    print('sssssssssssssssssssssssssssssssssssssssssssssssss');
    final fCMTocken = await firebaseMessaging.getToken();
    print(fCMTocken);
    initLocalNotificatons();
    FirebaseMessaging.onBackgroundMessage(handleBckgroundMessage);

    FirebaseMessaging.onMessage.listen((message) async {
      final notification = message.notification;
      print(message.data);
      print(channel);
      print('fffffffffffffffffffffffffffffffffffffffffffff');
      print(message.notification?.android?.imageUrl);

      var url = message.notification?.android?.imageUrl;
      String imgurl = await url.toString();
      // https://via.placeholder.com/150/FF0000/FFFFFF?Text=yttags.com
      final bigimg = await Utils.downloadFile(imgurl, "icon1");
      final styleimg = BigPictureStyleInformation(
        FilePathAndroidBitmap(bigimg),
        largeIcon: FilePathAndroidBitmap(bigimg),
      );
      if (notification != null) {
        localNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
              channel.id, channel.name,
              channelDescription: channel.description,
              icon: "appicon",
              playSound: true,
              styleInformation: styleimg,

              // other properties...
            )),
            payload: jsonEncode(message.notification?.android?.imageUrl));
      }
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

    print(filepath);
    return filepath;
  }
}
