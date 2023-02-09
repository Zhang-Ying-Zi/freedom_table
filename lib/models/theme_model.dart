import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  ThemeData theme = ThemeData();

  void changeTheme(ThemeData init) {
    theme = init;
    notifyListeners();
  }
}
