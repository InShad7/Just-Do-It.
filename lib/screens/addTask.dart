// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_do_it/function/db_function.dart';
import 'package:just_do_it/model/data_model.dart';
import 'package:just_do_it/utilities/Colors.dart';
import 'package:just_do_it/utilities/textfieldForm.dart';
import 'package:just_do_it/widgets/priority.dart';
// import 'package:just_do_it/widgets/prioritySwitch.dart';
import 'package:just_do_it/widgets/sizedbox.dart';
import 'package:intl/intl.dart';

// bool isSwitched = false;

String? myTaskId;

class addTask extends StatefulWidget {
  addTask({Key? key}) : super(key: key);

  @override
  State<addTask> createState() => _addTaskState();
}

class _addTaskState extends State<addTask> {
  // bool isSwitched = false;

  late DateTime dateTime = DateTime.now();
  // String formattedDate = DateFormat('yyyy-MM-dd - hh:mm').format(dateTime);
  // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");

  final _titleController = TextEditingController();

  final _contentController = TextEditingController();

  // final id = int;

  String? imagepath;

  Future<void> TaskAddBtn() async {
    final _title = _titleController.text.trim();
    final _content = _contentController.text.trim();
    final _dateTime = dateTime;
    final _isComplete = false;
    final _id = DateTime.now().toString();
    // myTaskId = _id;

    if (_title.isEmpty) {
      return;
    }

    print('$_title $_content $dateTime');

    final _tasks = Task(
      // isCompleted: false,
      title: _title,
      content: _content,
      date: _dateTime,
      priority: myPriority,
      id: _id,
      isCompleted: false,
    );
    addTasks(_tasks);
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
            '${dateTime.year}/${dateTime.month}/${dateTime.day}',
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

  bool myPriority = false;

  onChangeFunction(bool newValue) {
    setState(() {
      myPriority = newValue;
    });
  }

  Row DateAndTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        date(),
        time(),
      ],
    );
  }

  AppBar MyAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Black(),
      actions: [
        AppBarActions(context),
      ],
    );
  }

  Row AppBarActions(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              TaskAddBtn();
              Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Black(),
        appBar: MyAppBar(context),
        body: ListView(
          children: [
            const szdbx(ht: 100),
            MyTextFieldForm(myController: _titleController, hintName: 'Tittle'),
            MyTextFieldForm(
                myController: _contentController, hintName: 'Content'),
            DateAndTime(),
            const szdbx(ht: 10),
            PriorityBtn(
                isSwitched: myPriority, onChangeMethod: onChangeFunction),
            // priority(myPriority, onChangeFunction),
          ],
        ));
  }
}
