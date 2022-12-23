import 'dart:io';

import 'package:flutter/material.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:just_do_it/model/data_model.dart';
// import 'package:just_do_it/model/data_model_event.dart';
import 'package:just_do_it/screens/editEvent.dart';
import 'package:just_do_it/utilities/Colors.dart';
import 'package:just_do_it/utilities/date.dart';
import 'package:just_do_it/utilities/globalFunctions.dart';
import 'package:just_do_it/utilities/textField.dart';
import 'package:just_do_it/utilities/textfieldForm.dart';
// import 'package:just_do_it/widgets/delete.dart';
// import 'package:just_do_it/widgets/delete_event.dart';
// import 'package:just_do_it/widgets/delete_task.dart';
// import 'package:just_do_it/screens/editTask.dart';
import 'package:just_do_it/widgets/sizedbox.dart';
import 'package:intl/intl.dart';

// bool myhigh = false;

class eventView extends StatefulWidget {
  eventView(
      {Key? key,
      required this.passId,
      required this.passValue,
      required this.passDate,
      required this.taskEventKey,
      required this.priority})
      : super(key: key);

  Event passValue;
  final int passId;
  final passDate;
  final taskEventKey;
  final priority;

  @override
  State<eventView> createState() => _eventViewState();
}

class _eventViewState extends State<eventView> {
  DateTime dateTime = DateTime.now();

  final _titleController = TextEditingController();

  final _contentController = TextEditingController();

  String? imagePath;

  Widget img() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: FullScreenWidget(
        child: Container(
          // width: 400,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // color: Color.fromARGB(156, 212, 195, 195),
            image: DecorationImage(
              image: FileImage(File(widget.passValue.image)),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }

 

  AppBar MyAppBar() {
    return AppBar(
      actions: [appbarAction()],
      backgroundColor: Black(),
    );
  }

  Widget appbarAction() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        children: [
          IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => editEvent(
                        passId: widget.passId,
                        passValue: widget.passValue,
                      )))),
              icon: Icon(
                Icons.edit_outlined,
                size: 30,
              )),
        ],
      ),
    );
  }

  Padding PriorityAndDate() {
    return Padding(
      padding: const EdgeInsets.only(right: 17.0, left: 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          priorityDisplay(widget.priority),
          MyDate(passDate: widget.passDate),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Black(),
        appBar: MyAppBar(),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const szdbx(ht: 30),
                  PriorityAndDate(),
                  const szdbx(ht: 10),
                  img(),
                  MyTextField(hintName: widget.passValue.title, ht: 72),
                  MyTextField(hintName: widget.passValue.content, ht: 300),
                ],
              ),
            ),
            // szdbx(ht: 120),
          ],
        ));
  }
}
