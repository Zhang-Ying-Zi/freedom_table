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
      headers: [
        FreedomTableHeaderCell(
          // 宽度比例
          flex: 1,
          child: headerCell('header', Alignment.centerLeft),
        ),
        FreedomTableHeaderCell(
          // 宽度比例
          flex: 2,
          child: headerCell(
              'headerheaderheaderheaderheaderheaderheaderheaderheaderheaderheaderheaderheaderheader'),
        ),
        FreedomTableHeaderCell(
          // 宽度比例
          flex: 3,
          child: headerCell('header'),
        ),
        FreedomTableHeaderCell(
          // 固定宽度
          fixedWidth: 300,
          child: headerCell('header中文'),
        ),
      ],
      rows: [
        [
          FreedomTableBodyCell(
            // colspan: 3,
            child: rowCell('1-1', Alignment.centerLeft),
          ),
          FreedomTableBodyCell(
            // colspan: 2,
            // rowspan: 2,
            child: rowCell('1-2'),
          ),
          FreedomTableBodyCell(
            child: rowCell(
                '1-3 555555555555555555555555555555555555555555555555555555555'),
          ),
          FreedomTableBodyCell(
            child: rowCell('1-4'),
          ),
        ],
        [
          FreedomTableBodyCell(
            child: rowCell('2-1', Alignment.centerLeft),
          ),
          FreedomTableBodyCell(
            child: rowCell('2-2'),
          ),
          FreedomTableBodyCell(
            colspan: 2,
            child: rowCell('2-3'),
          ),
          FreedomTableBodyCell(
            // rowspan: 2,
            child: rowCell('2-4'),
          ),
        ],
        [
          FreedomTableBodyCell(
            // colspan: 3,
            child: rowCell('3-1', Alignment.centerLeft),
          ),
          FreedomTableBodyCell(
            rowspan: 2,
            child: rowCell('3-2 长文字长文字长文字长文字长文字长文字长文字长文字长文字长文'),
          ),
          FreedomTableBodyCell(
            child: rowCell('3-3'),
          ),
          FreedomTableBodyCell(
            child: rowCell('3-4'),
          ),
        ],
        [
          FreedomTableBodyCell(
            // colspan: 3,
            child: rowCell('4-1', Alignment.centerLeft),
          ),
          FreedomTableBodyCell(
            child: rowCell('4-2'),
          ),
          FreedomTableBodyCell(
            child: rowCell('4-3'),
          ),
          FreedomTableBodyCell(
            child: rowCell('4-4'),
          ),
        ],
        [
          FreedomTableBodyCell(
            // colspan: 3,
            child: rowCell('5-1', Alignment.centerLeft),
          ),
          FreedomTableBodyCell(
            child: rowCell('5-2'),
          ),
          FreedomTableBodyCell(
            colspan: 2,
            rowspan: 3,
            child: rowCell('5-3'),
          ),
          FreedomTableBodyCell(
            child: rowCell('5-4'),
          ),
        ],
        [
          FreedomTableBodyCell(
            // colspan: 3,
            child: rowCell('6-1', Alignment.centerLeft),
          ),
          FreedomTableBodyCell(
            child: rowCell('6-2'),
          ),
          FreedomTableBodyCell(
            child: rowCell('6-3'),
          ),
          FreedomTableBodyCell(
            child: rowCell('6-4'),
          ),
        ],
        [
          FreedomTableBodyCell(
            // colspan: 3,
            child: rowCell('7-1', Alignment.centerLeft),
          ),
          FreedomTableBodyCell(
            child: rowCell('7-2'),
          ),
          FreedomTableBodyCell(
            child: rowCell('7-3'),
          ),
          FreedomTableBodyCell(
            child: rowCell('7-4'),
          ),
        ],
        [
          FreedomTableBodyCell(
            // colspan: 3,
            child: rowCell('8-1', Alignment.centerLeft),
          ),
          FreedomTableBodyCell(
            child: rowCell('8-2'),
          ),
          FreedomTableBodyCell(
            child: rowCell('8-3'),
          ),
          FreedomTableBodyCell(
            child: rowCell('8-4'),
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
      ),
    );
  }

  // row单元格
  Widget rowCell(String name, [Alignment? align]) {
    return Container(
      // decoration: BoxDecoration(
      //     // border: Border.all(
      //     //   color: Colors.black,
      //     // ),
      //     ),
      padding: const EdgeInsets.all(10),
      alignment: align ?? Alignment.center,
      child: Text(
        name,
      ),
    );
  }
}
