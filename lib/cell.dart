import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/theme_model.dart';
import "types.dart";

class FreedomTableCell extends StatefulWidget {
  /// width
  final double width;

  /// height
  final double? height;

  /// cell type is header or body
  final CellType type;

  /// colspan
  final int colspan;

  /// rowspan
  final int rowspan;

  /// isFirstCellInRow
  final bool isFirstCellInRow;

  /// child widget
  final Widget? child;

  const FreedomTableCell({
    super.key,
    this.child,
    this.type = CellType.body,
    required this.width,
    this.height,
    this.colspan = 1,
    this.rowspan = 1,
    this.isFirstCellInRow = false,
  });

  @override
  State<FreedomTableCell> createState() => _FreedomTableCellState();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return "FreedomTableCell( width:$width, height:$height, type:$type, colspan:$colspan, rowspan:$rowspan, isFirstCellInRow:$isFirstCellInRow, child:$child )";
  }
}

class _FreedomTableCellState extends State<FreedomTableCell> {
  /// whether the cell is hovered
  bool isCellHovering = false;

  /// cell key
  GlobalKey cellKey = GlobalKey();

  @override
  void didUpdateWidget(covariant FreedomTableCell oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, themeModel, child) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: MouseRegion(
            cursor: widget.type == CellType.header ? SystemMouseCursors.basic : SystemMouseCursors.click,
            onEnter: (event) {
              setState(() {
                isCellHovering = true;
              });
            },
            onExit: (event) {
              setState(() {
                isCellHovering = false;
              });
            },
            child: Container(
              key: cellKey,
              decoration: BoxDecoration(
                border: Border(
                  top: widget.type == CellType.header ? BorderSide(color: themeModel.theme.dividerColor) : BorderSide.none,
                  bottom: BorderSide(color: themeModel.theme.dividerColor),
                  left: widget.isFirstCellInRow == true ? BorderSide(color: themeModel.theme.dividerColor) : BorderSide.none,
                  right: BorderSide(color: themeModel.theme.dividerColor),
                ),
                color: widget.type == CellType.header
                    ? themeModel.theme.backgroundColor
                    : isCellHovering
                        ? themeModel.theme.hoverColorGetter != null
                            ? themeModel.theme.hoverColorGetter!()
                            : themeModel.theme.hoverColor
                        : null,
              ),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
