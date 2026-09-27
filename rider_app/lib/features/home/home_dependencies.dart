import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/home_repository_impl.dart';
import 'domain/home_repository.dart';
import 'domain/usecases/get_home_summary.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) => HomeRepositoryImpl(ref.watch(deploymentApiProvider)));

final getHomeSummaryProvider = Provider<GetHomeSummary>((ref) => GetHomeSummary(ref.watch(homeRepositoryProvider)));
