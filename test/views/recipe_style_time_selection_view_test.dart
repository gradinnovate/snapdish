import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:snapdish/views/recipe_style_time_selection_view.dart';

// Basic GoRouter for testing purposes
final GoRouter _testRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => RecipeStyleTimeSelectionView(),
      routes: [
        GoRoute(
          path: 'final-dish-image', // Route RecipeStyleTimeSelectionView navigates to
          builder: (context, state) => const Scaffold(body: Text("Mock Final Dish Page")),
        ),
      ]
    ),
  ],
);

Widget createRecipeStyleTimeSelectionViewTestWidget() {
  return MaterialApp.router(
    routerConfig: _testRouter,
  );
}

void main() {
  group('RecipeStyleTimeSelectionView Tests', () {
    testWidgets('Test Initial State and Button Disabled', (WidgetTester tester) async {
      await tester.pumpWidget(createRecipeStyleTimeSelectionViewTestWidget());

      expect(find.text('Select Style & Time'), findsOneWidget); // AppBar title

      // Check for some style options
      expect(find.widgetWithText(ChoiceChip, '中式'), findsOneWidget);
      expect(find.widgetWithText(ChoiceChip, '日式'), findsOneWidget);
      expect(find.widgetWithText(ChoiceChip, '西式'), findsOneWidget);
      expect(find.widgetWithText(ChoiceChip, '韓式'), findsOneWidget);
      expect(find.widgetWithText(ChoiceChip, '新奇'), findsOneWidget);

      // Check for time options
      expect(find.widgetWithText(ElevatedButton, '10 分鐘'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, '20 分鐘'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, '30 分鐘'), findsOneWidget);

      // Check "Generate Recipe" button
      final generateButton = find.widgetWithText(ElevatedButton, 'Generate Recipe');
      expect(generateButton, findsOneWidget);
      expect(tester.widget<ElevatedButton>(generateButton).enabled, isFalse);
    });

    testWidgets('Test Style Selection', (WidgetTester tester) async {
      await tester.pumpWidget(createRecipeStyleTimeSelectionViewTestWidget());

      final styleChip = find.widgetWithText(ChoiceChip, '中式');
      expect(tester.widget<ChoiceChip>(styleChip).selected, isFalse);

      await tester.tap(styleChip);
      await tester.pumpAndSettle();

      expect(tester.widget<ChoiceChip>(styleChip).selected, isTrue);

      // Generate button should still be disabled as time is not selected
      final generateButton = find.widgetWithText(ElevatedButton, 'Generate Recipe');
      expect(tester.widget<ElevatedButton>(generateButton).enabled, isFalse);
    });

    testWidgets('Test Time Selection', (WidgetTester tester) async {
      await tester.pumpWidget(createRecipeStyleTimeSelectionViewTestWidget());

      final timeButton = find.widgetWithText(ElevatedButton, '20 分鐘');
      // We can check the style to infer selection, or later check the Generate button state
      // For now, just tap it. The visual change is handled by the widget's state.

      await tester.tap(timeButton);
      await tester.pumpAndSettle();
      
      // We expect the button's appearance to change, which indicates selection.
      // A more robust check would be to inspect properties if they directly reflect selection,
      // or by observing the side effect (Generate Recipe button enabling).

      // Generate button should still be disabled as style is not selected
      final generateButton = find.widgetWithText(ElevatedButton, 'Generate Recipe');
      expect(tester.widget<ElevatedButton>(generateButton).enabled, isFalse);
    });

    testWidgets('Test Generate Recipe Button Enablement and Tap', (WidgetTester tester) async {
      await tester.pumpWidget(createRecipeStyleTimeSelectionViewTestWidget());

      // Select a style
      await tester.tap(find.widgetWithText(ChoiceChip, '西式'));
      await tester.pumpAndSettle();

      // Select a time
      await tester.tap(find.widgetWithText(ElevatedButton, '30 分鐘'));
      await tester.pumpAndSettle();

      // Generate button should now be enabled
      final generateButton = find.widgetWithText(ElevatedButton, 'Generate Recipe');
      expect(tester.widget<ElevatedButton>(generateButton).enabled, isTrue);

      // Optional: Tap the button and ensure no crash (navigation is mocked)
      await tester.tap(generateButton);
      await tester.pumpAndSettle(); // Allow navigation to process
      // We expect to be on the "Mock Final Dish Page" if navigation worked as per mockRouter
      // This isn't strictly testing the view itself but that the GoRouter setup is okay.
      expect(find.text("Mock Final Dish Page"), findsOneWidget);
    });

     testWidgets('Test Selecting a different style changes selection', (WidgetTester tester) async {
      await tester.pumpWidget(createRecipeStyleTimeSelectionViewTestWidget());

      final chipChinese = find.widgetWithText(ChoiceChip, '中式');
      final chipJapanese = find.widgetWithText(ChoiceChip, '日式');

      // Select Chinese style
      await tester.tap(chipChinese);
      await tester.pumpAndSettle();
      expect(tester.widget<ChoiceChip>(chipChinese).selected, isTrue);
      expect(tester.widget<ChoiceChip>(chipJapanese).selected, isFalse);

      // Select Japanese style
      await tester.tap(chipJapanese);
      await tester.pumpAndSettle();
      expect(tester.widget<ChoiceChip>(chipChinese).selected, isFalse);
      expect(tester.widget<ChoiceChip>(chipJapanese).selected, isTrue);
    });

    testWidgets('Test Selecting a different time changes selection', (WidgetTester tester) async {
      await tester.pumpWidget(createRecipeStyleTimeSelectionViewTestWidget());

      final button10Min = find.widgetWithText(ElevatedButton, '10 分鐘');
      final button20Min = find.widgetWithText(ElevatedButton, '20 分鐘');

      // Select 10 minutes
      await tester.tap(button10Min);
      await tester.pumpAndSettle();
      // Verify selection by checking properties that change in the UI, e.g. background color
      // This is a simplified check. The actual color check can be more complex.
      // For this test, the enabling of "Generate Recipe" when both are selected is an indirect check.
      // Here, we rely on the visual feedback of the ElevatedButton's style for selection.

      // Select 20 minutes
      await tester.tap(button20Min);
      await tester.pumpAndSettle();
      
      // Select a style to enable the generate button and verify
      await tester.tap(find.widgetWithText(ChoiceChip, '中式'));
      await tester.pumpAndSettle();

      final generateButton = find.widgetWithText(ElevatedButton, 'Generate Recipe');
      expect(tester.widget<ElevatedButton>(generateButton).enabled, isTrue);
      // Tapping generate will now use the 20 min selection implicitly.
    });
  });
}
