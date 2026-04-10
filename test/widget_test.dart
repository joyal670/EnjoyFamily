import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EnjoyFamilyApp());
    expect(find.byType(EnjoyFamilyApp), findsOneWidget);
  });
}
