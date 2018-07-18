import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/calendar_tile.dart';
import 'package:tuple/tuple.dart';
import 'package:date_utils/date_utils.dart';


typedef DayBuilder(BuildContext context, DateTime day);

class Calendar extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<Tuple2<DateTime, DateTime>> onSelectedRangeChange;
  final bool isExpandable;
  final DayBuilder dayBuilder;
  final bool showTodayAction;

  Calendar({
    this.onDateSelected,
    this.onSelectedRangeChange,
    this.isExpandable: false,
    this.dayBuilder,
    this.showTodayAction: false,
  });

  @override
  _CalendarState createState() => new _CalendarState();
}

class _CalendarState extends State<Calendar> {
  static final DateFormat _monthFormat = new DateFormat("MMM");

  static String formatMonth(DateTime d) => _monthFormat.format(d);

  final calendarUtils = new Utils();
  DateTime today = new DateTime.now();
  List<DateTime> selectedMonthsDays;
  Iterable<DateTime> selectedWeeksDays;
  DateTime _selectedDate;
  Tuple2<DateTime, DateTime> selectedRange;
  String currentMonth;
  bool isExpanded = false;
  String displayMonth;

  DateTime get selectedDate => _selectedDate;

  void initState() {
    super.initState();
    selectedMonthsDays = Utils.daysInMonth(today);
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(today);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(today);
    selectedWeeksDays = Utils
        .daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
        .toList()
        .sublist(0, 7);
    _selectedDate = today;
    displayMonth = formatMonth(Utils.firstDayOfWeek(today));
  }

  Widget get nameAndIconRow {
    return new Text(
      displayMonth,
      style: new TextStyle(
        fontSize: 20.0,
      ),
    );
  }

  Widget get calendarGridView {
    return new Flexible(
      flex: 1,
      child: new Container(
        child: new GestureDetector(
          onHorizontalDragStart: (gestureDetails) => beginSwipe(gestureDetails),
          onHorizontalDragUpdate: (gestureDetails) =>
              getDirection(gestureDetails),
          onHorizontalDragEnd: (gestureDetails) => endSwipe(gestureDetails),
          child: new GridView.count(
            shrinkWrap: true,
            childAspectRatio: 0.8,
            crossAxisCount: 8,
            children: calendarBuilder(),
          ),
        ),
      ),
    );
  }

  List<Widget> calendarBuilder() {
    List<Widget> dayWidgets = [];
    List<DateTime> calendarDays =
    isExpanded ? selectedMonthsDays : selectedWeeksDays;

//    Utils.weekdays.forEach(
//      (day) {
//        dayWidgets.add(
//          new CalendarTile(
//            isDayOfWeek: true,
//            dayOfWeek: day,
//          ),
//        );
//      },
//    );
    dayWidgets.add(
        new CalendarTile(
          isMonth: true,
          dayOfMonth: displayMonth,
        )
    );

    bool monthStarted = false;
    bool monthEnded = false;

    int i=0;
    calendarDays.forEach(
          (day) {
        if (monthStarted && day.day == 01) {
          monthEnded = true;
        }

        if (Utils.isFirstDayOfMonth(day)) {
          monthStarted = true;
        }

        dayWidgets.add(
          new CalendarTile(
            onDateSelected: () => handleSelectedDateAndUserCallback(day),
            date: day,
            dateStyles: configureDateStyle(monthStarted, monthEnded),
            dayOfWeek: Utils.weekdays[i],
            isSelected: Utils.isSameDay(selectedDate, day),
          ),
        );
        i++;
      },
    );
    return dayWidgets;
  }

  TextStyle configureDateStyle(monthStarted, monthEnded) {
    return new TextStyle(color: Color.fromRGBO(179, 181, 192, 1.0),  fontSize: 12.0,fontWeight: FontWeight.bold);
  }

  Widget get expansionButtonRow {
    if (widget.isExpandable) {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(Utils.fullDayFormat(selectedDate)),
          new IconButton(
            iconSize: 20.0,
            padding: new EdgeInsets.all(0.0),
            onPressed: toggleExpanded,
            icon: isExpanded
                ? new Icon(Icons.arrow_drop_up)
                : new Icon(Icons.arrow_drop_down),
          ),
        ],
      );
    } else {
      return new Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Color.fromRGBO(242, 243, 246,1.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[ calendarGridView],
      ),
    );
  }

  void resetToToday() {
    today = new DateTime.now();
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(today);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(today);

    setState(() {
      _selectedDate = today;
      selectedWeeksDays = Utils
          .daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
          .toList();
      displayMonth = formatMonth(Utils.firstDayOfWeek(today));
    });

    _launchDateSelectionCallback(today);
  }

  void nextMonth() {
    setState(() {
      today = Utils.nextMonth(today);
      var firstDateOfNewMonth = Utils.firstDayOfMonth(today);
      var lastDateOfNewMonth = Utils.lastDayOfMonth(today);
      updateSelectedRange(firstDateOfNewMonth, lastDateOfNewMonth);
      selectedMonthsDays = Utils.daysInMonth(today);
      displayMonth = formatMonth(Utils.firstDayOfWeek(today));
    });
  }

  void previousMonth() {
    setState(() {
      today = Utils.previousMonth(today);
      var firstDateOfNewMonth = Utils.firstDayOfMonth(today);
      var lastDateOfNewMonth = Utils.lastDayOfMonth(today);
      updateSelectedRange(firstDateOfNewMonth, lastDateOfNewMonth);
      selectedMonthsDays = Utils.daysInMonth(today);
      displayMonth = formatMonth(Utils.firstDayOfWeek(today));
    });
  }

  void nextWeek() {
    setState(() {
      today = Utils.nextWeek(today);
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(today);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(today);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeeksDays = Utils
          .daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
          .toList()
          .sublist(0, 7);
      displayMonth = formatMonth(Utils.firstDayOfWeek(today));
    });
  }

  void previousWeek() {
    setState(() {
      today = Utils.previousWeek(today);
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(today);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(today);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeeksDays = Utils
          .daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
          .toList()
          .sublist(0, 7);
      displayMonth = formatMonth(Utils.firstDayOfWeek(today));
    });
  }

  void updateSelectedRange(DateTime start, DateTime end) {
    selectedRange = new Tuple2<DateTime, DateTime>(start, end);
    if (widget.onSelectedRangeChange != null) {
      widget.onSelectedRangeChange(selectedRange);
    }
  }

  Future<Null> selectDateFromPicker() async {
    DateTime selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? new DateTime.now(),
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );

    if (selected != null) {
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(selected);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(selected);

      setState(() {
        _selectedDate = selected;
        selectedWeeksDays = Utils
            .daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
            .toList();
        selectedMonthsDays = Utils.daysInMonth(selected);
        displayMonth = formatMonth(Utils.firstDayOfWeek(selected));
      });

      _launchDateSelectionCallback(selected);
    }
  }

  var gestureStart;
  var gestureDirection;

  void beginSwipe(DragStartDetails gestureDetails) {
    gestureStart = gestureDetails.globalPosition.dx;
  }

  void getDirection(DragUpdateDetails gestureDetails) {
    if (gestureDetails.globalPosition.dx < gestureStart) {
      gestureDirection = 'rightToLeft';
    } else {
      gestureDirection = 'leftToRight';
    }
  }

  void endSwipe(DragEndDetails gestureDetails) {
    if (gestureDirection == 'rightToLeft') {
      if (isExpanded) {
        nextMonth();
      } else {
        nextWeek();
      }
    } else {
      if (isExpanded) {
        previousMonth();
      } else {
        previousWeek();
      }
    }
  }

  void toggleExpanded() {
    if (widget.isExpandable) {
      setState(() => isExpanded = !isExpanded);
    }
  }

  void handleSelectedDateAndUserCallback(DateTime day) {
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(day);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(day);
    setState(() {
      _selectedDate = day;
      selectedWeeksDays = Utils
          .daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
          .toList();
    });
    _launchDateSelectionCallback(day);
  }

  void _launchDateSelectionCallback(DateTime day) {
    if (widget.onDateSelected != null) {
      widget.onDateSelected(day);
    }
  }
}

class ExpansionCrossFade extends StatelessWidget {
  final Widget collapsed;
  final Widget expanded;
  final bool isExpanded;

  ExpansionCrossFade({this.collapsed, this.expanded, this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return new Flexible(flex: 1, child: collapsed);
  }
}
