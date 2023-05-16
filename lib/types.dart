import 'package:flutter/material.dart';

enum CellWidthType { flex, fixed }

enum CellType { header, body }

const double minCellWidth = 100;

class FreedomTableTheme {
  /// table divider color
  final Color dividerColor;

  /// body cell background color
  final Color backgroundColor;

  /// body cell hover color
  final Color hoverColor;

  /// body cell hover color getter, this priority is higher than hoverColor
  final Color Function()? hoverColorGetter;

  /// pager Border Color
  final Color pagerBorderColor;

  /// pager Text Color
  final Color pagerTextColor;

  /// pager Text Focused Color
  final Color pagerTextFocusedColor;

  /// pager Text Disabled Color
  final Color pagerTextDisabledColor;

  /// pager Focused Background Color
  final Color pagerFocusedBackgroundColor;

  FreedomTableTheme({
    this.dividerColor = const Color(0xffe6e6e6),
    this.backgroundColor = const Color(0xfff2f2f2),
    this.hoverColor = const Color(0xfff6f6f6),
    this.hoverColorGetter,
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

  /// when the column is fixed when scroll horizontal, please ensure the column's child cell DON'T have colspan!!!
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
    return "FreedomTableHeaderCell( widthType:$widthType, flex:$flex, fixedWidth:$fixedWidth, child:$child, isFixedColumn:$isFixedColumn)";
  }
}

class FreedomTableBodyCell {
  /// colspan
  final int colspan;

  /// rowspan
  final int rowspan;

  /// child widget
  Widget child;

  /// passed data
  dynamic data;

  FreedomTableBodyCell({
    this.colspan = 1,
    this.rowspan = 1,
    required this.child,
    this.data,
  });

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return "FreedomTableBodyCell( colspan:$colspan, rowspan:$rowspan, child:$child, data:$data )";
  }
}
