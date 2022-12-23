// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationApi {
//   static final _notifications = FlutterLocalNotificationsPlugin();

//   static Future _notificationDetails() async {
//     return NotificationDetails(
//       android: AndroidNotificationDetails('channel id', 'channel name',
//           importance: Importance.max),
//     );
//   }

//   static Future showNotification({
//     int id = 0,
//     String? title,
//     String? body,
//   }) async =>
//       _notifications.show(id, title, body, await _notificationDetails());
// }

import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:intl/intl.dart';
import 'package:just_do_it/function/db_event_function.dart';
import 'package:just_do_it/function/db_function.dart';
import 'package:just_do_it/main.dart';
import 'package:just_do_it/model/data_model.dart';
// import 'package:just_do_it/widgets/eventList.dart';
import 'package:just_do_it/widgets/taskList.dart';

void Notify(Task data) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          //  DateTime.now().millisecond,
          channelKey: 'key',
          title: data.title,
          body: DateFormat("hh:mm a").format(DateTime.now()),
          displayOnBackground: true,
          displayOnForeground: true));
}

checkTimeForNotification() {
  Timer.periodic(Duration(seconds: 5), (timer) {
    DateTime timeNow = DateTime.now();

    // print('task');
    // print(DateTime(timeNow.year, timeNow.month, timeNow.day, timeNow.hour,
    //     timeNow.minute));

    // print(DateTime(notifyTime.year, notifyTime.month, notifyTime.day,
    //     notifyTime.hour, notifyTime.minute));

    if (DateTime(timeNow.year, timeNow.month, timeNow.day, timeNow.hour,
            timeNow.minute) ==
        DateTime(notifyTime.year, notifyTime.month, notifyTime.day,
            notifyTime.hour, notifyTime.minute)) {
      Notify(notifyData!);
      getTask();
    }
  });
}

void NotifyEvent(Event eventdata) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
    id: 1,
    // DateTime.now().millisecond,
    channelKey: 'key',
    title: eventdata.title,
    body: DateFormat("hh:mm a").format(DateTime.now()),
    displayOnBackground: true,
    displayOnForeground: true,
  ));
}

checkTimeNotificationEvent() {
  Timer.periodic(Duration(seconds: 5), (timer) {
    DateTime timeNow = DateTime.now();

    // print("event");
    // print(DateTime(timeNow.year, timeNow.month, timeNow.day, timeNow.hour,
    //     timeNow.minute));

    // print(DateTime(notifyTime.year, notifyTime.month, notifyTime.day,
    //     notifyTime.hour, notifyTime.minute));

    if (DateTime(notifyTime.year, notifyTime.month, notifyTime.day,
            notifyTime.hour, notifyTime.minute) ==
        (DateTime(timeNow.year, timeNow.month, timeNow.day, timeNow.hour,
            timeNow.minute))) {
      //   print("click");
      NotifyEvent(notifyDataEvnt!);
      getEvent();
    }
  });
}
