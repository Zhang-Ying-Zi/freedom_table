import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TableModel extends ChangeNotifier {
  // header每行cell宽度
  List<double> headerCellWidths = [];
  // body每行最大高度，行号从0开始
  Map<int, double?> rowMaxHeights = {};
  // 占用表 Map<rownumber, Map<colnumber, isOccupied>>
  Map<int, Map<int, bool>> occupiedTable = {};

  void initCellWidths(List<double> headerCellWidths) {
    this.headerCellWidths = headerCellWidths;
  }

  void addRowMaxHeight(int linenumber, double? rowMaxHeight) {
    rowMaxHeights.addAll({linenumber: rowMaxHeight});
    // print(rowMaxHeights);
    notifyListeners();
  }

  void updateOccupiedTable(int rownumber, Map<int, bool> updatedOccupiedRow) {
    Map<int, bool> occupiedRow = occupiedTable.putIfAbsent(rownumber, () => {});
    occupiedRow.addAll(updatedOccupiedRow);
    // print(occupiedTable);
    // notifyListeners();
  }
}
