import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  ThemeData theme;

  ThemeModel(this.theme);

  void changeTheme(ThemeData init) {
    theme = init;
    notifyListeners();
  }
}
