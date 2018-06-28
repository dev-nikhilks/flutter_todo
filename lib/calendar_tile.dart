import 'package:flutter/material.dart';
import 'package:date_utils/date_utils.dart';

class CalendarTile extends StatelessWidget {
  final VoidCallback onDateSelected;
  final DateTime date;
  final String dayOfWeek;
  final String dayOfMonth;
  final bool isDayOfWeek;
  final bool isSelected;
  final bool isMonth;
  final TextStyle dayOfWeekStyles;
  final TextStyle dateStyles;
  final Widget child;

  CalendarTile(
      {this.onDateSelected,
        this.date,
        this.child,
        this.dateStyles,
        this.dayOfWeek,
        this.dayOfMonth,
        this.dayOfWeekStyles,
        this.isDayOfWeek: false,
        this.isSelected: false,
        this.isMonth: false});

  Widget renderDateOrDayOfWeek(BuildContext context) {
    if (isMonth)
      return new Center(
          child: Column(
            children: <Widget>[
              Expanded(child: Center(child: new Text(dayOfMonth))),
              new Container(
                height: 10.0,
                color: Colors.white,
              )
            ],
          ));
    return new InkWell(
      onTap: onDateSelected,
      child: isSelected ?Container(
//        margin: EdgeInsets.all(3.0),
//        elevation: 5.0,
//      decoration: BoxDecoration(
//        boxShadow: [
//          BoxShadow(color: Color.fromRGBO(73, 103, 185, 1.0))
//        ],
        color: Color.fromRGBO(242, 243, 246, 1.0),
//      ),

//        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: new Container(
                margin: EdgeInsets.only(right: 3.0,left: 3.0),
                decoration: new BoxDecoration(
                  color: Color.fromRGBO(73, 103, 185, 1.0),
                  boxShadow: [
                    BoxShadow(color: Color.fromRGBO(73, 103, 185, 1.0),blurRadius: 5.0)
                  ],
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      dayOfWeek,
                      style: isSelected
                          ? TextStyle(color: Colors.white, fontWeight: FontWeight.bold )

                          : dateStyles,
                      textAlign: TextAlign.center,
                    ),
                    new Text(
                      Utils.formatDay(date).toString(),
                      style: isSelected
                          ? TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 12.0)
                          : dateStyles,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            isSelected
                ? Container(
              color: Colors.white,
              child: new Container(
                height: 10.0,
                margin: EdgeInsets.only(right: 3.0,left: 3.0),
                padding: EdgeInsets.only(bottom: 3.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                  color: Color.fromRGBO(73, 103, 185, 1.0),
                  boxShadow: [
                    BoxShadow(color: Color.fromRGBO(73, 103, 185, 1.0),blurRadius: 5.0)
                  ],
                ),
              ),
            )
                : new Container(
              height: 10.0,
              color: Colors.white,
            )
          ],
        ),
      ) : Container(
        decoration: BoxDecoration(color: Color.fromRGBO(242, 243, 246, 1.0),),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: new Container(
                decoration: isSelected
                    ? new BoxDecoration(
                  color: Color.fromRGBO(73, 103, 185, 1.0),
                )
                    : new BoxDecoration(color: Colors.transparent),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Text(
                      dayOfWeek,
                      style: isSelected
                          ? new TextStyle(color: Colors.white)
                          : dateStyles,
                      textAlign: TextAlign.center,
                    ),
                    new Text(
                      Utils.formatDay(date).toString(),
                      style: isSelected
                          ? new TextStyle(color: Colors.white)
                          : dateStyles,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            new Container(
              height: 10.0,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return child;
    }
    return new Container(
      decoration: new BoxDecoration(),
      child: renderDateOrDayOfWeek(context),
    );
  }
}
