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

  final ScrollController horizontalScrollController = ScrollController();
  final ScrollController verticalScrollController = ScrollController();
  final ScrollController fixedVerticalScrollController = ScrollController();

  FreedomTable({
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

  scrollToTheFarRight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (horizontalScrollController.hasClients) {
        horizontalScrollController.animateTo(
          horizontalScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  State<FreedomTable> createState() => _FreedomTableState();
}

class _FreedomTableState extends State<FreedomTable> {
  List<List<FreedomTableBodyCell>> rows = [];
  late FreedomTableTheme theme;

  List<Widget> fixedBodyCellWidgets = [];

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.verticalScrollController.hasClients) {
        widget.verticalScrollController.addListener(() {
          widget.fixedVerticalScrollController.animateTo(
            widget.verticalScrollController.offset,
            duration: const Duration(microseconds: 1),
            curve: Curves.linear,
          );
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.fixedVerticalScrollController.hasClients) {
        widget.fixedVerticalScrollController.addListener(() {
          widget.verticalScrollController.animateTo(
            widget.fixedVerticalScrollController.offset,
            duration: const Duration(microseconds: 1),
            curve: Curves.linear,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    widget.horizontalScrollController.dispose();
    widget.verticalScrollController.dispose();
    widget.fixedVerticalScrollController.dispose();
    super.dispose();
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
                          controller: widget.fixedVerticalScrollController,
                          scrollDirection: Axis.vertical,
                          child: Container(
                            color: theme.backgroundColor,
                            width: tableModel.fixedColumnWidth,
                            height: tableBodyHeight,
                            child: Stack(
                              children: fixedBodyCellWidgets,
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
                      return SizedBox.expand(
                        child: Column(
                          children: [
                            Flexible(
                              child: SingleChildScrollView(
                                controller: widget.horizontalScrollController,
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
                                        getFixedBodyCellWidgets: ((widgets) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback(
                                            (timeStamp) {
                                              if (fixedBodyCellWidgets.length !=
                                                  widgets.length) {
                                                setState(() {
                                                  fixedBodyCellWidgets =
                                                      widgets;
                                                });
                                              }
                                            },
                                          );
                                        }),
                                        bodyCellOnTap: widget.bodyCellOnTap,
                                        bodyCellOnSecondaryTap:
                                            widget.bodyCellOnSecondaryTap,
                                        verticalScrollController:
                                            widget.verticalScrollController,
                                        horizontalScrollController:
                                            widget.horizontalScrollController,
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
