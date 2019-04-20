import 'package:amap_base_example/search/search.screen.dart';
import 'package:amap_base_search/amap_base_search.dart';
import 'package:flutter/material.dart';

void main() async {
  await AMap.init('27d67839721288be2ddd87b4fd868822');
  runApp(MaterialApp(
    home: LauncherScreen(),
    theme: ThemeData(
      primaryColor: Color(0xff292c36),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    ),
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
      body: SearchDemo(),
    );
  }
}
