import 'package:flutter/material.dart';

class Constants {
  static BorderRadius kInputFieldBorderRadius = BorderRadius.circular(10);
  static BorderRadius kWeekDayContainerBorderRadius = BorderRadius.circular(15);

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
