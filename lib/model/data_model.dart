// import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
part 'data_model.g.dart';

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  //  DateTime id;
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final bool priority;

  @HiveField(5)
  final bool isCompleted;

  Task(
      // this.id,
      // this.image,
      {
     required this.isCompleted,
    required this.title,
    required this.content,
    required this.date,
    required this.priority,
    required this.id,
  });
}

@HiveType(typeId: 2)
class Event {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String image;

  @HiveField(5)
  final bool priority;

  @HiveField(6)
  final bool isCompleted;

  Event({
    required this.title,
    required this.content,
    required this.date,
    required this.image,
    required this.priority,
    required this.id,
    required this.isCompleted,
  });
}
