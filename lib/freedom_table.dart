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

class FreedomTable extends StatefulWidget {
  final List<FreedomTableHeaderCell> headers;
  final FreedomTablePager? pager;
  final FreedomTableTheme? theme;
  List<List<FreedomTableBodyCell>> rows = [];
  FreedomTable({
    super.key,
    required this.headers,
    this.theme,
    this.pager,
  });


  @override
  State<FreedomTable> createState() => _FreedomTableState();
}

class _FreedomTableState extends State<FreedomTable> {
  late FreedomTableTheme theme;

  @override
  void initState() {
    super.initState();
    theme = widget.theme ?? FreedomTableTheme();
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
          // print("** constrains **");
          // print(constrains.maxWidth);
          // print(constrains.maxHeight);
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FreedomTableHeaderRow(
                  headerCells: widget.headers,
                  constrains: constrains,
                ),
                Expanded(
                  child: FreedomTableBodyCells(
                    rows: widget.rows,
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
