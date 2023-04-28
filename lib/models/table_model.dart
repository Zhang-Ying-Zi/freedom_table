import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TableModel extends ChangeNotifier {
  // header每行cell宽度
  List<double> headerCellWidths = [];
  // header最大高度
  double headerMaxHeight = 0;
  // body每行最大高度，行号从0开始
  Map<int, double?> rowMaxHeights = {};
  // 占用表 Map<rownumber, Map<colnumber, isOccupied>>
  Map<int, Map<int, bool>> occupiedTable = {};

  // 固定的 header cell widgets
  List<Widget> fixedHeaderCellWidgets = [];
  int fixedColumnCount = 0;
  double fixedColumnWidth = 0;

  void initCellWidths(List<double> headerCellWidths) {
    this.headerCellWidths = headerCellWidths;
    // print(headerCellWidths);
  }

  void updateHeaderMaxHeight(double headerMaxHeight) {
    this.headerMaxHeight = headerMaxHeight;
    // print(headerMaxHeight);
  }

  void addRowMaxHeight(int linenumber, double? rowMaxHeight) {
    rowMaxHeights.addAll({linenumber: rowMaxHeight});
    // print(rowMaxHeights);
    // notifyListeners();
  }

  void updateOccupiedTable(Map<int, Map<int, bool>> occupiedTable) {
    this.occupiedTable = occupiedTable;
    // print(occupiedTable);
    // notifyListeners();
  }

  // void updateOccupiedRow(int rownumber, Map<int, bool> updatedOccupiedRow) {
  //   Map<int, bool> occupiedRow = occupiedTable.putIfAbsent(rownumber, () => {});
  //   occupiedRow.addAll(updatedOccupiedRow);
  //   // print(occupiedTable);
  //   // notifyListeners();
  // }

  void updateFixedHeaderCellWidgets(List<Widget> fixedHeaderCellWidgets) {
    this.fixedHeaderCellWidgets = fixedHeaderCellWidgets;
    // print(fixedHeaderCellWidgets);
    // notifyListeners();
  }

  void updateFixedColumnWidth(double fixedColumnWidth) {
    this.fixedColumnWidth = fixedColumnWidth;
    // print(fixedColumnWidth);
  }

  void updateFixedColumnCount(int fixedColumnCount) {
    this.fixedColumnCount = fixedColumnCount;
    // print(fixedColumnCount);
  }
}
