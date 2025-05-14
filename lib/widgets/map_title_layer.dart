import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';

import '../models/map_layer_type.dart';

class MapTileLayer extends StatelessWidget {
  final MapLayerType layerType;
  final bool isElevationEnabled;
  final bool isStreetAndRoadsEnabled;

  final HiveCacheStore cacheStore;

  const MapTileLayer({
    required this.layerType,
    required this.isElevationEnabled,
    required this.isStreetAndRoadsEnabled,
    required this.cacheStore,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        TileLayer(
          urlTemplate: layerType.urlTemplate,
          userAgentPackageName: 'com.example.elevation_map',
          tileProvider: CachedTileProvider(
            maxStale: const Duration(days: 30),
            store: cacheStore,
          ),
        ),

        if (isElevationEnabled)
          Opacity(
            opacity: 0.5,
            child: TileLayer(
              urlTemplate: MapLayerType.elevation.urlTemplate,
              userAgentPackageName: 'com.example.elevation_map',
              tileProvider: CachedTileProvider(
                maxStale: const Duration(days: 30),
                store: cacheStore,
              ),
            ),
          ),
        if (isStreetAndRoadsEnabled)
          TileLayer(
            urlTemplate: MapLayerType.streetandroads.urlTemplate,
            userAgentPackageName: 'com.example.elevation_map',
            tileProvider: CachedTileProvider(
              maxStale: const Duration(days: 30),
              store: cacheStore,
            ),
          ),
      ],
    );
  }
}
