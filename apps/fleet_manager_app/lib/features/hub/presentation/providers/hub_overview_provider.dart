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

  final (List<Result<HubSummary>> summaries, Result<HubProfile> profile) = await (
    Future.wait([for (final String code in hubCodes) getSummary(code)]),
    getProfile(hubCodes.first),
  ).wait;

  final HubSummary combined = hubCodes.length == 1
      ? summaries.single.getOrThrow()
      : HubSummary.combine([for (final Result<HubSummary> summary in summaries) summary.getOrThrow()]);

  return (summary: combined, profile: profile.getOrThrow());
});
