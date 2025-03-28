// This is a basic Flutter widget test for Last Light Randomizer app.
//
// Tests verify that the application renders correctly and contains expected elements.

import 'package:flutter_test/flutter_test.dart';

import 'package:lastlightrandomizer/main.dart';

void main() {
  testWidgets('Last Light Randomizer app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    // Using the correct LastLightRandomizerApp class instead of non-existent MyApp
    await tester.pumpWidget(const LastLightRandomizerApp());

    // Verify that the app title is displayed in the AppBar
    expect(find.text('Last Light Randomizer'), findsOneWidget);

    // Verify that the player selection screen is shown as the initial screen
    expect(find.text('Select Number of Players'), findsOneWidget);
    
    // Verify that player count buttons are shown (looking for at least one button with '4')
    expect(find.text('4'), findsOneWidget);
    
    // Verify that the Generate button is present
    expect(find.text('Generate'), findsOneWidget);
  });
}
