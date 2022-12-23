
import 'package:flutter/material.dart';
import 'package:just_do_it/utilities/colors.dart';

class MyTextFieldForm extends StatelessWidget {
  const MyTextFieldForm({
    Key? key,
    required this.myController,
    required this.hintName,
  }) : super(key: key);

  final TextEditingController myController;
  final String hintName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 75,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ThemeGrey(),
        ),
        child: TextFormField(
          controller: myController,
          cursorColor: Grey(),
          style: TextStyle(color: Grey()),
          decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              hintText: hintName,
              hintStyle: TextStyle(fontSize: 18, color: Grey())),
        ),
      ),
    );
  }
}
