import 'package:flutter/material.dart';

class NavigationHelper {
  static void navigateTo(context, widget) => Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

  static void pushAndReplace(context, widget) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget));

  static void goBackToHome(context) => Navigator.popUntil(context, (route) => route.isFirst);

  static void goBackToSpecificScreen(context, widget) =>
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => widget), (Route<dynamic> route) => false);
}
