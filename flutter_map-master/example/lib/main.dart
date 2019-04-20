import 'package:flutter/material.dart';
import './pages/moving_markers.dart';
import './pages/esri.dart';
import './pages/home.dart';
import './pages/map_controller.dart';
import './pages/animated_map_controller.dart';
import './pages/marker_anchor.dart';
import './pages/plugin_api.dart';
import './pages/polyline.dart';
import './pages/tap_to_add.dart';
import './pages/offline_map.dart';
import './pages/on_tap.dart';
import './pages/circle.dart';
import './pages/overlay_image.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Map Example',
      theme: new ThemeData(
        primarySwatch: mapBoxBlue,
      ),
      home: new HomePage(),
      routes: <String, WidgetBuilder>{
        TapToAddPage.route: (context) => new TapToAddPage(),
        EsriPage.route: (context) => new EsriPage(),
        PolylinePage.route: (context) => new PolylinePage(),
        MapControllerPage.route: (context) => new MapControllerPage(),
        AnimatedMapControllerPage.route: (context) =>
            new AnimatedMapControllerPage(),
        MarkerAnchorPage.route: (context) => new MarkerAnchorPage(),
        PluginPage.route: (context) => new PluginPage(),
        OfflineMapPage.route: (context) => new OfflineMapPage(),
        OnTapPage.route: (context) => new OnTapPage(),
        MovingMarkersPage.route: (context) => new MovingMarkersPage(),
        CirclePage.route: (context) => new CirclePage(),
        OverlayImagePage.route: (context) => new OverlayImagePage(),
      },
    );
  }
}

// Generated using Material Design Palette/Theme Generator
// http://mcg.mbitson.com/
// https://github.com/mbitson/mcg
const int _bluePrimary = 0xFF395afa;
const MaterialColor mapBoxBlue = const MaterialColor(
  _bluePrimary,
  const <int, Color>{
    50: const Color(0xFFE7EBFE),
    100: const Color(0xFFC4CEFE),
    200: const Color(0xFF9CADFD),
    300: const Color(0xFF748CFC),
    400: const Color(0xFF5773FB),
    500: const Color(_bluePrimary),
    600: const Color(0xFF3352F9),
    700: const Color(0xFF2C48F9),
    800: const Color(0xFF243FF8),
    900: const Color(0xFF172EF6),
  },
);
