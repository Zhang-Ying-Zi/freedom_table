library freedom_table;

import 'package:flutter/material.dart';
import 'package:freedom_table/freedom_table_pager.dart';
import 'package:provider/provider.dart';
import './models/theme_model.dart';
import './models/table_model.dart';
import "types.dart";
import 'freedom_table_header_row.dart';
import 'freedom_table_body_cells.dart';
export "types.dart";
export 'freedom_table_pager.dart';

FreedomTableData freedomTableData = FreedomTableData();

class FreedomTable extends StatefulWidget {
  final List<FreedomTableHeaderCell> headers;
  final FreedomTablePager? pager;
  final FreedomTableTheme? theme;
  final double? minCellWidthInFlexMode;
  final List<List<FreedomTableBodyCell>> initBodyCells;
  final void Function(
    FreedomTableBodyCell childCell,
    double left,
    double top,
    double width,
    double height,
    double scrollLeft,
    double scrollTop,
  )? bodyCellOnTap;
  final void Function(
    FreedomTableBodyCell childCell,
    double left,
    double top,
    double width,
    double height,
    double scrollLeft,
    double scrollTop,
  )? bodyCellOnSecondaryTap;

  const FreedomTable({
    super.key,
    required this.headers,
    this.theme,
    this.pager,
    this.bodyCellOnTap,
    this.bodyCellOnSecondaryTap,
    this.minCellWidthInFlexMode,
    this.initBodyCells = const [],
  });

  updateData(List<List<FreedomTableBodyCell>> rows) {
    freedomTableData.updateData(rows);
  }

  @override
  State<FreedomTable> createState() => _FreedomTableState();
}

class _FreedomTableState extends State<FreedomTable> {
  List<List<FreedomTableBodyCell>> rows = [];
  late FreedomTableTheme theme;

  ScrollController horizontalScrollController = ScrollController();
  ScrollController verticalScrollController = ScrollController();
  ScrollController fixedVerticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    theme = widget.theme ?? FreedomTableTheme();
    if (rows.isEmpty) rows = widget.initBodyCells;
    freedomTableData.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          rows = freedomTableData.rows;
        });
      });
    });
    verticalScrollController.addListener(() {
      fixedVerticalScrollController.animateTo(
        verticalScrollController.offset,
        duration: const Duration(milliseconds: 1),
        curve: Curves.linear,
      );
    });
    fixedVerticalScrollController.addListener(() {
      verticalScrollController.animateTo(
        fixedVerticalScrollController.offset,
        duration: const Duration(milliseconds: 1),
        curve: Curves.linear,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeModel(theme)),
        ChangeNotifierProvider(create: (context) => TableModel()),
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constrains) {
                  TableModel tableModel =
                      Provider.of<TableModel>(context, listen: false);
                  double tableBodyHeight = 0;
                  tableModel.rowMaxHeights.forEach(
                    (key, value) => tableBodyHeight += value ?? 0,
                  );
                  return Column(
                    children: [
                      SizedBox(
                        width: tableModel.fixedColumnWidth,
                        height: tableModel.headerMaxHeight,
                        child: Stack(
                          children: tableModel.fixedHeaderCellWidgets,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: fixedVerticalScrollController,
                          scrollDirection: Axis.vertical,
                          child: SizedBox(
                            width: tableModel.fixedColumnWidth,
                            height: tableBodyHeight,
                            child: Stack(
                              children: tableModel.fixedBodyCellWidgets,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                Expanded(
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constrains) {
                      // TableModel tableModel =
                      //     Provider.of<TableModel>(context, listen: false);
                      return SizedBox.expand(
                        child: Column(
                          children: [
                            Flexible(
                              child: SingleChildScrollView(
                                controller: horizontalScrollController,
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FreedomTableHeaderRow(
                                      headerCells: widget.headers,
                                      constrains: constrains,
                                      minCellWidthInFlexMode:
                                          widget.minCellWidthInFlexMode,
                                    ),
                                    Expanded(
                                      child: FreedomTableBodyCells(
                                        rows: rows,
                                        bodyCellOnTap: widget.bodyCellOnTap,
                                        bodyCellOnSecondaryTap:
                                            widget.bodyCellOnSecondaryTap,
                                        verticalScrollController:
                                            verticalScrollController,
                                        horizontalScrollController:
                                            horizontalScrollController,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (widget.pager != null) widget.pager!,
        ],
      ),
    );
  }
}
