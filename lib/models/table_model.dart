import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TableModel extends ChangeNotifier {
  // 非合并每行cell宽度
  List<double> cellWidths = [];
  // body每行最大高度，行号从0开始
  Map<int, double> rowMaxHeights = {};
  // rowspan记录，竖号从0开始, Map<colnumber, List<List<...rownumber>>>
  Map<int, List<List<int>>> colSpans = {};

  void initCellWidths(List<double> cellWidths) {
    this.cellWidths = cellWidths;
  }

  void addRowMaxHeight(int linenumber, double rowMaxHeight) {
    rowMaxHeights.addAll({linenumber: rowMaxHeight});
    print(rowMaxHeights);
    // notifyListeners();
  }

  void addColSpan(int colnumber, List<int> rownumbers) {
    List<List<int>> spans = colSpans.putIfAbsent(colnumber, () => []);
    if (spans
        .firstWhere(
            (element) =>
                element[0] == rownumbers[0] && element[1] == rownumbers[1],
            orElse: () => [])
        .isEmpty) {
      spans.add(rownumbers);
    }
    print(colSpans);
    // notifyListeners();
  }
}
