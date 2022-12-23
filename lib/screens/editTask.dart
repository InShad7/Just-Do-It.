import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_do_it/function/db_function.dart';
import 'package:just_do_it/model/data_model.dart';
import 'package:just_do_it/screens/HomeScreen.dart';
import 'package:just_do_it/utilities/Colors.dart';
import 'package:just_do_it/utilities/textfieldForm.dart';
import 'package:just_do_it/widgets/priority.dart';

import 'package:just_do_it/widgets/sizedbox.dart';

class editTask extends StatefulWidget {
  editTask({
    Key? key,
    required this.passId,
    required this.passValue,
  }) : super(key: key);

  late Task passValue;
  final int passId;

  @override
  State<editTask> createState() => _editTaskState();
}

class _editTaskState extends State<editTask> {
  @override
  void initState() {
    super.initState();
    myPriority = widget.passValue.priority;
    dateTime = widget.passValue.date;
  }

  DateTime dateTime = DateTime.now();

  late final _titleController =
      TextEditingController(text: widget.passValue.title);

  late final _contentController =
      TextEditingController(text: widget.passValue.content);

  Future<void> TaskAddBtn(int index) async {
    final _title = _titleController.text.trim();
    final _content = _contentController.text.trim();
    final _dateTime = dateTime;
    final _isComplete = false;
    final _id = DateTime.now().toString();

    if (_title.isEmpty) {
      return;
    }
    print('$_title $_content $dateTime');

    final _tasks = Task(
      title: _title,
      content: _content,
      date: _dateTime,
      priority: myPriority,
      // isCompleted: _isComplete,
      id: _id,
      isCompleted: false,
    );
    // addTasks(_tasks);

    // final taskDB = await Hive.openBox<Task>('Task_db');
    // taskDB.putAt(index, _tasks);
    // getTask();
    editTasks(widget.passValue.id, context, _tasks);
  }

  Widget date() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: ThemeGrey(),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.all(25)),
          onPressed: () async {
            final date = await pickDate();
            if (date == null) return;

            final newDateTime = DateTime(date.year, date.month, date.day,
                dateTime.hour, dateTime.minute);
            setState(() {
              dateTime = newDateTime;
            });
          },
          child: Text(
            '${dateTime.day}/${dateTime.month}/${dateTime.year}',
            style: TextStyle(color: Grey()),
          )),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2500));

  Widget time() {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: ThemeGrey(),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.all(25)),
        onPressed: () async {
          final time = await pickTime();
          if (time == null) return;

          final newDateTime = DateTime(dateTime.year, dateTime.month,
              dateTime.day, time.hour, time.minute);
          setState(() {
            dateTime = newDateTime;
          });
        },
        child: Text(
          '$hours:$minutes',
          style: TextStyle(color: Grey()),
        ),
      ),
    );
  }

  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));

  AppBar MyAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Black(),
      actions: [
        AppBarActions(context),
      ],
    );
  }

  Row AppBarActions(
    BuildContext context,
  ) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              TaskAddBtn(widget.passId);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: ((context) => HomeScreen())),
                  (route) => false);
            },
            icon: const Icon(
              Icons.check_rounded,
              size: 32,
            )),
        IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close_rounded,
              size: 32,
            ))
      ],
    );
  }

  var myPriority = false;

  onChangeFunction(bool newValue) {
    setState(() {
      myPriority = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Black(),
        appBar: MyAppBar(context),
        body: ListView(
          children: [
            const szdbx(ht: 100),
            MyTextFieldForm(myController: _titleController, hintName: 'Title'),
            MyTextFieldForm(
                myController: _contentController, hintName: 'Content'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                date(),
                time(),
              ],
            ),
            PriorityBtn(
                isSwitched: myPriority, onChangeMethod: onChangeFunction),
          ],
        ));
  }
}
