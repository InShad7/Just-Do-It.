import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:just_do_it/function/db_function.dart';
import 'package:just_do_it/model/data_model.dart';
// import 'package:just_do_it/screens/Homescreen.dart';

import 'package:just_do_it/screens/taskView.dart';
import 'package:just_do_it/utilities/Colors.dart';
import 'package:just_do_it/utilities/globalFunctions.dart';
// import 'package:just_do_it/widgets/delete.dart';
import 'package:just_do_it/widgets/sizedbox.dart';
import 'package:intl/intl.dart';
import 'package:just_do_it/widgets/taskList.dart';

class PendingTask extends StatelessWidget {
  PendingTask({Key? key, required this.taskEventKey}) : super(key: key);

  // List<Task> taskList = Hive.box<Task>('task_db').values.toList();

  // late List<Task> taskDisplay = List<Task>.from(taskList);

  var taskEventKey = 0;

  prior(mypriorityval) {
    if (mypriorityval == true) {
      return Container(
        child: const Icon(
          Icons.circle,
          color: Colors.red,
          size: 12,
        ),
      );
    } else {
      return Container(
        child: const Icon(
          Icons.circle,
          color: Colors.amber,
          size: 12,
        ),
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
          Text(DateFormat("dd MMM yyyy hh:mm a").format(mydate),
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
            backgroundColor: Color.fromARGB(255, 120, 181, 122),
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

  @override
  Widget build(BuildContext context) {

    return 
    ValueListenableBuilder(
      valueListenable: taskNotifier,
      builder: (BuildContext context, List<Task> TaskList, Widget? child) {
       
        return Padding(
            padding:
                const EdgeInsets.only(right: 13.0, left: 13.0, bottom: 8.0),
            child: ListView.builder(
                // shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                // itemCount: TaskList.length,
                itemCount: TaskList.where(((element) =>
                    element.date.isBefore(DateTime.now()) &&
                    element.isCompleted == false)).length,
                itemBuilder: (context, index) {
                  // List<Task> sortedList = [];
                  // TaskList.sort((Task a, Task b) => b.date.compareTo(a.date));

                  final data = TaskList.where(((element) =>
                      element.date.isBefore(DateTime.now()) &&
                      element.isCompleted == false)).toList()[index];
                  final mydate = data.date;
                  final myPriority = data.priority;

                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      decoration: MyBoxDecoration(),
                      child: MyListTileView(
                          index, data, myPriority, mydate, context),
                    ),
                  );
                }));
      },
    );
  }
}

