import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/header_model.dart';
import "types.dart";
import 'cell.dart';
import 'utils.dart';

class FreedomTableHeaderRow extends StatefulWidget {
  /// header constrains
  final BoxConstraints constrains;

  /// header cells
  final List<FreedomTableHeaderCell> headerCells;

  /// min Cell Width In Flex Mode
  final double? minCellWidthInFlexMode;

  const FreedomTableHeaderRow({
    super.key,
    required this.headerCells,
    required this.constrains,
    this.minCellWidthInFlexMode,
  });

  @override
  State<FreedomTableHeaderRow> createState() => _FreedomTableHeaderRowState();
}

class _FreedomTableHeaderRowState extends State<FreedomTableHeaderRow> {
  /// 原始总宽度
  double constrainRowWidth = 0;

  /// 最终总宽度
  double finalRowWidth = 0;

  /// cells总固定宽度
  double totalFixedWidth = 0;

  /// cells总flex比例之和
  int totalFlex = 0;

  /// cells为flex的个数
  int cellFlexCount = 0;

  /// cells最高高度
  double? maxCellHeight;

  /// cell widths
  List<double> cellWidths = [];

  // /// fixed Header Cell Widgets
  // List<Widget> fixedHeaderCellWidgets = [];

  /// scrollable Heade Cell Widgets
  List<Widget> scrollableHeaderCellWidgets = [];

  // /// fixed Column Width
  // double fixedColumnWidth = 0;

  // /// fixed Column Count
  // int fixedColumnCount = 0;

  @override
  void initState() {
    super.initState();
  }

  void setCells() {
    // print("** set header cell **");

    constrainRowWidth = widget.constrains.maxWidth;

    HeaderModel headerModel = Provider.of<HeaderModel>(context, listen: false);

    double minCellWidthInFlexMode = widget.minCellWidthInFlexMode ?? minCellWidth;

    totalFixedWidth = 0;
    totalFlex = 0;
    cellFlexCount = 0;
    finalRowWidth = 0;
    // fixedHeaderCellWidgets = [];
    scrollableHeaderCellWidgets = [];
    // fixedColumnWidth = 0;
    // fixedColumnCount = 0;
    cellWidths = [];

    for (var cell in widget.headerCells) {
      if (cell.widthType == CellWidthType.flex) {
        totalFlex += cell.flex ?? 1;
        cellFlexCount++;
      } else {
        totalFixedWidth += cell.fixedWidth ?? 0;
      }
    }
    if (totalFixedWidth + totalFlex * minCellWidthInFlexMode >= constrainRowWidth) {
      // 超过限制，需要滚动
      finalRowWidth = totalFixedWidth + totalFlex * minCellWidthInFlexMode;
    } else {
      finalRowWidth = constrainRowWidth;
    }

    for (var cell in widget.headerCells) {
      int colnumber = widget.headerCells.indexOf(cell);
      double cellWidth = 0;
      if (cell.widthType == CellWidthType.fixed) {
        cellWidth = cell.fixedWidth ?? minCellWidthInFlexMode;
      } else {
        cell.flex ??= 1;
        cellWidth = ((finalRowWidth - totalFixedWidth) / totalFlex) * cell.flex!;
      }
      cellWidths.add(cellWidth);

      Widget cellWidget = MeasureSize(
        onChange: (size) {
          // print(size);
          if (maxCellHeight == null || maxCellHeight! < size.height) {
            setState(() {
              maxCellHeight = size.height;
              headerModel.headerMaxHeight = maxCellHeight ?? 0;
            });
          }
        },
        child: FreedomTableCell(
          width: cellWidth,
          height: maxCellHeight,
          type: CellType.header,
          isFirstCellInRow: colnumber == 0,
          child: cell.child,
        ),
      );
      // if (cell.isFixedColumn) {
      //   fixedColumnWidth += cellWidth;
      //   fixedColumnCount++;
      //   double left = 0;
      //   for (var i = 0; i < colnumber; i++) {
      //     left += cellWidths[i];
      //   }
      //   fixedHeaderCellWidgets.add(Positioned(left: left, child: cellWidget));
      // } else {
      //   scrollableHeaderCellWidgets.add(cellWidget);
      // }
      scrollableHeaderCellWidgets.add(cellWidget);
    }

    headerModel.scrollableHeaderCellWidgets = scrollableHeaderCellWidgets;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      headerModel.setHeaderCellWidths(cellWidths);
      // headerModel.setFixedHeaderCellWidgets(fixedHeaderCellWidgets);
      // headerModel.setFixedColumnWidth(fixedColumnWidth);
      // headerModel.setFixedColumnCount(fixedColumnCount);
    });
  }

  @override
  Widget build(BuildContext context) {
    setCells();
    return Row(
      children: [...scrollableHeaderCellWidgets],
    );
  }
}
