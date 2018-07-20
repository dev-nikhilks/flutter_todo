
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/DatabaseHelper.dart';

//class TodoList extends StatefulWidget {
//  String _selectedDate;
//  var db = new DatabaseHelper();
//
//  TodoList(this._selectedDate);
//
//  @override
//  TodoListState createState() {
//    print('INSIDE CREATE STATE');
//    return new TodoListState();
//  }
//}
//
//class TodoListState extends State<TodoList> {
//  static final DateFormat _weekdayFormat = new DateFormat("EEEE");
//  static final DateFormat _dbDateFormat = new DateFormat("dd/MM/yyyy");
//  static final DateFormat _dateFormat = new DateFormat("dd MMM yyyy");
//  String weekDay;
//  String date;
//  List<TodoTable> taskList;
//
//
//  searchTasks() {
//    widget.db.getTasks(widget._selectedDate).then((onValue) {
//      setState(() {
//        taskList = onValue;
//      });
//    });
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    weekDay = _weekdayFormat.format(_dbDateFormat.parse(widget._selectedDate));
//    date = _dateFormat.format(_dbDateFormat.parse(widget._selectedDate));
//    searchTasks();
//  }
//
//  @override
//  void didUpdateWidget(TodoList oldWidget) {
//    weekDay = _weekdayFormat.format(_dbDateFormat.parse(widget._selectedDate));
//    date = _dateFormat.format(_dbDateFormat.parse(widget._selectedDate));
//    searchTasks();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//
////    searchTasks();
//    return new Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: <Widget>[
//        Padding(
//          padding: const EdgeInsets.all(4.0),
//          child: RichText(
//            text: TextSpan(
//                text: weekDay,
//                style: TextStyle(
//                  fontFamily: 'OpenSans-Light',
//                  fontWeight: FontWeight.bold,
//                  color: Colors.black,
//                  fontSize: 18.0,
//                ),
//                children: [
//                  TextSpan(
//                    text: date,
//                    style: TextStyle(
//                        fontFamily: 'OpenSans-Light',
//                        fontWeight: FontWeight.normal,
//                        color: Colors.black,
//                        fontSize: 15.0),
//                  )
//                ]),
//          ),
//        ),
//        taskList == null
//            ? Container(
//                child: new Center(
//                  child: Text('No Tasks Found'),
//                ),
//              )
//            : SingleChildScrollView(
//                child: Container(
//                    child: new Column(
//                  mainAxisSize: MainAxisSize.max,
//                  children: todoTaskList
//                )),
//              )
//      ],
//    );
//
//  }
//
//  List<Widget> get todoTaskList {
//
//    List<Widget> result  = [];
//
//    taskList.forEach((item) {
//      result.add(TodoItem(
//          item.todoTask,
//          item.category,
//          '09:00',
//          Color(item.color),
//          false,
//          false,
//          true));
//    });
//    return result;
//  }
//
//  @override
//  void deactivate() {
//    widget.db.close();
//    super.deactivate();
//  }
//}

class TodoList extends StatelessWidget {
  List<TodoTable> taskList;
  String selectedDate;
  static final DateFormat _weekdayFormat = new DateFormat("EEEE");
  static final DateFormat _dbDateFormat = new DateFormat("dd/MM/yyyy");
  static final DateFormat _dateFormat = new DateFormat("dd MMM yyyy");

  TodoList(this.taskList, this.selectedDate);

  @override
  Widget build(BuildContext context) {
    String weekDay = _weekdayFormat.format(_dbDateFormat.parse(selectedDate));
    String date = _dateFormat.format(_dbDateFormat.parse(selectedDate));
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 25.0,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: RichText(
              text: TextSpan(
                  text: weekDay,
                  style: TextStyle(
                    fontFamily: 'OpenSans-Light',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                  children: [
                    TextSpan(
                      text: date,
                      style: TextStyle(
                          fontFamily: 'OpenSans-Light',
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 15.0),
                    )
                  ]),
            ),
          ),
        ),
        taskList == null
            ? Container(
                child: new Center(
                  child: Text('No Tasks Found'),
                ),
              )
            : Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: todoTaskList,
                ),
              )
      ],
    );
  }

  List<Widget> get todoTaskList {
    List<Widget> result = [];
    int i = 1;
    if (taskList.length == 1) {
      result.add(TodoItem(
          taskList[0].todoTask,
          taskList[0].category,
          taskList[0].time,
          Color(taskList[0].color),
          taskList[0].isDone == 1 ? true : false,
          true,
          true));
      return result;
    }

    taskList.forEach((item) {
      if (i == 1) {
        result.add(TodoItem(item.todoTask, item.category, taskList[0].time,
            Color(item.color), item.isDone == 1 ? true : false, true, false));
      } else if (i == taskList.length) {
        result.add(TodoItem(item.todoTask, item.category, taskList[0].time,
            Color(item.color), item.isDone == 1 ? true : false, false, true));
      } else {
        result.add(TodoItem(item.todoTask, item.category, taskList[0].time,
            Color(item.color), item.isDone == 1 ? true : false, false, false));
      }
      i++;
    });
    return result;
  }
}

class TodoItem extends StatefulWidget {
  String todo, category, time;
  Color color;
  bool isDone, isFirst, isLast;

  TodoItem(this.todo, this.category, this.time, this.color, this.isDone,
      this.isFirst, this.isLast);

  @override
  _CalendarItemState createState() => _CalendarItemState();
}

class _CalendarItemState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          if (widget.isDone)
            widget.isDone = false;
          else
            widget.isDone = true;
        });
      },
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Column(
              children: <Widget>[
                Expanded(
                  child: new Container(
                    width: 0.3,
                    color: widget.isFirst ? Colors.white : Colors.grey,
                  ),
                ),
                widget.isDone
                    ? Container(
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(73, 103, 185, 0.2)),
                        child: Container(
                          margin: EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(73, 103, 185, 1.0)),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.radio_button_unchecked,
                          size: 20.0,
                          color: Colors.grey,
                        ),
                      ),
                Expanded(
                  child: new Container(
                    width: 0.3,
                    color: widget.isLast ? Colors.white : Colors.grey,
                  ),
                ),
              ],
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: new Text(widget.time),
            ),
            Flexible(
              child: new Container(
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(10.0).copyWith(right: 50.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    color: widget.color,
                    boxShadow: [
                      BoxShadow(
                          color: widget.color.withOpacity(0.5),
                          spreadRadius: 1.0,
                          blurRadius: 5.0),
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.todo,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          decoration: widget.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationStyle: TextDecorationStyle.solid,
                          decorationColor: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        widget.category,
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
