import 'package:flutter/material.dart';

enum CellWidthType { flex, fixed }

enum CellType { header, body }

const double minCellWidth = 40;

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
}

class FreedomTableBodyCell {
  final int colspan;
  final int rowspan;
  Widget child;
  FreedomTableBodyCell({
    required this.child,
    this.colspan = 1,
    this.rowspan = 1,
  });
}
