import 'package:flutter/material.dart';
import 'dart:async';
import 'package:date_format/date_format.dart';

enum Category { Todo, Event, Meeting, Shopping, Birthday, Personal }

class AddTask extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddTaskState();
  }
}

class _AddTaskState extends State<AddTask> {
  String _selectedCategory;
  DateTime _selectedDate;
  TimeOfDay _selectedTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedCategory = 'Todo';
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Add Task',
            style: TextStyle(
              fontFamily: 'Raleway-Regular',
              fontSize: 16.0,
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Card(
              margin: const EdgeInsets.all(15.0),
              elevation: 4.0,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Add to Category:",
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Expanded(
                              child: new PopupMenuButton<Category>(
                                child: Center(
                                    child: Text(
                                  _selectedCategory,
                                  style: TextStyle(fontSize: 16.0),
                                )),
                                onSelected: (Category result) {
                                  setState(() {
                                    _selectedCategory =
                                        result.toString().substring(
                                              9,
                                            );
                                  });
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<Category>>[
                                      const PopupMenuItem<Category>(
                                        value: Category.Todo,
                                        child: Text('To Do'),
                                      ),
                                      const PopupMenuItem<Category>(
                                        value: Category.Event,
                                        child: const Text('Event'),
                                      ),
                                      const PopupMenuItem<Category>(
                                        value: Category.Meeting,
                                        child: const Text('Meeting'),
                                      ),
                                      const PopupMenuItem<Category>(
                                        value: Category.Shopping,
                                        child: const Text('Shopping'),
                                      ),
                                      const PopupMenuItem<Category>(
                                        value: Category.Personal,
                                        child: const Text('Personal'),
                                      ),
                                    ],
                              ),
                            ),
                          ]),
                      TextFormField(
                          keyboardType: TextInputType
                              .text, // Use email input type for emails.
                          decoration: new InputDecoration(
                          //    hintText: 'Enter your Task',
                              labelText: 'Enter your Task')),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Date:'),
                          MaterialButton(
                            child: Text(formatDate(
                                _selectedDate, [dd, ' ', MM, ' ', yyyy])),
                            onPressed: () {
                              _showDatePicker();
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Time:'),
                          MaterialButton(
                            child: Text(_selectedTime.format(context)),
                            onPressed: () {
                              _showTimePicker();
                            },
                          ),
                        ],
                      )
                    ]),
              ),
            ),
            RaisedButton(
              onPressed: () {

              },
              child: Text(
                'SAVE',
                style: TextStyle(
                    fontWeight: FontWeight.w800, color: Colors.purple),
              ),
              color: Colors.white,
            )
          ],
        ));
  }

  Future<Null> _showDatePicker() async {
    DateTime date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2017),
        lastDate: DateTime(DateTime.now().year + 1));

    setState(() {
      if (date != null) _selectedDate = date;
    });
  }

  Future<Null> _showTimePicker() async {
    TimeOfDay time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    setState(() {
      if (time != null) _selectedTime = time;
    });
  }
}
