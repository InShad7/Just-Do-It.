import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:just_do_it/function/db_event_function.dart';
import 'package:just_do_it/function/db_function.dart';
import 'package:just_do_it/model/data_model.dart';
import 'package:just_do_it/screens/EventView.dart';
import 'package:just_do_it/screens/taskView.dart';
import 'package:just_do_it/utilities/Colors.dart';
import 'package:just_do_it/utilities/globalFunctions.dart';
import 'package:just_do_it/widgets/TaskList.dart';
import 'package:just_do_it/widgets/sizedbox.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  List<Task> taskList = Hive.box<Task>('task_db').values.toList();

  late List<Task> taskDisplay = List<Task>.from(taskList);

  List<Event> eventList = Hive.box<Event>('event_db').values.toList();

  late List<Event> eventDisplay = List<Event>.from(eventList);

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime today = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  var taskEventKey = 0;
  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  Container Calendar() {
    return Container(
      width: 500,
      height: 400,
      color: Black(),
      child: TableCalendar(
        // eventLoader: (
        //   day,
        // ) =>
        //     getTodos(day),
        focusedDay: today,
        firstDay: DateTime.utc(2010, 10, 20),
        lastDay: DateTime.utc(2040, 10, 20),
        calendarFormat: _calendarFormat,
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonShowsNext: true,
          formatButtonTextStyle: TextStyle(color: Grey()),
          titleTextStyle: TextStyle(color: Grey(), fontSize: 20),
        ),
        availableGestures: AvailableGestures.all,
        calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: OrangeColor(),
              shape: BoxShape.circle,
            ),
            canMarkersOverflow: true,
            defaultTextStyle: TextStyle(color: Grey(), fontSize: 15),
            todayDecoration: BoxDecoration(
              color: Color.fromARGB(154, 206, 110, 0),
              shape: BoxShape.circle,
            )),
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      ),
    );
  }

  Widget expandedTask() {
    return ValueListenableBuilder(
      valueListenable: taskNotifier,
      builder: (BuildContext context, List<Task> taskList, Widget? child) {
        return ListView.builder(
            itemCount: taskList.length,
            itemBuilder: (context, index) {
              return DateTime.parse(taskList[index].date.toString()).day ==
                          _selectedDay?.day &&
                      DateTime.parse(taskList[index].date.toString()).month ==
                          _selectedDay?.month &&
                      DateTime.parse(taskList[index].date.toString()).year ==
                          _selectedDay?.year
                  ? (Padding(
                      padding: const EdgeInsets.only(
                          right: 13.0, left: 13.0, bottom: 10.0),
                      child: Container(
                        decoration: MyBoxDecoration(),
                        child: Slidable(
                          startActionPane: ActionPane(
                            motion: BehindMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  // markDoneT(data, context);
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
                                  deleteTask(taskList[index].id);
                                  deleteToast();
                                },
                                // },
                                backgroundColor:
                                    Color.fromARGB(255, 213, 78, 68),
                                icon: Icons.close_rounded,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.only(
                              left: 20,
                              top: 15,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Text(
                                taskList[index].title,
                                style: TextStyle(
                                    color: White(),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            trailing: PriorityAndDate(
                                taskList[index].priority, taskList[index].date),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (ctx) => taskView(
                                      passValue: taskList[index],
                                      passId: index,
                                      passDate: taskList[index].date,
                                      taskEventKey: taskEventKey,
                                      priority: taskList[index].priority)),
                            ),
                          ),
                        ),
                      ),
                    ))
                  : const Center(
                      child: Text(
                        '  ',
                      ),
                    );
            });
      },
    );
  }

  Widget expandedEvent() {
    return ValueListenableBuilder(
      valueListenable: eventNotifier,
      builder: (BuildContext context, dynamic value, Widget? child) {
        return ListView.builder(
            itemCount: eventList.length,
            itemBuilder: (context, index) {
              return DateTime.parse(eventList[index].date.toString()).day ==
                          _selectedDay?.day &&
                      DateTime.parse(eventList[index].date.toString()).month ==
                          _selectedDay?.month &&
                      DateTime.parse(eventList[index].date.toString()).year ==
                          _selectedDay?.year
                  ? (Padding(
                      padding: const EdgeInsets.only(
                          right: 13.0, left: 13.0, bottom: 10.0),
                      child: Container(
                        decoration: MyBoxDecoration(),
                        child: Slidable(
                          startActionPane: ActionPane(
                            motion: BehindMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  // markDoneT(data, context);
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
                                  deleteTask(eventList[index].id);
                                  deleteToast();
                                },
                                // },
                                backgroundColor:
                                    Color.fromARGB(255, 213, 78, 68),
                                icon: Icons.close_rounded,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.only(
                              left: 20,
                              top: 15,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Text(
                                eventList[index].title,
                                style: TextStyle(
                                    color: White(),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            trailing: PriorityAndDate(eventList[index].priority,
                                eventList[index].date),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (ctx) => eventView(
                                      passValue: eventList[index],
                                      passId: index,
                                      passDate: eventList[index].date,
                                      taskEventKey: taskEventKey,
                                      priority: eventList[index].priority)),
                            ),
                          ),
                        ),
                      ),
                    ))
                  : const Center(
                      child: Text(
                        '  ',
                      ),
                    );
            });
      },
    );
  }

  BoxDecoration MyBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: ThemeGrey(),
    );
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

  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'Task'),
    const Tab(text: 'Event'),
  ];

  AppBar myAppBar() {
    return AppBar(
      backgroundColor: Black(),
    );
  }

  Widget PreferredSize() {
    return Container(
        color: Black(),
        height: 30.0,
        child: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: White(),
            tabs: myTabs));
  }

  TabBarView TabBarList() {
    return TabBarView(children: [
      Column(
        children: [
          const szdbx(ht: 20),
          Expanded(child: expandedTask()),
        ],
      ),
      Column(children: [
        const szdbx(ht: 20),
        Expanded(child: expandedEvent()),
      ]),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: myAppBar(),
        backgroundColor: Black(),
        body: Column(
          children: [
            Calendar(),
            PreferredSize(),
            Expanded(child: TabBarList())
            // expandedTask(),
            // expandedEvent()
          ],
        ),
      ),
    );
  }
}
