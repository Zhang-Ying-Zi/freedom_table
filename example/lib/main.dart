import 'package:flutter/material.dart';
import 'package:freedom_table/freedom_table.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
      // optional
      minCellWidthInFlexMode: 100,
      // optional paging
      pager: FreedomTablePager(
        totalCount: 90,
        pageEach: 10,
        callback: (totalPages, currentPageIndex) {
          print("($currentPageIndex, $totalPages)");
          table.updateData(getPageData(totalPages, currentPageIndex));
        },
      ),
      // header
      headers: [
        FreedomTableHeaderCell(
          // header width is flex
          flex: 1,
          // wether the column which the header cell belong is fixed when table is horizontal scroll
          // when the column is fixed, please ensure the column's child cell DON'T have colspan!!!
          isFixedColumn: true,
          child: headerCell('header-1'),
        ),
        FreedomTableHeaderCell(
          flex: 2,
          // wether the column which the header cell belong is fixed when table is horizontal scroll
          // when the column is fixed, please ensure the column's child cell DON'T have colspan!!!
          isFixedColumn: true,
          child: headerCell('header-2'),
        ),
        FreedomTableHeaderCell(
          // header width is fixed
          fixedWidth: 500,
          child: headerCell('header-3', Alignment.centerLeft),
        ),
        FreedomTableHeaderCell(
          flex: 2,
          child: headerCell('header-4'),
        ),
        FreedomTableHeaderCell(
          flex: 4,
          child: headerCell(
              'header-5 长中文测试：中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文'),
        ),
      ],
      initBodyCells: getPageData(1, 0),
      // theme
      theme: FreedomTableTheme(
        dividerColor: const Color(0xffe6e6e6),
        backgroundColor: const Color(0xfff2f2f2),
        hoverColor: const Color(0xfff6f6f6),
        pagerBorderColor: const Color(0xffcccccc),
        pagerTextColor: const Color(0xff666666),
        pagerTextFocusedColor: const Color(0xffffffff),
        pagerTextDisabledColor: const Color(0xffcccccc),
        pagerFocusedBackgroundColor: const Color(0xff5078F0),
      ),
      bodyCellOnTap:
          (childCell, left, top, width, height, scrollLeft, scrollTop) {
        print(
            "左键点击的值为 ${childCell.data}，在表中的位置 : left $left, top $top, width $width, height $height, bodyScrollLeft $scrollLeft, bodyScrollTop $scrollTop");
      },
      bodyCellOnSecondaryTap:
          (childCell, left, top, width, height, scrollLeft, scrollTop) {
        print(
            "右键点击的值为 ${childCell.data}，在表中的位置 : left $left, top $top, width $width, height $height, bodyScrollLeft $scrollLeft, bodyScrollTop $scrollTop");
      },
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
    return currentPageIndex % 2 == 0
        ? [
            [
              FreedomTableBodyCell(
                child: rowCell('row1-column1'),
                data: "testdata",
              ),
              FreedomTableBodyCell(
                rowspan: 2,
                // colspan: 2,
                child: rowCell('row1-column2'),
                data: ["testdata"],
              ),
              FreedomTableBodyCell(
                child: rowCell(
                    'row1-column3 long-english:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'),
                data: {
                  ["testdata"]
                },
              ),
              FreedomTableBodyCell(
                child: rowCell('row1-column4'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row1-column5'),
              ),
            ],
            [
              FreedomTableBodyCell(
                rowspan: 2,
                child: rowCell('row2-column1'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row2-column2'),
                data: 'row2-column2',
              ),
              FreedomTableBodyCell(
                child: rowCell('row2-column3'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row2-column4'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row2-column5'),
              ),
            ],
            [
              FreedomTableBodyCell(
                colspan: 2,
                // rowspan: 2,
                child: rowCell('row3-column1'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row3-column2'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row3-column3'),
              ),
              FreedomTableBodyCell(
                child: rowCell(
                    'row3-column4  长中文测试：中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row3-column4'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('row4-column1'),
                data: 'row4-column1',
              ),
              FreedomTableBodyCell(
                child: rowCell('row4-column2'),
              ),
              FreedomTableBodyCell(
                colspan: 2,
                rowspan: 3,
                child: rowCell('row4-column3'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row4-column4'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row4-column5'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('row5-column1'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row5-column2'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row5-column3'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row5-column4'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row5-column5'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('row6-column1'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row6-column2'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row6-column3'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row6-column4'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row6-column5'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('row7-column1'),
              ),
              FreedomTableBodyCell(
                rowspan: 2,
                child: rowCell('row7-column2'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row7-column3'),
              ),
              FreedomTableBodyCell(
                rowspan: 3,
                child: rowCell('row7-column4'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row7-column5'),
              ),
            ],
            [
              FreedomTableBodyCell(
                rowspan: 3,
                child: rowCell('row8-column1'),
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
              FreedomTableBodyCell(
                child: rowCell('row8-column5'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('row9-column1'),
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
              FreedomTableBodyCell(
                child: rowCell('row9-column5'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('row10-column1'),
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
              FreedomTableBodyCell(
                child: rowCell('row10-column5'),
              ),
            ]
          ]
        : [];
  }

  // header单元格，请设置fontFamily,否则中文高度显示不正确
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

  // body单元格，请设置fontFamily,否则中文高度显示不正确
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
