library freedom_table;

import 'package:flutter/material.dart';
import 'package:freedom_table/freedom_table_pager.dart';
import 'package:provider/provider.dart';
import './models/theme_model.dart';
import './models/header_model.dart';
import './models/table_model.dart';
import "types.dart";
import "utils.dart";
import 'freedom_table_header_row.dart';
import 'freedom_table_body_cells.dart';
export "types.dart";
export 'freedom_table_pager.dart';

class FreedomTableData extends ChangeNotifier {
  List<List<FreedomTableBodyCell>> rows = [];

  void updateBody(List<List<FreedomTableBodyCell>> rows) {
    this.rows = rows;
    notifyListeners();
  }
}

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

  final FreedomTableData freedomTableData = FreedomTableData();

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
    freedomTableData.updateBody(rows);
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

    TableModel tableModel = TableModel.instance;
    HeaderModel headerModel = HeaderModel.instance;

    rows = widget.initBodyCells;
    theme = widget.theme ?? FreedomTableTheme();
    tableModel.reset(widget.initBodyCells.length, widget.headers.length);

    widget.freedomTableData.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          setState(() {
            rows = widget.freedomTableData.rows;
            tableModel.reset(widget.freedomTableData.rows.length, widget.headers.length);
          });
        },
      );
    });

    tableModel.addListener(() {
      // print("finished");
      if (widget.bodyDataUpdateFinished != null) {
        widget.bodyDataUpdateFinished!();
      }
    });

    headerModel.addListener(() {
      // print("** table : header complete **");
      // setState(() {});
    });

    init();
  }

  @override
  void didUpdateWidget(covariant FreedomTable oldWidget) {
    init();
    super.didUpdateWidget(oldWidget);
  }

  void init() {
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
        ChangeNotifierProvider(create: (context) => TableModel.instance),
        ChangeNotifierProvider(create: (context) => HeaderModel.instance),
      ],
      builder: (context, child) {
        HeaderModel headerModel = Provider.of<HeaderModel>(context, listen: false);
        TableModel tableModel = Provider.of<TableModel>(context, listen: false);
        // TableModel tableModel = TableModel.instance;
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
                          width: headerModel.fixedColumnWidth,
                          height: headerModel.headerMaxHeight,
                          child: Stack(
                            children: headerModel.fixedHeaderCellWidgets,
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: widget.fixedVerticalScrollController,
                            scrollDirection: Axis.vertical,
                            child: Container(
                              color: theme.backgroundColor,
                              width: headerModel.fixedColumnWidth,
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
                                    bodyCellOnTap: widget.bodyCellOnTap,
                                    bodyCellOnSecondaryTap: widget.bodyCellOnSecondaryTap,
                                    verticalScrollController: widget.verticalScrollController,
                                    horizontalScrollController: widget.horizontalScrollController,
                                    getFixedBodyCellWidgets: ((widgets) {
                                      WidgetsBinding.instance.addPostFrameCallback(
                                        (timeStamp) {
                                          if (fixedBodyCellWidgets.length != widgets.length) {
                                            // setState(() {
                                            fixedBodyCellWidgets = widgets;
                                            // });
                                          }
                                        },
                                      );
                                    }),
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
                  )
                ],
              ),
            ),
            if (widget.pager != null) widget.pager!,
          ],
        );
      },
    );
  }
}
