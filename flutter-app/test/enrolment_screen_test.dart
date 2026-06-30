import 'package:cureblock/screens/operator/enrolment_stepper_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Enrolment stepper builds on narrow screen without overflow', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: EnrolmentStepperScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('New Enrolment'), findsOneWidget);
    expect(find.text('Step 1 of 5'), findsOneWidget);
    expect(find.text('Demographics'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
