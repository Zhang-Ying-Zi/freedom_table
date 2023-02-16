import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/theme_model.dart';
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
        padding: EdgeInsets.symmetric(
            horizontal: widget.type == PagerItemTypes.ellipsis ? 0 : 12),
        decoration: BoxDecoration(
          border: widget.type == PagerItemTypes.ellipsis
              ? null
              : Border.all(
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
                fontSize: 14,
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
  int? lastTotalPages;
  int? lastCurrentPageIndex;
  late int pageEach;
  int currentPageIndex = 0;

  TextEditingController gotoControl = TextEditingController();

  @override
  void initState() {
    super.initState();
    pageEach = widget.pageEach;
    initData();
  }

  initData() {
    totalPages = (widget.totalCount / pageEach).ceil();
    sideDiff = (pagesBetweenEllipsesCount / 2).floor();
    currentPageIndex = 0;
  }

  executeCallback() {
    if (widget.callback != null) {
      if ((lastTotalPages == null || lastCurrentPageIndex == null) ||
          (lastTotalPages != totalPages ||
              lastCurrentPageIndex != currentPageIndex)) {
        lastTotalPages = totalPages;
        lastCurrentPageIndex = currentPageIndex;
        widget.callback!(totalPages, currentPageIndex);
      }
    }
  }

  Widget pageItem(PagerItem item) {
    return GestureDetector(
      onTapUp: (e) {
        if (item.index != null) {
          setState(() {
            currentPageIndex = item.index!;
          });
        }
        executeCallback();
      },
      child: item,
    );
  }

  List<Widget> generatePager() {
    List<Widget> pageItems = [];
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
    executeCallback();
    return pageItems;
  }

  Widget text(String text) {
    ThemeModel themeModel = Provider.of<ThemeModel>(context);
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Center(
        child: Text(
          text,
          style:
              TextStyle(fontSize: 14, color: themeModel.theme.pagerTextColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeModel themeModel = Provider.of<ThemeModel>(context);
    List<Widget> pageItems = generatePager();
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          ...pageItems.map((pageItem) {
            int index = pageItems.indexOf(pageItem);
            return Container(
              margin: index == 0 ? null : const EdgeInsets.only(left: 10),
              child: pageItem,
            );
          }).toList(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              text("跳至"),
              SizedBox(
                width: 80,
                // height: 32,
                child: TextField(
                  controller: gotoControl,
                  autocorrect: false,
                  // maxLines: null,
                  // expands: true,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1,
                    color: themeModel.theme.pagerTextColor,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(gapPadding: 0),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 10,
                    ),
                    isDense: true,
                    // isCollapsed: true,
                  ),
                  onEditingComplete: () {
                    try {
                      int goto = int.parse(gotoControl.text);
                      setState(() {
                        currentPageIndex = max(0, goto - 1);
                        currentPageIndex =
                            min(currentPageIndex, totalPages - 1);
                        gotoControl.text = (currentPageIndex + 1).toString();
                        gotoControl.selection = TextSelection.fromPosition(
                            TextPosition(offset: gotoControl.text.length));
                      });
                    } on FormatException catch (e) {
                      print("unvalid number : $e");
                    }
                  },
                ),
              ),
              text("页"),
            ],
          ),
          text("共${widget.totalCount}条"),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              text("每页"),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: DropdownButton<String>(
                  value: pageEach.toString(),
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  style: TextStyle(color: themeModel.theme.pagerTextColor),
                  underline: Container(
                    height: 2,
                    color: themeModel.theme.pagerBorderColor,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      pageEach = int.parse(value!);
                      initData();
                    });
                  },
                  items: ["5", "10", "15", "20", "30"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              text("条"),
            ],
          ),
        ],
      ),
    );
  }
}
