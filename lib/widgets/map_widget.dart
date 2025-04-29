import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:latlong2/latlong.dart';

import '../models/map_layer_type.dart';
import 'map_title_layer.dart';
import 'router_markers_layer.dart';

class MapWidget extends StatelessWidget {
  final MapLayerType currentLayer;
  final HiveCacheStore cacheStore;
  final List<LatLng> points; // Список точек маршрута
  final Function(TapPosition, LatLng)
  onMapTap; // Функция для обработки нажатий на карту

  const MapWidget({
    super.key,
    required this.currentLayer,
    required this.cacheStore,
    required this.points,
    required this.onMapTap,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(55.751244, 37.618423),
        initialZoom: 10,
        onTap: onMapTap,
      ),
      children: [
        MapTileLayer(layerType: currentLayer, cacheStore: cacheStore),

        // Слой с маркерами маршрута, если точки заданы
        if (points.isNotEmpty)
          RouteMarkersLayer(points: points, markerColor: Colors.red),
      ],
    );
  }
}
