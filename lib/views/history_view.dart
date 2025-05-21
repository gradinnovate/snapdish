import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapdish/models/recipe.dart'; // Import Recipe from models

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  // Mock list of history recipes
  static final List<Recipe> _historyRecipes = [
    // Ensure Recipe.mockRecipe is available and copyWith works from the new model.
    Recipe.mockRecipe.copyWith(id: 'hist001', name: 'Viewed Lemon Herb Chicken', imageUrl: 'https://images.unsplash.com/photo-1543353071-873f17a7a088?q=80&w=870&auto=format&fit=crop'),
    Recipe.mockRecipe.copyWith(id: 'hist002', name: 'Viewed Classic Burger', imageUrl: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?q=80&w=872&auto=format&fit=crop'),
    Recipe.mockRecipe.copyWith(id: 'hist003', name: 'Viewed Vegetable Soup', imageUrl: 'https://images.unsplash.com/photo-1476718406336-bb5a9690ee7a?q=80&w=687&auto=format&fit=crop'),
    Recipe.mockRecipe.copyWith(id: 'hist004', name: 'Viewed Chocolate Cake', time: '60分鐘', style: '甜點', imageUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?q=80&w=789&auto=format&fit=crop'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('使用記錄'), // "Usage History"
      ),
      body: _historyRecipes.isEmpty
          ? const Center(
              child: Text(
                '您的瀏覽記錄是空的。', // "Your viewing history is empty."
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _historyRecipes.length,
              itemBuilder: (context, index) {
                final recipe = _historyRecipes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  elevation: 2.0,
                  child: ListTile(
                    leading: (recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty)
                        ? Image.network(
                            recipe.imageUrl!,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => 
                                const Icon(Icons.restaurant, size: 40, color: Colors.grey),
                          )
                        : const Icon(Icons.restaurant, size: 40, color: Colors.grey),
                    title: Text(recipe.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${recipe.time} - ${recipe.style}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // print('Tapped on history item: ${recipe.name}'); // For debugging
                      context.push('/historyRecipeDetail', extra: recipe);
                    },
                  ),
                );
              },
            ),
    );
  }
} 