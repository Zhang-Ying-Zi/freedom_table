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
          flex: 1,
          child: headCell('test1'),
        ),
        FreedomTableHeaderCell(
          flex: 1,
          child: headCell('longtestlongtestlongtesttest2'),
        ),
        FreedomTableHeaderCell(
          flex: 3,
          child: headCell('test3'),
        ),
        FreedomTableHeaderCell(
          fixedWidth: 300,
          child: headCell('中文测试'),
        ),
      ],
    );
  }

  Widget headCell(String name) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Text(
        name,
      ),
    );
  }
}
