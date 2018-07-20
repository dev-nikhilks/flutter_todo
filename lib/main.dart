import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_app/HomeScreen.dart';
import 'package:todo_app/add_task.dart';

Future main() async {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
          primarySwatch: Colors.purple, fontFamily: 'OpenSans-Light'),
      routes: <String, WidgetBuilder>
      {
        '/add_task': (BuildContext context) => new AddTask(),
      },
      home: new Scaffold(
          body: HomeScreen()
      ),
    );
  }
}



