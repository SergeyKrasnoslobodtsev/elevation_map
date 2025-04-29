import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';

import '../models/map_layer_type.dart';

class MapTileLayer extends StatelessWidget {
  final MapLayerType layerType;
  final HiveCacheStore cacheStore;

  const MapTileLayer({
    required this.layerType,
    required this.cacheStore,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TileLayer(
      urlTemplate: layerType.urlTemplate,
      userAgentPackageName: 'com.example.elevation_map',
      tileProvider: CachedTileProvider(
        maxStale: const Duration(days: 30),
        store: cacheStore,
      ),
    );
  }
}
