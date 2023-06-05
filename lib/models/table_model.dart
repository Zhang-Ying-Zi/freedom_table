import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TableModel extends ChangeNotifier {
  static TableModel? _instance;
  static bool _disposed = false;

  static TableModel get instance {
    if (_disposed) {
      _instance = TableModel();
    } else {
      _instance ??= TableModel();
    }

    return _instance!;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  /// body每行最大高度，行号从0开始
  Map<int, double?> rowMaxHeights = {};

  /// 占用表 Map<rownumber, Map<colnumber, isOccupied>>
  Map<int, Map<int, bool>> occupiedTable = {};

  /// 每页中的行数
  int rowCount = 0;

  /// header中的列数
  int columnCount = 0;

  Timer? waitBodyCellHeightChange;

  /// fixed Body Cell Widgets
  List<Widget> fixedBodyCellWidgets = [];

  /// scrollable Body Cell Widgets
  List<Widget> scrollableBodyCellWidgets = [];

  void notify() {
    notifyListeners();
  }

  void reset(int rowCount, int columnCount) {
    this.rowCount = rowCount;
    this.columnCount = columnCount;
    rowMaxHeights = {};
    occupiedTable = {};
    fixedBodyCellWidgets = [];
    scrollableBodyCellWidgets = [];
  }

  void addRowMaxHeight(int linenumber, double? rowMaxHeight) {
    rowMaxHeights.addAll({linenumber: rowMaxHeight});
    // 等等 body cell height 是否有新的改变，目前只能等待看看，无法主动判断是否已全部resize完
    waitBodyCellHeightChange?.cancel();
    waitBodyCellHeightChange = Timer(const Duration(milliseconds: 0), () {
      // print("${rowMaxHeights.length}  $rowCount");
      if (rowMaxHeights.length >= rowCount) {
        notifyListeners();
      }
    });
  }

  // void updateOccupiedRow(int rownumber, Map<int, bool> updatedOccupiedRow) {
  //   Map<int, bool> occupiedRow = occupiedTable.putIfAbsent(rownumber, () => {});
  //   occupiedRow.addAll(updatedOccupiedRow);
  //   // print(occupiedTable);
  //   // notifyListeners();
  // }
}
