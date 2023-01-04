import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';

import 'package:just_do_it/function/db_event_function.dart';
import 'package:just_do_it/model/data_model.dart';
import 'package:just_do_it/screens/EventView.dart';
import 'package:just_do_it/screens/addEvent.dart';
import 'package:just_do_it/screens/addTask.dart';
import 'package:just_do_it/screens/taskView.dart';
import 'package:just_do_it/utilities/Colors.dart';
import 'package:intl/intl.dart';
import 'package:just_do_it/utilities/globalFunctions.dart';
import 'package:just_do_it/widgets/pendingEvents.dart';
import 'package:just_do_it/widgets/pendingTasks.dart';

import '../function/db_function.dart';
import '../widgets/sizedbox.dart';
import '../widgets/taskList.dart';

class search extends StatefulWidget {
  search({
    Key? key,
    // required this.passValue,
  }) : super(key: key);
  // Task passValue;
  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  DateTimeRange? newDateTime;

  late DateTime dateTime = DateTime.now();
  var taskEventKey = 0;

  final _searchController = TextEditingController();

  List<Task> taskList = Hive.box<Task>('task_db').values.toList();

  late List<Task> taskDisplay = List<Task>.from(taskList);

  List<Event> eventList = Hive.box<Event>('event_db').values.toList();

  late List<Event> eventDisplay = List<Event>.from(eventList);

  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'Task'),
    const Tab(text: 'Event'),
  ];

  DateTimeRange dateRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

//<<<<<<<<<<------------search input field-------------->>>>>>>>>>>>>>>>>>>
  Widget searchTextField() {
    return TextFormField(
      autofocus: true,
      controller: _searchController,
      cursorColor: Grey(),
      style: TextStyle(color: Grey()),
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Grey(),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
              color: Grey(),
            ),
            onPressed: () => clearText(),
          ),
          filled: true,
          fillColor: ThemeGrey(),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(50)),
          hintText: 'search . . .',
          hintStyle: TextStyle(color: Grey())),
      onChanged: (value) {
        _searchTask(value, newDateTime);
      },
    );
  }

//<<<<<<<<<<<<---------search function----------->>>>>>>>>>>>>>>>>>>>>>>
  String filter = '';

  void _searchTask(String value, newDate) {
    setState(() {
      switch (filter) {
        case 'high':
          taskDisplay = taskList
              .where(
                (element) =>
                    element.priority == true &&
                    element.title.toLowerCase().contains(value),
              )
              .toList();

          eventDisplay = eventList
              .where((element) =>
                  element.priority == true &&
                  element.title.toLowerCase().contains(value))
              .toList();

          break;
        case 'low':
          taskDisplay = taskList
              .where((element) =>
                  element.priority == false &&
                  element.title.toLowerCase().contains(value))
              .toList();

          eventDisplay = eventList
              .where((element) =>
                  element.priority == false &&
                  element.title.toLowerCase().contains(value))
              .toList();
          break;
        case 'date':
          taskDisplay = taskList
              .where((element) =>
                  element.title.toLowerCase().contains(value) &&
                  element.date.isAfter(DateTime(newDate.start.year,
                      newDate.start.month, newDate.start.day)) &&
                  element.date.isBefore(DateTime(newDate.end.year,
                      newDate.end.month, newDate.end.day + 1)))
              .toList();

          eventDisplay = eventList
              .where((element) =>
                  element.date.isAfter(DateTime(newDate.start.year,
                      newDate.start.month, newDate.start.day)) &&
                  element.date.isBefore(DateTime(newDate.end.year,
                      newDate.end.month, newDate.end.day + 1)) &&
                  element.title.toLowerCase().contains(value))
              .toList();
          break;

        default:
          // }
          taskDisplay = taskList
              .where((element) =>
                  element.title.toLowerCase().contains(value.toLowerCase()))
              .toList();
          eventDisplay = eventList
              .where((element) =>
                  element.title.toLowerCase().contains(value.toLowerCase()))
              .toList();
      }
    });
  }

  void clearText() {
    _searchController.clear();
  }

//<<<<<<<<<<<<<--------------Filter Chipssss--------------->>>>>>>>>>>>>>>>>>>>>>>>>
  Widget techChips() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        FilterChip(
          label: Text('High Priority'),
          backgroundColor: Color.fromARGB(255, 208, 119, 113),
          selected: (filter == 'high') ? true : false,
          onSelected: (bool val) {
            setState(() {
              if (val) {
                filter = 'high';
                // priorityFilterHigh(val);
                _searchTask(_searchController.text, null);
              } else {
                filter = 'wrong';
                _searchTask(_searchController.text, null);
              }
            });
          },
        ),
        FilterChip(
          label: Text('Low Priority'),
          backgroundColor: Color.fromARGB(255, 206, 208, 113),
          selected: (filter == 'low') ? true : false,
          onSelected: (val) {
            setState(() {
              if (val) {
                filter = 'low';
                // priorityFilterLow(val);
                _searchTask(_searchController.text, null);
              } else {
                filter = 'wrong';
                _searchTask(_searchController.text, null);
              }
            });
          },
        ),

        FilterChip(
          label: Text('Date '),
          backgroundColor: Color.fromARGB(255, 113, 157, 208),
          selected: (filter == 'date') ? true : false,
          onSelected: (bool val) {
            setState(() {
              if (val) {
                filter = 'date';
                pickDateRange();
                // _searchTask(_searchController.text, dateRange);
              } else {
                filter = 'wrong';
                _searchTask(_searchController.text, null);
              }
            });
          },
        ),
      ]),
    );
  }

  Future pickDateRange() async {
    newDateTime = await showDateRangePicker(
        context: context,
        initialDateRange: dateRange,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));

    if (newDateTime == null) return;
    _searchTask(_searchController.text, newDateTime);
  }

//<<<<<<<<<<<<--------------priority and date--------------->>>>>>>>>>>>>>>>>>>>>>

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

  BoxDecoration MyBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: ThemeGrey(),
    );
  }

  TabBarView TabBarList() {
    return TabBarView(children: [
      Column(
        children: [
          const szdbx(ht: 100),
          // yourTask('Your tasks'),
          Expanded(
            child: TaskSearchList(),
          ),
        ],
      ),
      Column(children: [
        const szdbx(ht: 100),
        // yourTask('Your Events'),
        Expanded(
          child: EventSearchList(),
        ),
      ]),
    ]);
  }

  AppBar MyAppBar() {
    return AppBar(
        automaticallyImplyLeading: false,
        bottom: TabBar(
          // indicatorColor: Transprt(),
          indicatorSize: TabBarIndicatorSize.label,
          tabs: myTabs,
        ),
        backgroundColor: Black(),
        title: searchTextField()
        // actions: [appBarAction()],
        );
  }

  Widget EventSearchList() {
    // getTask();
    getEvent();
    return eventDisplay.isNotEmpty
        ? ValueListenableBuilder(
            valueListenable: eventNotifier,
            builder: (BuildContext context, dynamic value, Widget? child) {
              // getTask();
              getEvent();
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: eventDisplay.length,
                        itemBuilder: ((context, index) {
                          eventDisplay.sort(
                              (Event a, Event b) => a.date.compareTo(b.date));
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, bottom: 6),
                            child: Container(
                              decoration: MyBoxDecoration(),
                              child: Slidable(
                                startActionPane: ActionPane(
                                  motion: BehindMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        markDoneE(eventDisplay[index], context);
                                        doneToast();
                                      },
                                      backgroundColor:
                                          Color.fromARGB(255, 120, 181, 122),
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
                                        // if (taskEventKey == 1) {
                                        // deleteTask(index);
                                        deleteEvents(eventDisplay[index].id);
                                        deleteToast();
                                        // Navigator.of(context).pop();
                                        // }
                                      },
                                      backgroundColor:
                                          Color.fromARGB(255, 213, 78, 68),
                                      icon: Icons.close_rounded,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.only(
                                      left: 20, top: 10, bottom: 10),
                                  title: Text(
                                    eventDisplay[index].title,
                                    style: TextStyle(color: White()),
                                  ),
                                  subtitle: PriorityAndDate(
                                      eventDisplay[index].priority,
                                      eventDisplay[index].date),
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: ((context) => eventView(
                                              passValue: eventDisplay[index],
                                              passId: index,
                                              passDate:
                                                  eventDisplay[index].date,
                                              taskEventKey: taskEventKey,
                                              priority: eventDisplay[index]
                                                  .priority)))),
                                ),
                              ),
                            ),
                          );
                        }))
                  ],
                ),
              );
            })
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 120.0),
                child: Text(
                  'No Match Found',
                  style: TextStyle(color: Grey(), fontSize: 23),
                ),
              ),
            ],
          );
  }

  Widget TaskSearchList() {
    getTask();
    // getEvent();
    return taskDisplay.isNotEmpty
        ? ValueListenableBuilder(
            valueListenable: taskNotifier,
            builder: (BuildContext context, dynamic value, Widget? child) {
              getTask();
              // getEvent();
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: taskDisplay.length,
                        itemBuilder: ((context, index) {
                          // final data = taskList[index];
                          taskDisplay.sort(
                              (Task a, Task b) => a.date.compareTo(b.date));
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15, bottom: 6),
                            child: Container(
                              decoration: MyBoxDecoration(),
                              child: Slidable(
                                startActionPane: ActionPane(
                                  motion: BehindMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        markDoneT(taskDisplay[index], context);
                                        doneToast();
                                      },
                                      backgroundColor:
                                          Color.fromARGB(255, 120, 181, 122),
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
                                        deleteTask(taskDisplay[index].id);
                                        deleteToast();
                                        // }
                                      },
                                      backgroundColor:
                                          Color.fromARGB(255, 213, 78, 68),
                                      icon: Icons.close_rounded,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.only(
                                      left: 20, top: 10, bottom: 10),
                                  title: Text(
                                    taskDisplay[index].title,
                                    style: TextStyle(color: White()),
                                  ),
                                  subtitle: PriorityAndDate(
                                      taskDisplay[index].priority,
                                      taskDisplay[index].date),
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: ((context) => taskView(
                                              passValue: taskDisplay[index],
                                              passId: index,
                                              passDate: taskDisplay[index].date,
                                              taskEventKey: taskEventKey,
                                              priority: taskDisplay[index]
                                                  .priority)))),
                                ),
                              ),
                            ),
                          );
                        }))
                  ],
                ),
              );
            })
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 120.0),
                child: Text(
                  'No Match Found',
                  style: TextStyle(color: Grey(), fontSize: 23),
                ),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    getTask();
    getEvent();
    return DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
            appBar: MyAppBar(),
            backgroundColor: Black(),
            body: Stack(children: [
              TabBarList(),
              techChips(),
            ])));
  }
}
