import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapdish/views/home_view.dart';
import 'package:snapdish/views/camera_view.dart';
import 'package:snapdish/views/ingredient_result_view.dart';
import 'package:snapdish/views/recipe_style_view.dart';
import 'package:snapdish/views/recipe_detail_view.dart';
import 'package:snapdish/views/favorites_view.dart';
import 'package:snapdish/views/history_view.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithBottomNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeView(),
          routes: [
            GoRoute(
              path: 'camera',
              builder: (context, state) => const CameraView(),
            ),
            GoRoute(
              path: 'ingredient-result',
              builder: (context, state) => const IngredientResultView(),
            ),
            GoRoute(
              path: 'recipe-style',
              builder: (context, state) => const RecipeStyleView(),
            ),
            GoRoute(
              path: 'recipe/:id',
              builder: (context, state) => RecipeDetailView(
                recipeId: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) => const FavoritesView(),
        ),
        GoRoute(
          path: '/history',
          builder: (context, state) => const HistoryView(),
        ),
      ],
    ),
  ],
);

class ScaffoldWithBottomNavBar extends StatelessWidget {
  const ScaffoldWithBottomNavBar({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首頁',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '收藏',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '記錄',
          ),
        ],
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/favorites')) {
      return 1;
    }
    if (location.startsWith('/history')) {
      return 2;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/');
        break;
      case 1:
        GoRouter.of(context).go('/favorites');
        break;
      case 2:
        GoRouter.of(context).go('/history');
        break;
    }
  }
} 