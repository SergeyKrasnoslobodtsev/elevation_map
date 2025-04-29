import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

@injectable
class CacheStoreService {
  static const String _defaultBoxName = 'HiveCacheStore';

  String _cachePath = '';
  bool _isInitialized = false;

  String get cachePath => _cachePath;

  bool get isInitialized => _isInitialized;

  Future<String> getInitializedPath() async {
    if (!_isInitialized) {
      await _initializePath();
    }
    return _cachePath;
  }

  /// Инициализация кэша
  Future<HiveCacheStore> getHiveCacheStore({String? boxName}) async {
    final path = await getInitializedPath();
    return HiveCacheStore(path, hiveBoxName: boxName ?? _defaultBoxName);
  }

  /// Очистка кэша
  Future<bool> clearCache() async {
    try {
      final store = await getHiveCacheStore();
      await store.clean();
      return true;
    } catch (e) {
      debugPrint('Failed to clear cache: $e');
      return false;
    }
  }

  Future<int> getCacheSize() async {
    try {
      final path = await getInitializedPath();
      final directory = Directory(path);

      if (!directory.existsSync()) {
        return 0;
      }

      int totalSize = 0;
      await for (final FileSystemEntity entity in directory.list(
        recursive: true,
      )) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }

      return totalSize;
    } catch (e) {
      debugPrint('Failed to calculate cache size: $e');
      return 0;
    }
  }

  /// Gets a human-readable string representation of the cache size.
  Future<String> getReadableCacheSize() async {
    final bytes = await getCacheSize();

    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Initializes the cache path using the device's temporary directory.
  Future<void> _initializePath() async {
    try {
      final cacheDirectory = await getTemporaryDirectory();
      _cachePath = cacheDirectory.path;
      _isInitialized = true;

      // Ensure the directory exists
      final directory = Directory(_cachePath);
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }
    } catch (e) {
      debugPrint('Failed to initialize cache directory: $e');
      // Rethrow to allow callers to handle initialization failures
      rethrow;
    }
  }
}
