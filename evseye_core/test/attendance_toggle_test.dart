import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('tapping the pill flips attendance', (tester) async {
    bool present = false;
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: Center(
          child: StatefulBuilder(
            builder: (context, setState) => AttendanceToggle(
              present: present,
              onChanged: (v) => setState(() => present = v),
            ),
          ),
        ),
      ),
    ));

    expect(find.text('Absent'), findsOneWidget);
    await tester.tap(find.byType(AttendanceToggle));
    await tester.pumpAndSettle();
    expect(present, isTrue);
    expect(find.text('Present'), findsOneWidget);
  });
}
