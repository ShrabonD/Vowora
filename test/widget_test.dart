import 'package:flutter_test/flutter_test.dart';
import 'package:vowora/main.dart';

void main() {
  testWidgets('VoworaApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VoworaApp());
    await tester.pump(const Duration(seconds: 3));
    expect(find.byType(VoworaApp), findsOneWidget);
  });
}
