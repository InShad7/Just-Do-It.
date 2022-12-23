import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:just_do_it/function/DB_Event_Function.dart';
import 'package:just_do_it/function/db_event_function.dart';
import 'package:just_do_it/model/data_model.dart';
import 'package:just_do_it/screens/Homescreen.dart';
import 'package:just_do_it/utilities/colors.dart';
import 'package:just_do_it/utilities/textfieldForm.dart';
import 'package:just_do_it/widgets/priority.dart';
import 'package:just_do_it/widgets/sizedbox.dart';

class editEvent extends StatefulWidget {
  editEvent({Key? key, required this.passId, required this.passValue})
      : super(key: key);

  late Event passValue;
  final int passId;

  @override
  State<editEvent> createState() => _editEventState();
}

class _editEventState extends State<editEvent> {
  @override
  void initState() {
    super.initState();
    myPriority = widget.passValue.priority;
    dateTime = widget.passValue.date;
    imagePath = widget.passValue.image;
  }

  DateTime dateTime = DateTime.now();

  late final _titleController =
      TextEditingController(text: widget.passValue.title);

  late final _contentController =
      TextEditingController(text: widget.passValue.content);

  String? imagePath;

  Future<void> TaskAddBtn(int index) async {
    final _title = _titleController.text.trim();
    final _content = _contentController.text.trim();
    final _dateTime = dateTime;
    final _id = DateTime.now().toString();

    if (_title.isEmpty) {
      return;
    }
    print('$_title $_content $dateTime');

    final _events = Event(
        title: _title,
        content: _content,
        date: _dateTime,
        image: imagePath!,
        priority: myPriority,
        id: _id,
        isCompleted: false);

    // final eventDB = await Hive.openBox<Event>('Event_db');
    // eventDB.putAt(index, _events);
    editEvents(widget.passValue.id, context, _events);
    getEvent();
  }

  Widget img() {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          children: [
            InkWell(
              onTap: () => pickImage(),
              child: Container(
                // width: 400,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imagePath == null
                        ? FileImage(File(widget.passValue.image))
                        : FileImage(File(imagePath!)),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(156, 69, 69, 69),
                ),
              ),
            ),
            const Positioned(
              top: 20,
              left: 20,
              child: Icon(
                Icons.photo_library_rounded,
                size: 30,
                color: Colors.grey,
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
            backgroundColor: Color.fromARGB(156, 69, 69, 69),
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
          style: TextStyle(color: Colors.grey),
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

  AppBar MyAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      actions: [
        Row(
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
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: MyAppBar(context),
        body: ListView(
          children: [
            const szdbx(ht: 60),
            img(),
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
