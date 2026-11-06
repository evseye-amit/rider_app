import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('OTP input renders and completes a six-digit code', (tester) async {
    String? completed;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: OtpInput(onCompleted: (code) => completed = code),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.enterText(find.byType(EditableText), '123456');
    await tester.pump();
    expect(completed, '123456');
    expect(tester.takeException(), isNull);
  });
}
