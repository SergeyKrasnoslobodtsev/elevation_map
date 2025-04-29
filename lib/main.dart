import 'package:elevation_map/screens/home_screen.dart';
import 'package:flutter/material.dart';

import 'service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupDependencies();

  runApp(HomeScreen());
}
