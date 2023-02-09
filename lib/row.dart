import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/theme_model.dart';
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
  double constrainWidth = 0;
  double totalFixedWidth = 0;
  int totalFlex = 0;
  int flexCellCount = 0;
  double finalRowWidth = 0;
  double? maxCellHeight;

  @override
  void initState() {
    super.initState();
    constrainWidth = widget.constrains.maxWidth;
  }

  List<Widget> getCells() {
    totalFixedWidth = 0;
    totalFlex = 0;
    flexCellCount = 0;
    finalRowWidth = 0;

    List<Widget> cellWidgets = [];
    for (var cell in widget.headerCells) {
      if (cell.widthType == CellWidthType.flex) {
        totalFlex += cell.flex ?? 1;
        flexCellCount++;
      } else {
        totalFixedWidth += cell.fixedWidth ?? 0;
      }
    }
    if (totalFixedWidth + flexCellCount * minCellWidth >= constrainWidth) {
      // 超过限制，需要滚动
      finalRowWidth = totalFixedWidth + flexCellCount * minCellWidth;
    } else {
      finalRowWidth = constrainWidth;
    }

    for (var cell in widget.headerCells) {
      double cellWidth = 0;
      if (cell.widthType == CellWidthType.fixed) {
        cellWidth = cell.fixedWidth ?? minCellWidth;
      } else {
        cellWidth =
            ((finalRowWidth - totalFixedWidth) / totalFlex) * cell.flex!;
      }
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
          child: cell.child,
        ),
      ));
    }

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   print("** done **");
    // });

    return cellWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: getCells(),
    );
  }
}
