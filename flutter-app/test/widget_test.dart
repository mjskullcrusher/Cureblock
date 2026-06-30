import 'package:cureblock/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Splash screen shows CureBlock', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CureBlockApp()));
    await tester.pump();

    expect(find.text('CureBlock'), findsOneWidget);
    expect(find.text('A shield that never sleeps'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();

    expect(find.text('Sign In'), findsOneWidget);
  });
}
