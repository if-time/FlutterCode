import 'package:flutter/material.dart';
import 'pages/Map_screen.dart';
import 'pages/Trace_screen.dart';
import 'pages/Question_screen.dart';
import 'pages/Mine_screen.dart';
import 'DemoStateWidget.dart';
import 'package:demo_1/widgetstudy/DemoPage.dart';

class BottomNavigationWidget extends StatefulWidget {
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  final _BottomNavigationColor = Colors.blue;
  int _currentIndex = 0;
  List<Widget> list = List();

  @override
  void initState() {
    // TODO: implement initState
    list
      ..add(MapScreen())
      ..add(TraceScreen())
      ..add(QuestionScreen())
      ..add(MineScreen())
      ..add(DemoStateWidget("shiwo"))
      ..add(DemoPage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: list[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.map,
                color: _BottomNavigationColor,
              ),
              title: Text(
                'Map',
                style: TextStyle(color: _BottomNavigationColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.track_changes,
                color: _BottomNavigationColor,
              ),
              title: Text(
                'Trace',
                style: TextStyle(color: _BottomNavigationColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.question_answer,
                color: _BottomNavigationColor,
              ),
              title: Text(
                'Question_answer',
                style: TextStyle(color: _BottomNavigationColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                color: _BottomNavigationColor,
              ),
              title: Text(
                'Mine',
                style: TextStyle(color: _BottomNavigationColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.terrain,
                color: _BottomNavigationColor,
              ),
              title: Text(
                'DemoStateWidget',
                style: TextStyle(color: _BottomNavigationColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.terrain,
                color: _BottomNavigationColor,
              ),
              title: Text(
                'DemoStateWidget',
                style: TextStyle(color: _BottomNavigationColor),
              ))
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
