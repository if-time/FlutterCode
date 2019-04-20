import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/src/core/point.dart';
import 'package:flutter_map/src/gestures/gestures.dart';
import 'package:flutter_map/src/layer/group_layer.dart';
import 'package:flutter_map/src/layer/overlay_image_layer.dart';
import 'package:flutter_map/src/map/map.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:async/async.dart';

class FlutterMapState extends MapGestureMixin {
  final MapControllerImpl mapController;
  final List<StreamGroup<Null>> groups = <StreamGroup<Null>>[];
  MapOptions get options => widget.options ?? new MapOptions();
  MapState mapState;

  FlutterMapState(this.mapController);

  initState() {
    super.initState();
    mapState = new MapState(options);
    mapController.state = mapState;
  }

  void _dispose() {
    groups.forEach((group) => group.close());
    groups.clear();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  Stream<Null> _merge(LayerOptions options) {
    if (options?.rebuild == null) return mapState.onMoved;

    StreamGroup<Null> group = new StreamGroup<Null>();
    group.add(mapState.onMoved);
    group.add(options.rebuild);
    groups.add(group);
    return group.stream;
  }

  Widget build(BuildContext context) {
    _dispose();
    return new LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      mapState.size =
          new CustomPoint<double>(constraints.maxWidth, constraints.maxHeight);
      var layerWidgets = widget.layers
          .map((layer) => _createLayer(layer, widget.options.plugins))
          .toList();

      var layerWidgetsContainer = new Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: new Stack(
          children: layerWidgets,
        ),
      );

      if (!options.interactive) {
        return layerWidgetsContainer;
      }

      return PositionedTapDetector(
        onTap: handleTap,
        onLongPress: handleLongPress,
        onDoubleTap: handleDoubleTap,
        child: new GestureDetector(
          onScaleStart: handleScaleStart,
          onScaleUpdate: handleScaleUpdate,
          onScaleEnd: handleScaleEnd,
          child: layerWidgetsContainer,
        ),
      );
    });
  }

  Widget _createLayer(LayerOptions options, List<MapPlugin> plugins) {
    if (options is TileLayerOptions) {
      return new TileLayer(
          options: options, mapState: mapState, stream: _merge(options));
    }
    if (options is MarkerLayerOptions) {
      return new MarkerLayer(options, mapState, _merge(options));
    }
    if (options is PolylineLayerOptions) {
      return new PolylineLayer(options, mapState, _merge(options));
    }
    if (options is PolygonLayerOptions) {
      return new PolygonLayer(options, mapState, _merge(options));
    }
    if (options is CircleLayerOptions) {
      return new CircleLayer(options, mapState, _merge(options));
    }
    if (options is GroupLayerOptions) {
      return new GroupLayer(options, mapState, _merge(options));
    }
    if (options is OverlayImageLayerOptions) {
      return new OverlayImageLayer(options, mapState, _merge(options));
    }
    for (var plugin in plugins) {
      if (plugin.supportsLayer(options)) {
        return plugin.createLayer(options, mapState, _merge(options));
      }
    }
    return null;
  }
}
