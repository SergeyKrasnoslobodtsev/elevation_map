// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;

import 'service_locator.dart' as _i105;
import 'services/cash_store_service.dart' as _i890;
import 'services/elevation_map_service.dart' as _i415;
import 'viewmodels/home_view_model.dart' as _i420;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final externalDependenciesModule = _$ExternalDependenciesModule();
  gh.factory<_i890.CacheStoreService>(() => _i890.CacheStoreService());
  gh.lazySingleton<_i519.Client>(() => externalDependenciesModule.httpClient);
  gh.factory<_i415.ElevationMapService>(
    () => _i415.ElevationMapService(gh<_i519.Client>()),
  );
  gh.singleton<_i420.HomeViewModel>(
    () => _i420.HomeViewModel(
      gh<_i890.CacheStoreService>(),
      gh<_i415.ElevationMapService>(),
    ),
  );
  return getIt;
}

class _$ExternalDependenciesModule extends _i105.ExternalDependenciesModule {}
