import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../models/elevation_point.dart';

class ElevationChartWidget extends StatelessWidget {
  final List<ElevationPoint> elevationData;
  final double totalDistanceKm;
  final double elevationGain;
  final double elevationLoss;
  final double elevetionStart;
  final List<double> distances;

  const ElevationChartWidget({
    super.key,
    required this.elevationData,
    required this.totalDistanceKm,
    required this.elevationGain,
    required this.elevationLoss,
    required this.elevetionStart,
    required this.distances,
  });

  @override
  Widget build(BuildContext context) {
    if (elevationData.isEmpty) {
      return const Center(child: Text('Нет данных'));
    }

    // Преобразуем данные для графика
    final List<double> elevations =
        elevationData.map((point) => point.elevation).toList();

    // Найдем мин и макс значения высот для настройки шкалы
    final double minElevation = elevations.reduce((a, b) => a < b ? a : b);
    final double maxElevation = elevations.reduce((a, b) => a > b ? a : b);

    final double startOffsetElev = elevations.first + elevetionStart; // A + 50м
    final double endElev = elevations.last;

    // гарантируем, что chart.maxY покрывает и вашу пунктирную линию
    final double effectiveMaxElev = math.max(maxElevation, startOffsetElev);

    // Определим интервал для шкалы высот
    double yInterval;
    double elevationRange = maxElevation - minElevation;
    if (elevationRange < 50) {
      yInterval = 5;
    } else if (elevationRange < 100) {
      yInterval = 10;
    } else if (elevationRange < 500) {
      yInterval = 50;
    } else if (elevationRange < 1000) {
      yInterval = 100;
    } else if (elevationRange < 3000) {
      yInterval = 500;
    } else {
      yInterval = 1000;
    }

    // Определим интервал для шкалы расстояний
    double xInterval;
    if (totalDistanceKm < 0.05) {
      xInterval = 0.005;
    } else if (totalDistanceKm < 0.5) {
      xInterval = 0.05;
    } else if (totalDistanceKm < 1) {
      xInterval = 0.1;
    } else if (totalDistanceKm < 5) {
      xInterval = 0.5;
    } else if (totalDistanceKm < 20) {
      xInterval = 2;
    } else {
      xInterval = totalDistanceKm / 5;
    }

    return Column(
      children: [
        // Заголовок и статистика
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Профиль высот',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            Text(
              '${totalDistanceKm.toStringAsFixed(2)} км',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildStatItem(
              Icons.arrow_upward,
              Colors.green,
              '${elevationGain.toStringAsFixed(0)}м',
            ),
            const SizedBox(width: 16),
            _buildStatItem(
              Icons.arrow_downward,
              Colors.red,
              '${elevationLoss.toStringAsFixed(0)}м',
            ),
          ],
        ),
        const SizedBox(height: 16),

        // График высот
        SizedBox(
          height: 200,
          width: double.infinity,
          child: LineChart(
            LineChartData(
              minY: (minElevation - 5).floorToDouble(),
              maxY: (effectiveMaxElev + 5).ceilToDouble(),
              minX: 0,
              maxX: totalDistanceKm,
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    for (int i = 0; i < elevations.length; i++)
                      FlSpot(distances[i], elevations[i]),
                  ],
                  isCurved: true,
                  color: Colors.green.shade700,
                  barWidth: 3,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.green.withValues(alpha: .2),
                  ),
                ),
                // новая прямая от A до B
                LineChartBarData(
                  spots: [
                    FlSpot(0, startOffsetElev),
                    FlSpot(totalDistanceKm, endElev),
                  ],
                  isCurved: false,
                  color: Colors.blue,
                  barWidth: 2,
                  dotData: FlDotData(show: false),
                  dashArray: [5, 5], // пунктирная линия
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              titlesData: _buildTitlesData(yInterval, xInterval),
              gridData: _buildGridData(),
              borderData: _buildBorderData(),
            ),
          ),
        ),
      ],
    );
  }

  // Виджет для отображения статистики (подъем/спуск)
  Widget _buildStatItem(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }

  // Настройка осей и подписей
  FlTitlesData _buildTitlesData(double yInterval, double xInterval) {
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTitlesWidget: (value, meta) {
            return Text(
              value.toInt().toString(),
              style: TextStyle(color: Colors.grey[700], fontSize: 10),
              textAlign: TextAlign.right,
            );
          },
          interval: yInterval,
        ),
        axisNameWidget: Padding(
          padding: EdgeInsets.only(right: 8),
          child: Text(
            'м',
            style: TextStyle(color: Colors.grey[700], fontSize: 12),
          ),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 24,
          getTitlesWidget: (value, meta) {
            if (value == 0) {
              return Text(
                'A',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
              );
            }
            if (value >= totalDistanceKm * 0.98) {
              return Text(
                'Б',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
              );
            }

            // Для коротких расстояний показываем больше десятичных знаков
            String formattedValue;
            if (value < 0.1) {
              formattedValue = value.toStringAsFixed(2);
            } else if (value < 1) {
              formattedValue = value.toStringAsFixed(1);
            } else {
              formattedValue = value.toInt().toString();
            }

            return Text(
              formattedValue,
              style: TextStyle(color: Colors.grey[700], fontSize: 11),
            );
          },
          interval: xInterval,
        ),
      ),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  // Настройка сетки
  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: true,
      horizontalInterval: null,
      verticalInterval: null,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.grey.withValues(alpha: .15),
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: Colors.grey.withValues(alpha: .15),
          strokeWidth: 1,
        );
      },
    );
  }

  // Настройка границ графика
  FlBorderData _buildBorderData() {
    return FlBorderData(
      show: true,
      border: Border.all(color: Colors.grey.withValues(alpha: .3), width: 1),
    );
  }
}
