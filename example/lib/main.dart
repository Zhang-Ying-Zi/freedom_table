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
      bodys: [
        [
          FreedomTableBodyCell(
            child: bodyCell('1', Alignment.centerLeft),
          ),
          FreedomTableBodyCell(
            child: bodyCell('1'),
          ),
          FreedomTableBodyCell(
            child: bodyCell(
                '111111111111111111111111111111111111111111111111111111111111111111111111'),
          ),
          FreedomTableBodyCell(
            child: bodyCell('1'),
          ),
        ],
        [
          FreedomTableBodyCell(
            child: bodyCell('2', Alignment.centerLeft),
          ),
          FreedomTableBodyCell(
            colspan: 2,
            child: bodyCell('2'),
          ),
          FreedomTableBodyCell(
            child: bodyCell('2'),
          ),
        ],
        [
          FreedomTableBodyCell(
            child: bodyCell('3', Alignment.centerLeft),
          ),
          FreedomTableBodyCell(
            rowspan: 2,
            child: bodyCell('3'),
          ),
          FreedomTableBodyCell(
            child: bodyCell('3'),
          ),
          FreedomTableBodyCell(
            child: bodyCell('3'),
          ),
        ],
        [
          FreedomTableBodyCell(
            child: bodyCell('4', Alignment.centerLeft),
          ),
          FreedomTableBodyCell(
            child: bodyCell('4', Alignment.centerLeft),
          ),
          FreedomTableBodyCell(
            child: bodyCell(
                '44444444444444444444444444444444444444444444444444444444444444444444'),
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

  // bady单元格
  Widget bodyCell(String name, [Alignment? align]) {
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
