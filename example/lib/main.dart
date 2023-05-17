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
      title: 'Freedom Table Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Freedom Table Demo Home Page'),
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
  int changedTimes = 0;

  @override
  void initState() {
    super.initState();
    setTable();
  }

  void setTable() {
    changedTimes++;
    table = FreedomTable(
      // optional
      minCellWidthInFlexMode: 200,
      // header
      headers: getHeaders(),
      initBodyCells: changedTimes % 2 == 1 ? getPageData(10, 0) : getPageData(10, 1),
      // optional paging
      pager: FreedomTablePager(
        totalCount: 90,
        pageEach: 10,
        callback: (totalPages, currentPageIndex) {
          print("(currentPageIndex : $currentPageIndex, totalPages : $totalPages)");
          table.updateBody(getPageData(totalPages, currentPageIndex));
        },
      ),
      // theme
      theme: FreedomTableTheme(
        dividerColor: const Color(0xffe6e6e6),
        backgroundColor: const Color(0xfff2f2f2),
        hoverColor: const Color(0xfff6f6f6),
        hoverColorGetter: () => const Color(0xffFA8C00),
        pagerBorderColor: const Color(0xffcccccc),
        pagerTextColor: const Color(0xff666666),
        pagerTextFocusedColor: const Color(0xffffffff),
        pagerTextDisabledColor: const Color(0xffcccccc),
        pagerFocusedBackgroundColor: const Color(0xff5078F0),
      ),
      bodyCellOnTap: (childCell, left, top, width, height, scrollLeft, scrollTop) {
        print("左键点击的值为 ${childCell.data}，在表中的位置 : left $left, top $top, width $width, height $height, bodyScrollLeft $scrollLeft, bodyScrollTop $scrollTop");
      },
      bodyCellOnSecondaryTap: (childCell, left, top, width, height, scrollLeft, scrollTop) {
        print("右键点击的值为 ${childCell.data}，在表中的位置 : left $left, top $top, width $width, height $height, bodyScrollLeft $scrollLeft, bodyScrollTop $scrollTop");
      },
    );
  }

  List<FreedomTableHeaderCell> getHeaders() {
    List<FreedomTableHeaderCell> headers = [
      FreedomTableHeaderCell(
        // wether the column which the header cell belong is fixed when table is horizontal scroll
        // when the column is fixed, please ensure the column's child cell DON'T have colspan!!!
        isFixedColumn: true,
        fixedWidth: 200,
        child: headerCell('header-1'),
      ),
      FreedomTableHeaderCell(
        isFixedColumn: true,
        fixedWidth: 200,
        child: headerCell('header-2'),
      ),
      FreedomTableHeaderCell(
        // flex: 1,
        fixedWidth: 200,
        child: headerCell('header-3'),
      ),
      FreedomTableHeaderCell(
        flex: 1,
        // fixedWidth: 200,
        child: headerCell('header-4', Alignment.centerLeft),
      ),
    ];
    if (changedTimes % 2 == 1) {
      headers.add(FreedomTableHeaderCell(
        flex: 1,
        // fixedWidth: 200,
        child: headerCell('header-5 长中文测试：中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文'),
      ));
    }
    return headers;
  }

  // 获取分页数据
  List<List<FreedomTableBodyCell>> getPageData(totalPages, currentPageIndex) {
    return currentPageIndex % 2 == 0
        ? [
            [
              FreedomTableBodyCell(
                data: "testdata",
                child: rowCell('row1-column1'),
              ),
              FreedomTableBodyCell(
                data: ["testdata"],
                child: rowCell('row1-column2'),
              ),
              FreedomTableBodyCell(
                data: {
                  ["testdata"]
                },
                rowspan: 2,
                colspan: 2,
                child: rowCell('row1-column3 long-english:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row1-column4'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row1-column5'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row1-column6'),
              ),
            ],
            [
              FreedomTableBodyCell(
                rowspan: 2,
                child: rowCell('row2-column1'),
              ),
              FreedomTableBodyCell(
                data: 'row2-column2',
                child: rowCell('row2-column2'),
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
                // rowspan: 2,
                child: rowCell('row3-column1'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row3-column2'),
              ),
              FreedomTableBodyCell(
                colspan: 2,
                child: rowCell('row3-column3'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row3-column4  长中文测试：中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文'),
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
                rowspan: 2,
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
                rowspan: 2,
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
        : [
            [
              FreedomTableBodyCell(
                child: rowCell('row1-column1'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row1-column2'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row1-column3'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row1-column4'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row1-column5'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row1-column6'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('row2-column1'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row2-column2'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row2-column3'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row2-column4  long-english: long long long long long end'),
              ),
              FreedomTableBodyCell(
                child: rowCell('row2-column5'),
              ),
            ],
          ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10, right: 10),
                child: ElevatedButton(
                  child: const Text('滚动到表格最右边'),
                  onPressed: () {
                    table.scrollToTheFarRight();
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10, right: 10),
                child: ElevatedButton(
                  child: const Text('替换表格'),
                  onPressed: () {
                    setState(() {
                      setTable();
                    });
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: table,
          ),
        ]),
      ),
    );
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
