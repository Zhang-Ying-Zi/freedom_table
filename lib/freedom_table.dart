library freedom_table;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/theme_model.dart';
import './models/table_model.dart';
import "types.dart";
import 'freedom_table_header_row.dart';
import 'freedom_table_body_row.dart';
export "types.dart";

class FreedomTable extends StatefulWidget {
  final List<FreedomTableHeaderCell> headers;
  final List<List<FreedomTableBodyCell>> bodys;
  final ThemeData? theme;
  const FreedomTable(
      {super.key, required this.headers, this.theme, this.bodys = const []});

  @override
  State<FreedomTable> createState() => _FreedomTableState();
}

class _FreedomTableState extends State<FreedomTable> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = widget.theme ?? ThemeData();
    theme = theme.copyWith(
      dividerColor: const Color(0xffe6e6e6),
      backgroundColor: const Color(0xfff2f2f2),
      hoverColor: const Color(0xfff6f6f6),
    );
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
                ...getBodyRow(),
              ],
            ),
          );
        },
      ),
    );
  }

  List<FreedomTableBodyRow> getBodyRow() {
    List<FreedomTableBodyRow> bodyRows = [];
    for (var bodyRowCells in widget.bodys) {
      bodyRows.add(FreedomTableBodyRow(
        bodyCells: bodyRowCells,
        rownumber: widget.bodys.indexOf(bodyRowCells),
      ));
    }
    return bodyRows;
  }
}
