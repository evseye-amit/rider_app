import 'package:equatable/equatable.dart';

class ReferralLink extends Equatable {
  const ReferralLink({required this.code, this.inviteToken, this.campaignCode});

  static final RegExp _code = RegExp(r'^EVS-[A-Z2-9]{8}$');
  static final RegExp _campaign = RegExp(r'^[A-Z0-9_]{3,48}$');
  static final RegExp _token = RegExp(r'^[A-Za-z0-9_-]{16,128}$');

  final String code;
  final String? inviteToken;
  final String? campaignCode;

  static ReferralLink? parse(String? raw) {
    final String text = raw?.trim() ?? '';
    if (text.isEmpty) return null;
    final String upper = text.toUpperCase();
    if (_code.hasMatch(upper)) return ReferralLink(code: upper);
    final Uri? uri = Uri.tryParse(text);
    if (uri != null && uri.hasScheme) return fromParameters(uri.queryParameters);
    return fromParameters(_query(text));
  }

  static ReferralLink? fromParameters(Map<String, String> params) {
    final String code = (params['utm_source'] ?? params['code'] ?? '').trim().toUpperCase();
    if (!_code.hasMatch(code)) return null;
    final String invite = params['invite']?.trim() ?? '';
    final String campaign = params['campaign']?.trim().toUpperCase() ?? '';
    return ReferralLink(
      code: code,
      inviteToken: _token.hasMatch(invite) ? invite : null,
      campaignCode: _campaign.hasMatch(campaign) ? campaign : null,
    );
  }

  static ReferralLink? fromJson(Object? json) => json is Map
      ? fromParameters({for (final MapEntry<Object?, Object?> entry in json.entries) '${entry.key}': '${entry.value}'})
      : null;

  Map<String, String> toJson() => {'code': code, 'invite': ?inviteToken, 'campaign': ?campaignCode};

  static Map<String, String> _query(String text) {
    try {
      return Uri.splitQueryString(text);
    } on FormatException {
      return const {};
    }
  }

  @override
  List<Object?> get props => [code, inviteToken, campaignCode];
}
