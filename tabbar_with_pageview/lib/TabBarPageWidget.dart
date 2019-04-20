import 'package:flutter/material.dart';
import 'package:tabbar_with_pageview/pages/TabBarPageFirst.dart';
import 'GSYTabBarWidget.dart';

class TabBarPageWidget extends StatefulWidget {
  @override
  _TabBarPageWidgetState createState() => _TabBarPageWidgetState();
}

class _TabBarPageWidgetState extends State<TabBarPageWidget> with WidgetsBindingObserver {
  final PageController topPageontrol = new PageController();

  final List<String> tab = ["111", "222", "333", "444", "555", "666"];

  _renderTab() {
    List<Widget> list = new List();
    for (int i = 0; i < tab.length; i++) {
      list.add(new FlatButton(
        onPressed: () {
          topPageontrol.jumpTo(MediaQuery.of(context).size.width * i);
        },
        child: new Text(
          tab[i],
          maxLines: 1,
        ),
      ));
    }
    return list;
  }

  _renderPage() {
    return [
      new TabBarPageFirst(),
      new TabBarPageFirst(),
      new TabBarPageFirst(),
      new TabBarPageFirst(),
      new TabBarPageFirst(),
      new TabBarPageFirst()
    ];
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {

    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new GSYTabBarWidget(
      type: GSYTabBarWidget.TOP_TAB,
      tabItems: _renderTab(),
      tabViews: _renderPage(),
      topPageControl: topPageontrol,
      backgroundColor: Colors.lightBlue,
      indicatorColor: Colors.white,
      title: new Text("Test"),
    );
  }
}
