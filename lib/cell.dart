import 'package:flutter/material.dart';

import "types.dart";

class FreedomTableCell extends StatefulWidget {
  final double width;
  final double? height;
  final int colspan;
  final int rowspan;
  final Widget child;

  const FreedomTableCell({
    super.key,
    required this.child,
    this.width = minCellWidth,
    this.height,
    this.colspan = 1,
    this.rowspan = 1,
  });

  @override
  State<FreedomTableCell> createState() => _FreedomTableCellState();
}

class _FreedomTableCellState extends State<FreedomTableCell> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Container(
        // decoration: const BoxDecoration(
        //   border: Border(bottom: )
        // ),
        child: widget.child,
      ),
    );
  }
}
