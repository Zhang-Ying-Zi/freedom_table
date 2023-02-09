import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/theme_model.dart';
import './models/table_model.dart';
import 'package:flutter/scheduler.dart';
import "types.dart";
import 'cell.dart';
import 'utils.dart';

class FreedomTableBodyRow extends StatefulWidget {
  // body行号
  final int rownumber;
  final List<FreedomTableBodyCell> bodyCells;

  const FreedomTableBodyRow({
    super.key,
    required this.bodyCells,
    required this.rownumber,
  });

  @override
  State<FreedomTableBodyRow> createState() => _FreedomTableBodyRowState();
}

class _FreedomTableBodyRowState extends State<FreedomTableBodyRow> {
  // cells最高高度
  double? maxCellHeight;

  @override
  void initState() {
    super.initState();
  }

  // double getCellWidth(
  //     List<double> cellWidths, FreedomTableBodyCell cell, int rowCellIndex) {
  //   double cellWidth = 0;
  //   for (int i = 1; i <= cell.colspan; i++, rowCellIndex++) {
  //     // 配置span超过总个数，忽略
  //     if (rowCellIndex > cellWidths.length - 1) break;
  //     cellWidth += cellWidths[rowCellIndex];
  //   }
  //   return cellWidth;
  // }

  List<Widget> getCells() {
    TableModel tableModel = Provider.of<TableModel>(context, listen: false);
    List<double> cellWidths = tableModel.cellWidths;
    List<Widget> cellWidgets = [];

    int rowCellIndex = 0;
    for (var cell in widget.bodyCells) {
      int colnumber = widget.bodyCells.indexOf(cell);
      // 配置span超过总个数，忽略后面的cell
      if (rowCellIndex >= cellWidths.length) break;
      double cellWidth = 0;
      double cellHeight = 0;
      for (int i = 1; i <= cell.colspan; i++, rowCellIndex++) {
        // 配置span超过总个数，忽略
        if (rowCellIndex > cellWidths.length - 1) break;
        cellWidth += cellWidths[rowCellIndex];
      }
      if (cell.rowspan > 1) {
        List<int> rownumbers = [];
        for (int i = 0; i < cell.rowspan; i++) {
          rownumbers.add(widget.rownumber + i);
        }
        tableModel.addColSpan(colnumber, rownumbers);
      }
      Map<int, List<List<int>>> colSpans = tableModel.colSpans;
      int colnumberInSpans = colSpans.keys
          .firstWhere((element) => element == colnumber, orElse: () => -1);
      if (colnumberInSpans != -1) {
        // 存在跨列
        for (var rowsInSpansList in colSpans[colnumberInSpans]!) {
          for (var rowsInSpan in rowsInSpansList) {
            if (rowsInSpan == widget.rownumber &&
                rowsInSpansList.indexOf(rowsInSpan) == 0) {
              // 要跨列了！
              // UNDO 计算跨列高度
            } else if (rowsInSpan == widget.rownumber &&
                rowsInSpansList.indexOf(rowsInSpan) != 0) {
              // 增加空白区域
              cellWidgets.add(
                FreedomTableCell(
                  width: cellWidth,
                  height: maxCellHeight,
                  leftSibling: cellWidgets.isNotEmpty ? cellWidgets.last : null,
                ),
              );
              // 重新计算下一个cell宽度
              cellWidth = 0;
              for (int i = 1; i <= cell.colspan; i++, rowCellIndex++) {
                // 配置span超过总个数，忽略
                if (rowCellIndex > cellWidths.length - 1) break;
                cellWidth += cellWidths[rowCellIndex];
              }
            }
          }
        }
      }
      cellWidgets.add(
        MeasureSize(
          onChange: (size) {
            // print("** size **");
            // print(size);
            if (maxCellHeight == null || maxCellHeight! < size.height) {
              setState(() {
                maxCellHeight = size.height;
                tableModel.addRowMaxHeight(widget.rownumber, maxCellHeight!);
              });
            }
          },
          child: FreedomTableCell(
            width: cellWidth,
            height: maxCellHeight,
            leftSibling: cellWidgets.isNotEmpty ? cellWidgets.last : null,
            child: cell.child,
          ),
        ),
      );
    }

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   print("** done **");
    // });

    return cellWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return
        // Container(
        //   decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        //   child:
        Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: getCells(),
      // ),
    );
  }
}
