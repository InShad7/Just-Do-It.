import 'package:flutter/material.dart';

class szdbx extends StatelessWidget {
  final double ht;
  const szdbx({
    Key? key,
    required this.ht,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ht,
    );
  }
}
