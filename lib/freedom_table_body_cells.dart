import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/theme_model.dart';
import './models/table_model.dart';
import 'package:flutter/scheduler.dart';
import "types.dart";
import 'cell.dart';
import 'utils.dart';

class FreedomTableBodyCells extends StatefulWidget {
  final List<List<FreedomTableBodyCell>> rows;

  const FreedomTableBodyCells({
    super.key,
    required this.rows,
  });

  @override
  State<FreedomTableBodyCells> createState() => _FreedomTableBodyCellsState();
}

class _FreedomTableBodyCellsState extends State<FreedomTableBodyCells> {
  // 每行最高高度
  List<double> maxRowHeight = [];

  @override
  void initState() {
    super.initState();
  }

  // 计算 body cell 宽度
  List getCellWidthAndCountedColnumber(
    FreedomTableBodyCell cell,
    List<double> cellWidths,
    int countedColnumber,
  ) {
    double cellWidth = 0;
    for (int i = 1; i <= cell.colspan; i++, countedColnumber++) {
      if (countedColnumber > cellWidths.length - 1) break;
      cellWidth += cellWidths[countedColnumber];
    }
    return [cellWidth, countedColnumber];
  }

  Widget getCellWidget(FreedomTableBodyCell cell, double top, double left,
      int rownumber, int colnumber, double cellWidth, double? cellHeight,
      [void Function(Size)? onChange]) {
    return Positioned(
      top: top,
      left: left,
      child: MeasureSize(
        onChange: onChange ?? (size) => {},
        child: FreedomTableCell(
          width: cellWidth,
          height: cellHeight,
          row: rownumber,
          column: colnumber,
          child: cell.child,
        ),
      ),
    );
  }

  double getCellTop(Map<int, double> rowMaxHeights, int rownumber) {
    double top = 0;
    rowMaxHeights.forEach((key, value) {
      if (key < rownumber) {
        top += value;
      }
    });
    return top;
  }

  double getCellLeft(
    List<double> cellWidths,
    int countedColnumber,
  ) {
    double left = 0;
    for (var element in cellWidths) {
      if (cellWidths.indexOf(element) < countedColnumber) {
        left += element;
      }
    }
    return left;
  }

  List<Widget> getCells() {
    TableModel tableModel = Provider.of<TableModel>(context, listen: false);
    Map<int, List<List<int>>> rowSpans = tableModel.rowSpans;
    List<double> cellWidths = tableModel.cellWidths;
    Map<int, double> rowMaxHeights = tableModel.rowMaxHeights;
    List<Widget> widgets = [];

    // ** 每行 **
    for (var rowCells in widget.rows) {
      // 行号
      int rownumber = widget.rows.indexOf(rowCells) + 1;
      // 已遍历的列号
      int countedColnumber = 0;

      if (maxRowHeight.length < rownumber) {
        maxRowHeight.add(0);
      }

      // ** 每列 **
      for (var cell in rowCells) {
        // 配置span超过总个数，忽略后面的cell
        if (countedColnumber >= cellWidths.length) break;

        // 列号
        int colnumber = rowCells.indexOf(cell);

        double top = 0;
        double left = 0;
        double cellWidth = 0;

        // 计算top
        top = getCellTop(rowMaxHeights, rownumber);
        // print("top : $top");

        // 计算left
        left = getCellLeft(
          cellWidths,
          countedColnumber,
        );
        // print("left : $left");

        // 计算宽度
        List result =
            getCellWidthAndCountedColnumber(cell, cellWidths, countedColnumber);
        cellWidth = result[0];
        countedColnumber = result[1];

        // 记录跨列
        if (cell.rowspan > 1) {
          // UNDO 跨行+跨列
          List<int> rownumbers = [];
          for (int i = 0; i < cell.rowspan; i++) {
            rownumbers.add(rownumber + i);
          }
          tableModel.addRowSpan(colnumber, rownumbers);
        }

        // 检查是否跨列
        double cellSpanHeight = 0;
        bool isAdded = false;
        int colnumberNeededSpan = rowSpans.keys
            .firstWhere((element) => element == colnumber, orElse: () => -1);
        if (colnumberNeededSpan != -1) {
          // 存在跨列
          for (var affectRownumbers in rowSpans[colnumberNeededSpan]!) {
            for (var affectRownumber in affectRownumbers) {
              if (affectRownumber == rownumber &&
                  affectRownumbers.indexOf(affectRownumber) == 0) {
                // 要开始跨列了！
                // 计算跨列高度
                for (var affect in affectRownumbers) {
                  cellSpanHeight += rowMaxHeights[affect] ?? 0;
                }
                // print(cellSpanHeight);
                widgets.add(getCellWidget(
                  cell,
                  top,
                  left,
                  rownumber,
                  colnumber,
                  cellWidth,
                  cellSpanHeight,
                ));
                isAdded = true;
              } else if (affectRownumber == rownumber &&
                  affectRownumbers.indexOf(affectRownumber) != 0) {
                // 被跨的列！
                countedColnumber++;
                // left = getCellLeft(
                //   cellWidths,
                //   countedColnumber,
                // );
              }
            }
          }
        }

        // 单个cell
        if (!isAdded) {
          widgets.add(getCellWidget(
            cell,
            top,
            left,
            rownumber,
            colnumber,
            cellWidth,
            maxRowHeight[rownumber - 1] == 0
                ? null
                : maxRowHeight[rownumber - 1],
            (size) {
              // print("** size **");
              // print(size);
              int index = rownumber - 1;
              if (maxRowHeight[index] < size.height) {
                setState(() {
                  maxRowHeight[index] = size.height;
                  tableModel.addRowMaxHeight(rownumber, maxRowHeight[index]);
                });
              }
            },
          ));
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
    return Consumer<TableModel>(builder: (context, tableMode, child) {
      // print("** build **");
      double tableWidth =
          tableMode.cellWidths.reduce((value, element) => value + element);
      return Container(
        width: tableWidth,
        // decoration: BoxDecoration(
        //   border: Border.all(
        //     color: Colors.black,
        //   ),
        // ),
        // a Stack widget must have at least one item which can have a static size at build time
        child: Stack(
          children: [Container(), ...getCells()],
        ),
      );
    });
  }
}
