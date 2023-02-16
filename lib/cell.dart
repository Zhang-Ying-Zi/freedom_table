import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/theme_model.dart';
import "types.dart";

class FreedomTableCell extends StatefulWidget {
  final double width;
  final double? height;
  final CellType type;
  final int colspan;
  final int rowspan;
  final int colnumber;
  final Widget? child;

  const FreedomTableCell({
    super.key,
    this.child,
    this.type = CellType.body,
    this.width = minCellWidth,
    this.height,
    this.colspan = 1,
    this.rowspan = 1,
    this.colnumber = 0,
  });

  @override
  State<FreedomTableCell> createState() => _FreedomTableCellState();
}

class _FreedomTableCellState extends State<FreedomTableCell> {
  bool isCellHovering = false;

  GlobalKey cellKey = GlobalKey();

  @override
  void didUpdateWidget(covariant FreedomTableCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    // WidgetPosition.getSizes(cellKey);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, themeModel, child) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: MouseRegion(
            cursor: widget.type == CellType.header
                ? SystemMouseCursors.basic
                : SystemMouseCursors.click,
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
                  top: widget.type == CellType.header
                      ? BorderSide(color: themeModel.theme.dividerColor)
                      : BorderSide.none,
                  bottom: BorderSide(color: themeModel.theme.dividerColor),
                  left: widget.colnumber == 0
                      ? BorderSide(color: themeModel.theme.dividerColor)
                      : BorderSide.none,
                  right: BorderSide(color: themeModel.theme.dividerColor),
                ),
                color: widget.type == CellType.header
                    ? themeModel.theme.backgroundColor
                    : isCellHovering
                        ? themeModel.theme.hoverColor
                        : null,
              ),
              // child: IntrinsicHeight(
              //   child: widget.child,
              // ),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
