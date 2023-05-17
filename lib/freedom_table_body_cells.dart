import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/table_model.dart';
import './models/header_model.dart';
import "types.dart";
import 'cell.dart';
import 'utils.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;

class FreedomTableBodyCells extends StatefulWidget {
  /// rows
  final List<List<FreedomTableBodyCell>> rows;

  /// verticalScrollController
  final ScrollController verticalScrollController;

  /// horizontalScrollController
  final ScrollController horizontalScrollController;

  /// bodyCellOnTap
  final void Function(FreedomTableBodyCell childCell, double left, double top, double width, double height, double scrollLeft, double scrollTop)? bodyCellOnTap;

  /// bodyCellOnSecondaryTap
  final void Function(FreedomTableBodyCell childCell, double left, double top, double width, double height, double scrollLeft, double scrollTop)? bodyCellOnSecondaryTap;

  const FreedomTableBodyCells({
    super.key,
    required this.rows,
    this.bodyCellOnTap,
    this.bodyCellOnSecondaryTap,
    required this.verticalScrollController,
    required this.horizontalScrollController,
  });

  @override
  State<FreedomTableBodyCells> createState() => _FreedomTableBodyCellsState();
}

class _FreedomTableBodyCellsState extends State<FreedomTableBodyCells> {
  Map<int, double?> rowMaxHeights = {};

  double tableWidth = 0;
  double tableBodyHeight = 0;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      html.document.body!.addEventListener('contextmenu', (event) => event.preventDefault());
    }

    HeaderModel headerModel = Provider.of<HeaderModel>(context, listen: false);
    TableModel tableModel = Provider.of<TableModel>(context, listen: false);

    headerModel.addListener(() {
      // print("** body : header complete **");
      // if (tableModel.fixedBodyCellWidgets.isEmpty) {
      tableWidth = 0;
      if (headerModel.headerCellWidths.isNotEmpty) {
        tableWidth = headerModel.headerCellWidths.reduce((value, element) => value + element);
        // tableWidth -= headerModel.fixedColumnWidth;
      }
      setState(() {
        setCells();
      });
      // }
    });

    tableModel.addListener(() {
      // print("** body : height complete **");
      // if (tableModel.fixedBodyCellWidgets.isEmpty) {
      tableBodyHeight = 0;
      tableModel.rowMaxHeights.forEach(
        (key, value) => tableBodyHeight += value ?? 0,
      );
      setState(() {
        setCells();
      });
      // }
    });
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void computeSpan() {
    HeaderModel headerModel = Provider.of<HeaderModel>(context, listen: false);
    TableModel tableModel = Provider.of<TableModel>(context, listen: false);
    Map<int, Map<int, bool>> occupiedTable = tableModel.occupiedTable;

    // init occupiedTable
    for (var bodyRow in widget.rows) {
      int rownumber = widget.rows.indexOf(bodyRow);
      Map<int, bool> updatedOccupiedRow = {};
      for (int i = 0; i < headerModel.headerCellWidths.length; i++) {
        updatedOccupiedRow.addEntries({i: false}.entries);
      }
      occupiedTable.putIfAbsent(rownumber, () => updatedOccupiedRow);
    }

    // 每行
    for (var bodyRow in widget.rows) {
      int rownumber = widget.rows.indexOf(bodyRow);
      int colnumber = 0;

      int columnDelayIndex = 0;
      for (var i = 0; i < bodyRow.length; i++) {
        if (occupiedTable[rownumber]?[colnumber + i] == true && i <= colnumber) {
          columnDelayIndex++;
        }
      }

      // 每列
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
            if (occupiedTable[rownumber + j] != null) {
              occupiedTable[rownumber + j]![colnumber + columnDelayIndex] = true;
            }
          }
        }
        if (cell.colspan > 1 && cell.rowspan > 1) {
          // 跨列 + 跨行
          for (int i = 1; i < cell.colspan; i++) {
            for (int j = 1; j < cell.rowspan; j++) {
              if (occupiedTable[rownumber + j] != null) {
                occupiedTable[rownumber + j]![colnumber + i + columnDelayIndex] = true;
              }
            }
          }
        }
        colnumber++;
      }
      // print(occupiedTable);
      tableModel.occupiedTable = occupiedTable;
    }
  }

  double getCellTop(Map<int, double?> rowMaxHeights, int rownumber) {
    double top = 0;
    for (var i = 0; i < rownumber; i++) {
      top += rowMaxHeights[i] ?? 0;
    }
    return top;
  }

  double getCellLeft(FreedomTableBodyCell cell, Map<int, bool> occupiedTableRow, List<double> headerCellWidths, int rownumber, int colnumber) {
    double left = 0;
    for (var i = 0; i < colnumber; i++) {
      if (i > headerCellWidths.length - 1) {
        break;
      }
      left += headerCellWidths[i];
    }
    return left;
  }

  double getCellWidth(FreedomTableBodyCell cell, Map<int, bool> occupiedTableRow, List<double> headerCellWidths, int rownumber, int colnumber) {
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

  Widget getCellWidget(FreedomTableBodyCell cell, double top, double left, double cellWidth, double? cellHeight, bool isFirstCellInRow, bool isFixed, [void Function(Size)? onChange]) {
    HeaderModel headerModel = Provider.of<HeaderModel>(context, listen: false);
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
                headerModel.headerMaxHeight + top,
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
                headerModel.headerMaxHeight + top,
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
    // print("** set body cell **");
    HeaderModel headerModel = Provider.of<HeaderModel>(context, listen: false);
    List<double> headerCellWidths = headerModel.headerCellWidths;

    TableModel tableModel = Provider.of<TableModel>(context, listen: false);
    Map<int, Map<int, bool>> occupiedTable = tableModel.occupiedTable;

    if (tableModel.rowMaxHeights.isEmpty) {
      rowMaxHeights = {};
    }

    computeSpan();

    List<Widget> fixedBodyCellWidgets = [];
    List<Widget> scrollableBodyCellWidgets = [];

    // 每行
    for (var bodyRow in widget.rows) {
      // 行号
      int rownumber = widget.rows.indexOf(bodyRow);
      Map<int, bool> occupiedTableRow = occupiedTable[rownumber]!;

      int colnumber = 0;
      // int fixedColumnCount = 0;

      // 每列
      for (var cell in bodyRow) {
        while (occupiedTable[rownumber]![colnumber] == true) {
          colnumber++;
          // fixedColumnCount++;
        }

        double top = getCellTop(rowMaxHeights, rownumber);
        double left = getCellLeft(cell, occupiedTableRow, headerCellWidths, rownumber, colnumber);
        double cellWidth = getCellWidth(cell, occupiedTableRow, headerCellWidths, rownumber, colnumber);

        // 计算跨行高度
        double cellSpanHeight = 0;
        if (cell.rowspan > 1) {
          cellSpanHeight = rowMaxHeights[rownumber] ?? 0;
          for (var i = rownumber + 1; i < widget.rows.length; i++) {
            if (occupiedTable.keys.contains(i) && occupiedTable[i] != null && occupiedTable[i]!.keys.contains(colnumber)) {
              if (occupiedTable[i]![colnumber] == false) {
                break;
              } else {
                cellSpanHeight += rowMaxHeights[i] ?? 0;
              }
            }
          }
        }

        // if (fixedColumnCount < headerModel.fixedColumnCount) {
        //   // top += headerModel.headerMaxHeight;
        // } else {
        //   left -= headerModel.fixedColumnWidth;
        // }

        Widget cellWidget = getCellWidget(
          cell,
          top,
          left,
          cellWidth,
          cellSpanHeight == 0 ? rowMaxHeights[rownumber] : cellSpanHeight,
          occupiedTableRow[0] == false && colnumber == 0,
          // fixedColumnCount < headerModel.fixedColumnCount,
          colnumber == 0,
          cellSpanHeight == 0
              ? (size) {
                  // print(size);
                  // if (rownumber == 1) print("** $rownumber $colnumber ${size} **");
                  if (size.width > 0 && size.height > 0) {
                    if (rowMaxHeights[rownumber] == null || rowMaxHeights[rownumber]! < size.height) {
                      rowMaxHeights[rownumber] = size.height;
                      tableModel.addRowMaxHeight(rownumber, size.height);
                    }
                  }
                }
              : null,
        );

        // if (fixedColumnCount < headerModel.fixedColumnCount) {
        //   fixedBodyCellWidgets.add(cellWidget);
        // }
        if (colnumber < headerModel.fixedColumnCount) {
          fixedBodyCellWidgets.add(cellWidget);
        }
        scrollableBodyCellWidgets.add(cellWidget);

        colnumber++;
        // if (fixedColumnCount < headerModel.fixedColumnCount) {
        //   fixedColumnCount++;
        // }
      }
    }

    tableModel.fixedBodyCellWidgets = fixedBodyCellWidgets;
    tableModel.scrollableBodyCellWidgets = scrollableBodyCellWidgets;
  }

  @override
  Widget build(BuildContext context) {
    TableModel tableModel = Provider.of<TableModel>(context, listen: false);
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
            ...tableModel.scrollableBodyCellWidgets,
          ],
        ),
      ),
    );
  }
}
