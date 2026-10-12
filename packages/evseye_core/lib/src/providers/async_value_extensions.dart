import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/active_locale.dart';
import '../utils/result.dart';

extension AsyncFailureX<T> on AsyncValue<T> {
  Failure? get failure => switch (error) {
    final Failure failure => failure,
    _ => null,
  };

  String? get failureMessage {
    final Object? error = this.error;
    if (error == null) return null;
    return error is Failure ? error.message : ActiveLocale.strings.commonSomethingWentWrongPleaseTry;
  }
}

extension WidgetRefRefreshX on WidgetRef {
  Future<void> refreshQuietly<T>(FutureProvider<T> provider) =>
      refresh(provider.future).then<void>((_) {}, onError: (_) {});
}
