import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/DatabaseHelper.dart';
import 'package:todo_app/TodoList.dart';
import 'package:todo_app/calendar/calendar.dart';

class HomeScreen extends StatefulWidget {
  final db = new DatabaseHelper();
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedDate;
  static final DateFormat _dbDateFormat = new DateFormat("dd/MM/yyyy");
  List<TodoTable> _table;

  searchTasks(String date) {
    widget.db.getTasks(date).then((onValue) {
      setState(() {
        _selectedDate = date;
        _table = onValue;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = _dbDateFormat.format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
        child: new Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text('Todo App', style: TextStyle(
                      fontSize: 20.0
                  ),),
                  MaterialButton(
                    minWidth: 30.0,
                    height: 30.0,
                    padding: EdgeInsets.all(0.0),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/add_task');
                    },
                    child: new Text('+', style: TextStyle(
                        fontSize: 50.0
                    ),),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: new ListView(
                shrinkWrap: true,
                children: <Widget>[
                  new Calendar(
                    onDateSelected: (DateTime date) {
                      setState(() {
                        searchTasks(_dbDateFormat.format(date));
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(child: TodoList(_table, _selectedDate))
          ],
        ));
  }
}