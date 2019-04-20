import 'package:amap_base_example/location/location.screen.dart';
import 'package:amap_base_location/amap_base_location.dart';
import 'package:flutter/material.dart';

void main() async {
  debugPrint('main方法运行');
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
      backgroundColor: Colors.grey.shade200,
      body: LocationDemo(),
    );
  }
}
