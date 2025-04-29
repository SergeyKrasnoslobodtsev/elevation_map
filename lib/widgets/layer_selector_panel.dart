import 'package:flutter/material.dart';
import '../models/map_layer_type.dart';

class LayerSelectorPanel extends StatelessWidget {
  final MapLayerType currentLayer;
  final Function(MapLayerType) onLayerSelected;

  const LayerSelectorPanel({
    super.key,
    required this.currentLayer,
    required this.onLayerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .9),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Центрируем элементы
          children:
              MapLayerType.values
                  .map((layer) => _buildLayerItem(layer))
                  .toList(),
        ),
      ),
    );
  }

  Widget _buildLayerItem(MapLayerType layer) {
    final isSelected = layer == currentLayer;

    return GestureDetector(
      onTap: () => onLayerSelected(layer),
      child: Container(
        width: 76,
        height: 76,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconForLayer(layer),
              color: isSelected ? Colors.green : Colors.grey.shade700,
            ),
            const SizedBox(height: 8),
            Text(
              layer.name,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.green : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForLayer(MapLayerType layer) {
    switch (layer) {
      case MapLayerType.satellite:
        return Icons.satellite_alt;
      case MapLayerType.topographic:
        return Icons.terrain;
      case MapLayerType.standard:
        return Icons.map;
    }
  }
}
