import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../../features/hub/domain/entities/hub_profile.dart';

class FleetSession extends Equatable {
  FleetSession({
    this.user,
    FeatureFlags? flags,
    this.mobile = '',
    this.hubs = const [],
    Set<int> selectedHubIndexes = const {0},
    this.present = false,
  }) : flags = flags ?? FeatureFlags.empty,
       selectedHubIndexes = Set<int>.unmodifiable(selectedHubIndexes);

  final AuthUser? user;
  final FeatureFlags flags;
  final String mobile;
  final List<HubProfile> hubs;
  final Set<int> selectedHubIndexes;
  final bool present;

  bool get isSignedIn => user != null;

  List<int> get activeHubIndexes {
    final List<int> valid = selectedHubIndexes.where((i) => i >= 0 && i < hubs.length).toList()..sort();
    return valid.isEmpty && hubs.isNotEmpty ? const [0] : valid;
  }

  List<HubProfile> get activeHubs => [for (final int index in activeHubIndexes) hubs[index]];

  List<String> get activeHubCodes => [for (final HubProfile hub in activeHubs) hub.code];

  HubProfile? get hub => activeHubs.firstOrNull;

  String get hubId => hub?.id ?? '';

  String get hubName => hub?.name ?? '—';

  String get hubCode => hub?.code ?? '—';

  String get managerName => ActiveLocale.strings.commonManager;

  FleetSession copyWith({
    AuthUser? user,
    FeatureFlags? flags,
    String? mobile,
    List<HubProfile>? hubs,
    Set<int>? selectedHubIndexes,
    bool? present,
  }) => FleetSession(
    user: user ?? this.user,
    flags: flags ?? this.flags,
    mobile: mobile ?? this.mobile,
    hubs: hubs ?? this.hubs,
    selectedHubIndexes: selectedHubIndexes ?? this.selectedHubIndexes,
    present: present ?? this.present,
  );

  DynamicUiScope scope({
    required DynamicFormController form,
    required UiActionHandler onAction,
    Map<String, Object?> data = const {},
  }) => DynamicUiScope(
    flags: flags,
    form: form,
    onAction: onAction,
    data: {
      'manager': {'name': managerName, 'mobile': mobile},
      'hub': {'id': hubId, 'name': hubName, 'code': hubCode},
      ...data,
    },
  );

  @override
  List<Object?> get props => [user, flags, mobile, hubs, selectedHubIndexes, present];
}
