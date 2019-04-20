import 'package:flutter/material.dart';
import 'TabBarPageWidget.dart';
import 'TabBarBottomPageWidget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: new MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  Future<bool> _dialogExitApp(BuildContext context) async {
    if (Platform.isAndroid) {
      AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: "android.intent.category.HOME",
      );
      await intent.launch();
    }
    return Future.value(false);
  }
  // Future<bool> _dialogExitApp(BuildContext context) {
    // return showDialog(
    //     context: context,
    //     builder: (context) => new AlertDialog(
    //           content: new Text("是否退出"),
    //           actions: <Widget>[
    //             new FlatButton(
    //               onPressed: () => Navigator.of(context).pop(false),
    //               child: new Text("取消"),
    //             ),
    //             new FlatButton(
    //               onPressed: () {
    //                 Navigator.of(context).pop(true);
    //               },
    //               child: new Text("确定"),
    //             )
    //           ],
    //         ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
        onWillPop: () {
          _dialogExitApp(context);
        },
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text("Title"),
          ),
          body: new Column(
            children: <Widget>[
              new FlatButton(
                color: Colors.blue,
                onPressed: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new TabBarPageWidget()));
                },
                child: new Text("Top Tab"),
              ),
              new FlatButton(
                color: Colors.blue,
                onPressed: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new TabBarBottomPageWidget()));
                },
                child: new Text("Bottom Tab"),
              )
            ],
          ),
        ));
  }
}
