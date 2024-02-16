import 'package:flutter/material.dart';
import '../../utils/size_util.dart';

class BoldText extends StatelessWidget {
  final String text;
  final double size;
  final Color? color;
  final int lines;
  final TextOverflow? overflow;
  const BoldText({
    Key? key,
    required this.text,
    required this.size,
    this.color = Colors.black,
    this.overflow = TextOverflow.ellipsis,
    this.lines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: getFontSize(size),
        color: color,
        fontWeight: FontWeight.bold,
      ),
      maxLines: lines,
      overflow: overflow,
    );
  }
}
