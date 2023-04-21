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
  final void Function(double left, double top, double width, double height)?
      bodyCellOnTap;
  final void Function(double left, double top, double width, double height)?
      bodyCellOnSecondaryTap;

  const FreedomTableBodyCells({
    super.key,
    required this.rows,
    this.bodyCellOnTap,
    this.bodyCellOnSecondaryTap,
  });

  @override
  State<FreedomTableBodyCells> createState() => _FreedomTableBodyCellsState();
}

class _FreedomTableBodyCellsState extends State<FreedomTableBodyCells> {
  // 列号
  // int currentColnumber = 0;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      html.document.body!
          .addEventListener('contextmenu', (event) => event.preventDefault());
    }
  }

  void generateColspan() {
    TableModel tableModel = Provider.of<TableModel>(context, listen: false);
    List<double> headerCellWidths = tableModel.headerCellWidths;

    // ** 每行 **
    for (var bodyRow in widget.rows) {
      // 行号
      int rownumber = widget.rows.indexOf(bodyRow);
      // 列号
      int colnumber = 0;

      Map<int, bool> updatedOccupiedRow = {};
      // init
      for (var headerWidth in headerCellWidths) {
        int index = headerCellWidths.indexOf(headerWidth);
        updatedOccupiedRow.addEntries({index: false}.entries);
      }

      // ** 每列 **
      for (var cell in bodyRow) {
        // 记录跨列
        int currentColnumber = colnumber;
        for (int i = 1; i < cell.colspan; i++) {
          updatedOccupiedRow[currentColnumber + i] = true;
          colnumber++;
        }
        colnumber++;
        // print(updatedOccupiedRow);
      }
      tableModel.updateOccupiedTable(rownumber, updatedOccupiedRow);
    }
  }

  void generateRowspan() {
    TableModel tableModel = Provider.of<TableModel>(context, listen: false);

    // ** 每行 **
    for (var bodyRow in widget.rows) {
      // 行号
      int rownumber = widget.rows.indexOf(bodyRow);
      // 列号
      int colnumber = 0;

      // ** 每列 **
      for (var cell in bodyRow) {
        // 记录跨行
        for (int i = 1; i < cell.rowspan; i++) {
          tableModel.updateOccupiedTable(rownumber + i, {colnumber: true});
          for (int j = 1; j < cell.colspan; j++) {
            tableModel
                .updateOccupiedTable(rownumber + i, {colnumber + j: true});
          }
        }

        colnumber++;
      }
    }
  }

  double getCellTop(Map<int, double?> rowMaxHeights, int rownumber) {
    double top = 0;
    for (var i = 0; i < rownumber; i++) {
      top += rowMaxHeights[i] ?? 0;
    }
    return top;
  }

  double getCellLeft(Map<int, bool> occupiedTableRow,
      List<double> headerCellWidths, int colnumber) {
    double left = 0;
    int delayIndex = 0;
    for (var i = 0; i < occupiedTableRow.length; i++) {
      if (occupiedTableRow[i] == true && i <= colnumber) {
        delayIndex++;
      }
    }
    if (occupiedTableRow[colnumber] == true) {
      int nextIndex = colnumber + 1;
      while ((nextIndex < occupiedTableRow.length &&
          occupiedTableRow[nextIndex++] == true)) {
        delayIndex++;
      }
    }
    // if (delayIndex > 0) {
    //   print("colnumber=$colnumber  delayIndex=$delayIndex");
    // }
    for (var i = 0; i < colnumber + delayIndex; i++) {
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
      int colnumber) {
    int delayIndex = 0;
    for (var i = 0; i < occupiedTableRow.length; i++) {
      if (occupiedTableRow[i] == true && i <= colnumber) {
        delayIndex++;
      }
    }
    if (occupiedTableRow[colnumber] == true) {
      int nextIndex = colnumber + 1;
      while ((nextIndex < occupiedTableRow.length &&
          occupiedTableRow[nextIndex++] == true)) {
        delayIndex++;
      }
    }
    double cellWidth = 0;
    for (int i = 0; i < cell.colspan; i++) {
      if (colnumber + i + delayIndex > headerCellWidths.length - 1) break;
      cellWidth += headerCellWidths[colnumber + i + delayIndex];
      // if (delayIndex > 0) {
      //   print(colnumber + i + delayIndex);
      //   print(cellWidth);
      // }
    }
    return cellWidth;
  }

  Widget getCellWidget(FreedomTableBodyCell cell, double top, double left,
      double cellWidth, double? cellHeight, bool isFirstCellInRow,
      [void Function(Size)? onChange]) {
    TableModel tableModel = Provider.of<TableModel>(context);
    return Positioned(
      top: top,
      left: left,
      child: MeasureSize(
        onChange: onChange ?? (size) => {},
        child: GestureDetector(
          onTap: () {
            // print('左键点击');
            if (widget.bodyCellOnTap != null) {
              widget.bodyCellOnTap!(left, tableModel.headerMaxHeight + top,
                  cellWidth, cellHeight ?? 0);
            }
          },
          onSecondaryTap: () {
            // print('右键点击');
            if (widget.bodyCellOnSecondaryTap != null) {
              widget.bodyCellOnSecondaryTap!(left,
                  tableModel.headerMaxHeight + top, cellWidth, cellHeight ?? 0);
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

  List<Widget> getCells() {
    TableModel tableModel = Provider.of<TableModel>(context, listen: false);
    Map<int, Map<int, bool>> occupiedTable = tableModel.occupiedTable;
    List<double> headerCellWidths = tableModel.headerCellWidths;
    Map<int, double?> rowMaxHeights = tableModel.rowMaxHeights;
    List<Widget> widgets = [];
    // print("**********");
    // print("headerCellWidths");
    // print(headerCellWidths);
    // print("rowMaxHeights");
    // print(rowMaxHeights);
    // print("occupiedTable");
    // print(occupiedTable);

    // ** 每行 **
    for (var bodyRow in widget.rows) {
      // 行号
      int rownumber = widget.rows.indexOf(bodyRow);
      tableModel.updateOccupiedTable(rownumber, {});
      Map<int, bool> occupiedTableRow = occupiedTable[rownumber]!;

      int currentColnumber = 0;

      // ** 每列 **
      for (var cell in bodyRow) {
        // 配置span超过总个数，忽略后面的cell
        if (currentColnumber > headerCellWidths.length - 1) break;

        double top = getCellTop(rowMaxHeights, rownumber);
        double left =
            getCellLeft(occupiedTableRow, headerCellWidths, currentColnumber);
        double cellWidth = getCellWidth(
            cell, occupiedTableRow, headerCellWidths, currentColnumber);

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

        widgets.add(getCellWidget(
          cell,
          top,
          left,
          cellWidth,
          cellSpanHeight == 0 ? rowMaxHeights[rownumber] : cellSpanHeight,
          occupiedTableRow[0] == false && currentColnumber == 0,
          cellSpanHeight == 0
              ? (size) {
                  if (size.width > 0 && size.height > 0) {
                    // print("** size **");
                    // print(size);
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
        ));

        // print('$rownumber $currentColnumber');

        currentColnumber++;
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    generateColspan();
    generateRowspan();

    TableModel tableModel = Provider.of<TableModel>(context);
    double tableWidth =
        tableModel.headerCellWidths.reduce((value, element) => value + element);
    double tableBodyHeight = 0;
    tableModel.rowMaxHeights.forEach(
      (key, value) => tableBodyHeight += value ?? 0,
    );

    return SizedBox(
      width: tableWidth,
      // a Stack widget must have at least one item which can have a static size at build time
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: tableBodyHeight,
            ),
            ...getCells()
          ],
        ),
      ),
    );
  }
}
