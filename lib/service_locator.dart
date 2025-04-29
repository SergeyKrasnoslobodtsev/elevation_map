import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import 'service_locator.config.dart';

@module
abstract class ExternalDependenciesModule {
  // Регистрируем http.Client как фабрику (новый экземпляр при каждом запросе)
  @lazySingleton
  http.Client get httpClient => http.Client();
}

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
void setupDependencies() => $initGetIt(getIt);
