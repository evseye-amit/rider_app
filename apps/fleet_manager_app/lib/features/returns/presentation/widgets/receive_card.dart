import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../../hub/domain/entities/hub_profile.dart';

class ReceiveInput {
  const ReceiveInput({required this.hubId, this.receivedAt, this.backdateReason});

  final String hubId;
  final DateTime? receivedAt;
  final String? backdateReason;
}

class ReceiveCard extends StatefulWidget {
  const ReceiveCard({
    required this.hubs,
    required this.plannedHubId,
    required this.busy,
    required this.onReceive,
    super.key,
  });

  final List<HubProfile> hubs;
  final String? plannedHubId;
  final bool busy;
  final ValueChanged<ReceiveInput> onReceive;

  @override
  State<ReceiveCard> createState() => _ReceiveCardState();
}

class _ReceiveCardState extends State<ReceiveCard> {
  static const int _backdateDays = 30;

  final TextEditingController _reason = TextEditingController();

  late String? _hubId = widget.hubs.any((hub) => hub.id == widget.plannedHubId)
      ? widget.plannedHubId
      : widget.hubs.firstOrNull?.id;
  bool _earlier = false;
  DateTime? _at;
  bool _showErrors = false;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  HubProfile? get _hub => widget.hubs.where((hub) => hub.id == _hubId).firstOrNull;

  Future<void> _pickHub() async {
    final String? picked = await AppSheet.show<String>(
      context,
      title: context.l10n.returnDeskReceivingHub,
      child: Column(
        children: [
          for (final HubProfile hub in widget.hubs) ...[
            AppRadioTile(
              selected: hub.id == _hubId,
              onTap: () => Navigator.of(context).pop(hub.id),
              title: hub.name,
              subtitle: [hub.code, if (hub.city.isNotEmpty) hub.city].join(' · '),
              leading: const IconTile(icon: Icons.store_rounded, size: 36),
            ),
            const Gap.sm(),
          ],
        ],
      ),
    );
    if (picked != null) setState(() => _hubId = picked);
  }

  Future<void> _pickTime() async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime? day = await AppDateWheel.show(
      context,
      first: today.subtract(const Duration(days: _backdateDays)),
      last: today,
      initial: _at ?? today,
      title: context.l10n.returnDeskReceivedAt,
    );
    if (day == null || !mounted) return;
    final TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_at ?? now));
    if (time == null || !mounted) return;
    final DateTime picked = DateTime(day.year, day.month, day.day, time.hour, time.minute);
    setState(() => _at = picked.isAfter(now) ? now : picked);
  }

  void _submit() {
    FocusManager.instance.primaryFocus?.unfocus();
    final String? hubId = _hubId;
    final String reason = _reason.text.trim();
    if (hubId == null || (_earlier && (_at == null || reason.isEmpty))) {
      setState(() => _showErrors = true);
      return;
    }
    widget.onReceive(
      ReceiveInput(hubId: hubId, receivedAt: _earlier ? _at : null, backdateReason: _earlier ? reason : null),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateTime? at = _at;
    return ModuleCard(
      title: context.l10n.returnDeskReceiveTitle,
      leading: const IconTile(icon: Icons.assignment_turned_in_rounded, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(context.l10n.returnDeskReceiveHint, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45)),
          const Gap.lg(),
          AppPickerField(
            label: context.l10n.returnDeskReceivingHub,
            required: true,
            value: _hub?.name,
            hint: context.l10n.returnsPickHub,
            prefixIcon: Icons.store_rounded,
            errorText: _showErrors && _hubId == null ? context.l10n.returnsPickHub : null,
            onTap: widget.hubs.isEmpty ? null : _pickHub,
          ),
          const Gap.md(),
          AppCheckTile(
            value: _earlier,
            onChanged: (value) => setState(() => _earlier = value),
            title: context.l10n.returnDeskReceivedEarlier,
            subtitle: context.l10n.returnDeskReceivedEarlierHint,
          ),
          if (_earlier) ...[
            const Gap.md(),
            AppPickerField(
              label: context.l10n.returnDeskReceivedAt,
              required: true,
              value: at == null ? null : Fmt.dateTime(at),
              hint: context.l10n.commonSelectDate,
              prefixIcon: Icons.schedule_rounded,
              errorText: _showErrors && at == null ? context.l10n.commonSelectDate : null,
              onTap: _pickTime,
            ),
            const Gap.md(),
            AppTextField(
              label: context.l10n.returnDeskBackdateReason,
              required: true,
              controller: _reason,
              maxLines: 2,
              maxLength: 500,
              textCapitalization: TextCapitalization.sentences,
              errorText: _showErrors && _reason.text.trim().isEmpty
                  ? context.l10n.returnDeskBackdateReasonNeeded
                  : null,
              onChanged: (_) {
                if (_showErrors) setState(() {});
              },
            ),
          ],
          const Gap.lg(),
          PrimaryButton(
            label: context.l10n.returnDeskMarkReceived,
            icon: Icons.assignment_turned_in_rounded,
            loading: widget.busy,
            onPressed: widget.busy ? null : _submit,
          ),
        ],
      ),
    );
  }
}
