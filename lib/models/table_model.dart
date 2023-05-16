import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TableModel extends ChangeNotifier {
  static TableModel? _instance;

  static TableModel get instance {
    _instance ??= TableModel();
    return _instance!;
  }

  /// body每行最大高度，行号从0开始
  Map<int, double?> rowMaxHeights = {};

  /// 占用表 Map<rownumber, Map<colnumber, isOccupied>>
  Map<int, Map<int, bool>> occupiedTable = {};

  /// 每页中的行数
  int rowCount = 0;

  /// header中的列数
  int columnCount = 0;

  void reset(int rowCount, int columnCount) {
    this.rowCount = rowCount;
    this.columnCount = columnCount;
    rowMaxHeights = {};
    occupiedTable = {};
  }

  void addRowMaxHeight(int linenumber, double? rowMaxHeight) {
    rowMaxHeights.addAll({linenumber: rowMaxHeight});
    if (rowMaxHeights.length >= rowCount) {
      notifyListeners();
    }
  }

  void setOccupiedTable(Map<int, Map<int, bool>> occupiedTable) {
    this.occupiedTable = occupiedTable;
    // notifyListeners();
  }

  // void updateOccupiedRow(int rownumber, Map<int, bool> updatedOccupiedRow) {
  //   Map<int, bool> occupiedRow = occupiedTable.putIfAbsent(rownumber, () => {});
  //   occupiedRow.addAll(updatedOccupiedRow);
  //   // print(occupiedTable);
  //   // notifyListeners();
  // }

}
