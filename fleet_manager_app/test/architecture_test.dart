import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final List<File> dart = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList(growable: false);

  List<File> under(String segment) =>
      dart.where((f) => f.path.contains(segment)).toList(growable: false);

  void expectNoImport(
    Iterable<File> files,
    Pattern forbidden, {
    required String reason,
  }) {
    final List<String> offenders = [
      for (final f in files)
        for (final line in f.readAsLinesSync())
          if (line.startsWith('import ') && line.contains(forbidden))
            '${f.path}: ${line.trim()}',
    ];
    expect(offenders, isEmpty, reason: '$reason\n${offenders.join('\n')}');
  }

  test('presentation does not reach into data', () {
    expectNoImport(
      under('/presentation/'),
      '/data/',
      reason: 'A widget or cubit must depend on the domain contract, not the '
          'implementation. Inject the repository instead.',
    );
  });

  test('domain does not depend on Flutter', () {
    expectNoImport(
      under('/domain/'),
      RegExp(r'package:flutter/(material|widgets|cupertino)'),
      reason: 'Entities and use cases must be testable without a widget tree. '
          'Move anything that needs BuildContext into presentation.',
    );
  });

  test('domain does not know how it is transported', () {
    for (final f in under('/domain/')) {
      final String body = f.readAsStringSync();
      for (final banned in ['package:dio', 'ApiClient', 'http.']) {
        expect(
          body.contains(banned),
          isFalse,
          reason: '${f.path} mentions $banned. A use case states what it '
              'needs; the data layer decides how to fetch it.',
        );
      }
    }
  });

  test('the session controller sequences use cases rather than calling the API', () {
    final File session = File('lib/core/session/session_controller.dart');
    if (!session.existsSync()) return;
    final String body = session.readAsStringSync();
    for (final banned in ['ApiClient', 'package:dio']) {
      expect(
        body.contains(banned),
        isFalse,
        reason: 'session_controller.dart mentions $banned. It holds state and '
            'calls use cases; an endpoint named here is invisible to the '
            'domain layer.',
      );
    }
  });

  test('every feature with a data layer also declares a domain contract', () {
    final Directory features = Directory('lib/features');
    for (final entity in features.listSync().whereType<Directory>()) {
      final bool hasData = Directory('${entity.path}/data').existsSync();
      final bool hasDomain = Directory('${entity.path}/domain').existsSync();
      expect(
        !hasData || hasDomain,
        isTrue,
        reason: '${entity.path} has a data layer with no domain contract, so '
            'nothing above it can depend on an interface.',
      );
    }
  });
}
