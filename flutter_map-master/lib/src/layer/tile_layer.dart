import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/src/core/bounds.dart';
import 'package:flutter_map/src/core/point.dart';
import 'package:flutter_map/src/core/util.dart' as util;
import 'package:flutter_map/src/map/map.dart';
import 'package:latlong/latlong.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_image/network.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'layer.dart';

class TileLayerOptions extends LayerOptions {
  ///Defines the structure to create the URLs for the tiles.
  ///
  ///Example:
  ///
  ///https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png
  ///
  ///Is translated to this:
  ///
  ///https://a.tile.openstreetmap.org/12/2177/1259.png
  final String urlTemplate;

  /// If `true`, inverses Y axis numbering for tiles (turn this on for
  /// [TMS](https://en.wikipedia.org/wiki/Tile_Map_Service) services).
  final bool tms;

  ///Size for the tile.
  ///Default is 256
  final double tileSize;

  ///Determiantes the max zoom applicable.
  ///In most tile providers goes from 0 to 19.
  final double maxZoom;

  final bool zoomReverse;
  final double zoomOffset;

  ///List of subdomains for the URL.
  ///
  ///Example:
  ///
  ///Subdomains = {a,b,c}
  ///
  ///and the URL is as follows:
  ///
  ///https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png
  ///
  ///then:
  ///
  ///https://a.tile.openstreetmap.org/{z}/{x}/{y}.png
  ///https://b.tile.openstreetmap.org/{z}/{x}/{y}.png
  ///https://c.tile.openstreetmap.org/{z}/{x}/{y}.png
  final List<String> subdomains;

  ///Color shown behind the tiles.
  final Color backgroundColor;

  ///Turns on/off the offlineMode.
  ///
  ///Requires the urlTemplate to target assets or a filesystem path.
  ///
  ///Example:
  ///
  ///```dart
  ///urlTemplate: "assets/map/anholt_osmbright/{z}/{x}/{y}.png",
  ///```
  ///
  ///or:
  ///
  ///```dart
  ///urlTemplate: "/storage/emulated/0/tiles/some_place/{z}/{x}/{y}.png",
  ///```
  final bool offlineMode;

  ///Reads the tiles from the assets folder in the project.
  ///If true, reads the tiles from the project assets folder.
  ///If false, reads the tiles from the device filesystem.
  ///The later requires permissions to read the device files in Android.
  final bool fromAssets;

  /// Use CachedNetworkImageProvider instead NetworkImageWithRetry
  /// If true, every tile loaded will be storage on cache memory
  /// If false, will download every tiles again after every restart the app
  /// default is true
  final bool cachedTiles;

  /// When panning the map, keep this many rows and columns of tiles before
  /// unloading them.
  final int keepBuffer;
  ImageProvider placeholderImage;
  Map<String, String> additionalOptions;

  TileLayerOptions(
      {this.urlTemplate,
      this.tileSize = 256.0,
      this.maxZoom = 18.0,
      this.zoomReverse = false,
      this.zoomOffset = 0.0,
      this.additionalOptions = const <String, String>{},
      this.subdomains = const <String>[],
      this.keepBuffer = 2,
      this.backgroundColor = const Color(0xFFE0E0E0), // grey[300]
      this.placeholderImage,
      this.offlineMode = false,
      this.tms = false,
      this.fromAssets = true,
      this.cachedTiles = true,
      rebuild})
      : super(rebuild: rebuild);
}

class TileLayer extends StatefulWidget {
  final TileLayerOptions options;
  final MapState mapState;
  final Stream<Null> stream;

  TileLayer({
    this.options,
    this.mapState,
    this.stream,
  });

  State<StatefulWidget> createState() {
    return new _TileLayerState();
  }
}

class _TileLayerState extends State<TileLayer> {
  MapState get map => widget.mapState;

  TileLayerOptions get options => widget.options;
  Bounds _globalTileRange;
  Tuple2<double, double> _wrapX;
  Tuple2<double, double> _wrapY;
  double _tileZoom;
  Level _level;
  StreamSubscription _moveSub;

  Map<String, Tile> _tiles = {};
  Map<double, Level> _levels = {};

  void initState() {
    super.initState();
    _resetView();
    _moveSub = widget.stream.listen((_) => _handleMove());
  }

  void dispose() {
    super.dispose();
    _moveSub?.cancel();
  }

  void _handleMove() {
    setState(() {
      _pruneTiles();
      this._resetView();
    });
  }

  String getTileUrl(Coords coords) {
    var data = <String, String>{
      'x': coords.x.round().toString(),
      'y': coords.y.round().toString(),
      'z': coords.z.round().toString(),
      's': _getSubdomain(coords)
    };
    if (this.options.tms) {
      data['y'] = _invertY(coords.y.round(), coords.z.round()).toString();
    }
    Map<String, String> allOpts = new Map.from(data)
      ..addAll(this.options.additionalOptions);
    return util.template(this.options.urlTemplate, allOpts);
  }

  int _invertY(int y, int z) {
    return ((1 << z) - 1) - y;
  }

  void _resetView() {
    this._setView(map.center, map.zoom);
  }

  void _setView(LatLng center, double zoom) {
    var tileZoom = this._clampZoom(zoom.round().toDouble());
    if (_tileZoom != tileZoom) {
      _tileZoom = tileZoom;
      _updateLevels();
      _resetGrid();
    }
    _setZoomTransforms(center, zoom);
  }

  Level _updateLevels() {
    var zoom = this._tileZoom;
    var maxZoom = this.options.maxZoom;

    if (zoom == null) return null;

    List<double> toRemove = [];
    for (var z in this._levels.keys) {
      if (_levels[z].children.length > 0 || z == zoom) {
        _levels[z].zIndex = maxZoom = (zoom - z).abs();
      } else {
        toRemove.add(z);
      }
    }

    for (var z in toRemove) {
      _removeTilesAtZoom(z);
    }

    var level = _levels[zoom];
    var map = this.map;

    if (level == null) {
      level = _levels[zoom] = new Level();
      level.zIndex = maxZoom;
      var newOrigin = map.project(map.unproject(map.getPixelOrigin()), zoom);
      if (newOrigin != null) {
        level.origin = newOrigin;
      } else {
        level.origin = new CustomPoint(0.0, 0.0);
      }
      level.zoom = zoom;

      _setZoomTransform(level, map.center, map.zoom);
    }
    this._level = level;
    return level;
  }

  void _pruneTiles() {
    var center = map.center;
    var pixelBounds = this._getTiledPixelBounds(center);
    var tileRange = _pxBoundsToTileRange(pixelBounds);
    var margin = this.options.keepBuffer ?? 2;
    var noPruneRange = new Bounds(
        tileRange.bottomLeft - new CustomPoint(margin, -margin),
        tileRange.topRight + new CustomPoint(margin, -margin));
    for (var tileKey in _tiles.keys) {
      var tile = _tiles[tileKey];
      var c = tile.coords;
      if (c.z != _tileZoom ||
          !noPruneRange.contains(new CustomPoint(c.x, c.y))) {
        tile.current = false;
      }
    }
    _tiles.removeWhere((s, tile) => tile.current == false);
  }

  void _setZoomTransform(Level level, LatLng center, double zoom) {
    var scale = map.getZoomScale(zoom, level.zoom);
    var pixelOrigin = map.getNewPixelOrigin(center, zoom).round();
    if (level.origin == null) {
      return;
    }
    var translate = level.origin.multiplyBy(scale) - pixelOrigin;
    level.translatePoint = translate;
    level.scale = scale;
  }

  void _setZoomTransforms(LatLng center, double zoom) {
    for (var i in this._levels.keys) {
      this._setZoomTransform(_levels[i], center, zoom);
    }
  }

  void _removeTilesAtZoom(double zoom) {
    List<String> toRemove = [];
    for (var key in _tiles.keys) {
      if (_tiles[key].coords.z != zoom) {
        continue;
      }
      toRemove.add(key);
    }
    for (var key in toRemove) {
      _removeTile(key);
    }
  }

  void _removeTile(String key) {
    var tile = _tiles[key];
    if (tile == null) {
      return;
    }
    _tiles[key].current = false;
  }

  void _resetGrid() {
    var map = this.map;
    var crs = map.options.crs;
    var tileSize = this.getTileSize();
    var tileZoom = _tileZoom;

    var bounds = map.getPixelWorldBounds(_tileZoom);
    if (bounds != null) {
      _globalTileRange = _pxBoundsToTileRange(bounds);
    }

    // wrapping
    this._wrapX = crs.wrapLng;
    if (_wrapX != null) {
      var first = (map.project(new LatLng(0.0, crs.wrapLng.item1), tileZoom).x /
              tileSize.x)
          .floor()
          .toDouble();
      var second =
          (map.project(new LatLng(0.0, crs.wrapLng.item2), tileZoom).x /
                  tileSize.y)
              .ceil()
              .toDouble();
      _wrapX = new Tuple2(first, second);
    }

    this._wrapY = crs.wrapLat;
    if (_wrapY != null) {
      var first = (map.project(new LatLng(crs.wrapLat.item1, 0.0), tileZoom).y /
              tileSize.x)
          .floor()
          .toDouble();
      var second =
          (map.project(new LatLng(crs.wrapLat.item2, 0.0), tileZoom).y /
                  tileSize.y)
              .ceil()
              .toDouble();
      _wrapY = new Tuple2(first, second);
    }
  }

  double _clampZoom(double zoom) {
    // todo
    return zoom;
  }

  CustomPoint getTileSize() {
    return new CustomPoint(options.tileSize, options.tileSize);
  }

  Widget build(BuildContext context) {
    var pixelBounds = _getTiledPixelBounds(map.center);
    var tileRange = _pxBoundsToTileRange(pixelBounds);
    CustomPoint<double> tileCenter = tileRange.getCenter();
    var queue = <Coords>[];

    // mark tiles as out of view...
    for (var key in this._tiles.keys) {
      var c = this._tiles[key].coords;
      if (c.z != this._tileZoom) {
        _tiles[key].current = false;
      }
    }

    _setView(map.center, map.zoom);

    for (var j = tileRange.min.y; j <= tileRange.max.y; j++) {
      for (var i = tileRange.min.x; i <= tileRange.max.x; i++) {
        var coords = new Coords(i.toDouble(), j.toDouble());
        coords.z = this._tileZoom;

        if (!this._isValidTile(coords)) {
          continue;
        }

        // Add all valid tiles to the queue on Flutter
        queue.add(coords);
      }
    }

    if (queue.length > 0) {
      for (var i = 0; i < queue.length; i++) {
        _tiles[_tileCoordsToKey(queue[i])] =
            new Tile(_wrapCoords(queue[i]), true);
      }
    }

    var tilesToRender = <Tile>[];
    for (var tile in _tiles.values) {
      if ((tile.coords.z - _level.zoom).abs() > 1) {
        continue;
      }
      tilesToRender.add(tile);
    }
    tilesToRender.sort((aTile, bTile) {
      Coords<double> a = aTile.coords;
      Coords<double> b = bTile.coords;
      // a = 13, b = 12, b is less than a, the result should be positive.
      if (a.z != b.z) {
        return (b.z - a.z).toInt();
      }
      return (a.distanceTo(tileCenter) - b.distanceTo(tileCenter)).toInt();
    });

    var tileWidgets = <Widget>[];
    for (var tile in tilesToRender) {
      tileWidgets.add(_createTileWidget(tile.coords));
    }

    return new Container(
      child: new Stack(
        children: tileWidgets,
      ),
      color: this.options.backgroundColor,
    );
  }

  Bounds _getTiledPixelBounds(LatLng center) {
    return map.getPixelBounds(_tileZoom);
  }

  Bounds _pxBoundsToTileRange(Bounds bounds) {
    var tileSize = this.getTileSize();
    return new Bounds(
      bounds.min.unscaleBy(tileSize).floor(),
      bounds.max.unscaleBy(tileSize).ceil() - new CustomPoint(1, 1),
    );
  }

  bool _isValidTile(Coords coords) {
    var crs = map.options.crs;
    if (!crs.infinite) {
      var bounds = _globalTileRange;
      if ((crs.wrapLng == null &&
              (coords.x < bounds.min.x || coords.x > bounds.max.x)) ||
          (crs.wrapLat == null &&
              (coords.y < bounds.min.y || coords.y > bounds.max.y))) {
        return false;
      }
    }
    return true;
  }

  String _tileCoordsToKey(Coords coords) {
    return "${coords.x}:${coords.y}:${coords.z}";
  }

  Widget _createTileWidget(Coords coords) {
    var tilePos = _getTilePos(coords);
    var level = _levels[coords.z];
    var tileSize = getTileSize();
    var pos = (tilePos).multiplyBy(level.scale) + level.translatePoint;
    var width = tileSize.x * level.scale;
    var height = tileSize.y * level.scale;

    return new Positioned(
      left: pos.x.toDouble(),
      top: pos.y.toDouble(),
      width: width.toDouble(),
      height: height.toDouble(),
      child: new Container(
        child: new FadeInImage(
          fadeInDuration: const Duration(milliseconds: 100),
          key: new Key(_tileCoordsToKey(coords)),
          placeholder: options.placeholderImage != null
              ? options.placeholderImage
              : new MemoryImage(kTransparentImage),
          image: _getImageProvider(getTileUrl(coords)),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  ImageProvider _getImageProvider(String url) {
    if (options.offlineMode) {
      if (options.fromAssets) {
        return new AssetImage(url);
      } else {
        return new FileImage(new File(url));
      }
    } else {
      if (options.cachedTiles) {
        return new CachedNetworkImageProvider(url);
      } else {
        return new NetworkImageWithRetry(url);
      }
    }
  }

  Coords _wrapCoords(Coords coords) {
    var newCoords = new Coords(
      _wrapX != null
          ? util.wrapNum(coords.x.toDouble(), _wrapX)
          : coords.x.toDouble(),
      _wrapY != null
          ? util.wrapNum(coords.y.toDouble(), _wrapY)
          : coords.y.toDouble(),
    );
    newCoords.z = coords.z.toDouble();
    return newCoords;
  }

  CustomPoint _getTilePos(Coords coords) {
    var level = _levels[coords.z];
    return coords.scaleBy(this.getTileSize()) - level.origin;
  }

  String _getSubdomain(Coords coords) {
    if (options.subdomains.isEmpty) {
      return "";
    }
    var index = (coords.x + coords.y).round() % this.options.subdomains.length;
    return options.subdomains[index];
  }
}

class Tile {
  final Coords coords;
  bool current;

  Tile(this.coords, this.current);
}

class Level {
  List children = [];
  double zIndex;
  CustomPoint origin;
  double zoom;
  CustomPoint translatePoint;
  double scale;
}

class Coords<T extends num> extends CustomPoint<T> {
  T z;

  Coords(T x, T y) : super(x, y);

  String toString() => 'Coords($x, $y, $z)';

  bool operator ==(dynamic other) {
    if (other is Coords) {
      return this.x == other.x && this.y == other.y && this.z == other.z;
    }
    return false;
  }

  int get hashCode => hashValues(x.hashCode, y.hashCode, z.hashCode);
}
