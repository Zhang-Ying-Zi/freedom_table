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
                color: widget.index == null
                    ? themeModel.theme.pagerTextDisabledColor
                    : widget.isFocused
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
    pageItems.add(pageItem(PagerItem(
      type: PagerItemTypes.prev,
      index: currentPageIndex > 0 ? currentPageIndex - 1 : null,
    )));
    // 首页
    pageItems.add(pageItem(PagerItem(
      type: PagerItemTypes.number,
      index: 0,
      isFocused: currentPageIndex == 0,
    )));
    // number
    List<int> indexesBetweenEllipses = [];
    bool isReachStart = false;
    bool isReachEnd = false;
    int index = max(1, currentPageIndex - sideDiff);
    // 居中模式
    for (; index <= min(currentPageIndex + sideDiff, totalPages - 2); index++) {
      if (index == 1) {
        isReachStart = true;
      }
      if (index == totalPages - 2) {
        isReachEnd = true;
      }
      indexesBetweenEllipses.add(index);
    }
    // 补缺
    int lackDiff = pagesBetweenEllipsesCount - indexesBetweenEllipses.length;
    if (lackDiff > 0) {
      if (isReachStart) {
        for (int i = 0; i < lackDiff; i++) {
          if (index < totalPages - 1) {
            if (index == totalPages - 2) {
              isReachEnd = true;
            }
            indexesBetweenEllipses.add(index++);
          }
        }
      }
      if (isReachEnd) {
        var indexStart = indexesBetweenEllipses.first;
        for (int i = 0; i < lackDiff; i++) {
          if (indexStart > 1) {
            if (indexStart == 2) {
              isReachStart = true;
            }
            indexesBetweenEllipses.insert(0, --indexStart);
          }
        }
      }
    }
    // print("$isReachStart $isReachEnd");
    // print(indexesBetweenEllipses);
    for (var i = 0; i < indexesBetweenEllipses.length; i++) {
      int index = indexesBetweenEllipses[i];
      pageItems.add(pageItem(PagerItem(
        type: PagerItemTypes.number,
        index: index,
        isFocused: currentPageIndex == index,
      )));
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
    pageItems.add(pageItem(PagerItem(
      type: PagerItemTypes.next,
      index: currentPageIndex < totalPages - 1 ? currentPageIndex + 1 : null,
    )));
    // ...
    if (!isReachStart &&
        indexesBetweenEllipses.length >= pagesBetweenEllipsesCount) {
      // 前
      pageItems.insert(
          2, pageItem(const PagerItem(type: PagerItemTypes.ellipsis)));
    }
    if (!isReachEnd &&
        indexesBetweenEllipses.length >= pagesBetweenEllipsesCount) {
      // 后
      pageItems.insert(pageItems.length - 2,
          pageItem(const PagerItem(type: PagerItemTypes.ellipsis)));
    }
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
