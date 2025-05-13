import 'package:elevation_map/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  developer.log('Начинаем инициализацию приложения');

  try {
    developer.log('Настройка зависимостей');
    setupDependencies();
    developer.log('Зависимости настроены успешно');

    developer.log('Запуск приложения');
    runApp(HomeScreen());
  } catch (e) {
    developer.log('Ошибка при запуске: $e', error: e);
  }
}
