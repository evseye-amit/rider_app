import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/support_overview.dart';
import '../../support_dependencies.dart';

final supportOverviewProvider = FutureProvider.autoDispose<SupportOverview>(
  (ref) async => (await ref.watch(getSupportOverviewProvider)(const NoParams())).getOrThrow(),
);
