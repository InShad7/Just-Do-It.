import 'package:flutter/material.dart';
import 'package:just_do_it/screens/editTask.dart';
import 'package:just_do_it/utilities/colors.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    // required this.context,
    // required this.widget,
    // required this.widget,
    // required this.myController,
    required this.hintName,
    required this.ht,
  }) : super(key: key);

  // final BuildContext context;
  // final taskView widget;
  // final taskView widget;
  // final TextEditingController myController;
  final String hintName;
  final double? ht;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: ht,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ThemeGrey(),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 25),
          child: Text(
            hintName,
            style: TextStyle(
              fontSize: 18,
              color: Grey(),
            ),
          ),
        ),
      ),
    );
  }
}
