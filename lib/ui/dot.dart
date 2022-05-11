import 'package:flutter/material.dart';

class PomoDot extends StatelessWidget {
  final bool filled;
  final bool isMini;

  const PomoDot(this.filled, this.isMini, {Key? key}) : super(key: key);
  final double size = 10;
  final double miniSize = 5;
  final miniColor = Colors.red;
  final normalColor = Colors.orange;
  final disabledColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: isMini ? miniSize : size,
      width: isMini ? miniSize : size,
      margin: EdgeInsets.all(isMini ? miniSize : size),
      decoration: BoxDecoration(
          color: filled
              ? isMini
                  ? miniColor
                  : normalColor
              : Colors.grey,
          shape: BoxShape.circle),
    );
  }
}
