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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: table(),
      ),
    );
  }

  Widget table() {
    return FreedomTable(
      pager: FreedomTablePager(
        totalCount: 101,
        pageEach: 10,
        callback: (totalPages, currentPageIndex) {
          print("($currentPageIndex, $totalPages)");
        },
      ),
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
          fixedWidth: 1000,
          child: headerCell(
              'header-4 长中文测试：中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文 中文'),
        ),
      ],
      rows: [
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
        ],
      ],
    );
  }

  // header单元格
  Widget headerCell(String name, [Alignment? align]) {
    return Container(
      // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
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

  // row单元格
  Widget rowCell(String name, [Alignment? align]) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: align ?? Alignment.center,
      child: Text(
        name,
        style: const TextStyle(
          fontFamily: "Noto_Sans_SC",
        ),
        // strutStyle: const StrutStyle(
        //   fontSize: 16.0,
        //   height: 1.3,
        // ),
      ),
    );
  }
}
