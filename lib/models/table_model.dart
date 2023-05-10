import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TableModel extends ChangeNotifier {
  static TableModel? _instance;
  static get instance {
    _instance ??= TableModel();
    return _instance;
  }

  // header每行cell宽度
  List<double> headerCellWidths = [];
  // header最大高度
  double headerMaxHeight = 0;
  // body每行最大高度，行号从0开始
  Map<int, double?> rowMaxHeights = {};
  // 占用表 Map<rownumber, Map<colnumber, isOccupied>>
  Map<int, Map<int, bool>> occupiedTable = {};
  Map<int, Map<int, bool>> preOccupiedTable = {};

  // 固定的 header cell widgets
  List<Widget> fixedHeaderCellWidgets = [];
  int fixedColumnCount = 0;
  double fixedColumnWidth = 0;

  // 每页中的行数
  int rowCount = 0;

  void reset(int rowCount) {
    this.rowCount = rowCount;
    occupiedTable = {};
    rowMaxHeights = {};
  }

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
    if (rowMaxHeights.length >= rowCount) {
      notifyListeners();
    }
  }

  void updateOccupiedTable(Map<int, Map<int, bool>> occupiedTable) {
    this.occupiedTable = occupiedTable;

    // bool isSameAsPre = true;
    // occupiedTable.forEach(
    //   (rownumber, occupiedRow) {
    //     occupiedRow.forEach((columnnumber, occupied) {
    //       try {
    //         if (occupied != preOccupiedTable[rownumber]![columnnumber]) {
    //           isSameAsPre = false;
    //         }
    //       } catch (e) {
    //         isSameAsPre = false;
    //       }
    //     });
    //   },
    // );
    // // print(isSameAsPre);
    // // print(occupiedTable);
    // if (isSameAsPre &&
    //     rowCount > 0 &&
    //     occupiedTable.length >= rowCount &&
    //     occupiedTable[occupiedTable.length - 1]!.length >=
    //         headerCellWidths.length - fixedColumnCount) {
    //   notifyListeners();
    // }
    // preOccupiedTable = occupiedTable;
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
