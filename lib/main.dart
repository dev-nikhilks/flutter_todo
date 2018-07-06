import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/calendar.dart';
import 'package:todo_app/database.dart';
import 'package:todo_app/todo_itemlsit.dart';

void main() => runApp(new MyApp());
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'OpenSans-Light'
      ),
      home: new Scaffold(

//        body: new Container(
//          height: double.infinity,
//          color: Colors.white,
//
//          child: new ListView(
//            shrinkWrap: true,
//            children: <Widget>[
//              new Calendar(
//                onDateSelected: (date) => print(date),
//              ),
//            ],
//          ),
//        ),
      body: SafeArea(child: TodoList()),
      ),
    );
  }

}
