enum MapLayerType {
  satellite(
    'Спутник',
    'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
  ),
  topographic('Топография', 'https://tile.opentopomap.org/{z}/{x}/{y}.png'),
  standard('Стандарт', 'https://tile.openstreetmap.org/{z}/{x}/{y}.png');

  final String name;
  final String urlTemplate;

  const MapLayerType(this.name, this.urlTemplate);
}
