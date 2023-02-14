This Package is used for showing table data in web, which added support to **colspan** and **rowspan**

## Features

### support colspan and rowspan

![colspan and rowspan](https://i.328888.xyz/2023/02/14/mfjUL.png)

### table header-row and body-row is auto height

### support pager

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:freedom_table/freedom_table.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FreedomTable table;

  @override
  void initState() {
    super.initState();
    table = FreedomTable(
      // 分页
      pager: FreedomTablePager(
        // 总条数
        totalCount: 90,
        // 每页数量
        pageEach: 10,
        callback: (totalPages, currentPageIndex) {
          print("(当前页数（从0开始）：$currentPageIndex, 总页数：$totalPages)");
          // 更新表格分页数据
          table.updateData(getPageData(totalPages, currentPageIndex));
        },
      ),
      // 表格header
      headers: [
        FreedomTableHeaderCell(
          // 宽度比例
          flex: 1,
          child: headerCell('header-1', Alignment.centerLeft),
        ),
        FreedomTableHeaderCell(
          // 宽度比例
          flex: 2,
          child: headerCell('header-2'),
        ),
        FreedomTableHeaderCell(
          // 宽度比例
          flex: 3,
          child: headerCell('header-3'),
        ),
        FreedomTableHeaderCell(
          // 固定宽度
          fixedWidth: 300,
          child: headerCell(
              'header-4 长中文测试：中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: table,
      ),
    );
  }

  // 获取分页数据
  List<List<FreedomTableBodyCell>> getPageData(totalPages, currentPageIndex) {
    return [
            [
              FreedomTableBodyCell(
                child: rowCell('row1-column1', Alignment.centerLeft),
              ),
              FreedomTableBodyCell(
                child: rowCell('row1-column2'),
              ),
              FreedomTableBodyCell(
                child: rowCell(
                    'row1-column3 long-english:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row1-column4'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('row2-column1', Alignment.centerLeft),
              ),
              FreedomTableBodyCell(
                child: rowCell('row2-column2'),
              ),
              FreedomTableBodyCell(
                colspan: 2,
                child: rowCell('row2-column3'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('row3-column1', Alignment.centerLeft),
              ),
              FreedomTableBodyCell(
                rowspan: 2,
                child: rowCell('row3-column2'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row3-column3'),
              ),
              FreedomTableBodyCell(
                child: rowCell(
                    'row3-column4  长中文测试：中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('row4-column1', Alignment.centerLeft),
              ),
              FreedomTableBodyCell(
                child: rowCell('row4-column2'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row4-column3'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('row5-column1', Alignment.centerLeft),
              ),
              FreedomTableBodyCell(
                child: rowCell('row5-column2'),
              ),
              FreedomTableBodyCell(
                colspan: 2,
                rowspan: 3,
                child: rowCell('row5-column3'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('row6-column1', Alignment.centerLeft),
              ),
              FreedomTableBodyCell(
                child: rowCell('row6-column2'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('row7-column1', Alignment.centerLeft),
              ),
              FreedomTableBodyCell(
                child: rowCell('row7-column2'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('row8-column1', Alignment.centerLeft),
              ),
              FreedomTableBodyCell(
                child: rowCell('row8-column2'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row8-column3'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row8-column4'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('row9-column1', Alignment.centerLeft),
              ),
              FreedomTableBodyCell(
                child: rowCell('row9-column2'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row9-column3'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row9-column4'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('row10-column1', Alignment.centerLeft),
              ),
              FreedomTableBodyCell(
                child: rowCell('row10-column2'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row10-column3'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row10-column4'),
              ),
            ]
          ];
  }

  // header单元格，请设置fontFamily
  Widget headerCell(String name, [Alignment? align]) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: align ?? Alignment.center,
      child: Text(
        name,
        style: const TextStyle(
          fontFamily: "Noto_Sans_SC",
        ),
      ),
    );
  }

  // body单元格，请设置fontFamily
  Widget rowCell(String name, [Alignment? align]) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: align ?? Alignment.center,
      child: Text(
        name,
        style: const TextStyle(
          fontFamily: "Noto_Sans_SC",
        ),
      ),
    );
  }
}

```
