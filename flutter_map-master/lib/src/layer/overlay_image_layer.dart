import 'dart:async';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart' as img;
import 'package:flutter/services.dart' as img;
import 'package:flutter/widgets.dart' as img;
import 'package:flutter/painting.dart' as img;

import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/src/map/map.dart';

class OverlayImageLayerOptions extends LayerOptions {
  final List<OverlayImage> overlayImages;
  OverlayImageLayerOptions({this.overlayImages = const [], rebuild})
      : super(rebuild: rebuild);
}

class OverlayImage {
  final img.ImageProvider imageProvider;
  final double opacity;
  final LatLngBounds bounds;
  final List<Offset> offsets = [];
  ui.Image image;

  OverlayImage({
    this.bounds,
    this.imageProvider,
    this.opacity = 1.0,
  });
}

Future<ui.Image> _loadImage(img.ImageProvider imageProvider) async {
  img.ImageStream stream = imageProvider.resolve(img.ImageConfiguration.empty);
  Completer<ui.Image> completer = new Completer<ui.Image>();
  void listener(img.ImageInfo frame, bool synchronousCall) {
    final ui.Image image = frame.image;
    completer.complete(image);
    stream.removeListener(listener);
  }

  stream.addListener(listener);
  return completer.future;
}

class OverlayImageLayer extends StatelessWidget {
  final OverlayImageLayerOptions overlayImageOpts;
  final MapState map;
  final Stream<Null> stream;

  OverlayImageLayer(this.overlayImageOpts, this.map, this.stream);

  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: (BuildContext context, BoxConstraints bc) {
        final size = new Size(bc.maxWidth, bc.maxHeight);
        return _build(context, size);
      },
    );
  }

  Widget _build(BuildContext context, Size size) {
    return new StreamBuilder<int>(
      stream: stream, // a Stream<int> or null
      builder: (BuildContext context, _) {
        for (var overlayImageOpt in overlayImageOpts.overlayImages) {
          overlayImageOpt.offsets.clear();
          var pos1 = map.project(overlayImageOpt.bounds.northWest);
          pos1 = pos1.multiplyBy(map.getZoomScale(map.zoom, map.zoom)) -
              map.getPixelOrigin();
          var pos2 = map.project(overlayImageOpt.bounds.southEast);
          pos2 = pos2.multiplyBy(map.getZoomScale(map.zoom, map.zoom)) -
              map.getPixelOrigin();

          overlayImageOpt.offsets
              .add(new Offset(pos1.x.toDouble(), pos1.y.toDouble()));
          overlayImageOpt.offsets
              .add(new Offset(pos2.x.toDouble(), pos2.y.toDouble()));
          _loadImage(overlayImageOpt.imageProvider).then((image) {
            overlayImageOpt.image = image;
          });
        }

        var overlayImages = <Widget>[];
        for (var overlayImageOpt in this.overlayImageOpts.overlayImages) {
          overlayImages.add(
            new CustomPaint(
              painter: new OverlayImagePainter(overlayImageOpt),
              size: size,
            ),
          );
        }

        return new Container(
          child: new Stack(
            children: overlayImages,
          ),
        );
      },
    );
  }
}

class OverlayImagePainter extends CustomPainter {
  final OverlayImage overlayImageOpt;
  BoxFit boxfit = BoxFit.fitWidth;
  OverlayImagePainter(this.overlayImageOpt);
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.clipRect(rect);
    final paint = new Paint()
      ..color = Color.fromRGBO(255, 255, 255, overlayImageOpt.opacity);

    final Size imageSize = new Size(overlayImageOpt.image.width.toDouble(),
        overlayImageOpt.image.height.toDouble());
    final Rect inputSubrect = Offset.zero & imageSize;

    canvas.drawImageRect(
        overlayImageOpt.image,
        inputSubrect,
        Rect.fromPoints(overlayImageOpt.offsets[0], overlayImageOpt.offsets[1]),
        paint);
  }

  @override
  bool shouldRepaint(OverlayImagePainter other) => false;
}
