import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:just_do_it/function/db_event_function.dart';

import 'package:just_do_it/model/data_model.dart';

import 'package:just_do_it/screens/EventView.dart';
import 'package:just_do_it/screens/addEvent.dart';
import 'package:just_do_it/utilities/globalFunctions.dart';
import 'package:just_do_it/widgets/sizedbox.dart';
import 'package:intl/intl.dart';
import 'package:just_do_it/widgets/taskList.dart';

class CompletedEvent extends StatelessWidget {
  CompletedEvent({
    Key? key,
    required this.taskEventKey,
  }) : super(key: key);

  var taskEventKey = 1;

  prior(mypriorityval) {
    if (mypriorityval == true) {
      return Container(
        child: Icon(
          Icons.circle,
          color: Colors.red,
          size: 12,
        ),
      );
    } else {
      return Container(
        child: Icon(
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
          szdbx(ht: 10),
          Text(DateFormat("dd MMM yyyy hh:mm a").format(mydate),
              // mydate.substring(0, mydate.length - 7),
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  ListTile MyListTile(Event data, bool myPriority, DateTime mydate,
      BuildContext context, int index) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 20, top: 10),
      title: Text(
        data.title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: PriorityAndDate(myPriority, mydate),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: ((context) => eventView(
                passValue: data,
                passId: index,
                passDate: mydate,
                taskEventKey: taskEventKey,
                priority: myPriority,
              )))),
    );
  }

  Slidable MyListTilView(int index, Event data, bool myPriority,
      DateTime mydate, BuildContext context) {
    return Slidable(
      // startActionPane: ActionPane(
      //   motion: BehindMotion(),
      //   children: [
      //     SlidableAction(
      //       onPressed: (context) {
      //         doneToast();
      //       },
      //       backgroundColor: Color.fromARGB(255, 120, 181, 122),
      //       icon: Icons.check_rounded,
      //       label: 'Done',
      //     ),
      //   ],
      // ),
      endActionPane: ActionPane(
        motion: BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              // if (taskEventKey == 1) {
              deleteEvents(data.id);
              deleteToast();
              // }
            },
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
      color: const Color.fromARGB(156, 69, 69, 69),
    );
  }

  @override
  Widget build(BuildContext context) {
    getEvent();
    return ValueListenableBuilder(
      valueListenable: eventNotifier,
      builder: (BuildContext context, List<Event> EventList, Widget? child) {
        return Padding(
            padding: const EdgeInsets.all(13.0),
            child: ListView.builder(
                // shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                // itemCount: EventList.length,
                itemCount:
                    EventList.where(((element) => element.isCompleted == true))
                        .length,
                itemBuilder: (context, index) {
                  final data =
                      //  completed[index];
                      EventList.where(
                              ((element) => element.isCompleted == true))
                          .toList()[index];
                  final mydate = data.date;
                  final myPriority = data.priority;

                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      height: 80,
                      decoration: MyBoxDecoration(),
                      child: MyListTilView(
                          index, data, myPriority, mydate, context),
                    ),
                  );
                }));
      },
    );
  }
}
