import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/table_model.dart';
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
  // 列号
  int currentColnumber = 0;

  @override
  void initState() {
    super.initState();
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
    rowMaxHeights.forEach((key, value) {
      if (key < rownumber) {
        top += value ?? 0;
      }
    });
    return top;
  }

  double getCellLeft(Map<int, bool> occupiedTableRow,
      List<double> headerCellWidths, int colnumber) {
    double left = 0;
    for (var element in headerCellWidths) {
      if (headerCellWidths.indexOf(element) < colnumber) {
        left += element;
      }
    }
    return left;
  }

  // 计算 body cell 宽度
  double getCellWidth(
      FreedomTableBodyCell cell,
      Map<int, bool> occupiedTableRow,
      List<double> headerCellWidths,
      int colnumber) {
    double cellWidth = 0;
    for (int i = 0; i < cell.colspan; i++) {
      if (colnumber + i > headerCellWidths.length - 1) break;
      cellWidth += headerCellWidths[colnumber + i];
    }
    return cellWidth;
  }

  Widget getCellWidget(FreedomTableBodyCell cell, double top, double left,
      double cellWidth, double? cellHeight, int currentColnumber,
      [void Function(Size)? onChange]) {
    return Positioned(
      top: top,
      left: left,
      child: MeasureSize(
        onChange: onChange ?? (size) => {},
        child: FreedomTableCell(
          width: cellWidth,
          height: cellHeight,
          colnumber: currentColnumber,
          child: cell.child,
        ),
      ),
    );
  }

  void setCurrenColnumber(Map<int, bool> occupiedTableRow) {
    bool isMatch = false;
    occupiedTableRow.forEach((key, value) {
      if (key == currentColnumber && value) {
        isMatch = true;
      }
      if (isMatch && value) {
        currentColnumber++;
      }
    });
  }

  List<Widget> getCells() {
    TableModel tableModel = Provider.of<TableModel>(context, listen: false);
    Map<int, Map<int, bool>> occupiedTable = tableModel.occupiedTable;
    List<double> headerCellWidths = tableModel.headerCellWidths;
    Map<int, double?> rowMaxHeights = tableModel.rowMaxHeights;
    List<Widget> widgets = [];

    // ** 每行 **
    for (var bodyRow in widget.rows) {
      // 行号
      int rownumber = widget.rows.indexOf(bodyRow);
      tableModel.updateOccupiedTable(rownumber, {});
      Map<int, bool> occupiedTableRow = occupiedTable[rownumber]!;

      currentColnumber = 0;

      // ** 每列 **
      for (var cell in bodyRow) {
        setCurrenColnumber(occupiedTableRow);

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
          for (var i = rownumber + 1; i < widget.rows.length; i++) {
            if (occupiedTable.keys.contains(i) &&
                occupiedTable[i]!.keys.contains(currentColnumber) &&
                occupiedTable[i]![currentColnumber]!) {
              if (i == rownumber + 1) {
                cellSpanHeight += rowMaxHeights[rownumber] ?? 0;
              }
              cellSpanHeight += rowMaxHeights[i] ?? 0;
            }
          }
        }

        widgets.add(getCellWidget(
          cell,
          top,
          left,
          cellWidth,
          cellSpanHeight == 0 ? rowMaxHeights[rownumber] : cellSpanHeight,
          currentColnumber,
          cellSpanHeight == 0
              ? (size) {
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
              : null,
        ));

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
