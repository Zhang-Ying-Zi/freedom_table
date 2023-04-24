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

class FreedomTableData extends ChangeNotifier {
  List<List<FreedomTableBodyCell>> rows = [];

  void updateData(List<List<FreedomTableBodyCell>> rows) {
    this.rows = rows;
    notifyListeners();
  }
}

FreedomTableData freedomTableData = FreedomTableData();

class FreedomTable extends StatefulWidget {
  final List<FreedomTableHeaderCell> headers;
  final FreedomTablePager? pager;
  final FreedomTableTheme? theme;
  final double? minCellWidthInFlexMode;
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
  const FreedomTable({
    super.key,
    required this.headers,
    this.theme,
    this.pager,
    this.bodyCellOnTap,
    this.bodyCellOnSecondaryTap,
    this.minCellWidthInFlexMode,
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

  @override
  void initState() {
    super.initState();
    theme = widget.theme ?? FreedomTableTheme();
    freedomTableData.addListener(() {
      // print(freedomTableData.rows);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          rows = freedomTableData.rows;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeModel(theme)),
        ChangeNotifierProvider(create: (context) => TableModel()),
      ],
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constrains) {
          TableModel tableModel =
              Provider.of<TableModel>(context, listen: false);
          // print("** constrains **");
          // print(constrains.maxWidth);
          // print(constrains.maxHeight);
          return SingleChildScrollView(
            controller: tableModel.horizontalScrollController,
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FreedomTableHeaderRow(
                  headerCells: widget.headers,
                  constrains: constrains,
                  minCellWidthInFlexMode: widget.minCellWidthInFlexMode,
                ),
                Expanded(
                  child: FreedomTableBodyCells(
                    rows: rows,
                    bodyCellOnTap: widget.bodyCellOnTap,
                    bodyCellOnSecondaryTap: widget.bodyCellOnSecondaryTap,
                  ),
                ),
                if (widget.pager != null) widget.pager!,
              ],
            ),
          );
        },
      ),
    );
  }
}
