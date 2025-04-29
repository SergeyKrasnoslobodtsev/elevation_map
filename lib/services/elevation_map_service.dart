import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';

import '../models/elevation_point.dart';

/// Результат маршрута с высотами и расстоянием
class RouteElevationResult {
  final List<ElevationPoint> points;
  final double distanceInKm;
  final double elevationGainInM;
  final double elevationLossInM;
  final List<double> distances; // Добавлен массив расстояний для графика

  RouteElevationResult({
    required this.points,
    required this.distanceInKm,
    required this.elevationGainInM,
    required this.elevationLossInM,
    required this.distances,
  });
}

// Сервис для работы с высотами на карте и расчетом расстояний
@injectable
class ElevationMapService {
  final http.Client _httpClient;
  static const String _baseUrl = 'https://api.opentopodata.org/v1/srtm30m';

  // Максимальный интервал между точками в метрах
  static const double _maxPointIntervalInMeters = 150.0;

  // Максимальное количество точек в одном запросе
  static const int _maxRequestPoints = 100;

  ElevationMapService(this._httpClient);

  /// Получает данные о высотах для списка точек
  Future<List<ElevationPoint>> getElevationData(List<LatLng> points) async {
    if (points.isEmpty) {
      return [];
    }

    try {
      List<LatLng> pathPoints = points;

      // Если у нас только 2 точки, применяем динамическую интерполяцию
      if (points.length == 2) {
        pathPoints = _generateOptimalPathPoints(points[0], points[1]);
      }

      final locations = pathPoints
          .map((point) => '${point.latitude},${point.longitude}')
          .join('|');

      final url = '$_baseUrl?locations=$locations';

      final response = await _httpClient.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch elevation data: ${response.statusCode}',
        );
      }

      final data = jsonDecode(response.body);
      final results = data['results'] as List;

      return List<ElevationPoint>.from(
        results.map((result) {
          final location = LatLng(
            result['location']['lat'],
            result['location']['lng'],
          );

          double elevation = 0;
          if (result['elevation'] != null) {
            elevation = result['elevation'].toDouble();
          } else {
            debugPrint(
              'Warning: Null elevation for point ${location.latitude},${location.longitude}',
            );
          }

          return ElevationPoint(location: location, elevation: elevation);
        }),
      );
    } catch (e) {
      debugPrint('Error getting elevation data: $e');
      rethrow;
    }
  }

  /// Генерирует оптимальное количество точек для маршрута
  List<LatLng> _generateOptimalPathPoints(LatLng start, LatLng end) {
    // Рассчитываем расстояние между точками в метрах
    double distanceInMeters = FlutterMapMath().distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
      'meters',
    );

    // Определяем оптимальное количество шагов
    int steps = (distanceInMeters / _maxPointIntervalInMeters).ceil();

    // // Ограничиваем максимальное количество точек
    steps = min(steps, _maxRequestPoints - 1);

    // Минимум 5 точек для коротких маршрутов
    steps = max(steps, 25);

    debugPrint(
      'Distance: ${distanceInMeters}m, using $steps interpolation points',
    );

    return _interpolatePoints(start, end, steps);
  }

  /// Создает список точек между началом и концом
  List<LatLng> _interpolatePoints(LatLng start, LatLng end, int steps) {
    return List.generate(
      steps + 1,
      (i) => LatLng(
        start.latitude + (end.latitude - start.latitude) * i / steps,
        start.longitude + (end.longitude - start.longitude) * i / steps,
      ),
    );
  }

  /// Рассчитывает расстояние между двумя точками в километрах
  double calculateDistanceInKm(LatLng point1, LatLng point2) {
    final meters = FlutterMapMath().distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
      'meters',
    );
    return meters > 0
        ? meters / 1000.0
        : 0; // Преобразование метров в километры
  }

  /// Получает полную информацию о маршруте, включая высоты и расстояние
  Future<RouteElevationResult> getRouteInfo(List<LatLng> points) async {
    if (points.length < 2) {
      return RouteElevationResult(
        points: [],
        distanceInKm: 0,
        elevationGainInM: 0,
        elevationLossInM: 0,
        distances: [],
      );
    }

    final elevationPoints = await getElevationData(points);

    // Создаем массив с промежуточными расстояниями
    List<double> distances = [0.0];
    double totalDistance = 0.0;

    for (int i = 1; i < elevationPoints.length; i++) {
      totalDistance += calculateDistanceInKm(
        elevationPoints[i - 1].location,
        elevationPoints[i].location,
      );
      distances.add(totalDistance);
    }

    // Расчет подъемов и спусков
    double elevationGain = 0;
    double elevationLoss = 0;

    for (int i = 0; i < elevationPoints.length - 1; i++) {
      final diff =
          elevationPoints[i + 1].elevation - elevationPoints[i].elevation;
      if (diff > 0) {
        elevationGain += diff;
      } else {
        elevationLoss += diff.abs();
      }
    }

    return RouteElevationResult(
      points: elevationPoints,
      distanceInKm: totalDistance,
      elevationGainInM: elevationGain,
      elevationLossInM: elevationLoss,
      distances: distances,
    );
  }
}
