import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:snapdish/views/final_dish_image_view.dart';
import 'package:network_image_mock/network_image_mock.dart'; // For mocking Image.network

// Basic GoRouter for testing purposes
final GoRouter _testRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => FinalDishImageView(), // Assuming it might take recipeId as param in real app
      routes: [
        GoRoute(
          path: 'recipe/:id', // Route FinalDishImageView navigates to
          builder: (context, state) => Scaffold(body: Text("Mock Recipe Detail Page: ${state.pathParameters['id']}")),
        ),
      ]
    ),
  ],
);

Widget createFinalDishImageViewTestWidget() {
  // We use mockNetworkImagesFor to ensure that Image.network calls in tests don't hit the actual network.
  // The FinalDishImageView uses a picsum.photos URL which is a real network call.
  return mockNetworkImagesFor(() => MaterialApp.router(
    routerConfig: _testRouter,
  ));
}


void main() {
  group('FinalDishImageView Tests', () {
    testWidgets('Test Initial Loading State and then Successful Image Display', (WidgetTester tester) async {
      await tester.pumpWidget(createFinalDishImageViewTestWidget());

      // Initially, it should be loading due to _fetchDishImage in initState
      expect(find.byType(CircularProgressIndicator), findsOneWidget, reason: "Should show CircularProgressIndicator while loading");
      
      // Verify action buttons are present but should be disabled during loading
      final viewDetailsButton = find.widgetWithText(ElevatedButton, "View Recipe Details");
      expect(viewDetailsButton, findsOneWidget);
      expect(tester.widget<ElevatedButton>(viewDetailsButton).enabled, isFalse, reason: "View Details button should be disabled during load");
      
      final favoriteButton = find.widgetWithIcon(IconButton, Icons.favorite_border);
      expect(tester.widget<IconButton>(favoriteButton).onPressed, isNull, reason: "Favorite button should be disabled during load");
      
      final shareButton = find.widgetWithIcon(IconButton, Icons.share);
      expect(tester.widget<IconButton>(shareButton).onPressed, isNull, reason: "Share button should be disabled during load");


      // Wait for the simulated API call in _fetchDishImage (1 second) 
      // and for the image to "load" (mocked by network_image_mock)
      await tester.pumpAndSettle(const Duration(seconds: 2)); 

      // After loading, the CircularProgressIndicator should be gone
      expect(find.byType(CircularProgressIndicator), findsNothing);
      
      // An Image widget should be displayed
      // The underlying Image.network is mocked by network_image_mock, so it "loads" instantly.
      expect(find.byType(Image), findsOneWidget);

      // Action buttons should now be enabled
      expect(tester.widget<ElevatedButton>(viewDetailsButton).enabled, isTrue, reason: "View Details button should be enabled after load");
      expect(tester.widget<IconButton>(favoriteButton).onPressed, isNotNull, reason: "Favorite button should be enabled after load");
      expect(tester.widget<IconButton>(shareButton).onPressed, isNotNull, reason: "Share button should be enabled after load");
    });

    testWidgets('Test Action Buttons Presence and Tap (View Details)', (WidgetTester tester) async {
      await tester.pumpWidget(createFinalDishImageViewTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2)); // Wait for load

      // Verify buttons are present
      expect(find.widgetWithText(ElevatedButton, "View Recipe Details"), findsOneWidget);
      expect(find.widgetWithIcon(IconButton, Icons.favorite_border), findsOneWidget);
      expect(find.text("Favorite"), findsOneWidget); // Text label for icon button
      expect(find.widgetWithIcon(IconButton, Icons.share), findsOneWidget);
      expect(find.text("Share"), findsOneWidget); // Text label for icon button

      // Tap "View Recipe Details" button
      await tester.tap(find.widgetWithText(ElevatedButton, "View Recipe Details"));
      await tester.pumpAndSettle(); // Allow navigation to process

      // Check if it navigated to the mock recipe detail page
      expect(find.text("Mock Recipe Detail Page: mock-recipe-id"), findsOneWidget);
    });

    testWidgets('Test Favorite and Share buttons show SnackBar (mock actions)', (WidgetTester tester) async {
      await tester.pumpWidget(createFinalDishImageViewTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2)); // Wait for load

      // Tap Favorite button
      await tester.tap(find.widgetWithIcon(IconButton, Icons.favorite_border));
      await tester.pumpAndSettle(); // For SnackBar
      expect(find.text("Action: Save to Favorites (Not Implemented Yet)"), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 4)); // Dismiss SnackBar

      // Tap Share button
      await tester.tap(find.widgetWithIcon(IconButton, Icons.share));
      await tester.pumpAndSettle(); // For SnackBar
      expect(find.text("Action: Share (Not Implemented Yet)"), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 4)); // Dismiss SnackBar
    });

    // Test for the view's own _error state (if _fetchDishImage itself fails)
    // This test is a bit more conceptual as directly causing _fetchDishImage to throw
    // without DI or specific test hooks in the widget is hard.
    // However, if _dishImage remains null and _error is set, the UI should reflect that.
    // The current _fetchDishImage in FinalDishImageView catches errors and sets _error.
    // For this example, we assume a scenario where _fetchDishImage sets _error.
    // The `network_image_mock` handles Image.network errors, not the view's general error state.
    // To truly test the view's _error state path, one would typically inject a service that can be
    // mocked to throw an error during the fetch operation.
    // Given the current structure, I'll simulate the state where _error is set,
    // if _fetchDishImage had an internal error BEFORE trying to load the Image.network URL.
    // The current _fetchDishImage in the view *does* have a try/catch that sets _error.
    // If, for example, `DishImage(...)` constructor threw an error, or `Future.delayed` somehow failed.
    // This test is more about the UI path than triggering the actual error.
    
    // For now, the provided tests cover loading, success, and basic interactions.
    // A dedicated test for the `_error != null` path in `_buildImageContent` would require
    // more advanced test setup (like dependency injection for the fetching logic)
    // or modifying the widget to allow error state simulation, which is beyond "basic widget tests".
    // The `Image.network`'s own `errorBuilder` is covered by `network_image_mock` if an image fails to load.
    // The view's `_error` state (red error icon and message) is for when the `_fetchDishImage` Future itself fails.
  });
}
