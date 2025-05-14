import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

import '../models/map_layer_type.dart';
import '../services/cash_store_service.dart';
import '../services/elevation_map_service.dart';

@singleton
class HomeViewModel extends ChangeNotifier {
  final CacheStoreService _cacheStoreService;
  final ElevationMapService _elevationMapService;

  HomeViewModel(this._cacheStoreService, this._elevationMapService) {
    _initCacheStore();
  }

  // Состояние
  MapLayerType _currentLayer = MapLayerType.satellite;
  bool _isStreetAndRoadsEnabled = true;
  bool _isElevationEnabled = true;
  bool _showLayerSelector = false;
  HiveCacheStore? _cacheStore;
  bool _isLoading = true;

  List<LatLng> _routePoints = [];

  // Геттеры
  MapLayerType get currentLayer => _currentLayer;
  bool get isStreetAndRoadsEnabled => _isStreetAndRoadsEnabled;
  bool get isElevationEnabled => _isElevationEnabled;
  bool get showLayerSelector => _showLayerSelector;
  HiveCacheStore? get cacheStore => _cacheStore;
  bool get isLoading => _isLoading;
  List<LatLng> get routePoints => _routePoints;

  RouteElevationResult? _routeInfo;
  RouteElevationResult? get routeInfo => _routeInfo;

  // Методы
  Future<void> _initCacheStore() async {
    try {
      _cacheStore = await _cacheStoreService.getHiveCacheStore();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing cache store: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleLayerSelector() {
    _showLayerSelector = !_showLayerSelector;
    notifyListeners();
  }

  // Метод для переключения слоя карты
  void toggleStreetAndRoads(bool value) {
    _isStreetAndRoadsEnabled = value;
    notifyListeners();
  }

  void toggleElevation(bool value) {
    _isElevationEnabled = value;
    notifyListeners();
  }

  void selectMapLayer(MapLayerType layer) {
    _currentLayer = layer;
    _showLayerSelector = false;
    notifyListeners();
  }

  // Метод для обработки нажатия на карту
  Future<void> onMapTap(TapPosition tapPosition, LatLng point) async {
    // Если у нас уже 2 точки, начинаем заново
    _showLayerSelector = false;
    if (_routePoints.length >= 2) {
      _routePoints = [point];
      _routeInfo = null;
    } else {
      _routePoints.add(point);
    }

    notifyListeners();

    // Если у нас есть обе точки, запрашиваем данные высот
    if (_routePoints.length == 2) {
      await fetchElevationData();
    }
  }

  // Метод для очистки маршрута
  void clearRoute() {
    _routePoints.clear();
    _routeInfo = null;
    notifyListeners();
  }

  // Метод для получения данных о высоте
  Future<void> fetchElevationData() async {
    try {
      _routeInfo = await _elevationMapService.getRouteInfo(_routePoints);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching elevation data: $e');
      // Можно добавить обработку ошибок
    }
  }
}
