import 'package:flutter/cupertino.dart';

class Navigation {
  static void pushCupertino(BuildContext context, Widget screen) {
    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => screen));
  }

  static void pushReplacementCupertino(BuildContext context, Widget screen) {
    Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => screen));
  }
}