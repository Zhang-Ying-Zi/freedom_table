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
          child: headerCell('header-1', Alignment.centerLeft),
        ),
        FreedomTableHeaderCell(
          // header width is flex
          flex: 2,
          child: headerCell('header-2'),
        ),
        FreedomTableHeaderCell(
          // header width is flex
          flex: 3,
          child: headerCell('header-3'),
        ),
        FreedomTableHeaderCell(
          // header width is fixed
          fixedWidth: 300,
          child: headerCell(
              'header-4 ???????????????????????? ?????? ?????? ?????? ?????? ?????? ?????? ?????? ?????? ?????? ?????? ?????? ?????? ?????? ??????'),
        ),
      ],
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
    );
    // if not paging, calling below
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   table.updateData(getPageData(1, 0));
    // });
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

  // ??????????????????
  List<List<FreedomTableBodyCell>> getPageData(totalPages, currentPageIndex) {
    return currentPageIndex % 2 == 0
        ? [
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
                    'row3-column4  ???????????????????????? ?????? ?????? ?????? ?????? ?????? ?????? ?????? ?????? ?????? ?????? ?????? ?????? ?????? ??????'),
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
          ]
        : [
            [
              FreedomTableBodyCell(
                child: rowCell('item', Alignment.centerLeft),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('item', Alignment.centerLeft),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('item', Alignment.centerLeft),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('item', Alignment.centerLeft),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('item', Alignment.centerLeft),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('item', Alignment.centerLeft),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('item', Alignment.centerLeft),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('item', Alignment.centerLeft),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('item', Alignment.centerLeft),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
            ],
            [
              FreedomTableBodyCell(
                child: rowCell('item', Alignment.centerLeft),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
              FreedomTableBodyCell(
                child: rowCell('item'),
              ),
            ],
          ];
  }

  // header?????????????????????fontFamily,?????????????????????????????????
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

  // body?????????????????????fontFamily,?????????????????????????????????
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
