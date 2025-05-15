import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MapboxMap? mapboxMap;
  var isLight = true;
  final List<Object> hypsometricRamp = [
    'interpolate', ['linear'], ['raster-value'],
    //   высота (м)      ―――― RGBA ――――
    0, ['rgba', 165, 0, 38, 1], // тёмно-красный
    500, ['rgba', 215, 48, 39, 1], // красный
    1000, ['rgba', 244, 109, 67, 1], // оранжево-красный
    1500, ['rgba', 253, 174, 97, 1], // оранжевый
    2000, ['rgba', 254, 224, 139, 1], // светло-жёлтый
    3000, ['rgba', 217, 239, 139, 1], // жёлто-зелёный
    4000, ['rgba', 166, 217, 106, 1], // зелёный
    4500, ['rgba', 102, 189, 99, 1], // тёмно-зелёный
  ];
  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    mapboxMap.scaleBar.updateSettings(ScaleBarSettings(isMetricUnits: true));
    mapboxMap.logo.updateSettings(LogoSettings(enabled: false));
    mapboxMap.attribution.updateSettings(AttributionSettings(enabled: false));
  }

  _onStyleLoadedCallback(StyleLoadedEventData data) async {
    await mapboxMap!.style.addSource(
      RasterDemSource(
        id: 'terrain-dem',
        url: 'mapbox://mapbox.mapbox-terrain-dem-v1',
        tileSize: 512,
      ),
    );

    // await mapboxMap!.style.addLayer(
    //   RasterLayer(id: 'hypsometry', sourceId: 'terrain-dem')
    //     // В Flutter-SDK 2.8.0 поле называется exactly **rasterColorExpression**
    //     ..rasterColorExpression = hypsometricRamp
    //     ..rasterOpacity = 1.0,
    // );

    await mapboxMap!.style.addLayer(
      HillshadeLayer(id: 'terrain-hillshade', sourceId: 'terrain-dem')
        ..hillshadeShadowColor =
            Colors.red
                .toARGB32() // тени
        ..hillshadeHighlightColor =
            Colors.amber
                .toARGB32() // свет
        ..hillshadeAccentColor =
            Colors.deepOrange
                .toARGB32() // грани
        ..hillshadeExaggeration = 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWidget(
        key: ValueKey('mapWidget'),
        cameraOptions: CameraOptions(
          center: Point(coordinates: Position(37.618423, 55.751244)),
          zoom: 10,
        ),
        styleUri: MapboxStyles.OUTDOORS,
        onMapCreated: _onMapCreated,
        onStyleLoadedListener: _onStyleLoadedCallback,
      ),
    );
  }
}
