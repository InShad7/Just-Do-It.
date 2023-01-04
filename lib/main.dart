import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';


import 'package:just_do_it/model/data_model.dart';


import 'package:just_do_it/screens/splashScren.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_do_it/widgets/notification.dart';

Event? notifyDataEvnt;

Task? notifyData;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(TaskAdapter().typeId)) {
    Hive.registerAdapter(TaskAdapter());
  }
  if (!Hive.isAdapterRegistered(EventAdapter().typeId)) {
    Hive.registerAdapter(EventAdapter());
  }

  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'key',
          channelName: "myNotification",
          channelDescription: "this is message",
          playSound: true,
          channelShowBadge: true,
        )
      ],
      debug: true);

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    checkTimeForNotification();
    checkTimeNotificationEvent();

    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(colorSchemeSeed: Colors.black, fontFamily: 'Ubuntu'),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
