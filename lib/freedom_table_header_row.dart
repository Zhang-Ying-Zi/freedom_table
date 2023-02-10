import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/theme_model.dart';
import './models/table_model.dart';
import 'package:flutter/scheduler.dart';
import "types.dart";
import 'cell.dart';
import 'utils.dart';

class FreedomTableHeaderRow extends StatefulWidget {
  final BoxConstraints constrains;
  final List<FreedomTableHeaderCell> headerCells;

  const FreedomTableHeaderRow({
    super.key,
    required this.headerCells,
    required this.constrains,
  });

  @override
  State<FreedomTableHeaderRow> createState() => _FreedomTableHeaderRowState();
}

class _FreedomTableHeaderRowState extends State<FreedomTableHeaderRow> {
  // 原始总宽度
  double constrainRowWidth = 0;
  // 最终总宽度
  double finalRowWidth = 0;
  // cells总固定宽度
  double totalFixedWidth = 0;
  // cells总flex比例之和
  int totalFlex = 0;
  // cells为flex的个数
  int cellFlexCount = 0;
  // cells最高高度
  double? maxCellHeight;

  @override
  void initState() {
    super.initState();
    constrainRowWidth = widget.constrains.maxWidth;
  }

  List<Widget> getCells() {
    totalFixedWidth = 0;
    totalFlex = 0;
    cellFlexCount = 0;
    finalRowWidth = 0;

    List<Widget> cellWidgets = [];
    List<double> cellWidths = [];

    for (var cell in widget.headerCells) {
      if (cell.widthType == CellWidthType.flex) {
        totalFlex += cell.flex ?? 1;
        cellFlexCount++;
      } else {
        totalFixedWidth += cell.fixedWidth ?? 0;
      }
    }
    if (totalFixedWidth + cellFlexCount * minCellWidth >= constrainRowWidth) {
      // 超过限制，需要滚动
      finalRowWidth = totalFixedWidth + cellFlexCount * minCellWidth;
    } else {
      finalRowWidth = constrainRowWidth;
    }

    for (var cell in widget.headerCells) {
      int colnumber = widget.headerCells.indexOf(cell);
      double cellWidth = 0;
      if (cell.widthType == CellWidthType.fixed) {
        cellWidth = cell.fixedWidth ?? minCellWidth;
      } else {
        cell.flex ??= 1;
        cellWidth =
            ((finalRowWidth - totalFixedWidth) / totalFlex) * cell.flex!;
      }
      cellWidths.add(cellWidth);
      // print("** cellWidth **");
      // print(cellWidth);

      cellWidgets.add(MeasureSize(
        onChange: (size) {
          // print("** size **");
          // print(size);
          if (maxCellHeight == null || maxCellHeight! < size.height) {
            setState(() {
              maxCellHeight = size.height;
            });
          }
        },
        child: FreedomTableCell(
          width: cellWidth,
          height: maxCellHeight,
          type: CellType.header,
          colnumber: colnumber,
          child: cell.child,
        ),
      ));
    }

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   print("** done **");
    // });

    Provider.of<TableModel>(context, listen: false).initCellWidths(cellWidths);

    return cellWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: getCells(),
    );
  }
}
