import 'package:flutter_test/flutter_test.dart';
import 'package:gym_hci/main.dart'; // Import your main.dart file

void main() {
  testWidgets('GymBud app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(GymBudApp()); // Run the GymBudApp

    expect(find.text('Welcome to GymBud'), findsOneWidget); // Check if welcome text exists
  });
}
