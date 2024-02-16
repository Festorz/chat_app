import 'package:flutter/material.dart';

import 'apptext.dart';

class Appsnackbar {
  static void snackbar(context, String text, Color color, icon,
      {int duration = 2}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Row(
        mainAxisAlignment: icon != null
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: [
          icon != null
              ? Icon(icon, color: Colors.white, size: 16)
              : const SizedBox(),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Center(
                  child: AppText(
                      text: text, color: Colors.white, size: 12, lines: 5))),
        ],
      ),
      backgroundColor: color,
      elevation: 1,
      duration: Duration(seconds: duration),
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.04,
          left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1),
    ));
  }
}
