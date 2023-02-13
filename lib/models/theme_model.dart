import 'package:flutter/material.dart';
import '../types.dart';

class ThemeModel extends ChangeNotifier {
  FreedomTableTheme theme;

  ThemeModel(this.theme);

  void changeTheme(FreedomTableTheme changedTheme) {
    theme = changedTheme;
    notifyListeners();
  }
}
