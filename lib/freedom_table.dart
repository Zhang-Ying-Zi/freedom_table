library freedom_table;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/theme_model.dart';
import "types.dart";
import 'row.dart';
export "types.dart";

class FreedomTable extends StatefulWidget {
  final List<FreedomTableHeaderCell> headers;
  final ThemeData? theme;
  const FreedomTable({super.key, required this.headers, this.theme});

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
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeModel(theme)),
      ],
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constrains) {
          // print("** constrains **");
          // print(constrains.maxWidth);
          // print(constrains.maxHeight);
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FreedomTableHeaderRow(
              headerCells: widget.headers,
              constrains: constrains,
            ),
          );
        },
      ),
    );
  }
}
