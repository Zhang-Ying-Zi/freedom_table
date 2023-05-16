import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeaderModel extends ChangeNotifier {
  static HeaderModel? _instance;

  static HeaderModel get instance {
    _instance ??= HeaderModel();
    return _instance!;
  }

  /// header每行cell宽度
  List<double> headerCellWidths = [];

  /// header最大高度
  double headerMaxHeight = 0;

  /// 固定的header cell widgets
  List<Widget> fixedHeaderCellWidgets = [];

  /// 固定的header cell 个数
  int fixedColumnCount = 0;

  /// 固定的header总宽度
  double fixedColumnWidth = 0;

  /// 每次headerMaxHeight调整都会触发一次
  void setHeaderCellWidths(List<double> headerCellWidths) {
    this.headerCellWidths = headerCellWidths;
    notifyListeners();
  }

  void setHeaderMaxHeight(double headerMaxHeight) {
    this.headerMaxHeight = headerMaxHeight;
  }

  void setFixedHeaderCellWidgets(List<Widget> fixedHeaderCellWidgets) {
    this.fixedHeaderCellWidgets = fixedHeaderCellWidgets;
  }

  void setFixedColumnWidth(double fixedColumnWidth) {
    this.fixedColumnWidth = fixedColumnWidth;
  }

  void setFixedColumnCount(int fixedColumnCount) {
    this.fixedColumnCount = fixedColumnCount;
  }
}
