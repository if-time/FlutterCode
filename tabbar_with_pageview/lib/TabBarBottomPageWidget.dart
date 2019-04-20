import 'package:flutter/material.dart';
import 'GSYTabBarWidget.dart';
import 'pages/TabBarPageFirst.dart';

class TabBarBottomPageWidget extends StatefulWidget {
  @override
  _TabBarBottomPageWidgetState createState() => _TabBarBottomPageWidgetState();
}

class _TabBarBottomPageWidgetState extends State<TabBarBottomPageWidget> {
  final PageController topPageControl = new PageController();

  final List<String> tab = ["动态", "趋势", "我的"];

  _renderTab() {
    List<Widget> list = new List();

    for (int i = 0; i < tab.length; i++) {
      list.add(new FlatButton(
        onPressed: () {
          topPageControl.jumpTo(MediaQuery.of(context).size.width * i);
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
      new TabBarPageFirst()
    ];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new GSYTabBarWidget(
      type: GSYTabBarWidget.BOTTOM_TAB,
      tabItems: _renderTab(),
      tabViews: _renderPage(),
      topPageControl: topPageControl,
      backgroundColor: Colors.black45,
      indicatorColor: Colors.white,
      title: new Text("flutter"),
    );
  }
}
