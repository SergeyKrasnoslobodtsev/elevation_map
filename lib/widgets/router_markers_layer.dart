import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RouteMarkersLayer extends StatelessWidget {
  final List<LatLng> points;
  final Color markerColor;
  final Color labelColor;

  const RouteMarkersLayer({
    super.key,
    required this.points,
    this.markerColor = Colors.red,
    this.labelColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    // Если точек нет, возвращаем пустой контейнер
    if (points.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        // Точки маршрута (кружки)
        MarkerLayer(
          markers: points.map((point) => _buildPointMarker(point)).toList(),
        ),

        // Метки A и Б
        MarkerLayer(
          rotate: true,
          markers:
              points
                  .asMap()
                  .entries
                  .map(
                    (entry) => _buildLabelMarker(
                      entry.value,
                      entry.key == 0 ? 'A' : 'Б',
                    ),
                  )
                  .toList(),
        ),

        // Линия маршрута (если есть хотя бы 2 точки)
        if (points.length >= 2)
          PolylineLayer(
            polylines: [
              Polyline(
                points: points,
                strokeWidth: 1.5,
                color: Colors.green.shade200,
              ),
            ],
          ),
      ],
    );
  }

  /// Создает маркер для указания точки (кружок)
  Marker _buildPointMarker(LatLng point) {
    return Marker(
      point: point,
      child: Icon(Icons.circle, size: 8.0, color: markerColor),
      alignment: Alignment.center,
      height: 8,
      width: 8,
    );
  }

  /// Создает маркер с меткой (A или Б)
  Marker _buildLabelMarker(LatLng point, String label) {
    return Marker(
      point: point,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .7),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .2),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
      ),
      alignment: Alignment.topCenter,
      height: 24,
      width: 24,
    );
  }
}
