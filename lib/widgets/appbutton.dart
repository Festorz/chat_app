import 'package:flutter/material.dart';

import '../utils/size_util.dart';
import 'apptext.dart';

class AppButton extends StatelessWidget {
  final Color? color;
  final String text;
  // IconData? icon;
  final Color? backgroundColor;
  final double size;
  final bool bold;
  final double textSize;
  final Color borderColor;
  // bool? isIcon;

  const AppButton({
    Key? key,
    required this.color,
    required this.backgroundColor,
    required this.text,
    required this.size,
    this.bold = true,
    this.textSize = 18,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: getVerticalSize(45),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: borderColor, width: 1.0, style: BorderStyle.solid),
          color: backgroundColor),
      child: Center(
        child: AppText(
          text: text,
          size: getFontSize(textSize),
          bold: bold,
          color: color,
        ),
      ),
    );
  }
}
