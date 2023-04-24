import 'package:flutter/material.dart';

enum CellWidthType { flex, fixed }

enum CellType { header, body }

const double minCellWidth = 80;

class FreedomTableTheme {
  final Color dividerColor;
  final Color backgroundColor;
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
  late CellWidthType widthType;
  int? flex;
  double? fixedWidth;
  Widget child;
  FreedomTableHeaderCell({
    this.flex,
    this.fixedWidth,
    required this.child,
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
