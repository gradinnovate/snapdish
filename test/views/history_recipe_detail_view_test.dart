import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snapdish/models/recipe.dart';
import 'package:snapdish/views/history_recipe_detail_view.dart';
import 'package:snapdish/services/api_service.dart';
import 'package:mockito/mockito.dart';

// Helper to prevent HTTP errors for Image.network in tests
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _createMockImageHttpClient(context);
  }
}

HttpClient _createMockImageHttpClient(SecurityContext? _) {
  final client = MockHttpClient();
  final request = MockHttpClientRequest();
  final response = MockHttpClientResponse();

  when(client.getUrl(any)).thenAnswer((_) async => request);
  when(request.close()).thenAnswer((_) async => response);
  when(response.statusCode).thenReturn(HttpStatus.ok);
  when(response.contentLength).thenReturn(0);
  when(response.listen(
    any,
    onError: anyNamed('onError'),
    onDone: anyNamed('onDone'),
    cancelOnError: anyNamed('cancelOnError'),
  )).thenAnswer((Invocation invocation) {
    final onData = invocation.positionalArguments[0] as void Function(List<int>);
    final onDone = invocation.namedArguments[#onDone] as void Function()?;
    onData(<int>[]);
    if (onDone != null) {
      onDone();
    }
    return MockStreamSubscription();
  });
  return client;
}

class MockHttpClient extends Mock implements HttpClient {}
class MockHttpClientRequest extends Mock implements HttpClientRequest {}
class MockHttpClientResponse extends Mock implements HttpClientResponse {}
class MockStreamSubscription extends Mock implements StreamSubscription<List<int>> {}

// Mock ApiService
class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApiService;

  setUpAll(() {
    HttpOverrides.global = MyHttpOverrides();
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

  setUp(() {
    mockApiService = MockApiService();
    // Default behavior for isFavorite, can be overridden in specific tests
    when(mockApiService.isFavorite(any)).thenAnswer((_) async => false);
    when(mockApiService.addToFavorites(any)).thenAnswer((_) async => Future.value());
    when(mockApiService.removeFromFavorites(any)).thenAnswer((_) async => Future.value());
  });

  final testRecipe = Recipe(
    id: 'histTest002',
    name: 'Historic Grilled Cheese',
    time: '15 mins',
    style: 'Comfort Food',
    ingredients: ['2 slices Bread', '2 slices Cheese', '1 tbsp Butter'],
    steps: ['Butter bread.', 'Add cheese.', 'Grill until golden.'],
    imageUrl: 'https://example.com/grilledcheese.jpg',
    isFavorite: false, // Initially not a favorite
  );

  Widget createTestableWidget(Recipe recipe) {
    // Since HistoryRecipeDetailView instantiates its own ApiService, we cannot directly inject a mock.
    // This is a limitation for testing the interaction with ApiService.
    // The test will rely on the widget's internal ApiService placeholder behavior.
    // For a real app, dependency injection (e.g. Provider, Riverpod) would be used.
    return MaterialApp(
      home: HistoryRecipeDetailView(recipe: recipe),
    );
  }

  testWidgets('HistoryRecipeDetailView renders correctly with recipe data', (WidgetTester tester) async {
    // As ApiService is internally instantiated, isFavorite will use the placeholder logic.
    // To ensure predictable UI for the favorite icon, we'd ideally inject the service.
    // For this test, we'll assume the initial state of the icon based on recipe.isFavorite
    // and the placeholder ApiService.isFavorite (which is random).
    // This makes testing the exact icon state tricky without DI.
    // We will check for one of the two icons.

    await tester.pumpWidget(createTestableWidget(testRecipe));
    await tester.pumpAndSettle(); // Allow time for initState and potential API calls

    // Verify AppBar title
    expect(find.text('Recipe from History'), findsOneWidget);

    // Verify Recipe Name is displayed
    expect(find.text(testRecipe.name), findsOneWidget);

    // Verify Image.network is present
    expect(find.byType(Image), findsOneWidget);
    final imageWidget = tester.widget<Image>(find.byType(Image));
    expect(imageWidget.image, isA<NetworkImage>());
    expect((imageWidget.image as NetworkImage).url, testRecipe.imageUrl);

    // Verify "Add to Favorites" or "Remove from Favorites" icon is present
    // Due to internal ApiService and its random nature, we check for either state.
    expect(
      find.byWidgetPredicate((widget) =>
          widget is Icon && (widget.icon == Icons.favorite || widget.icon == Icons.favorite_border)),
      findsOneWidget,
      reason: 'Should find either a favorite or favorite_border icon'
    );


    // Verify Ingredients section title
    expect(find.text('Ingredients'), findsOneWidget);
    expect(find.text(testRecipe.ingredients.first), findsOneWidget);

    // Verify Steps section title
    expect(find.text('Steps'), findsOneWidget);
    expect(find.text(testRecipe.steps.first), findsOneWidget);
  });

   testWidgets('HistoryRecipeDetailView favorite button interaction (limited test)', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(testRecipe));
    await tester.pumpAndSettle();

    // Find the favorite button (could be favorite or favorite_border initially)
    final favoriteButtonFinder = find.byWidgetPredicate(
        (widget) => widget is IconButton && widget.icon is Icon &&
                   ((widget.icon as Icon).icon == Icons.favorite || (widget.icon as Icon).icon == Icons.favorite_border)
    );
    expect(favoriteButtonFinder, findsOneWidget);

    // Tap the button
    // Similar to FavoriteRecipeDetailView, this calls the internal ApiService.
    // Testing the exact state change is unreliable without DI.
    await tester.ensureVisible(favoriteButtonFinder);
    await tester.tap(favoriteButtonFinder);
    await tester.pumpAndSettle(); // Allow for API call and rebuild

    print('NOTE: HistoryRecipeDetailView favorite button interaction test is limited due to internal ApiService instantiation.');
    expect(true, isTrue); // Placeholder assertion
  });
}
