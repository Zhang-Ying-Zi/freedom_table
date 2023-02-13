import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/theme_model.dart';
import "types.dart";
import 'dart:math';

enum PagerItemTypes { prev, next, ellipsis, number }

typedef PagerClickCallback = void Function(
    int totalPages, int currentPageIndex)?;

class PagerItem extends StatefulWidget {
  final PagerItemTypes type;
  final int? index;
  final bool isFocused;
  const PagerItem({
    super.key,
    required this.type,
    this.index,
    this.isFocused = false,
  });

  @override
  State<PagerItem> createState() => _PagerItemState();
}

class _PagerItemState extends State<PagerItem> {
  @override
  Widget build(BuildContext context) {
    ThemeModel themeModel = Provider.of<ThemeModel>(context);
    String itemName = "";
    switch (widget.type) {
      case PagerItemTypes.prev:
        itemName = "<上一页";
        break;
      case PagerItemTypes.next:
        itemName = "下一页>";
        break;
      case PagerItemTypes.ellipsis:
        itemName = "...";
        break;
      case PagerItemTypes.number:
        itemName = (widget.index! + 1).toString();
        break;
    }
    return MouseRegion(
      cursor: widget.index == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(
              color: widget.isFocused
                  ? themeModel.theme.pagerFocusedBackgroundColor
                  : themeModel.theme.pagerBorderColor),
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          color: widget.isFocused
              ? themeModel.theme.pagerFocusedBackgroundColor
              : null,
        ),
        child: Center(
          child: Text(
            itemName,
            style: TextStyle(
                color: widget.isFocused
                    ? themeModel.theme.pagerTextFocusedColor
                    : themeModel.theme.pagerTextColor),
          ),
        ),
      ),
    );
  }
}

class FreedomTablePager extends StatefulWidget {
  final int totalCount;
  final int pageEach;
  final PagerClickCallback callback;
  const FreedomTablePager({
    super.key,
    required this.totalCount,
    required this.pageEach,
    this.callback,
  });

  @override
  State<FreedomTablePager> createState() => _FreedomTablePagerState();
}

class _FreedomTablePagerState extends State<FreedomTablePager> {
  int pagesBetweenEllipsesCount = 5;
  late int sideDiff;
  late int totalPages;
  int currentPageIndex = 0;

  List<Widget> pageItems = [];

  @override
  void initState() {
    super.initState();
    totalPages = (widget.totalCount / widget.pageEach).ceil();
    sideDiff = (pagesBetweenEllipsesCount / 2).floor();
    generatePager();
  }

  Widget pageItem(PagerItem item) {
    return GestureDetector(
      onTapUp: (e) {
        if (item.index != null) {
          setState(() {
            currentPageIndex = item.index!;
            generatePager();
          });
        }
        if (widget.callback != null) {
          widget.callback!(totalPages, currentPageIndex);
        }
      },
      child: item,
    );
  }

  void generatePager() {
    pageItems = [];
    // prev
    pageItems.add(pageItem(const PagerItem(type: PagerItemTypes.prev)));
    // 首页
    pageItems.add(pageItem(PagerItem(
      type: PagerItemTypes.number,
      index: 0,
      isFocused: currentPageIndex == 0,
    )));
    // ...
    if (currentPageIndex >= sideDiff) {
      pageItems.add(pageItem(const PagerItem(type: PagerItemTypes.ellipsis)));
    }
    int index = max(1, currentPageIndex - sideDiff);
    int prefDiff = currentPageIndex - index;
    for (;
        index < currentPageIndex + pagesBetweenEllipsesCount - prefDiff;
        index++) {
      if (index > totalPages - 2) break;
      pageItems.add(pageItem(PagerItem(
        type: PagerItemTypes.number,
        index: index,
        isFocused: currentPageIndex == index,
      )));
    }
    // ...
    if (index < totalPages - 1) {
      pageItems.add(pageItem(const PagerItem(type: PagerItemTypes.ellipsis)));
    }
    // 尾页
    if (totalPages > 1) {
      pageItems.add(pageItem(PagerItem(
        type: PagerItemTypes.number,
        index: totalPages - 1,
        isFocused: currentPageIndex == totalPages - 1,
      )));
    }
    // next
    pageItems.add(pageItem(const PagerItem(type: PagerItemTypes.next)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: pageItems.map((pageItem) {
          int index = pageItems.indexOf(pageItem);
          return Container(
            margin: index == 0 ? null : const EdgeInsets.only(left: 10),
            child: pageItem,
          );
        }).toList(),
      ),
    );
  }
}
