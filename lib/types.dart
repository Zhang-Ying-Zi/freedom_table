import 'package:flutter/material.dart';

enum CellWidthType { flex, fixed }

enum CellType { header, body }

const double minCellWidth = 80;

class FreedomTableTheme {
  /// table divider color
  final Color dividerColor;
  final Color backgroundColor;

  /// body cell hover color
  final Color hoverColor;
  final Color pagerBorderColor;
  final Color pagerTextColor;
  final Color pagerTextFocusedColor;
  final Color pagerTextDisabledColor;
  final Color pagerFocusedBackgroundColor;
  FreedomTableTheme({
    this.dividerColor = const Color(0xffe6e6e6),
    this.backgroundColor = const Color(0xfff2f2f2),
    this.hoverColor = const Color(0xfff6f6f6),
    this.pagerBorderColor = const Color(0xffcccccc),
    this.pagerTextColor = const Color(0xff666666),
    this.pagerTextFocusedColor = const Color(0xffffffff),
    this.pagerTextDisabledColor = const Color(0xffcccccc),
    this.pagerFocusedBackgroundColor = const Color(0xff5078F0),
  });
}

class FreedomTableHeaderCell {
  /// set the header cell width in flex mode
  int? flex;

  /// set the header cell width in fixed width
  double? fixedWidth;

  /// child widget
  Widget child;

  /// wether the column which the header cell belong is fixed when table is horizontal scroll
  /// when the column is fixed, please ensure the column's child cell DON'T have colspan!!!
  bool isFixedColumn;

  /// header cell width type is flex width or fixed width
  late CellWidthType widthType;
  FreedomTableHeaderCell({
    this.flex,
    this.fixedWidth,
    required this.child,
    this.isFixedColumn = false,
  }) {
    if (fixedWidth != null) {
      widthType = CellWidthType.fixed;
    } else {
      widthType = CellWidthType.flex;
      flex ??= 1;
    }
  }
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return "(widthType: $widthType, flex: $flex, fixedWidth: $fixedWidth, child: $child)";
  }
}

class FreedomTableBodyCell {
  final int colspan;
  final int rowspan;
  Widget child;
  dynamic data;
  FreedomTableBodyCell({
    required this.child,
    this.colspan = 1,
    this.rowspan = 1,
    this.data,
  });
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return "(colspan: $colspan, rowspan: $rowspan, child: $child, data: $data)";
  }
}

class FreedomTableData extends ChangeNotifier {
  List<List<FreedomTableBodyCell>> rows = [];

  void updateData(List<List<FreedomTableBodyCell>> rows) {
    this.rows = rows;
    notifyListeners();
  }
}
