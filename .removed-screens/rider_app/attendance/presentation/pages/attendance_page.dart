import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../../../app/di/injector.dart';

/// One day of shift history, as read from `assets/config/attendance_data.json`.
class _AttendanceDay {
  const _AttendanceDay({
    required this.date,
    required this.status,
    required this.inAt,
    required this.outAt,
    required this.minutes,
    required this.trips,
  });

  final DateTime date;
  final String status; // present | absent | halfday
  final String? inAt;
  final String? outAt;
  final int minutes;
  final int trips;
}

/// The rider's attendance record: this month's summary, a streak callout, a
/// calendar-style month grid, and a day-by-day list.
///
/// The ink band carries the month, the present/absent headline counts and the
/// streak; the calendar and the list live on the white sheet below.
class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late final Future<_AttendanceData> _future = _load();

  Future<_AttendanceData> _load() async {
    final Map<String, dynamic> data = await sl<UiConfigService>().loadRaw(
      'attendance_data',
    );
    final List<_AttendanceDay> days =
        (data['days'] as List<dynamic>? ?? const [])
            .map((e) => Map<String, dynamic>.from(e as Map))
            .map(
              (m) => _AttendanceDay(
                date: DateTime.parse(m['date'] as String),
                status: m['status'] as String? ?? 'absent',
                inAt: m['inAt'] as String?,
                outAt: m['outAt'] as String?,
                minutes: (m['minutes'] as num?)?.toInt() ?? 0,
                trips: (m['trips'] as num?)?.toInt() ?? 0,
              ),
            )
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));

    return _AttendanceData(
      monthLabel: data['monthLabel'] as String? ?? '',
      presentDays: (data['presentDays'] as num?)?.toInt() ?? 0,
      absentDays: (data['absentDays'] as num?)?.toInt() ?? 0,
      averageShiftMinutes: (data['averageShiftMinutes'] as num?)?.toInt() ?? 0,
      streak: (data['streak'] as num?)?.toInt() ?? 0,
      days: days,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_AttendanceData>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const AppScaffold(
            title: 'Attendance',
            body: _AttendanceSkeleton(),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return AppScaffold(
            title: 'Attendance',
            body: EmptyState(
              title: 'Could not load attendance',
              message: '${snapshot.error ?? 'Something went wrong.'}',
              icon: Icons.cloud_off_rounded,
              tone: AppColors.danger,
              actionLabel: 'Try again',
              onAction: () => setState(() {}),
            ),
          );
        }
        return _AttendanceContent(data: snapshot.data!);
      },
    );
  }
}

class _AttendanceData {
  const _AttendanceData({
    required this.monthLabel,
    required this.presentDays,
    required this.absentDays,
    required this.averageShiftMinutes,
    required this.streak,
    required this.days,
  });

  final String monthLabel;
  final int presentDays;
  final int absentDays;
  final int averageShiftMinutes;
  final int streak;
  final List<_AttendanceDay> days;

  int get halfDays => days.where((d) => d.status == 'halfday').length;
}

class _AttendanceContent extends StatefulWidget {
  const _AttendanceContent({required this.data});

  final _AttendanceData data;

  @override
  State<_AttendanceContent> createState() => _AttendanceContentState();
}

class _AttendanceContentState extends State<_AttendanceContent> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  int _filterIndex = 0;
  static const List<String> _filters = ['All', 'Present', 'Half day', 'Absent'];

  _AttendanceData get data => widget.data;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _statusFor(int index) => switch (index) {
        1 => 'present',
        2 => 'halfday',
        3 => 'absent',
        _ => 'all',
      };

  List<_AttendanceDay> get _visibleDays {
    final String status = _statusFor(_filterIndex);
    final String query = _query.trim().toLowerCase();
    return data.days.where((d) {
      final bool matchesFilter = status == 'all' || d.status == status;
      final bool matchesQuery = query.isEmpty || Fmt.date(d.date).toLowerCase().contains(query);
      return matchesFilter && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<_AttendanceDay> visibleDays = _visibleDays;

    return HeroScaffold(
      band: _Band(data: data),
      children: [
        Row(
          children: [
            Expanded(
              child: AccentCard(
                accent: AppColors.warning,
                child: Row(
                  children: [
                    const Icon(
                      Icons.hourglass_bottom_rounded,
                      size: 20,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: Insets.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data.halfDays}',
                            style: AppText.numeric.copyWith(fontSize: 18),
                          ),
                          Text(
                            'Half days',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.bodySmall.copyWith(fontSize: 10.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: AccentCard(
                accent: AppColors.cyan,
                child: Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 20,
                      color: AppColors.cyan,
                    ),
                    const SizedBox(width: Insets.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Fmt.duration(
                              Duration(minutes: data.averageShiftMinutes),
                            ),
                            style: AppText.numeric.copyWith(fontSize: 18),
                          ),
                          Text(
                            'Avg. shift',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.bodySmall.copyWith(fontSize: 10.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Gap.lg(),

        ModuleCard(
          title: 'Month at a glance',
          leading: const IconTile(
            icon: Icons.calendar_month_rounded,
            tone: AppColors.primary,
            size: 34,
            solid: true,
          ),
          child: _MonthGrid(days: data.days),
        ),
        const Gap.lg(),

        AppSearchField(
          hint: 'Search by date',
          controller: _searchController,
          onChanged: (v) => setState(() => _query = v),
        ),
        const Gap.md(),
        FilterChipBar(
          items: _filters,
          selectedIndex: _filterIndex,
          onChanged: (i) => setState(() => _filterIndex = i),
          padding: EdgeInsets.zero,
        ),
        const Gap.lg(),

        ModuleCard(
          title: 'Day by day',
          child: visibleDays.isEmpty
              ? const EmptyState(
                  compact: true,
                  title: 'No matching days',
                  icon: Icons.event_busy_rounded,
                )
              : Column(
                  children: [
                    for (final day in visibleDays) ...[
                      _DayRow(day: day, onTap: () => _showDayDetail(context, day)),
                      if (day != visibleDays.last) const Gap.md(),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  Future<void> _showDayDetail(BuildContext context, _AttendanceDay day) {
    final Color tone = switch (day.status) {
      'present' => AppColors.success,
      'halfday' => AppColors.warning,
      _ => AppColors.danger,
    };
    return AppSheet.show<void>(
      context,
      title: Fmt.date(day.date),
      subtitle: switch (day.status) {
        'present' => 'Marked present',
        'halfday' => 'Half day',
        _ => 'Marked absent',
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (day.status == 'absent')
            const Padding(
              padding: EdgeInsets.symmetric(vertical: Insets.lg),
              child: Text(
                'No shift was logged this day. Rent still accrues on weekly and monthly plans.',
                style: AppText.bodyMedium,
              ),
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Clock in',
                    value: day.inAt ?? '—',
                    icon: Icons.login_rounded,
                    accent: tone,
                    compact: true,
                  ),
                ),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: StatCard(
                    label: 'Clock out',
                    value: day.outAt ?? '—',
                    icon: Icons.logout_rounded,
                    accent: tone,
                    compact: true,
                  ),
                ),
              ],
            ),
            const Gap.lg(),
            KeyValueRow(
              label: 'Hours online',
              value: Fmt.duration(Duration(minutes: day.minutes)),
            ),
            KeyValueRow(label: 'Trips completed', value: '${day.trips}'),
          ],
          const Gap.lg(),
        ],
      ),
    );
  }
}

/// Month, headline present/absent counts and the streak, reversed out on ink.
class _Band extends StatelessWidget {
  const _Band({required this.data});

  final _AttendanceData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Builder(
              builder: (context) => InkCircleButton(
                icon: Icons.arrow_back_rounded,
                onTap: () => Navigator.of(context).maybePop(),
              ),
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Text(
                data.monthLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.titleLarge.copyWith(
                  fontSize: 17,
                  color: AppColors.onInk,
                ),
              ),
            ),
          ],
        ),
        const Gap.xl(),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Your attendance',
                style: AppText.displaySmall.copyWith(
                  fontSize: 25,
                  color: AppColors.onInk,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Insets.md,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.onInkMint.withValues(alpha: 0.16),
                borderRadius: Corners.pill,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.local_fire_department_rounded,
                    size: 14,
                    color: AppColors.onInkMint,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${data.streak}-day streak',
                    style: AppText.bodySmall.copyWith(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onInkMint,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${data.presentDays + data.absentDays} shifts logged this month',
          style: AppText.bodySmall.copyWith(color: AppColors.onInkSecondary),
        ),
        const Gap.xl(),

        Container(
          padding: const EdgeInsets.symmetric(
            vertical: Insets.md,
            horizontal: Insets.sm,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: Corners.brMd,
            border: Border.all(color: AppColors.inkStroke),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkStat(
                  label: 'Present',
                  value: '${data.presentDays}',
                  icon: Icons.how_to_reg_rounded,
                  valueColor: AppColors.mint,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: 'Absent',
                  value: '${data.absentDays}',
                  icon: Icons.person_off_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: 'Streak',
                  value: '${data.streak}d',
                  icon: Icons.local_fire_department_rounded,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The month grid. Each cell carries a day number and a status dot large
/// enough to read at a glance, with a legend that spells out what each colour
/// means rather than leaving it to be inferred.
class _MonthGrid extends StatelessWidget {
  const _MonthGrid({required this.days});

  final List<_AttendanceDay> days;

  Color _toneFor(_AttendanceDay? day) {
    if (day == null) return AppColors.stroke;
    return switch (day.status) {
      'present' => AppColors.success,
      'halfday' => AppColors.warning,
      _ => AppColors.danger,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) return const SizedBox.shrink();
    final DateTime first = days
        .map((d) => d.date)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    final int daysInMonth = DateTime(first.year, first.month + 1, 0).day;
    final int leadingBlank = DateTime(first.year, first.month, 1).weekday - 1;

    final Map<int, _AttendanceDay> byDay = {
      for (final d in days) d.date.day: d,
    };

    // A fixed 7-wide grid built from Rows of Expanded cells rather than a
    // Wrap of fixed-width boxes: it scales to any screen width by
    // construction, so the weekday header always lines up with the day
    // cells beneath it, even on the narrowest phones.
    final int totalCells = leadingBlank + daysInMonth;
    final int weekCount = (totalCells / 7).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (final label in const ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: AppText.overline.copyWith(
                      fontSize: 10.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: Insets.sm),
        for (var week = 0; week < weekCount; week++)
          Padding(
            padding: EdgeInsets.only(
              bottom: week == weekCount - 1 ? 0 : Insets.xs,
            ),
            child: Row(
              children: [
                for (var col = 0; col < 7; col++)
                  Builder(
                    builder: (context) {
                      final int cellIndex = week * 7 + col;
                      final int day = cellIndex - leadingBlank + 1;
                      final bool valid = day >= 1 && day <= daysInMonth;
                      final _AttendanceDay? entry = valid ? byDay[day] : null;
                      return Expanded(
                        child: SizedBox(
                          height: 34,
                          child: !valid
                              ? const SizedBox.shrink()
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$day',
                                      style: AppText.bodySmall.copyWith(
                                        fontSize: 11,
                                        fontWeight: entry != null
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: entry != null
                                            ? AppColors.textPrimary
                                            : AppColors.textMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: _toneFor(entry),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        const SizedBox(height: Insets.lg),
        const Divider(color: AppColors.stroke, height: 1),
        const SizedBox(height: Insets.md),
        Wrap(
          spacing: Insets.lg,
          runSpacing: Insets.sm,
          children: const [
            _Legend(color: AppColors.success, label: 'Present'),
            _Legend(color: AppColors.warning, label: 'Half day'),
            _Legend(color: AppColors.danger, label: 'Absent'),
            _Legend(color: AppColors.stroke, label: 'Upcoming'),
          ],
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppText.bodySmall.copyWith(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({required this.day, required this.onTap});

  final _AttendanceDay day;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (Color tone, String label, IconData icon, StatusTone statusTone) = switch (day.status) {
      'present' => (
        AppColors.success,
        'Present',
        Icons.how_to_reg_rounded,
        StatusTone.success,
      ),
      'halfday' => (
        AppColors.warning,
        'Half day',
        Icons.hourglass_bottom_rounded,
        StatusTone.warning,
      ),
      _ => (AppColors.danger, 'Absent', Icons.person_off_rounded, StatusTone.danger),
    };

    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Container(
        padding: const EdgeInsets.all(Insets.md + 2),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: Corners.brLg,
        ),
        child: Row(
          children: [
            IconTile(icon: icon, tone: tone, size: 38),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Fmt.date(day.date),
                    style: AppText.titleSmall.copyWith(fontSize: 13.5),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    day.status == 'absent'
                        ? 'No shift logged'
                        : '${day.inAt} – ${day.outAt} · ${day.trips} trips · ${Fmt.duration(Duration(minutes: day.minutes))}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall.copyWith(fontSize: 11.5),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Insets.sm),
            StatusChip(label: label, tone: statusTone, dense: true),
            const SizedBox(width: Insets.xs),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceSkeleton extends StatelessWidget {
  const _AttendanceSkeleton();

  @override
  Widget build(BuildContext context) {
    return PageBody(
      children: [
        const ShimmerBox(height: 150, borderRadius: Corners.brLg),
        const Gap.xxl(),
        Row(
          children: List.generate(
            2,
            (i) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i == 1 ? 0 : Insets.md),
                child: const ShimmerBox(height: 64, borderRadius: Corners.brLg),
              ),
            ),
          ),
        ),
        const Gap.xxl(),
        const ShimmerBox(height: 260, borderRadius: Corners.brLg),
        const Gap.xxl(),
        const ShimmerBox(height: 70, borderRadius: Corners.brLg),
        const Gap.md(),
        const ShimmerBox(height: 70, borderRadius: Corners.brLg),
      ],
    );
  }
}
