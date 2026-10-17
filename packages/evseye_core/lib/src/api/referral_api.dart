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

List<Map<String, dynamic>> _maps(Object? value) => [
  for (final Object? item in value is List ? value : const [])
    if (item is Map) Map<String, dynamic>.from(item),
];

enum ReferralSource {
  referralCode('REFERRAL_CODE'),
  qrCode('QR_CODE'),
  deepLink('DEEP_LINK'),
  shareLink('SHARE_LINK');

  const ReferralSource(this.wire);

  final String wire;
}

class ReferralMilestoneDto {
  const ReferralMilestoneDto({
    required this.type,
    required this.target,
    this.operator,
    this.current,
    this.mandatory = true,
    this.completedAt,
  });

  factory ReferralMilestoneDto.fromJson(Map<String, dynamic> json) => ReferralMilestoneDto(
    type: _textOrNull(json['type']) ?? '',
    target: _amount(json['target']),
    operator: _textOrNull(json['operator']),
    current: json['current'] == null ? null : _amount(json['current']),
    mandatory: json['mandatory'] != false,
    completedAt: _date(json['completedAt']),
  );

  final String type;
  final num target;
  final String? operator;
  final num? current;
  final bool mandatory;
  final DateTime? completedAt;

  bool get isDone => completedAt != null;
}

class ReferralCampaignDto {
  const ReferralCampaignDto({
    required this.title,
    this.code,
    this.description,
    this.terms,
    this.endAt,
    this.milestones = const [],
  });

  factory ReferralCampaignDto.fromJson(Map<String, dynamic> json) => ReferralCampaignDto(
    title: _textOrNull(json['title']) ?? '',
    code: _textOrNull(json['code']),
    description: _textOrNull(json['description']),
    terms: _textOrNull(json['terms']),
    endAt: _date(json['endAt']),
    milestones: _maps(json['milestones']).map(ReferralMilestoneDto.fromJson).toList(growable: false),
  );

  final String title;
  final String? code;
  final String? description;
  final String? terms;
  final DateTime? endAt;
  final List<ReferralMilestoneDto> milestones;
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
    this.qrPayload,
    this.shareMessage,
    this.referrerReward,
    this.refereeReward,
    this.currency,
  });

  factory ReferralHomeDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> referral = _map(json['referral']);
    final Map<String, dynamic> rewards = _map(json['rewards']);
    return ReferralHomeDto(
      summary: ReferralSummaryDto.fromJson(_map(json['summary'])),
      campaign: json['campaign'] is Map ? ReferralCampaignDto.fromJson(_map(json['campaign'])) : null,
      code: _textOrNull(referral['code']),
      shareLink: _textOrNull(referral['shareLink']),
      qrPayload: _textOrNull(referral['qrPayload']),
      shareMessage: _textOrNull(referral['shareMessage']),
      referrerReward: rewards['referrerReward'] is Map
          ? ReferralRewardRuleDto.fromJson(_map(rewards['referrerReward']))
          : null,
      refereeReward: rewards['refereeReward'] is Map
          ? ReferralRewardRuleDto.fromJson(_map(rewards['refereeReward']))
          : null,
      currency: _textOrNull(rewards['currency']),
    );
  }

  final ReferralSummaryDto summary;
  final ReferralCampaignDto? campaign;
  final String? code;
  final String? shareLink;
  final String? qrPayload;
  final String? shareMessage;
  final ReferralRewardRuleDto? referrerReward;
  final ReferralRewardRuleDto? refereeReward;
  final String? currency;
}

class ReferralInviteDto {
  const ReferralInviteDto({
    required this.referralCode,
    required this.shareLink,
    this.inviteToken,
    this.qrPayload,
    this.expiresAt,
  });

  factory ReferralInviteDto.fromJson(Map<String, dynamic> json) => ReferralInviteDto(
    referralCode: _textOrNull(json['referralCode']) ?? '',
    shareLink: _textOrNull(json['shareLink']) ?? '',
    inviteToken: _textOrNull(json['inviteToken']),
    qrPayload: _textOrNull(json['qrPayload']),
    expiresAt: _date(json['expiresAt']),
  );

  final String referralCode;
  final String shareLink;
  final String? inviteToken;
  final String? qrPayload;
  final DateTime? expiresAt;
}

class ReferralRewardDto {
  const ReferralRewardDto({
    required this.beneficiary,
    required this.amount,
    required this.status,
    this.currency,
    this.earnedAt,
    this.approvedAt,
    this.paidAt,
  });

  factory ReferralRewardDto.fromJson(Map<String, dynamic> json) => ReferralRewardDto(
    beneficiary: _textOrNull(json['beneficiary']) ?? '',
    amount: _amount(json['amount']),
    status: _textOrNull(json['status']) ?? '',
    currency: _textOrNull(json['currency']),
    earnedAt: _date(json['earnedAt']),
    approvedAt: _date(json['approvedAt']),
    paidAt: _date(_map(json['payout'])['paidAt']),
  );

  final String beneficiary;
  final num amount;
  final String status;
  final String? currency;
  final DateTime? earnedAt;
  final DateTime? approvedAt;
  final DateTime? paidAt;
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
    this.qualificationDeadlineAt,
    this.milestones = const [],
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
      qualificationDeadlineAt: _date(json['qualificationDeadlineAt']),
      milestones: _maps(json['milestones']).map(ReferralMilestoneDto.fromJson).toList(growable: false),
      rewards: _maps(json['rewards']).map(ReferralRewardDto.fromJson).toList(growable: false),
    );
  }

  final String id;
  final String status;
  final String? refereeName;
  final String? refereeMobile;
  final DateTime? invitedAt;
  final DateTime? registeredAt;
  final DateTime? qualifiedAt;
  final DateTime? qualificationDeadlineAt;
  final List<ReferralMilestoneDto> milestones;
  final List<ReferralRewardDto> rewards;
}

class ReferralDetailDto extends ReferralDto {
  const ReferralDetailDto({
    required super.id,
    required super.status,
    required super.rewards,
    super.refereeName,
    super.refereeMobile,
    super.invitedAt,
    super.registeredAt,
    super.qualifiedAt,
    super.qualificationDeadlineAt,
    super.milestones,
    this.campaignTitle,
    this.kycVerifiedAt,
    this.activatedAt,
    this.expiresAt,
  });

  factory ReferralDetailDto.fromJson(Map<String, dynamic> json) {
    final ReferralDto base = ReferralDto.fromJson(json);
    return ReferralDetailDto(
      id: base.id,
      status: base.status,
      rewards: base.rewards,
      refereeName: base.refereeName,
      refereeMobile: base.refereeMobile,
      invitedAt: base.invitedAt,
      registeredAt: base.registeredAt,
      qualifiedAt: base.qualifiedAt,
      qualificationDeadlineAt: base.qualificationDeadlineAt,
      milestones: base.milestones,
      campaignTitle: _textOrNull(_map(json['campaign'])['title']),
      kycVerifiedAt: _date(json['kycVerifiedAt']),
      activatedAt: _date(json['activatedAt']),
      expiresAt: _date(json['expiresAt']),
    );
  }

  final String? campaignTitle;
  final DateTime? kycVerifiedAt;
  final DateTime? activatedAt;
  final DateTime? expiresAt;
}

class ReferralActivityDto {
  const ReferralActivityDto({required this.id, required this.eventType, this.referralId, this.createdAt});

  factory ReferralActivityDto.fromJson(Map<String, dynamic> json) => ReferralActivityDto(
    id: json['id']?.toString() ?? '',
    eventType: _textOrNull(json['eventType']) ?? '',
    referralId: _textOrNull(json['referralId']),
    createdAt: _date(json['createdAt']),
  );

  final String id;
  final String eventType;
  final String? referralId;
  final DateTime? createdAt;
}

class ReferralApi {
  ReferralApi(this._client);

  final ApiClient _client;

  static const String _base = '/rider-app/referrals';

  Future<Result<ReferralHomeDto>> home() =>
      _client.get<ReferralHomeDto>('$_base/home', parse: (data) => ReferralHomeDto.fromJson(_map(data)));

  Future<Result<ReferralInviteDto>> invite() =>
      _client.post<ReferralInviteDto>('$_base/invites', parse: (data) => ReferralInviteDto.fromJson(_map(data)));

  Future<Result<void>> attribute(
    String referralCode, {
    ReferralSource? source,
    String? inviteToken,
    String? campaignCode,
  }) => _client.post<void>(
    '$_base/attribute',
    body: {
      'referralCode': referralCode,
      'source': ?source?.wire,
      'inviteToken': ?inviteToken,
      'campaignCode': ?campaignCode,
    },
  );

  Future<Result<String>> resolveInput(String input) => _client.get<String>(
    '$_base/resolve-input',
    query: {'input': input},
    parse: (data) => _map(data)['referralCode']?.toString() ?? '',
  );

  Future<Result<List<ReferralDto>>> mine({int page = 1, int pageSize = 50}) => _client.get<List<ReferralDto>>(
    _base,
    query: {'page': page, 'pageSize': pageSize},
    parse: (data) => _maps(_map(data)['items']).map(ReferralDto.fromJson).toList(growable: false),
  );

  Future<Result<ReferralDetailDto>> detail(String id) =>
      _client.get<ReferralDetailDto>('$_base/$id', parse: (data) => ReferralDetailDto.fromJson(_map(data)));

  Future<Result<List<ReferralActivityDto>>> activity({int page = 1, int pageSize = 20}) =>
      _client.get<List<ReferralActivityDto>>(
        '$_base/notifications',
        query: {'page': page, 'pageSize': pageSize},
        parse: (data) => _maps(_map(data)['items']).map(ReferralActivityDto.fromJson).toList(growable: false),
      );
}
