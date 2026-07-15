import 'package:flutter_test/flutter_test.dart';
import 'package:tapontask/main.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const TapOnTaskApp(firebaseReady: false));
    await tester.pump();
    expect(find.byType(TapOnTaskApp), findsOneWidget);
  });
}
