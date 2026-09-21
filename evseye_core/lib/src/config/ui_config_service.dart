import 'dart:convert';

import 'package:flutter/services.dart';

import '../dynamic_ui/models/ui_screen_config.dart';
import '../api/config_api.dart';
import '../utils/result.dart';
import 'feature_flags.dart';

class UiConfigService {
  UiConfigService({AssetBundle? bundle, this.basePath = 'assets/config'})
      : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  final String basePath;

  final Map<String, Map<String, dynamic>> _cache = {};

  Future<Map<String, dynamic>> _load(String name) async {
    final cached = _cache[name];
    if (cached != null) return cached;
    final String raw = await _bundle.loadString('$basePath/$name.json');
    final Map<String, dynamic> parsed = json.decode(raw) as Map<String, dynamic>;
    _cache[name] = parsed;
    return parsed;
  }

  Future<FeatureFlags> loadFeatureFlags({
    String name = 'package_features',
    ConfigApi? config,
    String? clientId,
  }) async {
    final FeatureFlags bundled = FeatureFlags.fromJson(await _load(name));

    if (config != null && clientId != null && clientId.isNotEmpty) {
      final Result<ClientConfig> result = await config.fetch(clientId);
      if (result case Ok<ClientConfig>(:final value)) {
        _lastLoadCameFromApi = true;
        return value.flags.copyWith(
          flags: {...bundled.all, ...value.flags.all},
          settings: bundled.allSettings,
        );
      }
    }
    _lastLoadCameFromApi = false;
    return bundled;
  }

  bool _lastLoadCameFromApi = false;

  bool get lastLoadCameFromApi => _lastLoadCameFromApi;

  Future<UiScreenConfig> loadScreen(String name) async =>
      UiScreenConfig.fromJson(await _load(name));

  Future<UiFlowConfig> loadFlow(String name) async => UiFlowConfig.fromJson(await _load(name));

  Future<Map<String, dynamic>> loadRaw(String name) => _load(name);

  Future<List<Map<String, dynamic>>> loadList(String name, {String key = 'items'}) async {
    final Map<String, dynamic> doc = await _load(name);
    return (doc[key] as List<dynamic>? ?? const [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList(growable: false);
  }

  void invalidate([String? name]) => name == null ? _cache.clear() : _cache.remove(name);
}
