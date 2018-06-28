import 'package:flutter/material.dart';
import 'package:todo_app/calendar.dart';

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
        appBar: new AppBar(
          title: new Text('Flutter Calendar'),
        ),
        body: new Container(
          height: double.infinity,
          color: Colors.white,

          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              new Calendar(
                onDateSelected: (date) => print(date),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
