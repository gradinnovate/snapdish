import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:snapdish/views/ingredients_identification_view.dart';
import 'package:snapdish/models/ingredient.dart';

// A basic GoRouter setup for testing.
// This router won't actually navigate, but it will prevent errors when
// `context.push` or other GoRouter methods are called.
final GoRouter _testRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => IngredientsIdentificationView(),
      routes: [
        GoRoute(
          path: 'recipe-style-time-selection', // The route IngredientsIdentificationView navigates to
          builder: (context, state) => const Scaffold(body: Text("Mock Recipe Style Page")),
        ),
      ]
    ),
  ],
);

Widget createIngredientsIdentificationViewTestWidget() {
  return MaterialApp.router(
    routerConfig: _testRouter,
  );
}

void main() {
  group('IngredientsIdentificationView Tests', () {
    testWidgets('Test Initial State', (WidgetTester tester) async {
      await tester.pumpWidget(createIngredientsIdentificationViewTestWidget());

      expect(find.text('Identify Ingredients'), findsOneWidget); // AppBar title
      expect(find.widgetWithIcon(ElevatedButton, Icons.camera_alt), findsOneWidget);
      expect(find.text('Capture/Upload Image'), findsOneWidget);
      expect(find.text('Please capture or upload an image to identify ingredients.'), findsOneWidget);
      // Continue button should be present but disabled
      final continueButton = find.widgetWithText(ElevatedButton, 'Continue');
      expect(continueButton, findsOneWidget);
      expect(tester.widget<ElevatedButton>(continueButton).enabled, isFalse);
    });

    testWidgets('Test Loading State and Content Display', (WidgetTester tester) async {
      await tester.pumpWidget(createIngredientsIdentificationViewTestWidget());

      // Tap the "Capture/Upload Image" button
      await tester.tap(find.widgetWithIcon(ElevatedButton, Icons.camera_alt));
      await tester.pump(); // Start loading

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 3)); // Wait for simulated API call

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Please capture or upload an image to identify ingredients.'), findsNothing);
      
      // Verify mock ingredients are displayed
      expect(find.byType(Chip), findsNWidgets(4)); // Based on the mock data in the view
      expect(find.widgetWithText(Chip, 'Tomatoes'), findsOneWidget);
      expect(find.widgetWithText(Chip, 'Cheese'), findsOneWidget);
      expect(find.widgetWithText(Chip, 'Basil'), findsOneWidget);
      expect(find.widgetWithText(Chip, 'Mushrooms'), findsOneWidget);

      // Continue button should now be enabled
      final continueButton = find.widgetWithText(ElevatedButton, 'Continue');
      expect(tester.widget<ElevatedButton>(continueButton).enabled, isTrue);
    });

    testWidgets('Test Add Ingredient', (WidgetTester tester) async {
      await tester.pumpWidget(createIngredientsIdentificationViewTestWidget());

      // First, load initial ingredients
      await tester.tap(find.widgetWithIcon(ElevatedButton, Icons.camera_alt));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Tap the "Add Ingredient" button
      expect(find.widgetWithIcon(ElevatedButton, Icons.add), findsOneWidget);
      await tester.tap(find.widgetWithIcon(ElevatedButton, Icons.add));
      await tester.pumpAndSettle(); // For dialog to appear

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Add Ingredient'), findsOneWidget);

      // Enter text into the TextField
      await tester.enterText(find.byType(TextField), 'Pepper');
      await tester.pumpAndSettle();

      // Tap the "Add" button in the dialog
      await tester.tap(find.widgetWithText(TextButton, 'Add'));
      await tester.pumpAndSettle(); // For dialog to disappear and UI to update

      expect(find.byType(AlertDialog), findsNothing);
      expect(find.widgetWithText(Chip, 'Pepper'), findsOneWidget);
      expect(find.byType(Chip), findsNWidgets(5)); // 4 initial + 1 new
    });

    testWidgets('Test Remove Ingredient', (WidgetTester tester) async {
      await tester.pumpWidget(createIngredientsIdentificationViewTestWidget());

      // Load initial ingredients
      await tester.tap(find.widgetWithIcon(ElevatedButton, Icons.camera_alt));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.widgetWithText(Chip, 'Tomatoes'), findsOneWidget);
      
      // Find the delete icon for the "Tomatoes" chip
      final chip = find.widgetWithText(Chip, 'Tomatoes');
      final deleteIcon = find.descendant(of: chip, matching: find.byIcon(Icons.cancel));
      expect(deleteIcon, findsOneWidget);

      // Tap the delete icon
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle(); // UI to update

      expect(find.widgetWithText(Chip, 'Tomatoes'), findsNothing);
      expect(find.byType(Chip), findsNWidgets(3)); // 4 initial - 1 removed

      // Remove all and check continue button
      await tester.tap(find.descendant(of: find.widgetWithText(Chip, 'Cheese'), matching: find.byIcon(Icons.cancel)));
      await tester.pumpAndSettle();
      await tester.tap(find.descendant(of: find.widgetWithText(Chip, 'Basil'), matching: find.byIcon(Icons.cancel)));
      await tester.pumpAndSettle();
      await tester.tap(find.descendant(of: find.widgetWithText(Chip, 'Mushrooms'), matching: find.byIcon(Icons.cancel)));
      await tester.pumpAndSettle();

      expect(find.byType(Chip), findsNothing);
      final continueButton = find.widgetWithText(ElevatedButton, 'Continue');
      expect(tester.widget<ElevatedButton>(continueButton).enabled, isFalse);
       expect(find.text('Please capture or upload an image to identify ingredients.'), findsOneWidget);
    });
  });
}
