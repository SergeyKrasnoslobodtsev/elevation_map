import 'package:elevation_map/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../viewmodels/home_view_model.dart';
import '../widgets/elevation_chart_panel.dart';
import '../widgets/layer_selector_panel.dart';
import '../widgets/map_control_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GetIt.instance<HomeViewModel>(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          return MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  // Карта
                  viewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : MapWidget(
                        currentLayer: viewModel.currentLayer,
                        isElevationEnabled: viewModel.isElevationEnabled,
                        isStreetAndRoadsEnabled:
                            viewModel.isStreetAndRoadsEnabled,
                        cacheStore: viewModel.cacheStore!,
                        points: viewModel.routePoints,
                        onMapTap: viewModel.onMapTap,
                      ),

                  if (viewModel.routeInfo != null &&
                      viewModel.routePoints.length >= 2)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: ElevationChartPanel(
                        routeInfo: viewModel.routeInfo!,
                        onClose: viewModel.clearRoute,
                      ),
                    ),

                  // Кнопки управления
                  Positioned(
                    top: 32,
                    right: 16,
                    child: MapControlButton(
                      icon: Icons.settings,
                      onTap: viewModel.toggleLayerSelector,
                    ),
                  ),
                  Positioned(
                    top: 92,
                    right: 16,
                    child: MapControlButton(
                      icon: Icons.layers,
                      onTap: viewModel.toggleLayerSelector,
                    ),
                  ),
                  // Панель выбора слоев
                  if (viewModel.showLayerSelector)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: LayerSelectorPanel(
                        currentLayer: viewModel.currentLayer,
                        isStreetAndRoadsEnabled:
                            viewModel.isStreetAndRoadsEnabled,
                        isElevationEnabled: viewModel.isElevationEnabled,
                        onLayerSelected: viewModel.selectMapLayer,
                        onStreetAndRoadsToggled: viewModel.toggleStreetAndRoads,
                        onElevationToggled: viewModel.toggleElevation,
                      ),
                    ),
                ],
              ),
            ),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
