import 'package:amap_base/amap_base.dart';
import 'package:amap_base_example/composite/composite.screen.dart';
import 'package:amap_base_example/location/location.screen.dart';
import 'package:amap_base_example/map/map.screen.dart';
import 'package:amap_base_example/navi/navi.screen.dart';
import 'package:amap_base_example/search/search.screen.dart';
import 'package:amap_base_example/widgets/dimens.dart';
import 'package:flutter/material.dart';

void main() async {
  await AMap.init('27d67839721288be2ddd87b4fd868822');
  runApp(MaterialApp(
    home: LauncherScreen(),
    theme: ThemeData(primaryColor: Color(0xff292c36)),
  ));
}

class LauncherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AMaps examples'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Color(0xff747474),
      body: DefaultTabController(
        length: 5,
        child: Column(
          children: <Widget>[
            Flexible(
              child: TabBarView(children: [
                MapDemo(),
                SearchDemo(),
                LocationDemo(),
                NaviScreen(),
                CompositeScreen(),
              ]),
            ),
            SPACE_TINY,
            Container(
              color: Colors.white,
              height: 48,
              child: TabBar(
                tabs: [
                  Text('地图', style: TextStyle(color: Colors.black)),
                  Text('搜索', style: TextStyle(color: Colors.black)),
                  Text('定位', style: TextStyle(color: Colors.black)),
                  Text('导航', style: TextStyle(color: Colors.black)),
                  Text('综合', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
