
import 'package:flutter/material.dart';
import 'package:just_do_it/screens/calendarScreen.dart';
import 'package:just_do_it/utilities/Colors.dart';

class YourTasks extends StatelessWidget {
  const YourTasks({
    Key? key,
    required this.context,
    required this.mylistName,
  }) : super(key: key);

  final BuildContext context;
  final String mylistName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 26.0, right: 26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            mylistName,
            style: TextStyle(
                color: White(), fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
              alignment: Alignment.center,
              width: 45,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ThemeGrey(),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.calendar_month_rounded,
                  size: 25,
                  color: White(),
                ),
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CalendarScreen())),
              )),
        ],
      ),
    );
  }
}