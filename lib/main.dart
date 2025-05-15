import 'package:elevation_map/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'dart:developer' as developer;
import 'service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  developer.log('Начинаем инициализацию приложения');

  try {
    developer.log('Настройка зависимостей');
    await dotenv.load();
    String token = dotenv.get('ACCESS_TOKEN');
    MapboxOptions.setAccessToken(token);
    setupDependencies();
    developer.log('Зависимости настроены успешно');

    developer.log('Запуск приложения');
    runApp(App());
  } catch (e) {
    developer.log('Ошибка при запуске: $e', error: e);
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.green),
      home: HomeScreen(),
    );
  }
}
