import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_do_it/function/db_event_function.dart';
import 'package:just_do_it/function/db_function.dart';
import 'package:just_do_it/model/data_model.dart';
import 'package:just_do_it/utilities/colors.dart';
//<<<<<<<<<<<<---------------toast fun--------->>>>>>>>>>>>>>>>>>>>>>>>>>>
void deleteToast() {
  Fluttertoast.showToast(
      msg: "Removed..!!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 15.0);
}

void doneToast() {
  Fluttertoast.showToast(
      msg: "Completed..!!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: greenC(),
      textColor: Colors.white,
      fontSize: 15.0);
}
//<<<<<<<<<<<--------mark done -------------->>>>>>>>>>>>>>>>>>>>>>>>>>>


void markDoneT(Task data, BuildContext context) {
  final updateData = Task(
    id: data.id,
    content: data.content,
    date: data.date,
    priority: data.priority,
    title: data.title,
    isCompleted: true,
  );

  editTasks(data.id, context, updateData);
}



void markDoneE(Event data, BuildContext context) {
  final updateData = Event(
      id: data.id,
      content: data.content,
      date: data.date,
      priority: data.priority,
      title: data.title,
      isCompleted: true,
      image: data.image);

  editEvents(data.id, context, updateData);
}

//<<<<<<<<<------------priority Icon------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>..




 priorityDisplay(mypriorityval) {
    if (mypriorityval) {
      return Row(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.circle,
              color: Red(),
              size: 15,
            ),
            Text(
              ' High Priority',
              style: TextStyle(color: Red()),
            )
          ]);
    } else {
      return Row(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.circle,
              color: Amber(),
              size: 15,
            ),
            Text(
              ' Low Priority',
              style: TextStyle(color: Amber()),
            )
          ]);
    }
  }
