import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/home_summary.dart';
import '../../home_dependencies.dart';

final homeSummaryProvider = FutureProvider.autoDispose<HomeSummary>(
  (ref) async => (await ref.watch(getHomeSummaryProvider)(const NoParams())).getOrThrow(),
);
