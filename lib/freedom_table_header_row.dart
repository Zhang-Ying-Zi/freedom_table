import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
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
  List<FreedomTableHeaderCell>? preHeaderCells;

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

  @override
  void initState() {
    // print("** header initState **");
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FreedomTableHeaderRow oldWidget) {
    // print("** header didUpdateWidget **");
    super.didUpdateWidget(oldWidget);
    if (preHeaderCells != null && preHeaderCells != widget.headerCells) {
      setState(() {
        setCells();
      });
    }
  }

  void setCells() {
    // print("** set header cell **");

    constrainRowWidth = widget.constrains.maxWidth;

    HeaderModel headerModel = HeaderModel.instance;

    double minCellWidthInFlexMode = widget.minCellWidthInFlexMode ?? minCellWidth;

    List<Widget> scrollableHeaderCellWidgets = [];

    totalFixedWidth = 0;
    totalFlex = 0;
    cellFlexCount = 0;
    finalRowWidth = 0;
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

      if (colnumber >= HeaderModel.instance.fixedHeaderCellWidgets.length) {
        scrollableHeaderCellWidgets.add(cellWidget);
      }
    }

    headerModel.scrollableHeaderCellWidgets = scrollableHeaderCellWidgets;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      headerModel.setHeaderCellWidths(cellWidths);
    });

    preHeaderCells = widget.headerCells;
  }

  @override
  Widget build(BuildContext context) {
    if (HeaderModel.instance.fixedHeaderCellWidgets.isEmpty) setCells();
    return Row(
      children: [...HeaderModel.instance.scrollableHeaderCellWidgets],
    );
  }
}
