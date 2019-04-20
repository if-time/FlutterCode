import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/src/gestures/latlng_tween.dart';
import 'package:flutter_map/src/map/map.dart';
import 'package:latlong/latlong.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

abstract class MapGestureMixin extends State<FlutterMap>
    with TickerProviderStateMixin {
  static const double _kMinFlingVelocity = 800.0;

  LatLng _mapCenterStart;
  double _mapZoomStart;
  LatLng _focalStartGlobal;
  CustomPoint _focalStartLocal;

  AnimationController _controller;
  Animation<Offset> _flingAnimation;
  Offset _flingOffset = Offset.zero;

  AnimationController _doubleTapController;
  Animation _doubleTapZoomAnimation;
  Animation _doubleTapCenterAnimation;

  FlutterMap get widget;
  MapState get mapState;
  MapState get map => mapState;
  MapOptions get options;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(vsync: this)
      ..addListener(_handleFlingAnimation);
    _doubleTapController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200))
      ..addListener(_handleDoubleTapZoomAnimation);
  }

  void handleScaleStart(ScaleStartDetails details) {
    setState(() {
      _mapZoomStart = map.zoom;
      _mapCenterStart = map.center;

      // determine the focal point within the widget
      final focalOffset = details.focalPoint - _mapOffset;
      _focalStartLocal = _offsetToPoint(focalOffset);
      _focalStartGlobal = _offsetToCrs(focalOffset);

      _controller.stop();
    });
  }

  void handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      final focalOffset = _offsetToPoint(details.focalPoint - _mapOffset);
      final newZoom = _getZoomForScale(_mapZoomStart, details.scale);
      final focalStartPt = map.project(_focalStartGlobal, newZoom);
      final newCenterPt = focalStartPt - focalOffset + map.size / 2.0;
      final newCenter = map.unproject(newCenterPt, newZoom);
      map.move(newCenter, newZoom);
      _flingOffset = _pointToOffset(_focalStartLocal - focalOffset);
    });
  }

  void handleScaleEnd(ScaleEndDetails details) {
    final double magnitude = details.velocity.pixelsPerSecond.distance;
    if (magnitude < _kMinFlingVelocity) return;
    final Offset direction = details.velocity.pixelsPerSecond / magnitude;
    final double distance = (Offset.zero & context.size).shortestSide;
    _flingAnimation = new Tween<Offset>(
      begin: _flingOffset,
      end: _flingOffset - direction * distance,
    ).animate(_controller);
    _controller
      ..value = 0.0
      ..fling(velocity: magnitude / 1000.0);
  }

  void handleTap(TapPosition position) {
    if (options.onTap == null) {
      return;
    }
    final latlng = _offsetToCrs(position.relative);
    // emit the event
    options.onTap(latlng);
  }

  void handleLongPress(TapPosition position) {
    if (options.onLongPress == null) {
      return;
    }
    final latlng = _offsetToCrs(position.relative);
    // emit the event
    options.onLongPress(latlng);
  }

  LatLng _offsetToCrs(Offset offset) {
    // Get the widget's offset
    var renderObject = context.findRenderObject() as RenderBox;
    var width = renderObject.size.width;
    var height = renderObject.size.height;

    // convert the point to global coordinates
    var localPoint = _offsetToPoint(offset);
    var localPointCenterDistance = new CustomPoint(
        (width / 2) - localPoint.x, (height / 2) - localPoint.y);
    var mapCenter = map.project(map.center);
    var point = mapCenter - localPointCenterDistance;
    return map.unproject(point);
  }

  void handleDoubleTap(TapPosition tapPosition) {
    final centerPos = _pointToOffset(map.size) / 2.0;
    final newZoom = _getZoomForScale(map.zoom, 2.0);
    final focalDelta = _getDoubleTapFocalDelta(
        centerPos, tapPosition.relative, newZoom - map.zoom);
    final newCenter = _offsetToCrs(centerPos + focalDelta);
    _startDoubleTapAnimation(newZoom, newCenter);
  }

  Offset _getDoubleTapFocalDelta(
      Offset centerPos, Offset tapPos, double zoomDiff) {
    final tapDelta = tapPos - centerPos;
    final zoomScale = 1 / math.pow(2, zoomDiff);
    // map center offset within which double-tap won't
    // cause zooming to previously invisible area
    final maxDelta = centerPos * (1 - zoomScale);
    final tappedOutExtent =
        tapDelta.dx.abs() > maxDelta.dx || tapDelta.dy.abs() > maxDelta.dy;
    return tappedOutExtent
        ? _projectDeltaOnBounds(tapDelta, maxDelta)
        : tapDelta;
  }

  Offset _projectDeltaOnBounds(Offset delta, Offset maxDelta) {
    final weightX = delta.dx.abs() / maxDelta.dx;
    final weightY = delta.dy.abs() / maxDelta.dy;
    return delta / math.max(weightX, weightY);
  }

  void _startDoubleTapAnimation(double newZoom, LatLng newCenter) {
    _doubleTapZoomAnimation = Tween<double>(begin: map.zoom, end: newZoom)
        .chain(CurveTween(curve: Curves.fastOutSlowIn))
        .animate(_doubleTapController);
    _doubleTapCenterAnimation = LatLngTween(begin: map.center, end: newCenter)
        .chain(CurveTween(curve: Curves.fastOutSlowIn))
        .animate(_doubleTapController);
    _doubleTapController
      ..value = 0.0
      ..forward();
  }

  void _handleDoubleTapZoomAnimation() {
    setState(() {
      map.move(
        _doubleTapCenterAnimation.value,
        _doubleTapZoomAnimation.value,
        hasGesture: true,
      );
    });
  }

  void _handleFlingAnimation() {
    setState(() {
      _flingOffset = _flingAnimation.value;
      var newCenterPoint = map.project(_mapCenterStart) +
          new CustomPoint(_flingOffset.dx, _flingOffset.dy);
      var newCenter = map.unproject(newCenterPoint);
      map.move(newCenter, map.zoom, hasGesture: true);
    });
  }

  CustomPoint _offsetToPoint(Offset offset) {
    return new CustomPoint(offset.dx, offset.dy);
  }

  Offset _pointToOffset(CustomPoint point) {
    return new Offset(point.x.toDouble(), point.y.toDouble());
  }

  Offset get _mapOffset =>
      (context.findRenderObject() as RenderBox).localToGlobal(Offset.zero);

  double _getZoomForScale(double startZoom, double scale) =>
      startZoom + math.log(scale) / math.ln2;

  @override
  void dispose() {
    _controller.dispose();
    _doubleTapController.dispose();
    super.dispose();
  }
}
