import 'package:flutter/material.dart';
import '../services/elevation_map_service.dart';
import 'elevation_chart.dart';

class ElevationChartPanel extends StatefulWidget {
  final RouteElevationResult routeInfo;
  final VoidCallback onClose;

  const ElevationChartPanel({
    super.key,
    required this.routeInfo,
    required this.onClose,
  });

  @override
  _ElevationChartPanelState createState() => _ElevationChartPanelState();
}

class _ElevationChartPanelState extends State<ElevationChartPanel> {
  double _offsetMeters = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .9),
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
            elevationData: widget.routeInfo.points,
            totalDistanceKm: widget.routeInfo.distanceInKm,
            elevationGain: widget.routeInfo.elevationGainInM,
            elevationLoss: widget.routeInfo.elevationLossInM,
            elevetionStart: _offsetMeters,
            distances: widget.routeInfo.distances,
          ),
          const SizedBox(height: 16),

          // Трэкбар для смещения высоты от 5 до 50 м с шагом 5
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Добавочная высота источника сигнала:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                '${_offsetMeters.toInt()} м',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          Slider(
            thumbColor: Colors.green.shade50,
            inactiveColor: Colors.green[300],
            activeColor: Colors.green[700],
            value: _offsetMeters,
            min: 5,
            max: 50,
            divisions: 9,
            label: '${_offsetMeters.toInt()} м',
            onChanged: (val) => setState(() => _offsetMeters = val),
          ),

          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade50,
              foregroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: widget.onClose,
            child: const Text('Очистить маршрут'),
          ),
        ],
      ),
    );
  }
}
