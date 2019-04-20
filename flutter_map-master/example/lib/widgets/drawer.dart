import 'package:flutter/material.dart';
import '../pages/animated_map_controller.dart';
import '../pages/esri.dart';
import '../pages/home.dart';
import '../pages/map_controller.dart';
import '../pages/marker_anchor.dart';
import '../pages/offline_map.dart';
import '../pages/plugin_api.dart';
import '../pages/polyline.dart';
import '../pages/tap_to_add.dart';
import '../pages/on_tap.dart';
import '../pages/moving_markers.dart';
import '../pages/circle.dart';
import '../pages/overlay_image.dart';

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return new Drawer(
    child: new ListView(
      children: <Widget>[
        const DrawerHeader(
          child: const Center(
            child: const Text("Flutter Map Examples"),
          ),
        ),
        new ListTile(
          title: const Text('OpenStreetMap'),
          selected: currentRoute == HomePage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, HomePage.route);
          },
        ),
        new ListTile(
          title: const Text('Add Pins'),
          selected: currentRoute == TapToAddPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, TapToAddPage.route);
          },
        ),
        new ListTile(
          title: const Text('Esri'),
          selected: currentRoute == EsriPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, EsriPage.route);
          },
        ),
        new ListTile(
          title: const Text('Polylines'),
          selected: currentRoute == PolylinePage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, PolylinePage.route);
          },
        ),
        new ListTile(
          title: const Text('MapController'),
          selected: currentRoute == MapControllerPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, MapControllerPage.route);
          },
        ),
        new ListTile(
          title: const Text('Animated MapController'),
          selected: currentRoute == AnimatedMapControllerPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(
                context, AnimatedMapControllerPage.route);
          },
        ),
        new ListTile(
          title: const Text('Marker Anchors'),
          selected: currentRoute == MarkerAnchorPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, MarkerAnchorPage.route);
          },
        ),
        new ListTile(
          title: const Text('Plugins'),
          selected: currentRoute == PluginPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, PluginPage.route);
          },
        ),
        new ListTile(
          title: const Text('Offline Map'),
          selected: currentRoute == OfflineMapPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, OfflineMapPage.route);
          },
        ),
        new ListTile(
          title: const Text('OnTap'),
          selected: currentRoute == OnTapPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, OnTapPage.route);
          },
        ),
        new ListTile(
          title: const Text('Moving Markers'),
          selected: currentRoute == MovingMarkersPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, MovingMarkersPage.route);
          },
        ),
        new ListTile(
          title: const Text('Circle'),
          selected: currentRoute == CirclePage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, CirclePage.route);
          },
        ),
        new ListTile(
          title: const Text('Overlay Image'),
          selected: currentRoute == OverlayImagePage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, OverlayImagePage.route);
          },
        ),
      ],
    ),
  );
}
