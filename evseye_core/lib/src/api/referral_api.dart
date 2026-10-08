import '../utils/result.dart';
import 'api_client.dart';

String? _textOrNull(Object? value) {
  final String text = value?.toString().trim() ?? '';
  return text.isEmpty ? null : text;
}

num _amount(Object? value) => value is num ? value : num.tryParse(value?.toString() ?? '') ?? 0;

int _count(Object? value) => value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;

DateTime? _date(Object? value) => value == null ? null : DateTime.tryParse(value.toString());

Map<String, dynamic> _map(Object? value) => value is Map ? Map<String, dynamic>.from(value) : const <String, dynamic>{};

class ReferralCampaignDto {
  const ReferralCampaignDto({required this.title, this.description, this.terms, this.endAt});

  factory ReferralCampaignDto.fromJson(Map<String, dynamic> json) => ReferralCampaignDto(
    title: _textOrNull(json['title']) ?? '',
    description: _textOrNull(json['description']),
    terms: _textOrNull(json['terms']),
    endAt: _date(json['endAt']),
  );

  final String title;
  final String? description;
  final String? terms;
  final DateTime? endAt;
}

class ReferralRewardRuleDto {
  const ReferralRewardRuleDto({required this.type, required this.value});

  factory ReferralRewardRuleDto.fromJson(Map<String, dynamic> json) =>
      ReferralRewardRuleDto(type: _textOrNull(json['type']) ?? '', value: _amount(json['value']));

  final String type;
  final num value;
}

class ReferralSummaryDto {
  const ReferralSummaryDto({
    required this.totalInvited,
    required this.registered,
    required this.qualified,
    required this.totalEarned,
    required this.pendingReward,
    required this.paidReward,
  });

  factory ReferralSummaryDto.fromJson(Map<String, dynamic> json) => ReferralSummaryDto(
    totalInvited: _count(json['totalInvited']),
    registered: _count(json['registered']),
    qualified: _count(json['qualified']),
    totalEarned: _amount(json['totalEarned']),
    pendingReward: _amount(json['pendingReward']),
    paidReward: _amount(json['paidReward']),
  );

  final int totalInvited;
  final int registered;
  final int qualified;
  final num totalEarned;
  final num pendingReward;
  final num paidReward;
}

class ReferralHomeDto {
  const ReferralHomeDto({
    required this.summary,
    this.campaign,
    this.code,
    this.shareLink,
    this.shareMessage,
    this.referrerReward,
    this.refereeReward,
  });

  factory ReferralHomeDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> referral = _map(json['referral']);
    final Map<String, dynamic> rewards = _map(json['rewards']);
    return ReferralHomeDto(
      summary: ReferralSummaryDto.fromJson(_map(json['summary'])),
      campaign: json['campaign'] is Map ? ReferralCampaignDto.fromJson(_map(json['campaign'])) : null,
      code: _textOrNull(referral['code']),
      shareLink: _textOrNull(referral['shareLink']),
      shareMessage: _textOrNull(referral['shareMessage']),
      referrerReward: rewards['referrerReward'] is Map
          ? ReferralRewardRuleDto.fromJson(_map(rewards['referrerReward']))
          : null,
      refereeReward: rewards['refereeReward'] is Map
          ? ReferralRewardRuleDto.fromJson(_map(rewards['refereeReward']))
          : null,
    );
  }

  final ReferralSummaryDto summary;
  final ReferralCampaignDto? campaign;
  final String? code;
  final String? shareLink;
  final String? shareMessage;
  final ReferralRewardRuleDto? referrerReward;
  final ReferralRewardRuleDto? refereeReward;
}

class ReferralInviteDto {
  const ReferralInviteDto({required this.referralCode, required this.shareLink, this.expiresAt});

  factory ReferralInviteDto.fromJson(Map<String, dynamic> json) => ReferralInviteDto(
    referralCode: _textOrNull(json['referralCode']) ?? '',
    shareLink: _textOrNull(json['shareLink']) ?? '',
    expiresAt: _date(json['expiresAt']),
  );

  final String referralCode;
  final String shareLink;
  final DateTime? expiresAt;
}

class ReferralRewardDto {
  const ReferralRewardDto({required this.beneficiary, required this.amount, required this.status});

  factory ReferralRewardDto.fromJson(Map<String, dynamic> json) => ReferralRewardDto(
    beneficiary: _textOrNull(json['beneficiary']) ?? '',
    amount: _amount(json['amount']),
    status: _textOrNull(json['status']) ?? '',
  );

  final String beneficiary;
  final num amount;
  final String status;
}

class ReferralDto {
  const ReferralDto({
    required this.id,
    required this.status,
    required this.rewards,
    this.refereeName,
    this.refereeMobile,
    this.invitedAt,
    this.registeredAt,
    this.qualifiedAt,
  });

  factory ReferralDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> referee = _map(json['referee']);
    return ReferralDto(
      id: json['id']?.toString() ?? '',
      status: _textOrNull(json['status']) ?? '',
      refereeName: _textOrNull(referee['firstName']),
      refereeMobile: _textOrNull(referee['maskedMobile']),
      invitedAt: _date(json['invitedAt']),
      registeredAt: _date(json['registeredAt']),
      qualifiedAt: _date(json['qualifiedAt']),
      rewards: [
        for (final Object? reward in json['rewards'] as List? ?? const [])
          if (reward is Map) ReferralRewardDto.fromJson(Map<String, dynamic>.from(reward)),
      ],
    );
  }

  final String id;
  final String status;
  final String? refereeName;
  final String? refereeMobile;
  final DateTime? invitedAt;
  final DateTime? registeredAt;
  final DateTime? qualifiedAt;
  final List<ReferralRewardDto> rewards;
}

class ReferralApi {
  ReferralApi(this._client);

  final ApiClient _client;

  static const String _base = '/rider-app/referrals';

  Future<Result<ReferralHomeDto>> home() =>
      _client.get<ReferralHomeDto>('$_base/home', parse: (data) => ReferralHomeDto.fromJson(_map(data)));

  Future<Result<ReferralInviteDto>> invite() =>
      _client.post<ReferralInviteDto>('$_base/invites', parse: (data) => ReferralInviteDto.fromJson(_map(data)));

  Future<Result<void>> attribute(String referralCode) =>
      _client.post<void>('$_base/attribute', body: {'referralCode': referralCode});

  Future<Result<List<ReferralDto>>> mine({int page = 1, int pageSize = 50}) => _client.get<List<ReferralDto>>(
    _base,
    query: {'page': page, 'pageSize': pageSize},
    parse: (data) => [
      for (final Object? item in _map(data)['items'] as List? ?? const [])
        if (item is Map) ReferralDto.fromJson(Map<String, dynamic>.from(item)),
    ],
  );
}
