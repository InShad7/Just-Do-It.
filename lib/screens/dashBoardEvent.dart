import 'package:flutter/material.dart';
import 'package:just_do_it/screens/homeScreen.dart';
import 'package:just_do_it/screens/search.dart';

import 'package:just_do_it/utilities/colors.dart';
import 'package:just_do_it/widgets/completedEvents.dart';
import 'package:just_do_it/widgets/completedTask.dart';
import 'package:just_do_it/widgets/eventList.dart';
import 'package:just_do_it/widgets/pendingEvents.dart';
import 'package:just_do_it/widgets/pendingTasks.dart';
import 'package:just_do_it/widgets/sizedbox.dart';
import 'package:just_do_it/widgets/taskList.dart';

class DashBoardEvent extends StatefulWidget {
  DashBoardEvent({Key? key}) : super(key: key);

  @override
  State<DashBoardEvent> createState() => _DashBoardEventState();
}

class _DashBoardEventState extends State<DashBoardEvent> {
  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'Pending'),
    const Tab(text: 'Completed'),
  ];

  TabBarView TabBarList() {
    return TabBarView(children: [
      Column(
        children: [
          const szdbx(ht: 50),
          // yourTask('Your Tasks'),
          const szdbx(ht: 10),
          Expanded(child: PendingEvent(taskEventKey: 1)),
        ],
      ),
      Column(children: [
        const szdbx(ht: 50),
        // yourTask('Your Events'),
        Expanded(child: CompletedEvent(taskEventKey: 1)),
      ]),
    ]);
  }

  AppBar myAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      bottom: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        tabs: myTabs,
      ),
      title: Text(
        '    Events.',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Black(),
      actions: [
        InkWell(
          onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen()),
              ModalRoute.withName('/')),
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0, right: 15.0),
            child: Text(
              'Home',
              style: TextStyle(color: Grey(), fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            backgroundColor: Black(),
            appBar: myAppBar(context),
            body: Column(children: [Expanded(child: TabBarList())])));
  }
}
