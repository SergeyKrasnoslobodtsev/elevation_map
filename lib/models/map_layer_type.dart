enum MapLayerType {
  satellite(
    'Спутник',
    'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
  ),
  topographic('Топография', 'https://tile.opentopomap.org/{z}/{x}/{y}.png'),
  standard('Стандарт', 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
  streetandroads(
    'Улицы и дороги',
    'https://services.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/{z}/{y}/{x}',
  ),
  elevation(
    'Высота',
    'https://s3.amazonaws.com/elevation-tiles-prod/terrarium/{z}/{x}/{y}.png',
  );

  final String name;
  final String urlTemplate;

  const MapLayerType(this.name, this.urlTemplate);
}

// Примеры URL для карт высоты:
// https://s3.amazonaws.com/elevation-tiles-prod/terrarium/{z}/{x}/{y}.png
// https://stamen-tiles.a.ssl.fastly.net/terrain/{z}/{x}/{y}.jpg
// https://remotepixel.ca/srtm/{z}/{x}/{y}.png
