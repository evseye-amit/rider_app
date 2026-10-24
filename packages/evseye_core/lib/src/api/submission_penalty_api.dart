import '../utils/result.dart';
import 'api_client.dart';
import 'json_fields.dart';
import 'ride_returns_api.dart';
import 'vehicle_submission_api.dart';

enum PenaltyPaymentStatus {
  unpaid('UNPAID'),
  paid('PAID');

  const PenaltyPaymentStatus(this.wire);

  final String wire;

  static PenaltyPaymentStatus parse(Object? raw) =>
      PenaltyPaymentStatus.values.firstWhere((status) => status.wire == raw?.toString(), orElse: () => unpaid);
}

class PenaltyChargeLineDto {
  const PenaltyChargeLineDto({
    required this.code,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unitAmount,
    required this.amount,
    required this.details,
    required this.evidencePhotoIds,
  });

  factory PenaltyChargeLineDto.fromJson(Map<String, dynamic> json) => PenaltyChargeLineDto(
    code: jsonText(json['code']),
    name: jsonTextOrNull(jsonMap(json['spare'])['name']) ?? jsonText(json['description']),
    category: PenaltyCategory.parse(json['category']),
    quantity: jsonIntOrNull(json['quantity']) ?? 1,
    unitAmount: jsonNum(json['unitAmount']),
    amount: jsonNum(json['amount']),
    details: jsonText(json['details']),
    evidencePhotoIds: jsonStrings(json['evidencePhotoIds']),
  );

  final String code;
  final String name;
  final PenaltyCategory category;
  final int quantity;
  final num unitAmount;
  final num amount;
  final String details;
  final List<String> evidencePhotoIds;
}

class SubmissionPenaltyDto {
  const SubmissionPenaltyDto({
    required this.invoiceId,
    required this.invoiceNumber,
    required this.currency,
    required this.totalAmount,
    required this.paidAmount,
    required this.settledCreditAmount,
    required this.outstandingAmount,
    required this.status,
    required this.paymentStatus,
    required this.stage,
    required this.summary,
    required this.lines,
    this.createdAt,
    this.reportId,
    this.submissionId,
  });

  factory SubmissionPenaltyDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> breakdown = jsonMap(json['breakdown']);
    return SubmissionPenaltyDto(
      invoiceId: jsonText(json['invoiceId']),
      invoiceNumber: jsonText(json['invoiceNumber']),
      currency: jsonTextOrNull(json['currency']) ?? 'INR',
      totalAmount: jsonNum(json['totalAmount']),
      paidAmount: jsonNum(json['paidAmount']),
      settledCreditAmount: jsonNum(json['settledCreditAmount']),
      outstandingAmount: jsonNum(json['outstandingAmount']),
      status: jsonText(json['status']),
      paymentStatus: PenaltyPaymentStatus.parse(json['paymentStatus']),
      stage: SubmissionStage.parse(breakdown['stage']),
      summary: jsonText(breakdown['summary']),
      lines: [
        for (final Map<String, dynamic> row in jsonMaps(breakdown['penalties'])) PenaltyChargeLineDto.fromJson(row),
      ],
      createdAt: jsonDate(json['createdAt']),
      reportId: jsonTextOrNull(breakdown['reportId']),
      submissionId: jsonTextOrNull(breakdown['submissionId']),
    );
  }

  final String invoiceId;
  final String invoiceNumber;
  final String currency;
  final num totalAmount;
  final num paidAmount;
  final num settledCreditAmount;
  final num outstandingAmount;
  final String status;
  final PenaltyPaymentStatus paymentStatus;
  final SubmissionStage stage;
  final String summary;
  final List<PenaltyChargeLineDto> lines;
  final DateTime? createdAt;
  final String? reportId;
  final String? submissionId;

  bool get isVoid => status == 'VOID';
}

class SubmissionPenaltySummaryDto {
  const SubmissionPenaltySummaryDto({
    required this.totalAmount,
    required this.paidAmount,
    required this.settledCreditAmount,
    required this.outstandingAmount,
    required this.pendingCount,
    this.paymentInProgressAmount,
    this.paymentInProgressSource,
    this.paymentInProgressStatus,
  });

  factory SubmissionPenaltySummaryDto.fromJson(Map<String, dynamic> json) {
    final String currency = jsonTextOrNull(json['currency']) ?? 'INR';
    final Map<String, dynamic> totals = jsonMaps(
      json['totals'],
    ).firstWhere((row) => jsonText(row['currency']) == currency, orElse: () => const <String, dynamic>{});
    final Map<String, dynamic> inProgress = jsonMap(json['paymentInProgress']);
    return SubmissionPenaltySummaryDto(
      totalAmount: jsonNum(totals['totalAmount']),
      paidAmount: jsonNum(totals['paidAmount']),
      settledCreditAmount: jsonNum(totals['settledCreditAmount']),
      outstandingAmount: jsonNum(totals['outstandingAmount']),
      pendingCount: jsonIntOrNull(json['pendingCount']) ?? 0,
      paymentInProgressAmount: inProgress.isEmpty ? null : jsonNum(inProgress['amount']),
      paymentInProgressSource: jsonTextOrNull(inProgress['source']),
      paymentInProgressStatus: jsonTextOrNull(inProgress['status']),
    );
  }

  final num totalAmount;
  final num paidAmount;
  final num settledCreditAmount;
  final num outstandingAmount;
  final int pendingCount;
  final num? paymentInProgressAmount;
  final String? paymentInProgressSource;
  final String? paymentInProgressStatus;
}

class SubmissionPenaltyPage {
  const SubmissionPenaltyPage({required this.items, required this.page, required this.hasMore});

  final List<SubmissionPenaltyDto> items;
  final int page;
  final bool hasMore;
}

class SubmissionPenaltyApi {
  const SubmissionPenaltyApi(this._client);

  final ApiClient _client;

  static const String _base = '/rider-app/submission-penalties';

  Future<Result<SubmissionPenaltyPage>> list({bool includePaid = false, int page = 1, int limit = 25}) =>
      _client.get<SubmissionPenaltyPage>(
        _base,
        query: {'page': page, 'limit': limit, 'status': includePaid ? 'ALL' : 'PENDING'},
        parse: (data) {
          final List<SubmissionPenaltyDto> items = jsonMaps(
            data,
          ).map(SubmissionPenaltyDto.fromJson).toList(growable: false);
          return SubmissionPenaltyPage(items: items, page: page, hasMore: items.length >= limit);
        },
      );

  Future<Result<SubmissionPenaltySummaryDto>> summary() => _client.get<SubmissionPenaltySummaryDto>(
    '$_base/summary',
    parse: (data) => SubmissionPenaltySummaryDto.fromJson(jsonMap(data)),
  );

  Future<Result<SubmissionPenaltyDto>> detail(String invoiceId) => _client.get<SubmissionPenaltyDto>(
    '$_base/$invoiceId',
    parse: (data) => SubmissionPenaltyDto.fromJson(jsonMap(data)),
  );
}
