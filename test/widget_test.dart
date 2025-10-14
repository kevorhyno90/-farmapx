import 'package:flutter_test/flutter_test.dart';
import 'package:farmapx/main.dart';

void main() {
  testWidgets('Farm management app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FarmApxApp());

    // Verify that the app title is present.
    expect(find.text('FarmApx - Farm Management'), findsOneWidget);
    
    // Verify that the dashboard title is present.
    expect(find.text('Farm Dashboard'), findsOneWidget);
    
    // Verify dashboard cards are present
    expect(find.text('Total Crops'), findsOneWidget);
    expect(find.text('Livestock'), findsOneWidget);
  });

  testWidgets('Navigation drawer works', (WidgetTester tester) async {
    await tester.pumpWidget(const FarmApxApp());

    // Open the drawer
    await tester.tap(find.byType(Builder).first);
    await tester.pumpAndSettle();

    // Verify drawer items are present
    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Crops'), findsOneWidget);
    expect(find.text('Livestock'), findsOneWidget);
    expect(find.text('Inventory'), findsOneWidget);
    
    // Navigate to Crops page
    await tester.tap(find.text('Crops'));
    await tester.pumpAndSettle();
    
    // Verify Crops page is displayed
    expect(find.text('Crops Management'), findsOneWidget);
  });
}
