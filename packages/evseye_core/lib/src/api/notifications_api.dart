import '../utils/result.dart';
import 'api_client.dart';
import 'json_fields.dart';

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.source,
    required this.createdAt,
    this.readAt,
    this.data = const {},
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
    id: jsonText(json['id']),
    title: jsonText(json['title']),
    body: jsonText(json['body']),
    source: jsonText(json['source']),
    createdAt: jsonDateOr(json['createdAt'], DateTime.now()),
    readAt: jsonDate(json['readAt']),
    data: {
      for (final MapEntry<String, dynamic> entry in jsonMap(json['data']).entries) entry.key: jsonText(entry.value),
    },
  );

  final String id;
  final String title;
  final String body;
  final String source;
  final DateTime createdAt;
  final DateTime? readAt;
  final Map<String, String> data;

  bool get isRead => readAt != null;

  bool get isBroadcast => source != 'SYSTEM';

  AppNotification markedRead() => AppNotification(
    id: id,
    title: title,
    body: body,
    source: source,
    createdAt: createdAt,
    readAt: readAt ?? DateTime.now(),
    data: data,
  );
}

class NotificationPage {
  const NotificationPage({required this.items, this.nextCursor});

  final List<AppNotification> items;
  final String? nextCursor;
}

class NotificationsApi {
  const NotificationsApi(this._client);

  final ApiClient _client;

  Future<Result<NotificationPage>> inbox({String? cursor, int limit = 20}) => _client.get<NotificationPage>(
    '/app/notifications',
    query: {'limit': limit, 'cursor': ?cursor},
    parse: (data) {
      final Map<String, dynamic> page = jsonMap(data);
      return NotificationPage(
        items: jsonMaps(page['items']).map(AppNotification.fromJson).toList(growable: false),
        nextCursor: jsonTextOrNull(page['nextCursor']),
      );
    },
  );

  Future<Result<int>> unreadCount() =>
      _client.get<int>('/app/notifications/unread-count', parse: (data) => jsonIntOrNull(jsonMap(data)['count']) ?? 0);

  Future<Result<void>> markRead(String id) => _client.patch<void>('/app/notifications/$id/read', parse: (_) {});

  Future<Result<void>> markAllRead() =>
      _client.post<void>('/app/notifications/read-all', body: const <String, dynamic>{}, parse: (_) {});
}
