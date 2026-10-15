import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/exchange_desk_repository_impl.dart';
import 'domain/exchange_desk_repository.dart';
import 'domain/usecases/exchange_steps.dart';
import 'domain/usecases/get_exchange_cases.dart';

final exchangeDeskRepositoryProvider = Provider<ExchangeDeskRepository>(
  (ref) => ExchangeDeskRepositoryImpl(ref.watch(exchangeOperationsApiProvider), ref.watch(apiClientProvider)),
);

final getExchangeCasesProvider = Provider<GetExchangeCases>(
  (ref) => GetExchangeCases(ref.watch(exchangeDeskRepositoryProvider)),
);

final getExchangeCaseProvider = Provider<GetExchangeCase>(
  (ref) => GetExchangeCase(ref.watch(exchangeDeskRepositoryProvider)),
);

final getAvailableScootersProvider = Provider<GetAvailableScooters>(
  (ref) => GetAvailableScooters(ref.watch(exchangeDeskRepositoryProvider)),
);

final getExchangeQuoteProvider = Provider<GetExchangeQuote>(
  (ref) => GetExchangeQuote(ref.watch(exchangeDeskRepositoryProvider)),
);

final approveExchangeProvider = Provider<ApproveExchange>(
  (ref) => ApproveExchange(ref.watch(exchangeDeskRepositoryProvider)),
);

final rejectExchangeProvider = Provider<RejectExchange>(
  (ref) => RejectExchange(ref.watch(exchangeDeskRepositoryProvider)),
);

final startExchangeReturnProvider = Provider<StartExchangeReturn>(
  (ref) => StartExchangeReturn(ref.watch(exchangeDeskRepositoryProvider)),
);

final confirmExchangeReturnProvider = Provider<ConfirmExchangeReturn>(
  (ref) => ConfirmExchangeReturn(ref.watch(exchangeDeskRepositoryProvider)),
);

final chooseReplacementScooterProvider = Provider<ChooseReplacementScooter>(
  (ref) => ChooseReplacementScooter(ref.watch(exchangeDeskRepositoryProvider)),
);

final sendExchangeOfferProvider = Provider<SendExchangeOffer>(
  (ref) => SendExchangeOffer(ref.watch(exchangeDeskRepositoryProvider)),
);

final settleExchangeDepositsProvider = Provider<SettleExchangeDeposits>(
  (ref) => SettleExchangeDeposits(ref.watch(exchangeDeskRepositoryProvider)),
);

final startExchangeHandoverProvider = Provider<StartExchangeHandover>(
  (ref) => StartExchangeHandover(ref.watch(exchangeDeskRepositoryProvider)),
);

final completeExchangeProvider = Provider<CompleteExchange>(
  (ref) => CompleteExchange(ref.watch(exchangeDeskRepositoryProvider)),
);

final cancelExchangeCaseProvider = Provider<CancelExchangeCase>(
  (ref) => CancelExchangeCase(ref.watch(exchangeDeskRepositoryProvider)),
);

final acceptOfferOnBehalfProvider = Provider<AcceptOfferOnBehalf>(
  (ref) => AcceptOfferOnBehalf(ref.watch(exchangeDeskRepositoryProvider)),
);

final rejectOfferOnBehalfProvider = Provider<RejectOfferOnBehalf>(
  (ref) => RejectOfferOnBehalf(ref.watch(exchangeDeskRepositoryProvider)),
);
