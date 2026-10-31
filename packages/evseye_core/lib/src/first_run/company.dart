import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_env.dart';
import '../api/company_api.dart';
import '../api/legal_api.dart';
import '../flavor/flavor_config.dart';
import '../providers/core_providers.dart';
import '../utils/result.dart';
import 'pre_login_resolution.dart';

class ResolvedCompany extends Equatable {
  const ResolvedCompany({required this.code, this.name});

  final String code;
  final String? name;

  @override
  List<Object?> get props => [code, name];
}

class CompanyNotifier extends Notifier<ResolvedCompany?> {
  static const String _codeKey = 'app.company.code';
  static const String _nameKey = 'app.company.name';

  SharedPreferences get _preferences => ref.read(sharedPreferencesProvider);
  String? _lastInput;
  LegalAudience? _lastAudience;
  bool _resolving = false;
  PreLoginResolutionState _resolution = const PreLoginResolutionState();
  PreLoginResolutionState get resolution => _resolution;
  bool get isResolving => _resolving;

  @override
  ResolvedCompany? build() {
    final SharedPreferences preferences = ref.watch(sharedPreferencesProvider);
    if (FlavorConfig.companyCode.isNotEmpty) {
      ApiEnv.companyCode = FlavorConfig.companyCode;
      return const ResolvedCompany(code: FlavorConfig.companyCode);
    }
    final String code = preferences.getString(_codeKey) ?? '';
    if (code.isEmpty) return null;
    ApiEnv.companyCode = code;
    return ResolvedCompany(code: code, name: preferences.getString(_nameKey));
  }

  Future<Result<ResolvedCompany>> resolve(String input, LegalAudience audience) async {
    _lastInput = input;
    _lastAudience = audience;
    _resolving = true;
    _resolution = _resolution.resolving();
    final Result<CompanyDto> result = await ref
        .read(companyApiProvider)
        .resolve(code: input.trim().toLowerCase(), audience: audience);
    if (result case Err<CompanyDto>(:final failure)) {
      _resolving = false;
      _resolution = _resolution.error(failure);
      return Result.err(failure);
    }
    final CompanyDto company = (result as Ok<CompanyDto>).value;
    await _preferences.setString(_codeKey, company.code);
    await _preferences.setString(_nameKey, company.name);
    ApiEnv.companyCode = company.code;
    final ResolvedCompany resolved = ResolvedCompany(code: company.code, name: company.name);
    state = resolved;
    _resolving = false;
    _resolution = _resolution.success();
    return Result.ok(resolved);
  }

  Future<Result<ResolvedCompany>> retry() async {
    final input = _lastInput;
    final audience = _lastAudience;
    if (input == null || audience == null) {
      return Result.err(const ValidationFailure('Enter your company code to try again.'));
    }
    return resolve(input, audience);
  }
}

final companyProvider = NotifierProvider<CompanyNotifier, ResolvedCompany?>(CompanyNotifier.new);
