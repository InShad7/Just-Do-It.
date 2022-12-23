// import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_do_it/function/db_event_function.dart';
// import 'package:just_do_it/function/db_function.dart';
import 'package:just_do_it/model/data_model.dart';
import 'package:just_do_it/utilities/Colors.dart';
import 'package:just_do_it/utilities/textfieldForm.dart';
import 'package:just_do_it/widgets/priority.dart';
// import 'package:just_do_it/model/data_model_event.dart';
// import 'package:just_do_it/widgets/prioritySwitch.dart';
import 'package:just_do_it/widgets/sizedbox.dart';
// import 'package:intl/intl.dart';

String? myEventId;

class addEvent extends StatefulWidget {
  addEvent({Key? key}) : super(key: key);

  @override
  State<addEvent> createState() => _addEventState();
}

class _addEventState extends State<addEvent> {
  late DateTime dateTime = DateTime.now();
  // String formattedDate = DateFormat('yyyy-MM-dd - kk:mm').format(dateTime);
  // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");

  final _titleController = TextEditingController();

  final _contentController = TextEditingController();

  String? imagePath;

  Future<void> TaskAddBtn() async {
    final _title = _titleController.text.trim();
    final _content = _contentController.text.trim();
    final _dateTime = dateTime;
    final _id = DateTime.now().toString();
    myEventId = _id;

    if (_title.isEmpty) {
      return;
    }
    print('$_title $_content $dateTime');

    final _events = Event(
      title: _title,
      content: _content,
      date: _dateTime,
      image: imagePath!,
      priority: mypriority,
      id: _id,
      isCompleted: false,
    );
    addEvents(_events);
  }

  Widget img() {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          children: [
            InkWell(
              onTap: () => pickImage(),
              child: Container(
                width: 400,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ThemeGrey(),
                  image: DecorationImage(
                    image: imagePath == null
                        ? AssetImage('assets/images/bg.jpg') as ImageProvider
                        : FileImage(File(imagePath!)),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Icon(
                Icons.photo_library_rounded,
                size: 30,
                color: Grey(),
              ),

              // pickImage(),
            )
          ],
        ));
  }

  Future<void> pickImage() async {
    final PickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (PickedFile != null) {
      setState(() {
        imagePath = PickedFile.path;
      });
    }
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

  bool mypriority = false;

  onChangeFunction(bool newValue) {
    setState(() {
      mypriority = newValue;
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

  AppBar MyAppBar() {
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
        appBar: MyAppBar(),
        body: ListView(
          children: [
            const szdbx(ht: 40),
            img(),
            MyTextFieldForm(myController: _titleController, hintName: 'Title'),
            MyTextFieldForm(
                myController: _contentController, hintName: 'Content'),
            DateAndTime(),
            const szdbx(ht: 10),
            PriorityBtn(
                isSwitched: mypriority, onChangeMethod: onChangeFunction),
          ],
        ));
  }
}
