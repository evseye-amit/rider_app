import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/session/fleet_session_provider.dart';
import '../../domain/entities/hub_profile.dart';
import '../../domain/entities/hub_summary.dart';
import '../../domain/usecases/get_hub_profile.dart';
import '../../domain/usecases/get_hub_summary.dart';
import '../../hub_dependencies.dart';

typedef HubOverview = ({HubSummary summary, HubProfile profile});

final hubOverviewProvider = FutureProvider.autoDispose<HubOverview>((ref) async {
  final String selection = ref.watch(fleetSessionProvider.select((s) => s.activeHubCodes.join(',')));
  final List<String> hubCodes = selection.isEmpty ? const [] : selection.split(',');
  if (hubCodes.isEmpty) throw NotFoundFailure(ActiveLocale.strings.hubSomethingWentWrong);

  final GetHubSummary getSummary = ref.watch(getHubSummaryProvider);
  final GetHubProfile getProfile = ref.watch(getHubProfileProvider);

  final (List<Result<HubSummary>> summaries, Result<HubProfile> firstProfile) = await (
    Future.wait([for (final String code in hubCodes) getSummary(code)]),
    getProfile(hubCodes.first),
  ).wait;

  final List<(String, HubSummary)> loaded = [
    for (final (int i, Result<HubSummary> summary) in summaries.indexed)
      if (summary case Ok<HubSummary>(:final value)) (hubCodes[i], value),
  ];
  if (loaded.isEmpty) {
    throw switch (summaries.first) {
      Err<HubSummary>(:final failure) => failure,
      Ok<HubSummary>() => NotFoundFailure(ActiveLocale.strings.hubSomethingWentWrong),
    };
  }

  final String profileCode = loaded.first.$1;
  final Result<HubProfile> profile = profileCode == hubCodes.first ? firstProfile : await getProfile(profileCode);

  return (summary: HubSummary.combine([for (final (_, summary) in loaded) summary]), profile: profile.getOrThrow());
});
