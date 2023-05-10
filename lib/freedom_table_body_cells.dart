import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/table_model.dart';
import "types.dart";
import 'cell.dart';
import 'utils.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;

class FreedomTableBodyCells extends StatefulWidget {
  final List<List<FreedomTableBodyCell>> rows;
  final ScrollController verticalScrollController;
  final ScrollController horizontalScrollController;
  final void Function(
      FreedomTableBodyCell childCell,
      double left,
      double top,
      double width,
      double height,
      double scrollLeft,
      double scrollTop)? bodyCellOnTap;
  final void Function(
      FreedomTableBodyCell childCell,
      double left,
      double top,
      double width,
      double height,
      double scrollLeft,
      double scrollTop)? bodyCellOnSecondaryTap;
  final void Function(List<Widget> fixedBodyCellWidgets)
      getFixedBodyCellWidgets;

  const FreedomTableBodyCells({
    super.key,
    required this.rows,
    this.bodyCellOnTap,
    this.bodyCellOnSecondaryTap,
    required this.verticalScrollController,
    required this.horizontalScrollController,
    required this.getFixedBodyCellWidgets,
  });

  @override
  State<FreedomTableBodyCells> createState() => _FreedomTableBodyCellsState();
}

class _FreedomTableBodyCellsState extends State<FreedomTableBodyCells> {
  List<Widget> fixedBodyCellWidgets = [];
  List<Widget> scrollableBodyCellWidgets = [];

  @override
  void initState() {
    // print("initState");
    super.initState();

    if (kIsWeb) {
      html.document.body!
          .addEventListener('contextmenu', (event) => event.preventDefault());
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    // print("didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  void computeSpan() {
    // TableModel tableModel = Provider.of<TableModel>(context, listen: false);
    TableModel tableModel = TableModel.instance;
    List<double> headerCellWidths = tableModel.headerCellWidths;
    Map<int, Map<int, bool>> occupiedTable = tableModel.occupiedTable;

    // init occupiedTable
    for (var bodyRow in widget.rows) {
      int rownumber = widget.rows.indexOf(bodyRow);
      Map<int, bool> updatedOccupiedRow = {};
      for (var headerWidth in headerCellWidths) {
        int index = headerCellWidths.indexOf(headerWidth);
        updatedOccupiedRow.addEntries({index: false}.entries);
      }
      Map<int, bool> occupiedRow =
          occupiedTable.putIfAbsent(rownumber, () => {});
      occupiedRow.addAll(updatedOccupiedRow);
    }

    // ** 每行 **
    for (var bodyRow in widget.rows) {
      int rownumber = widget.rows.indexOf(bodyRow);
      int colnumber = 0;

      int columnDelayIndex = 0;
      for (var i = 0; i < bodyRow.length; i++) {
        if (occupiedTable[rownumber]?[colnumber + i] == true &&
            i <= colnumber) {
          columnDelayIndex++;
        }
      }

      // ** 每列 **
      for (var cell in bodyRow) {
        if (cell.colspan > 1) {
          // 跨列
          for (int i = 1; i < cell.colspan; i++) {
            occupiedTable[rownumber]![colnumber + i + columnDelayIndex] = true;
          }
        }
        if (cell.rowspan > 1) {
          // 跨行
          for (int j = 1; j < cell.rowspan; j++) {
            occupiedTable[rownumber + j]![colnumber + columnDelayIndex] = true;
          }
        }
        if (cell.colspan > 1 && cell.rowspan > 1) {
          // 双跨
          for (int i = 1; i < cell.colspan; i++) {
            for (int j = 1; j < cell.rowspan; j++) {
              occupiedTable[rownumber + j]![colnumber + i + columnDelayIndex] =
                  true;
            }
          }
        }
        colnumber++;
      }

      tableModel.updateOccupiedTable(occupiedTable);
    }
  }

  double getCellTop(Map<int, double?> rowMaxHeights, int rownumber) {
    double top = 0;
    for (var i = 0; i < rownumber; i++) {
      top += rowMaxHeights[i] ?? 0;
    }
    return top;
  }

  double getCellLeft(FreedomTableBodyCell cell, Map<int, bool> occupiedTableRow,
      List<double> headerCellWidths, int rownumber, int colnumber) {
    double left = 0;
    for (var i = 0; i < colnumber; i++) {
      if (i > headerCellWidths.length - 1) break;
      left += headerCellWidths[i];
    }
    return left;
  }

  // 计算 body cell 宽度
  double getCellWidth(
      FreedomTableBodyCell cell,
      Map<int, bool> occupiedTableRow,
      List<double> headerCellWidths,
      int rownumber,
      int colnumber) {
    double cellWidth = 0;
    for (int i = 0; i < cell.colspan; i++) {
      int index = colnumber + i;
      if (index > headerCellWidths.length - 1) {
        break;
      }
      cellWidth += headerCellWidths[index];
    }

    return cellWidth;
  }

  Widget getCellWidget(FreedomTableBodyCell cell, double top, double left,
      double cellWidth, double? cellHeight, bool isFirstCellInRow, bool isFixed,
      [void Function(Size)? onChange]) {
    // TableModel tableModel = Provider.of<TableModel>(context, listen: false);
    TableModel tableModel = TableModel.instance;
    return Positioned(
      top: top,
      left: left,
      child: MeasureSize(
        onChange: onChange ?? (size) => {},
        child: GestureDetector(
          onTap: () {
            // print('左键点击');
            if (widget.bodyCellOnTap != null && !isFixed) {
              widget.bodyCellOnTap!(
                cell,
                left,
                tableModel.headerMaxHeight + top,
                cellWidth,
                cellHeight ?? 0,
                widget.horizontalScrollController.offset,
                widget.verticalScrollController.offset,
              );
            }
          },
          onSecondaryTap: () {
            // print('右键点击');
            if (widget.bodyCellOnSecondaryTap != null && !isFixed) {
              widget.bodyCellOnSecondaryTap!(
                cell,
                left,
                tableModel.headerMaxHeight + top,
                cellWidth,
                cellHeight ?? 0,
                widget.horizontalScrollController.offset,
                widget.verticalScrollController.offset,
              );
            }
          },
          child: FreedomTableCell(
            width: cellWidth,
            height: cellHeight,
            isFirstCellInRow: isFirstCellInRow,
            child: cell.child,
          ),
        ),
      ),
    );
  }

  void setCells() {
    // print("setCells");
    // TableModel tableModel = Provider.of<TableModel>(context, listen: false);
    TableModel tableModel = TableModel.instance;

    Map<int, Map<int, bool>> occupiedTable = tableModel.occupiedTable;
    List<double> headerCellWidths = tableModel.headerCellWidths;
    Map<int, double?> rowMaxHeights = tableModel.rowMaxHeights;

    fixedBodyCellWidgets = [];
    scrollableBodyCellWidgets = [];

    // ** 每行 **
    for (var bodyRow in widget.rows) {
      // 行号
      int rownumber = widget.rows.indexOf(bodyRow);
      Map<int, bool> occupiedTableRow = occupiedTable[rownumber]!;

      int currentColnumber = 0;
      int fixedColumnNumber = 0;

      // ** 每列 **
      for (var cell in bodyRow) {
        // 配置span超过总个数，忽略后面的cell
        // if (currentColnumber > headerCellWidths.length - 1) break;

        while (occupiedTable[rownumber]![currentColnumber] == true) {
          currentColnumber++;
          fixedColumnNumber++;
        }

        double top = getCellTop(rowMaxHeights, rownumber);
        double left = getCellLeft(cell, occupiedTableRow, headerCellWidths,
            rownumber, currentColnumber);
        double cellWidth = getCellWidth(cell, occupiedTableRow,
            headerCellWidths, rownumber, currentColnumber);

        // 计算跨行高度
        double cellSpanHeight = 0;
        if (cell.rowspan > 1) {
          cellSpanHeight = rowMaxHeights[rownumber] ?? 0;
          for (var i = rownumber + 1; i < widget.rows.length; i++) {
            if (occupiedTable.keys.contains(i) &&
                occupiedTable[i]!.keys.contains(currentColnumber)) {
              if (occupiedTable[i]![currentColnumber] == false) {
                break;
              } else {
                cellSpanHeight += rowMaxHeights[i] ?? 0;
              }
            }
          }
        }

        if (fixedColumnNumber < tableModel.fixedColumnCount) {
          // top += tableModel.headerMaxHeight;
        } else {
          left -= tableModel.fixedColumnWidth;
        }

        Widget cellWidget = getCellWidget(
          cell,
          top,
          left,
          cellWidth,
          cellSpanHeight == 0 ? rowMaxHeights[rownumber] : cellSpanHeight,
          occupiedTableRow[0] == false && currentColnumber == 0,
          fixedColumnNumber < tableModel.fixedColumnCount,
          cellSpanHeight == 0
              ? (size) {
                  // if (rownumber == 7)
                  // print("** $rownumber $currentColnumber ${size} **");
                  // print(rowMaxHeights);
                  if (size.width > 0 && size.height > 0) {
                    // print(rowMaxHeights);
                    if (rowMaxHeights[rownumber] == null ||
                        rowMaxHeights[rownumber]! < size.height) {
                      setState(() {
                        rowMaxHeights[rownumber] = size.height;
                        tableModel.addRowMaxHeight(rownumber, size.height);
                      });
                    }
                  }
                }
              : null,
        );

        if (fixedColumnNumber < tableModel.fixedColumnCount) {
          // 目前会执行2次 setCells(), 第一次setCells()中，rowMaxHeights为空
          if (rowMaxHeights.isNotEmpty) fixedBodyCellWidgets.add(cellWidget);
        } else {
          scrollableBodyCellWidgets.add(cellWidget);
        }

        // print('$rownumber $currentColnumber');
        currentColnumber++;
        if (fixedColumnNumber < tableModel.fixedColumnCount) {
          fixedColumnNumber++;
        }
      }
    }

    widget.getFixedBodyCellWidgets(fixedBodyCellWidgets);
  }

  @override
  Widget build(BuildContext context) {
    // print("build");
    computeSpan();
    setCells();
    // TableModel tableModel = Provider.of<TableModel>(context);
    TableModel tableModel = TableModel.instance;
    double tableWidth =
        tableModel.headerCellWidths.reduce((value, element) => value + element);
    tableWidth -= tableModel.fixedColumnWidth;
    double tableBodyHeight = 0;
    tableModel.rowMaxHeights.forEach(
      (key, value) => tableBodyHeight += value ?? 0,
    );

    return SizedBox(
      width: tableWidth,
      // a Stack widget must have at least one item which can have a static size at build time
      child: SingleChildScrollView(
        controller: widget.verticalScrollController,
        child: Stack(
          children: [
            Container(
              height: tableBodyHeight,
            ),
            ...scrollableBodyCellWidgets,
          ],
        ),
      ),
    );
  }
}
