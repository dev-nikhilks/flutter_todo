import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_app/DatabaseHelper.dart';
import 'package:todo_app/calendar.dart';
import 'package:todo_app/todo_itemlsit.dart';

Future main() async {
  runApp(new MyApp());

  print(DateTime.fromMillisecondsSinceEpoch(1540201500000));
  List notes;
  var db = new DatabaseHelper();

//  await db.saveTask(new TodoTable("2018-07-16", "Flutter Tutorials",
//      0xFFF44336, "Create SQLite Tutorial"));
//  await db.saveTask(new TodoTable("2018-07-16", "Android Development",
//      0xFFF44336, "Build Firebase Android Apps"));
//  await db.saveTask(new TodoTable("2018-07-16", "Mobile App R&D",
//      0xFFF44336, "Research more cross-flatforms"));

  print('=== getAllNotes() ===');
  notes = await db.getAllTasks();
  notes.forEach((note) => print(note));
  await db.close();
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
          primarySwatch: Colors.purple, fontFamily: 'OpenSans-Light'),
      home: new Scaffold(
        body: new SafeArea(
            child: new Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: new ListView(
                shrinkWrap: true,
                children: <Widget>[
                  new Calendar(
                    onDateSelected: (date) {
                      setState(() {
                        selectedDate = date;
                        print(selectedDate);
                      });
                    },
                  ),
                ],
              ),
            ),
            TodoList(selectedDate)
          ],
        )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }
}
