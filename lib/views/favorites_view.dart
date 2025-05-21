import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapdish/models/recipe.dart'; // Import Recipe from models

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  // Mock list of favorite recipes
  static final List<Recipe> _favoriteRecipes = [
    // Ensure Recipe.mockRecipe is available and copyWith works from the new model.
    // The Recipe class in models/recipe.dart should have mockRecipe and copyWith.
    Recipe.mockRecipe.copyWith(id: 'fav001', name: 'Favorite Spicy Chicken Stir-fry', imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=781&auto=format&fit=crop', isFavorite: true),
    Recipe.mockRecipe.copyWith(id: 'fav002', name: 'Favorite Pasta Carbonara', imageUrl: 'https://images.unsplash.com/photo-1588013273468-31508066425d?q=80&w=687&auto=format&fit=crop', isFavorite: true),
    Recipe.mockRecipe.copyWith(id: 'fav003', name: 'Favorite Beef Tacos', imageUrl: 'https://images.unsplash.com/photo-1565031491910-e57fac031c41?q=80&w=687&auto=format&fit=crop', isFavorite: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的收藏'), // "My Favorites"
      ),
      body: _favoriteRecipes.isEmpty
          ? const Center(
              child: Text(
                '您還沒有收藏任何食譜。', // "You haven't favorited any recipes yet."
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = _favoriteRecipes[index];
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
                      // print('Tapped on favorite: ${recipe.name}'); // For debugging
                      context.push('/favoriteRecipeDetail', extra: recipe);
                    },
                  ),
                );
              },
            ),
    );
  }
}

// The RecipeCopyWith extension is removed as it's part of the Recipe class in models/recipe.dart