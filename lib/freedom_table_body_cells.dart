import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/theme_model.dart';
import './models/table_model.dart';
import 'package:flutter/scheduler.dart';
import "types.dart";
import 'cell.dart';
import 'utils.dart';

class FreedomTableBodyCells extends StatefulWidget {
  final List<List<FreedomTableBodyCell>> bodys;

  const FreedomTableBodyCells({
    super.key,
    required this.bodys,
  });

  @override
  State<FreedomTableBodyCells> createState() => _FreedomTableBodyCellsState();
}

class _FreedomTableBodyCellsState extends State<FreedomTableBodyCells> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> getCells() {
    TableModel tableModel = Provider.of<TableModel>(context, listen: false);
    Map<int, List<List<int>>> colSpans = tableModel.colSpans;
    List<double> cellWidths = tableModel.cellWidths;
    Map<int, double> rowMaxHeights = tableModel.rowMaxHeights;
    List<Widget> widgets = [];

    // ** 每行 **
    for (var rowCells in widget.bodys) {
      // 行号
      int rownumber = widget.bodys.indexOf(rowCells) + 1;
      // 行内cells最高高度
      double? maxRowCellHeight;
      int countedColnumber = 0;
      // ** 每列 **
      for (var cell in rowCells) {
        // 配置span超过总个数，忽略后面的cell
        if (countedColnumber >= cellWidths.length) break;
        // 列号
        int colnumber = rowCells.indexOf(cell);

        double top = 0;
        double left = 0;

        rowMaxHeights.forEach((key, value) {
          if (key < rownumber) {
            top += value;
          }
        });
        // print("top : $top");

        for (var element in cellWidths) {
          if (cellWidths.indexOf(element) < countedColnumber) {
            left += element;
          }
        }
        // print("left : $left");

        // 计算宽度
        double cellWidth = 0;
        for (int i = 1; i <= cell.colspan; i++, countedColnumber++) {
          if (countedColnumber > cellWidths.length - 1) break;
          cellWidth += cellWidths[countedColnumber];
        }

        // 记录跨列
        if (cell.rowspan > 1) {
          List<int> rownumbers = [];
          for (int i = 0; i < cell.rowspan; i++) {
            rownumbers.add(rownumber + i);
          }
          tableModel.addColSpan(colnumber, rownumbers);
        }

        // // 检查是否跨列
        // double cellSpanHeight = 0;
        bool isAdded = false;
        // int colnumberInSpans = colSpans.keys
        //     .firstWhere((element) => element == colnumber, orElse: () => -1);
        // if (colnumberInSpans != -1) {
        //   // 存在跨列
        //   for (var rowsInSpansList in colSpans[colnumberInSpans]!) {
        //     for (var rowsInSpan in rowsInSpansList) {
        //       if (rowsInSpan == rownumber &&
        //           rowsInSpansList.indexOf(rowsInSpan) == 0) {
        //         // 要跨列了！
        //         // 计算跨列高度
        //         rowMaxHeights.forEach((row, height) {
        //           for (var eachrow in rowsInSpansList) {
        //             if (row == eachrow) {
        //               cellSpanHeight += height;
        //             }
        //           }
        //         });
        //         widgets.add(
        //           Positioned(
        //             top: top,
        //             left: left,
        //             child: FreedomTableCell(
        //               width: cellWidth,
        //               height: cellSpanHeight,
        //               row: rownumber,
        //               column: colnumber,
        //               child: cell.child,
        //             ),
        //           ),
        //         );
        //         isAdded = true;
        //         print(cellSpanHeight);
        //       } else if (rowsInSpan == rownumber &&
        //           rowsInSpansList.indexOf(rowsInSpan) != 0) {
        //         // 增加空白区域
        //         widgets.add(
        //           Positioned(
        //             top: top,
        //             left: left,
        //             child: FreedomTableCell(
        //               width: cellWidth,
        //               height: maxRowCellHeight,
        //               row: rownumber,
        //               column: colnumber,
        //             ),
        //           ),
        //         );
        //         // 重新计算下一个cell宽度
        //         cellWidth = 0;
        //         for (int i = 1;
        //             i <= cell.colspan;
        //             i++, countedColnumber++) {
        //           if (countedColnumber > cellWidths.length - 1) break;
        //           cellWidth += cellWidths[countedColnumber];
        //         }
        //       }
        //     }
        //   }
        // }

        // 单个cell
        if (!isAdded) {
          widgets.add(
            Positioned(
              top: top,
              left: left,
              child: MeasureSize(
                onChange: (size) {
                  // print("** size **");
                  // print(size);
                  if (maxRowCellHeight == null ||
                      maxRowCellHeight! < size.height) {
                    setState(() {
                      maxRowCellHeight = size.height;
                      tableModel.addRowMaxHeight(rownumber, maxRowCellHeight!);
                    });
                  }
                },
                child: FreedomTableCell(
                  width: cellWidth,
                  height: maxRowCellHeight,
                  row: rownumber,
                  column: colnumber,
                  child: cell.child,
                ),
              ),
            ),
          );
        }
      }
    }

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   print("** done **");
    // });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    double tableWidth = Provider.of<TableModel>(context, listen: false)
        .cellWidths
        .reduce((value, element) => value + element);

    // a Stack widget must have at least one item which can have a static size at build time
    return Container(
      width: tableWidth,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Stack(
        children: [Container(), ...getCells()],
      ),
    );
  }
}
