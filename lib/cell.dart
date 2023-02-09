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
  final Widget? child;
  final Widget? leftSibling;

  const FreedomTableCell({
    super.key,
    this.child,
    this.type = CellType.body,
    this.width = minCellWidth,
    this.height,
    this.colspan = 1,
    this.rowspan = 1,
    this.leftSibling,
  });

  @override
  State<FreedomTableCell> createState() => _FreedomTableCellState();
}

class _FreedomTableCellState extends State<FreedomTableCell> {
  bool isCellHovering = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, themeModel, child) {
        return MouseRegion(
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
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: widget.type == CellType.header
                      ? BorderSide(color: themeModel.theme.dividerColor)
                      : BorderSide.none,
                  bottom: BorderSide(color: themeModel.theme.dividerColor),
                  left: widget.leftSibling == null
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
              child: IntrinsicHeight(
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}
