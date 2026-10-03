import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/exchange_request.dart';
import '../../exchange_dependencies.dart';

final exchangesProvider = FutureProvider.autoDispose<List<ExchangeRequest>>(
  (ref) async => (await ref.watch(getExchangesProvider)(const NoParams())).getOrThrow(),
);

final exchangeProvider = FutureProvider.autoDispose.family<ExchangeRequest, String>(
  (ref, id) async => (await ref.watch(getExchangeProvider)(id)).getOrThrow(),
);
