import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: new Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        getItem('Breakfast with my family ABDCJS DHNCs', 'Personal', '08:00',
            ColorConst.colorItems[Random().nextInt(ColorConst.colorItems.length)], false, true, false),
        getItem('Breakfast with my family', 'Personal', '12.00',
            ColorConst.colorItems[Random().nextInt(ColorConst.colorItems.length)], true, false, false),
        getItem('Breakfast with my family', 'Personal', '08:00',
            ColorConst.colorItems[Random().nextInt(ColorConst.colorItems.length)], false, false, false),
        getItem('Breakfast with my family', 'Personal', '08:00',
            ColorConst.colorItems[Random().nextInt(ColorConst.colorItems.length)], false, false, false),
        getItem('Breakfast with my family', 'Personal', '08:00',
            ColorConst.colorItems[Random().nextInt(ColorConst.colorItems.length)], false, false, true),
      ],
    ));
  }

  Widget getItem(String todo, String category, String time, Color color,
      bool isDone, bool isFirst, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Column(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: new Container(
                  width: 0.3,
                  color: isFirst ? Colors.white : Colors.grey,
                ),
              ),
              isDone
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
                  color: isLast ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: new Text(time),
          ),
          Flexible(
            child: new Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.all(10.0).copyWith(right: 50.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  color: color,
                  boxShadow: [
                    BoxShadow(
                        color: color.withOpacity(0.5),
                        spreadRadius: 1.0,
                        blurRadius: 5.0),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    todo,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                        decorationStyle: TextDecorationStyle.solid,
                        decorationColor: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      category,
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
