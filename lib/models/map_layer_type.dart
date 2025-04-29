enum MapLayerType {
  satellite(
    'Спутник',
    'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
    labelUrlTemplate:
        'https://services.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/{z}/{y}/{x}',
  ),
  topographic('Топография', 'https://tile.opentopomap.org/{z}/{x}/{y}.png'),
  standard('Стандарт', 'https://tile.openstreetmap.org/{z}/{x}/{y}.png');

  final String name;
  final String urlTemplate;
  final String? labelUrlTemplate;

  const MapLayerType(this.name, this.urlTemplate, {this.labelUrlTemplate});
}
