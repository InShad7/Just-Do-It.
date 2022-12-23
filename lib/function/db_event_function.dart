import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_do_it/model/data_model.dart';

ValueNotifier<List<Event>> eventNotifier = ValueNotifier([]);

Future<void> addEvents(Event value) async {
  final eventDB = await Hive.openBox<Event>('Event_db');
  final _id = await eventDB.add(value);
  // value.id = _id;

  eventNotifier.value.add(value);
  eventNotifier.notifyListeners();
}

Future<void> getEvent() async {
  final eventDB = await Hive.openBox<Event>('Event_db');
  eventNotifier.value.clear();

  eventNotifier.value.addAll(eventDB.values);
  eventNotifier.notifyListeners();
}

Future<void> deleteEvents(String index) async {
  final box = Hive.box<Event>("Event_db");

  final Map<dynamic, Event> eventListMap = box.toMap();
  dynamic desiredKey;
  eventListMap.forEach((key, value) {
    if (value.id == index) {
      desiredKey = key;
    }
  });
  await box.delete(desiredKey);
  getEvent();
}

editEvents(index, context, Event value) async {
  final eventDB = await Hive.openBox<Event>('Event_db');
  final Map<dynamic, Event> eventMap = eventDB.toMap();
  dynamic desiredKey;
  eventMap.forEach((key, value) {
    if (value.id == index) {
      desiredKey = key;
    }
  });
  eventDB.put(desiredKey, value);
  getEvent();
}
