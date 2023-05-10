import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/table_model.dart';
import "types.dart";
import 'cell.dart';
import 'utils.dart';

class FreedomTableHeaderRow extends StatefulWidget {
  final BoxConstraints constrains;
  final List<FreedomTableHeaderCell> headerCells;
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
  List<double> cellWidths = [];

  List<Widget> fixedHeaderCellWidgets = [];
  List<Widget> scrollableHeaderCellWidgets = [];
  double fixedColumnWidth = 0;
  int fixedColumnCount = 0;

  @override
  void initState() {
    super.initState();
    constrainRowWidth = widget.constrains.maxWidth;

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   TableModel tableModel = Provider.of<TableModel>(context, listen: false);
    //   tableModel.initCellWidths(cellWidths);
    //   tableModel.updateFixedHeaderCellWidgets(fixedHeaderCellWidgets);
    //   tableModel.updateFixedColumnWidth(fixedColumnWidth);
    //   tableModel.updateFixedColumnCount(fixedColumnCount);
    // });
  }

  void setCells() {
    // TableModel tableModel = Provider.of<TableModel>(context, listen: false);
    TableModel tableModel = TableModel.instance;

    double minCellWidthInFlexMode =
        widget.minCellWidthInFlexMode ?? minCellWidth;

    totalFixedWidth = 0;
    totalFlex = 0;
    cellFlexCount = 0;
    finalRowWidth = 0;

    fixedHeaderCellWidgets = [];
    scrollableHeaderCellWidgets = [];
    fixedColumnWidth = 0;
    fixedColumnCount = 0;
    cellWidths = [];

    for (var cell in widget.headerCells) {
      if (cell.widthType == CellWidthType.flex) {
        totalFlex += cell.flex ?? 1;
        cellFlexCount++;
      } else {
        totalFixedWidth += cell.fixedWidth ?? 0;
      }
    }
    if (totalFixedWidth + totalFlex * minCellWidthInFlexMode >=
        constrainRowWidth) {
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
        cellWidth =
            ((finalRowWidth - totalFixedWidth) / totalFlex) * cell.flex!;
      }
      cellWidths.add(cellWidth);

      Widget cellWidget = MeasureSize(
        onChange: (size) {
          // print("** size **");
          // print(size);
          if (maxCellHeight == null || maxCellHeight! < size.height) {
            setState(() {
              maxCellHeight = size.height;
              tableModel.updateHeaderMaxHeight(maxCellHeight ?? 0);
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
      if (cell.isFixedColumn) {
        fixedColumnWidth += cellWidth;
        fixedColumnCount++;
        double left = 0;
        for (var i = 0; i < colnumber; i++) {
          left += cellWidths[i];
        }
        fixedHeaderCellWidgets.add(Positioned(left: left, child: cellWidget));
      } else {
        scrollableHeaderCellWidgets.add(cellWidget);
      }
    }

    tableModel.initCellWidths(cellWidths);
    tableModel.updateFixedHeaderCellWidgets(fixedHeaderCellWidgets);
    tableModel.updateFixedColumnWidth(fixedColumnWidth);
    tableModel.updateFixedColumnCount(fixedColumnCount);
  }

  @override
  Widget build(BuildContext context) {
    setCells();
    return Row(
      children: [...scrollableHeaderCellWidgets],
    );
  }
}
