import 'package:flutter/material.dart';
import '../models/map_layer_type.dart';

class LayerSelectorPanel extends StatelessWidget {
  final MapLayerType currentLayer;
  final bool isStreetAndRoadsEnabled;
  final bool isElevationEnabled;
  final Function(MapLayerType) onLayerSelected;
  final Function(bool) onStreetAndRoadsToggled;
  final Function(bool) onElevationToggled;

  const LayerSelectorPanel({
    super.key,
    required this.currentLayer,
    required this.isStreetAndRoadsEnabled,
    required this.isElevationEnabled,
    required this.onLayerSelected,
    required this.onStreetAndRoadsToggled,
    required this.onElevationToggled,
  });

  List<MapLayerType> get baseMapLayers => [
    MapLayerType.satellite,
    MapLayerType.topographic,
    MapLayerType.standard,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
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
      child: Column(
        children: [
          const SizedBox(height: 12),
          Center(
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Центрируем элементы
              children:
                  baseMapLayers.map((layer) => _buildLayerItem(layer)).toList(),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildOverlaySwitch(
                  "Улицы и дороги",
                  Icons.directions,
                  isStreetAndRoadsEnabled,
                  onStreetAndRoadsToggled,
                ),
                _buildOverlaySwitch(
                  "Высота",
                  Icons.height,
                  isElevationEnabled,
                  onElevationToggled,
                ),
              ],
            ),
          ),
        ],
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

  Widget _buildOverlaySwitch(
    String title,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: value ? Colors.green : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: value ? FontWeight.bold : FontWeight.normal,
          color: value ? Colors.green : Colors.black,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.green,
      ),
      dense: true,
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
      case MapLayerType.streetandroads:
        return Icons.directions;
      case MapLayerType.elevation:
        return Icons.height;
    }
  }
}
