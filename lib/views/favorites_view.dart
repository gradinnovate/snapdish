import 'package:flutter/material.dart';
import 'package:snapdish/widgets/recent_recipes.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的收藏'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: RecentRecipes(), // Reusing the same widget for now
      ),
    );
  }
} 