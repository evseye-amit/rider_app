import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/exchange_case.dart';
import '../../exchange_dependencies.dart';

final exchangeCasesProvider = FutureProvider.autoDispose<List<ExchangeCase>>(
  (ref) async => (await ref.watch(getExchangeCasesProvider)(const NoParams())).getOrThrow(),
);

final exchangeCaseProvider = FutureProvider.autoDispose.family<ExchangeCase, String>(
  (ref, id) async => (await ref.watch(getExchangeCaseProvider)(id)).getOrThrow(),
);

final availableScootersProvider = FutureProvider.autoDispose<List<ScooterOption>>(
  (ref) async => (await ref.watch(getAvailableScootersProvider)(const NoParams())).getOrThrow(),
);

final exchangeQuoteProvider = FutureProvider.autoDispose.family<CaseQuote, String>(
  (ref, id) async => (await ref.watch(getExchangeQuoteProvider)(id)).getOrThrow(),
);
