import 'package:flutter/material.dart';
import 'package:just_do_it/utilities/colors.dart';

class PriorityBtn extends StatefulWidget {
  const PriorityBtn({
    Key? key,
    required this.isSwitched,
    required this.onChangeMethod,
  }) : super(key: key);

  final bool isSwitched;
  final Function onChangeMethod;

  @override
  State<PriorityBtn> createState() => _PriorityBtnState();
}

class _PriorityBtnState extends State<PriorityBtn> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'Priority',
          style: TextStyle(color: Grey(), fontSize: 18),
        ),
        Row(
          children: [
            Text(
              'Low',
              style: TextStyle(color: Grey()),
            ),
            Switch(
              value: widget.isSwitched,
              onChanged: (newValue) {
                widget.onChangeMethod(newValue);
              },
              activeColor: SwitchActiveColor(),
              inactiveThumbColor: SwitchInActiveColor(),
              inactiveTrackColor: SwitchInActiveColor(),
            ),
            const Text(
              'High',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  //   bool myPriority = false;

  // onChangeFunction(bool newValue) {
  //   setState(() {
  //     myPriority = newValue;
  //   });
  // }
}
