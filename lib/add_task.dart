import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/DatabaseHelper.dart';
import 'package:material_color_picker/material_color_picker.dart';
import 'package:todo_app/constants.dart';

enum Category { Todo, Event, Meeting, Shopping, Birthday, Personal }

class AddTask extends StatefulWidget {
  var db = new DatabaseHelper();

  @override
  State<StatefulWidget> createState() {
    return _AddTaskState();
  }
}

class _AddTaskState extends State<AddTask> {
  String _selectedCategory;
  DateTime _selectedDate;
  TimeOfDay _selectedTime;
  Color _selectedColor;
  TextEditingController mController = new TextEditingController();
  static final DateFormat _dbDateFormat = new DateFormat("dd/MM/yyyy");
  static final DateFormat _dbTimeFormat = new DateFormat.Hm();
  static final DateFormat _timeFormat = new DateFormat().add_jm();

  @override
  void initState() {

    _selectedColor = ColorConst.colorItems[
      Random().nextInt(ColorConst.colorItems.length)];
    _selectedCategory = 'Todo';
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _selectedColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15.0),
            elevation: 4.0,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child:
              new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Add to Category:",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      new Expanded(
                        child: new PopupMenuButton<Category>(
                          child: Center(
                              child: Text(
                                _selectedCategory,
                                style: TextStyle(fontSize: 16.0),
                              )),
                          onSelected: (Category result) {
                            setState(() {
                              _selectedCategory = result.toString().substring(
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
                    controller: mController,
                    keyboardType: TextInputType.text,
                    decoration:
                    new InputDecoration(labelText: 'Enter your Task')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Date:'),
                    MaterialButton(
                      child: Text(
                          formatDate(_selectedDate, [dd, ' ', MM, ' ', yyyy])),
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
                      onPressed: () async {
                        _showTimePicker();
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Color :'),
                    MaterialButton(
                      child: Container(
                        width: 25.0,
                        height: 25.0,
                        decoration: BoxDecoration(
                          color: _selectedColor,
                          shape: BoxShape.circle
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          child: new SimpleDialog(
                            title: const Text('Select color'),
                            children: <Widget>[
                              new ColorPicker(
                                type: MaterialType.transparency,
                                onColor: (color) {
                                  Navigator.pop(context, color);
                                },
                                currentColor: Colors.black,
                              ),
                            ],
                          ),
                        ).then((color){
                          setState(() {
                            _selectedColor = color;
                          });
                        });
                      },
                    ),
                  ],
                )
              ]),
            ),
          ),
          RaisedButton(
            onPressed: () {
              widget.db.saveTask(TodoTable(
                  _dbDateFormat.format(_selectedDate),
                  mController.value.text,
                  _selectedCategory,
                  _dbTimeFormat
                      .format(_timeFormat.parse(_selectedTime.format(context))),
                  _selectedColor.value,
                  0));
            },
            child: Text(
              'SAVE',
              style:
              TextStyle(fontWeight: FontWeight.w800, color: Colors.purple),
            ),
            color: Colors.white,
          )
        ],
      ),
    );
  }

  Future<Null> _showDatePicker() async {
    DateTime date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2017),
        lastDate: DateTime(DateTime
            .now()
            .year + 1));

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
