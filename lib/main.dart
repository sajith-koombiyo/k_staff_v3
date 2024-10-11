import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/push_notification/push_notification.dart';
import 'package:flutter_application_2/uI/main/navigation/navigation.dart';
import 'package:flutter_application_2/uI/splash/splash.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';
import 'provider/provider.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await notify().initNotifications();
  FirebaseMessaging.instance.subscribeToTopic('allDevices');
  FirebaseMessaging.instance.requestPermission(alert: true,sound:  true,badge: true);
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelShowBadge: true,
        channelKey: 'call_channel',
        defaultColor: Colors.blue,
        channelName: "Basic Notifications",
        importance: NotificationImportance.High,
        channelDescription: "Description",
      ),
    ],
  );

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event!.notification!.body!.toString());
  });
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ProviderS()),
      ChangeNotifierProvider(create: (_) => ProviderDropDown()),
    ],
    child: MyApp(navigatorKey: navigatorKey),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.navigatorKey});
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return FlutterSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        onGenerateRoute: (settings) {
          
        },
        navigatorKey: widget.navigatorKey,
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        title: 'Koombiyo Staff',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Splash(),
      );
    });
  }
}
