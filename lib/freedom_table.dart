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
    double totalScrollWidth,
    double totalScrollHeight,
  )? bodyCellOnTap;
  final void Function(
    FreedomTableBodyCell childCell,
    double left,
    double top,
    double width,
    double height,
    double scrollLeft,
    double scrollTop,
    double totalScrollWidth,
    double totalScrollHeight,
  )? bodyCellOnSecondaryTap;

  /// when body data is empty, this can't be called.
  final void Function()? bodyUpdateFinished;

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
    this.bodyUpdateFinished,
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

  @override
  void initState() {
    // print("** initState **");
    super.initState();

    TableModel tableModel = TableModel.instance;
    HeaderModel headerModel = HeaderModel.instance;

    // pager | update | replace
    headerModel.reset();

    init();

    // table update complete
    tableModel.addListener(tableBodyComplete);
  }

  @override
  void didUpdateWidget(covariant FreedomTable oldWidget) {
    // print("** didUpdateWidget **");
    super.didUpdateWidget(oldWidget);
    init();
  }

  @override
  void dispose() {
    // print("** dispose **");
    widget.horizontalScrollController.dispose();
    widget.verticalScrollController.dispose();
    widget.fixedVerticalScrollController.dispose();

    TableModel.instance.removeListener(tableBodyComplete);

    super.dispose();
  }

  void init() {
    // print("** init **");
    TableModel tableModel = TableModel.instance;
    HeaderModel headerModel = HeaderModel.instance;

    theme = widget.theme ?? FreedomTableTheme();

    setState(() {
      rows = widget.initBodyCells;
      tableModel.reset(rows.length, widget.headers.length);
    });

    /// pager
    widget.freedomTableData.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          setState(() {
            // print("** pager update **");
            rows = widget.freedomTableData.rows;
            tableModel.reset(rows.length, widget.headers.length);
            runFixedVertical();
            runScrollVertical();
          });
        },
      );
    });

    widget.verticalScrollController.addListener(() {
      runFixedVertical();
    });

    widget.fixedVerticalScrollController.addListener(() {
      runScrollVertical();
    });
  }

  void runFixedVertical() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.verticalScrollController.hasClients) {
        widget.fixedVerticalScrollController.animateTo(
          widget.verticalScrollController.offset,
          duration: const Duration(microseconds: 1),
          curve: Curves.linear,
        );
      }
    });
  }

  void runScrollVertical() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.fixedVerticalScrollController.hasClients) {
        widget.verticalScrollController.animateTo(
          widget.fixedVerticalScrollController.offset,
          duration: const Duration(microseconds: 1),
          curve: Curves.linear,
        );
      }
    });
  }

  void tableBodyComplete() {
    // print("** table : body complete **");

    HeaderModel headerModel = HeaderModel.instance;

    // fixed header
    if (headerModel.fixedHeaderCellWidgets.isEmpty) {
      double fixedColumnWidth = 0;
      int fixedColumnCount = 0;
      for (int i = 0; i < headerModel.headerCellWidths.length; i++) {
        FreedomTableHeaderCell header = widget.headers[i];
        if (header.isFixedColumn) {
          fixedColumnWidth += headerModel.headerCellWidths[i];
          fixedColumnCount++;
          double left = 0;
          for (var j = 0; j < i; j++) {
            left += headerModel.headerCellWidths[j];
          }
          if (headerModel.scrollableHeaderCellWidgets.isNotEmpty) {
            headerModel.fixedHeaderCellWidgets.add(Positioned(left: left, child: headerModel.scrollableHeaderCellWidgets.first));
            headerModel.scrollableHeaderCellWidgets.removeAt(0);
          }
        }
      }
      headerModel.fixedColumnWidth = fixedColumnWidth;
      headerModel.fixedColumnCount = fixedColumnCount;
    }

    if (mounted) {
      setState(() {});
    }

    if (widget.bodyUpdateFinished != null) {
      widget.bodyUpdateFinished!();
    }
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
        // HeaderModel headerModel = Provider.of<HeaderModel>(context, listen: false);
        // TableModel tableModel = Provider.of<TableModel>(context, listen: false);
        HeaderModel headerModel = HeaderModel.instance;
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
                    tableModel.rowMaxHeights.forEach(
                      (key, value) => tableBodyHeight += value ?? 0,
                    );
                    return Column(
                      children: [
                        // CustomGradientContainer(
                        //   child:
                        SizedBox(
                          width: headerModel.fixedColumnWidth,
                          height: headerModel.headerMaxHeight,
                          child: Stack(
                            children: headerModel.fixedHeaderCellWidgets,
                          ),
                        ),
                        // ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: widget.fixedVerticalScrollController,
                            scrollDirection: Axis.vertical,
                            child:
                                // CustomGradientContainer(
                                //   child:
                                SizedBox(
                              width: headerModel.fixedColumnWidth,
                              height: tableBodyHeight,
                              child: Stack(
                                children: tableModel.fixedBodyCellWidgets,
                              ),
                            ),
                            // ),
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
