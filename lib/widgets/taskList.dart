import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:just_do_it/function/db_function.dart';
import 'package:just_do_it/main.dart';
import 'package:just_do_it/model/data_model.dart';
// import 'package:just_do_it/screens/Homescreen.dart';

import 'package:just_do_it/screens/taskView.dart';
import 'package:just_do_it/utilities/Colors.dart';
import 'package:just_do_it/utilities/globalFunctions.dart';
import 'package:just_do_it/widgets/notification.dart';
// import 'package:just_do_it/widgets/notification.dart';
import 'package:just_do_it/widgets/pendingTasks.dart';
// import 'package:just_do_it/widgets/delete.dart';
import 'package:just_do_it/widgets/sizedbox.dart';
import 'package:intl/intl.dart';

DateTime notifyTime = DateTime(2020, 2, 1);
List<Task> upcomingTasks = [];

class TaskList extends StatelessWidget {
  TaskList({
    Key? key,
    required this.taskEventKey,
  }) : super(key: key);

  var taskEventKey = 0;

  prior(mypriorityval) {
    if (mypriorityval == true) {
      return const Icon(
        Icons.circle,
        color: Colors.red,
        size: 12,
      );
    } else {
      return const Icon(
        Icons.circle,
        color: Colors.amber,
        size: 12,
      );
    }
  }

  Padding PriorityAndDate(bool myPriority, DateTime mydate) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          prior(myPriority),
          const szdbx(ht: 10),
          Text(DateFormat(" hh:mm a").format(mydate),
              // mydate.substring(0, mydate.length - 7),
              style: TextStyle(color: Grey())),
        ],
      ),
    );
  }

  ListTile MyListTile(Task data, bool myPriority, DateTime mydate,
      BuildContext context, int index) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
      title: Text(
        data.title,
        style: TextStyle(color: White(), fontWeight: FontWeight.bold),
      ),
      subtitle: PriorityAndDate(myPriority, mydate),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: ((context) => taskView(
              passValue: data,
              passId: index,
              passDate: mydate,
              taskEventKey: taskEventKey,
              priority: myPriority)))),
    );
  }

  Slidable MyListTileView(int index, Task data, bool myPriority,
      DateTime mydate, BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              markDoneT(data, context);
              doneToast();
            },
            backgroundColor: greenC(),
            icon: Icons.check_rounded,
            label: 'Done',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              // if (taskEventKey == 0) {
              deleteTask(data.id);
              deleteToast();
            },
            // },
            backgroundColor: Color.fromARGB(255, 213, 78, 68),
            icon: Icons.close_rounded,
            label: 'Delete',
          ),
        ],
      ),
      child: MyListTile(data, myPriority, mydate, context, index),
    );
  }

  BoxDecoration MyBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: ThemeGrey(),
    );
  }

  ValueListenableBuilder<List<Task>> MyListVIewBuilder() {
    return ValueListenableBuilder(
      valueListenable: taskNotifier,
      builder: (BuildContext context, List<Task> taskList, Widget? child) {
        final data = taskList.where((Task) {
          return DateTime.parse(Task.date.toString()).day ==
                  DateTime.now().day &&
              DateTime.parse(Task.date.toString()).month ==
                  DateTime.now().month &&
              DateTime.parse(Task.date.toString()).year ==
                  DateTime.now().year &&
              Task.isCompleted == false;
        }).toList();
        return data.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(13.0),
                child: ListView.builder(
                    // shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics(),
                    // itemCount: EventList.length,
                    itemCount: taskList.where((Task) {
                      return DateTime.parse(Task.date.toString()).day ==
                              DateTime.now().day &&
                          DateTime.parse(Task.date.toString()).month ==
                              DateTime.now().month &&
                          DateTime.parse(Task.date.toString()).year ==
                              DateTime.now().year &&
                          Task.isCompleted == false;
                    }).length,
                    itemBuilder: (context, index) {
                      // final data = taskList.where((Task) {
                      //   return DateTime.parse(Task.date.toString()).day ==
                      //           DateTime.now().day &&
                      //       DateTime.parse(Task.date.toString()).month ==
                      //           DateTime.now().month &&
                      //       DateTime.parse(Task.date.toString()).year ==
                      //           DateTime.now().year &&
                      //       Task.isCompleted == false;
                      // }).toList()[index];
                      // print(data.title);
                      taskList.sort((a, b) => a.date.compareTo(b.date));
                      upcomingTasks = taskList
                          .where(
                              (element) => element.date.isAfter(DateTime.now()))
                          .toList();

                      // if (upcomingTasks != null) {
                      for (int i = 0; i < upcomingTasks.length; i++) {
                        notifyTime = upcomingTasks[i].date;
                        notifyData = upcomingTasks[i];
                      }

                      // } else {
                      //   checkTimeForNotification().exit();
                      // }

                      // print('this is task time ${notifyData!.date}');

                      final mydate = data[index].date;
                      final myPriority = data[index].priority;

                      return Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          height: 80,
                          decoration: MyBoxDecoration(),
                          child: MyListTileView(
                              index, data[index], myPriority, mydate, context),
                        ),
                      );
                    }))
            : const Center(
                child: Text(
                  'No Tasks Today',
                  style: TextStyle(color: Colors.grey),
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getTask();
    // checkTimeForNotification();
    return MyListVIewBuilder();
  }
}
