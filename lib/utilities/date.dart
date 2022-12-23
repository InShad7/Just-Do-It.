
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_do_it/utilities/colors.dart';

class MyDate extends StatelessWidget {
  const MyDate({
    Key? key,
    required this.passDate,
  }) : super(key: key);

  final DateTime passDate;

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat("dd MMM yyyy hh:mm a").format(passDate),
      // '${widget.passDate.substring(0, widget.passDate.length - 7)}',
      style: TextStyle(
        fontSize: 18,
        color: Grey(),
      ),
    );
  }
}
