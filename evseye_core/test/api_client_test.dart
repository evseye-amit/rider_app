import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_test/flutter_test.dart';

class _CapturingAdapter implements HttpClientAdapter {
  final List<RequestOptions> sent = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    sent.add(options);
    return ResponseBody.fromString(
      jsonEncode({'data': <String, dynamic>{}}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _CapturingAdapter adapter;
  late ApiClient client;

  setUp(() {
    adapter = _CapturingAdapter();

    client = ApiClient(
      tokens: TokenStore(),
      baseUrl: 'http://localhost/api/v1',
      logRequests: false,
    );
    client.raw.httpClientAdapter = adapter;
  });

  String? contentTypeOf(RequestOptions o) =>
      o.headers[Headers.contentTypeHeader]?.toString();

  test('a bodyless POST sends no Content-Type', () async {
    await client.post<void>('/media/abc/complete');

    expect(adapter.sent, hasLength(1));
    expect(contentTypeOf(adapter.sent.single), isNull);
  });

  test('a POST with a body still declares JSON', () async {
    await client.post<void>('/auth/otp/request', body: {'mobile': '9876543210'});

    expect(contentTypeOf(adapter.sent.single), Headers.jsonContentType);
  });

  test('a GET sends no Content-Type', () async {
    await client.get<void>('/riders/me');

    expect(contentTypeOf(adapter.sent.single), isNull);
  });
}
