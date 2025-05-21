import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snapdish/views/finished_dish_view.dart';

// Helper to prevent HTTP errors for Image.network in tests
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return createMockImageHttpClient(context);
  }
}

HttpClient createMockImageHttpClient(SecurityContext? _) {
  // This is a simplified mock. For more complex scenarios, a library like mocktail or mockito would be used.
  // For this test, we just need to prevent Image.network from throwing HTTP errors.
  // It won't actually load an image, but the widget will be on the tree.
  return MockHttpClient();
}

class MockHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return MockHttpClientRequest();
  }
  // Other methods are not called in this Image.network scenario, so they are omitted for brevity.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockHttpClientRequest implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() async {
    return MockHttpClientResponse();
  }
  // Other methods are not called in this Image.network scenario, so they are omitted for brevity.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockHttpClientResponse implements HttpClientResponse {
  @override
  int get statusCode => HttpStatus.ok;

  @override
  Future<T> Folgen<T>(Future<T> Function(Stream<List<int>> stream) action, {T Function()? onError, bool? onDone}) {
    return action(Stream.fromIterable([])); // Empty stream
  }
  // Other methods are not called in this Image.network scenario, so they are omitted for brevity.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}


void main() {
  // Use HttpOverrides to mock HttpClient for Image.network
  setUpAll(() => HttpOverrides.global = MyHttpOverrides());
  tearDownAll(() => HttpOverrides.global = null);

  testWidgets('FinishedDishView renders correctly and shows image and buttons', (WidgetTester tester) async {
    const String testImageUrl = 'https://example.com/test_image.png';

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: FinishedDishView(imageUrl: testImageUrl),
      ),
    );

    // Verify AppBar title
    expect(find.text('View Dish'), findsOneWidget);

    // Verify Image.network is present
    // We find it by type. We can also check its properties if needed.
    final imageWidget = tester.widget<Image>(find.byType(Image));
    expect(imageWidget.image, isA<NetworkImage>());
    expect((imageWidget.image as NetworkImage).url, testImageUrl);
    expect(imageWidget.fit, BoxFit.cover);

    // Verify the "Return to Recipe" button is present
    expect(find.widgetWithText(ElevatedButton, 'Return to Recipe'), findsOneWidget);
    expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);


    // Verify the "Save/Share Image" button is present
    expect(find.widgetWithText(ElevatedButton, 'Save/Share Image'), findsOneWidget);
    expect(find.byIcon(Icons.share), findsOneWidget);

  });

  testWidgets('FinishedDishView Return to Recipe button pops navigation', (WidgetTester tester) async {
    const String testImageUrl = 'https://example.com/test_image.png';
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold( // Dummy home page
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FinishedDishView(imageUrl: testImageUrl),
                ),
              ),
              child: const Text('Go to FinishedDishView'),
            ),
          ),
        ),
      ),
    );

    // Navigate to FinishedDishView
    await tester.tap(find.text('Go to FinishedDishView'));
    await tester.pumpAndSettle(); // Wait for navigation and animations

    // Verify FinishedDishView is shown
    expect(find.text('View Dish'), findsOneWidget);

    // Tap the "Return to Recipe" button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Return to Recipe'));
    await tester.pumpAndSettle(); // Wait for navigation and animations

    // Verify FinishedDishView is no longer shown (popped)
    expect(find.text('View Dish'), findsNothing);
    // Verify we are back on the dummy home page
    expect(find.text('Go to FinishedDishView'), findsOneWidget);
  });
}
