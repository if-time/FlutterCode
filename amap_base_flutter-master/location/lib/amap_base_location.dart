library amap_base_location;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'src/location/amap_location.dart';

export 'src/common/permissions.dart';
export 'src/location/amap_location.dart';
export 'src/location/model/location.dart';
export 'src/location/model/location_client_options.dart';

class AMap {
  static final _channel = MethodChannel('me.yohom/amap_base');

  static Map<String, List<String>> assetManifest;

  static Future init(String key) async {
    await _channel.invokeMethod('setKey', {'key': key});

    // 加载asset相关信息, 供区分图片分辨率用, 因为native端的加载asset方法无法区分分辨率, 这是一个变通方法
    assetManifest =
        await rootBundle.loadStructuredData<Map<String, List<String>>>(
      'AssetManifest.json',
      (String jsonData) {
        if (jsonData == null)
          return SynchronousFuture<Map<String, List<String>>>(null);

        final Map<String, dynamic> parsedJson = json.decode(jsonData);
        final Iterable<String> keys = parsedJson.keys;
        final Map parsedManifest = Map<String, List<String>>.fromIterables(
          keys,
          keys.map<List<String>>((key) => List<String>.from(parsedJson[key])),
        );
        return SynchronousFuture<Map<String, List<String>>>(parsedManifest);
      },
    );

    await AMapLocation().init();
  }

  @Deprecated('使用init方法初始化的时候设置key')
  static Future setKey(String key) {
    return _channel.invokeMethod('setKey', {'key': key});
  }
}
