import 'package:flutter_test/flutter_test.dart';
import 'package:card_pulse_loader/main.dart';

void main() {
  testWidgets('SportsCardLoaderApp renders live match card correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SportsCardLoaderApp());

    // Verify key sports match elements exist
    expect(find.text('Arsenal'), findsOneWidget);
    expect(find.text('Real Madrid'), findsOneWidget);
    expect(find.text('UEFA CHAMPIONS LEAGUE'), findsOneWidget);
    expect(find.text('Simulate Live API Poll (2.4s)'), findsOneWidget);
  });
}
