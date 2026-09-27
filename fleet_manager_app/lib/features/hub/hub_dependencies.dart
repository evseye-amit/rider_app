import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/hub_repository_impl.dart';
import 'domain/hub_repository.dart';
import 'domain/usecases/get_hub_profile.dart';
import 'domain/usecases/get_hub_summary.dart';
import 'domain/usecases/list_hubs.dart';

final hubRepositoryProvider = Provider<HubRepository>((ref) => HubRepositoryImpl(ref.watch(apiClientProvider)));

final listHubsProvider = Provider<ListHubs>((ref) => ListHubs(ref.watch(hubRepositoryProvider)));

final getHubSummaryProvider = Provider<GetHubSummary>((ref) => GetHubSummary(ref.watch(hubRepositoryProvider)));

final getHubProfileProvider = Provider<GetHubProfile>((ref) => GetHubProfile(ref.watch(hubRepositoryProvider)));
