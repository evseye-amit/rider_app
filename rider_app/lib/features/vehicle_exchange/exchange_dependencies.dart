import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/exchange_repository_impl.dart';
import 'domain/exchange_repository.dart';
import 'domain/usecases/get_exchange.dart';
import 'domain/usecases/get_exchanges.dart';
import 'domain/usecases/request_exchange.dart';
import 'domain/usecases/respond_to_offer.dart';

final exchangeRepositoryProvider = Provider<ExchangeRepository>(
  (ref) => ExchangeRepositoryImpl(ref.watch(vehicleExchangeApiProvider)),
);

final getExchangesProvider = Provider<GetExchanges>((ref) => GetExchanges(ref.watch(exchangeRepositoryProvider)));

final getExchangeProvider = Provider<GetExchange>((ref) => GetExchange(ref.watch(exchangeRepositoryProvider)));

final requestExchangeProvider = Provider<RequestExchange>(
  (ref) => RequestExchange(ref.watch(exchangeRepositoryProvider)),
);

final acceptExchangeOfferProvider = Provider<AcceptExchangeOffer>(
  (ref) => AcceptExchangeOffer(ref.watch(exchangeRepositoryProvider)),
);

final rejectExchangeOfferProvider = Provider<RejectExchangeOffer>(
  (ref) => RejectExchangeOffer(ref.watch(exchangeRepositoryProvider)),
);

final cancelExchangeProvider = Provider<CancelExchange>((ref) => CancelExchange(ref.watch(exchangeRepositoryProvider)));
