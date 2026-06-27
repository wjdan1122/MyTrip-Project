import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets('shows the travel planner form', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('تخطيط رحلتك الذكية'), findsOneWidget);
    expect(find.text('إنشاء الخطة'), findsOneWidget);
  });
}
