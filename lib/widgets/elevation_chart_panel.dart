import 'package:flutter/material.dart';
import '../services/elevation_map_service.dart';
import 'elevation_chart.dart';

class ElevationChartPanel extends StatelessWidget {
  final RouteElevationResult routeInfo;
  final VoidCallback onClose;

  const ElevationChartPanel({
    super.key,
    required this.routeInfo,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          ElevationChartWidget(
            elevationData: routeInfo.points,
            totalDistanceKm: routeInfo.distanceInKm,
            elevationGain: routeInfo.elevationGainInM,
            elevationLoss: routeInfo.elevationLossInM,
            distances: routeInfo.distances,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade50,
              foregroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: onClose,
            child: const Text('Очистить маршрут'),
          ),
        ],
      ),
    );
  }
}
