import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Will be used for navigation
import 'package:snapdish/utils/app_theme.dart'; // For consistent styling
import 'package:snapdish/models/recipe.dart'; // Import Recipe from models
import 'package:snapdish/services/api_service.dart'; // Import ApiService

class FavoriteRecipeDetailView extends StatefulWidget {
  final Recipe recipe;

  const FavoriteRecipeDetailView({
    super.key,
    required this.recipe,
  });

  @override
  State<FavoriteRecipeDetailView> createState() => _FavoriteRecipeDetailViewState();
}

class _FavoriteRecipeDetailViewState extends State<FavoriteRecipeDetailView> {
  final ApiService _apiService = ApiService();
  bool _isRemovingFavorite = false;

  Future<void> _removeFromFavorites() async {
    if (!mounted) return;
    setState(() {
      _isRemovingFavorite = true;
    });

    try {
      await _apiService.removeFromFavorites(widget.recipe.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.recipe.name} removed from favorites.')),
        );
        // Check if context is still valid before popping
        if (Navigator.of(context).canPop()) {
             context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove from favorites: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRemovingFavorite = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access recipe via widget.recipe
    final recipe = widget.recipe;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Recipe Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        actions: [
          _isRemovingFavorite
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.white),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Remove from Favorites',
                  onPressed: _removeFromFavorites,
                ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image display
            if (recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty)
              Container(
                width: double.infinity,
                height: 250, // Adjusted height for better visuals
                child: Image.network(
                  recipe.imageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 250,
                      color: Colors.grey[300],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.error_outline, color: Colors.red, size: 50),
                            Text('Error loading image.'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Container( // Placeholder if no image URL
                width: double.infinity,
                height: 250,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(
                    Icons.restaurant_menu, // Different icon for placeholder
                    size: 64,
                    color: Colors.white70,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppTheme.textSecondaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        recipe.time,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.kitchen, // Changed icon for style
                        size: 16,
                        color: AppTheme.textSecondaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        recipe.style,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Ingredients', // Changed to English
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...recipe.ingredients.map<Widget>((ingredient) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline, // Changed icon for ingredients
                          size: 16, // Slightly larger
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(ingredient)), // Expanded to handle long ingredient names
                      ],
                    ),
                  )),
                  const SizedBox(height: 24),
                  Text(
                    'Steps', // Changed to English
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...recipe.steps.asMap().entries.map<Widget>((entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(6), // Slightly rounded square
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(entry.value),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
