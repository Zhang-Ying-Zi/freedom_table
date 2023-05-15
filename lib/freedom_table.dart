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

  /// when body data is empty, this can't be called.
  final void Function()? bodyDataUpdateFinished;

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
    this.bodyDataUpdateFinished,
    this.minCellWidthInFlexMode,
    this.initBodyCells = const [],
  });

  updateBody(List<List<FreedomTableBodyCell>> rows) {
    freedomTableData.updateData(rows);
    // // 目前切换表格数据时，需要与前一次数据不同，才能获取正确的表格高度
    // freedomTableData.updateData([]);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   freedomTableData.updateData(rows);
    // });
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
    // theme = widget.theme ?? FreedomTableTheme();
    // if (rows.isEmpty) rows = widget.initBodyCells;

    TableModel tableModel = TableModel.instance;

    freedomTableData.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          rows = freedomTableData.rows;
          tableModel.reset(rows.length);
        });
      });
    });

    tableModel.addListener(() {
      // print("finished");
      if (widget.bodyDataUpdateFinished != null) {
        widget.bodyDataUpdateFinished!();
      }
    });

    init();
  }

  @override
  void didUpdateWidget(covariant FreedomTable oldWidget) {
    init();
    super.didUpdateWidget(oldWidget);
  }

  void init() {
    setState(() {
      TableModel tableModel = TableModel.instance;
      theme = widget.theme ?? FreedomTableTheme();
      rows = widget.initBodyCells;
      tableModel.reset(rows.length);
    });

    widget.verticalScrollController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.verticalScrollController.hasClients) {
          widget.fixedVerticalScrollController.animateTo(
            widget.verticalScrollController.offset,
            duration: const Duration(microseconds: 1),
            curve: Curves.linear,
          );
        }
      });
    });

    widget.fixedVerticalScrollController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.fixedVerticalScrollController.hasClients) {
          widget.verticalScrollController.animateTo(
            widget.fixedVerticalScrollController.offset,
            duration: const Duration(microseconds: 1),
            curve: Curves.linear,
          );
        }
      });
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
        // ChangeNotifierProvider(create: (context) => TableModel()),
      ],
      builder: (context, child) {
        // TableModel tableModel = Provider.of<TableModel>(context, listen: false);
        TableModel tableModel = TableModel.instance;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 固定列
                  LayoutBuilder(builder: (BuildContext context, BoxConstraints constrains) {
                    double tableBodyHeight = 0;
                    // print("table ${tableModel.rowMaxHeights}");
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
                  // 自由表格
                  Expanded(
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constrains) {
                        return SizedBox.expand(
                          child:
                              // Column(
                              //   children: [
                              // Flexible(
                              //   child: SizedBox.expand(
                              //     child:
                              SingleChildScrollView(
                            controller: widget.horizontalScrollController,
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 自由表格header
                                FreedomTableHeaderRow(
                                  headerCells: widget.headers,
                                  constrains: constrains,
                                  minCellWidthInFlexMode: widget.minCellWidthInFlexMode,
                                ),
                                // 自由表格body
                                Expanded(
                                  child: FreedomTableBodyCells(
                                    rows: rows,
                                    getFixedBodyCellWidgets: ((widgets) {
                                      WidgetsBinding.instance.addPostFrameCallback(
                                        (timeStamp) {
                                          if (fixedBodyCellWidgets.length != widgets.length) {
                                            setState(() {
                                              fixedBodyCellWidgets = widgets;
                                            });
                                          }
                                        },
                                      );
                                    }),
                                    bodyCellOnTap: widget.bodyCellOnTap,
                                    bodyCellOnSecondaryTap: widget.bodyCellOnSecondaryTap,
                                    verticalScrollController: widget.verticalScrollController,
                                    horizontalScrollController: widget.horizontalScrollController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //   ),
                          // ),
                          //   ],
                          // ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (widget.pager != null) widget.pager!,
          ],
        );
      },
    );
  }

  Widget outline(Widget child) {
    return Container(decoration: BoxDecoration(border: Border.all()), child: child);
  }
}
