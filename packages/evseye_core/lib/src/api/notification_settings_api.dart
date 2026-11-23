import 'package:equatable/equatable.dart';

import '../utils/result.dart';
import 'api_client.dart';
import 'json_fields.dart';

class NotificationCategory extends Equatable {
  const NotificationCategory({required this.code, required this.name, required this.description});

  factory NotificationCategory.fromJson(Map<String, dynamic> json) => NotificationCategory(
    code: jsonText(json['code']),
    name: jsonText(json['name']),
    description: jsonText(json['description']),
  );

  final String code;
  final String name;
  final String description;

  bool get isMarketing => code.startsWith('PG11_');

  @override
  List<Object?> get props => [code, name, description];
}

class NotificationGroup extends Equatable {
  const NotificationGroup({required this.code, required this.name, required this.categories});

  factory NotificationGroup.fromJson(Map<String, dynamic> json) => NotificationGroup(
    code: jsonText(json['code']),
    name: jsonText(json['name']),
    categories: [
      for (final Map<String, dynamic> item in jsonMaps(json['categories'])) NotificationCategory.fromJson(item),
    ],
  );

  final String code;
  final String name;
  final List<NotificationCategory> categories;

  @override
  List<Object?> get props => [code, name, categories];
}

class NotificationCatalog extends Equatable {
  const NotificationCatalog({required this.revision, required this.groups});

  factory NotificationCatalog.fromJson(Map<String, dynamic> json) => NotificationCatalog(
    revision: jsonText(json['catalogRevision']),
    groups: [for (final Map<String, dynamic> item in jsonMaps(json['groups'])) NotificationGroup.fromJson(item)],
  );

  final String revision;
  final List<NotificationGroup> groups;

  @override
  List<Object?> get props => [revision, groups];
}

class NotificationCategoryPreference extends Equatable {
  const NotificationCategoryPreference({
    required this.code,
    required this.mandatory,
    required this.pushEnabled,
    required this.effectivePushEnabled,
  });

  factory NotificationCategoryPreference.fromJson(Map<String, dynamic> json) => NotificationCategoryPreference(
    code: jsonText(json['categoryCode']),
    mandatory: jsonBool(json['mandatory']),
    pushEnabled: jsonBool(json['pushEnabled']),
    effectivePushEnabled: jsonBool(json['effectivePushEnabled']),
  );

  final String code;
  final bool mandatory;
  final bool pushEnabled;
  final bool effectivePushEnabled;

  NotificationCategoryPreference withPush(bool enabled) => NotificationCategoryPreference(
    code: code,
    mandatory: mandatory,
    pushEnabled: enabled,
    effectivePushEnabled: enabled,
  );

  @override
  List<Object?> get props => [code, mandatory, pushEnabled, effectivePushEnabled];
}

class NotificationPreferences extends Equatable {
  const NotificationPreferences({required this.marketingEnabled, required this.categories});

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) => NotificationPreferences(
    marketingEnabled: jsonBool(json['marketingEnabled']),
    categories: {
      for (final Map<String, dynamic> item in jsonMaps(json['categories']))
        jsonText(item['categoryCode']): NotificationCategoryPreference.fromJson(item),
    },
  );

  final bool marketingEnabled;
  final Map<String, NotificationCategoryPreference> categories;

  NotificationPreferences copyWith({bool? marketingEnabled, Map<String, NotificationCategoryPreference>? categories}) =>
      NotificationPreferences(
        marketingEnabled: marketingEnabled ?? this.marketingEnabled,
        categories: categories ?? this.categories,
      );

  @override
  List<Object?> get props => [marketingEnabled, categories];
}

class NotificationSettingsApi {
  const NotificationSettingsApi(this._client);

  final ApiClient _client;

  Future<Result<NotificationCatalog>> catalog(String application) => _client.get<NotificationCatalog>(
    '/app/notification-catalog',
    query: {'application': application},
    parse: (data) => NotificationCatalog.fromJson(jsonMap(data)),
  );

  Future<Result<NotificationPreferences>> preferences(String application) => _client.get<NotificationPreferences>(
    '/app/notification-preferences',
    query: {'application': application},
    parse: (data) => NotificationPreferences.fromJson(jsonMap(data)),
  );

  Future<Result<NotificationPreferences>> update(
    String application, {
    bool? marketingEnabled,
    Map<String, bool> categories = const {},
  }) => _client.put<NotificationPreferences>(
    '/app/notification-preferences',
    body: {
      'application': application,
      'marketingEnabled': ?marketingEnabled,
      if (categories.isNotEmpty)
        'categories': [
          for (final MapEntry<String, bool> entry in categories.entries)
            {'categoryCode': entry.key, 'pushEnabled': entry.value},
        ],
    },
    parse: (data) => NotificationPreferences.fromJson(jsonMap(data)),
  );
}
