import 'dart:io';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/support_ticket.dart';
import '../../domain/usecases/raise_ticket.dart';
import '../../support_dependencies.dart';

class RaiseTicketPage extends ConsumerStatefulWidget {
  const RaiseTicketPage({super.key});

  @override
  ConsumerState<RaiseTicketPage> createState() => _RaiseTicketPageState();
}

class _RaiseTicketPageState extends ConsumerState<RaiseTicketPage> {
  static const int _maxPhotos = 3;
  static const int _minMessage = 10;

  final TextEditingController _subject = TextEditingController();
  final TextEditingController _message = TextEditingController();
  final List<File> _photos = [];

  int? _topic;
  bool _submitting = false;
  String? _subjectError;
  String? _messageError;

  @override
  void dispose() {
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  List<_Topic> _topics(BuildContext context) => [
    _Topic(Icons.battery_charging_full_rounded, context.l10n.supportBatteryCharging),
    _Topic(Icons.car_crash_rounded, context.l10n.supportBreakdownRoad),
    _Topic(Icons.account_balance_wallet_rounded, context.l10n.supportPaymentWallet),
    _Topic(Icons.badge_rounded, context.l10n.supportDocumentsKyc),
    _Topic(Icons.report_rounded, context.l10n.supportAccidentTheft),
    _Topic(Icons.help_outline_rounded, context.l10n.supportSomethingElse, fillsSubject: false),
  ];

  void _pickTopic(List<_Topic> topics, int index) {
    final String current = _subject.text.trim();
    final int? previous = _topic;
    final bool untouched = current.isEmpty || (previous != null && current == topics[previous].label);
    setState(() {
      _topic = index;
      if (!untouched) return;
      _subject.text = topics[index].fillsSubject ? topics[index].label : '';
      _subjectError = null;
    });
  }

  Future<void> _addPhoto() async {
    final File? file = await PhotoSourceSheet.pick(context);
    if (file == null || !mounted) return;
    setState(() => _photos.add(file));
  }

  bool _validate() {
    setState(() {
      _subjectError = _subject.text.trim().isEmpty ? context.l10n.supportTellUsWhatAbout : null;
      _messageError = _message.text.trim().length < _minMessage ? context.l10n.supportAddFewMoreDetails10 : null;
    });
    return _subjectError == null && _messageError == null;
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_validate()) return;
    setState(() => _submitting = true);

    final Result<RaisedTicket> result = await ref.read(raiseTicketProvider)(
      RaiseTicketParams(subject: _subject.text.trim(), message: _message.text.trim(), photos: List.of(_photos)),
    );
    if (!mounted) return;
    setState(() => _submitting = false);

    switch (result) {
      case Ok<RaisedTicket>(:final value):
        if (value.failedPhotos > 0) {
          AppSnack.warning(context, context.l10n.supportPhotosNotAttached(value.failedPhotos));
        } else {
          AppSnack.success(context, context.l10n.supportTicketRaised);
        }
        context.pop(value.ticket.id);
      case Err<RaisedTicket>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<_Topic> topics = _topics(context);

    return AppScaffold(
      title: context.l10n.supportRaiseTicket,
      subtitle: context.l10n.supportMoreDetailGiveFasterCan,
      footer: PrimaryButton(
        label: context.l10n.supportSubmitTicket,
        icon: Icons.send_rounded,
        loading: _submitting,
        onPressed: _submitting ? null : _submit,
      ),
      body: PageBody(
        children: [
          ModuleCard(
            title: context.l10n.supportWhatsTheIssue,
            leading: const IconTile(icon: Icons.category_rounded, tone: AppColors.primary, solid: true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.supportPickTopic, style: AppText.bodySmall.copyWith(fontSize: 12.5)),
                const Gap.md(),
                Wrap(
                  spacing: Insets.sm,
                  runSpacing: Insets.sm,
                  children: [
                    for (int i = 0; i < topics.length; i++)
                      _TopicChip(topic: topics[i], selected: _topic == i, onTap: () => _pickTopic(topics, i)),
                  ],
                ),
                const Gap.lg(),
                AppTextField(
                  label: context.l10n.supportSubject,
                  required: true,
                  controller: _subject,
                  hint: context.l10n.supportOneLineSumsUpIssue,
                  errorText: _subjectError,
                  maxLength: 160,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (_) {
                    if (_subjectError != null) setState(() => _subjectError = null);
                  },
                ),
              ],
            ),
          ),
          const Gap.lg(),
          ModuleCard(
            title: context.l10n.supportTellUsMore,
            leading: const IconTile(icon: Icons.notes_rounded, tone: AppColors.primary, solid: true),
            child: AppTextField(
              label: context.l10n.supportDescription,
              required: true,
              controller: _message,
              hint: context.l10n.supportWhatHappenedSinceWhen,
              maxLines: 6,
              maxLength: 10000,
              errorText: _messageError,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) {
                if (_messageError != null) setState(() => _messageError = null);
              },
            ),
          ),
          const Gap.lg(),
          ModuleCard(
            title: context.l10n.supportPhotosOptional,
            leading: const IconTile(icon: Icons.photo_camera_rounded, tone: AppColors.primary, solid: true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.supportPhotosHint(_maxPhotos), style: AppText.bodySmall.copyWith(fontSize: 12.5)),
                const Gap.md(),
                LocalPhotoGrid(
                  photos: _photos,
                  max: _maxPhotos,
                  onAdd: _submitting ? null : _addPhoto,
                  onRemove: _submitting ? null : (index) => setState(() => _photos.removeAt(index)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Topic {
  const _Topic(this.icon, this.label, {this.fillsSubject = true});

  final IconData icon;
  final String label;
  final bool fillsSubject;
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({required this.topic, required this.selected, required this.onTap});

  final _Topic topic;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color tone = selected ? AppColors.primary : AppColors.textSecondary;
    return Pressable(
      onTap: onTap,
      scale: 0.96,
      child: AnimatedContainer(
        duration: Motion.fast,
        padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryWash : AppColors.surface,
          borderRadius: Corners.pill,
          border: Border.all(color: selected ? AppColors.primary : AppColors.stroke),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(topic.icon, size: 16, color: tone),
            const SizedBox(width: Insets.xs + 2),
            Text(topic.label, style: AppText.titleSmall.copyWith(fontSize: 12.5, color: tone)),
          ],
        ),
      ),
    );
  }
}
