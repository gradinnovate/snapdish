import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapdish/models/dish_image.dart'; // Import DishImage model

class FinalDishImageView extends StatefulWidget {
  // final String recipeId; // Conceptually, this might be passed to fetch/display the correct image and recipe
  // FinalDishImageView({Key? key, this.recipeId}) : super(key: key);

  @override
  _FinalDishImageViewState createState() => _FinalDishImageViewState();
}

class _FinalDishImageViewState extends State<FinalDishImageView> {
  DishImage? _dishImage;
  bool _isLoading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    // String conceptualRecipeId = widget.recipeId ?? "defaultRecipeId"; // If recipeId was passed
    _fetchDishImage("mock_recipe_id"); 
  }

  Future<void> _fetchDishImage(String conceptualRecipeId) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay
      // Mock data, replace with actual API call in the future
      // The conceptualRecipeId could be used to fetch a specific image if the API supported it
      _dishImage = DishImage(id: 'dish1', imageUrl: 'https://picsum.photos/seed/snapdish_final_${conceptualRecipeId}/800/600');
    } catch (e) {
      _error = e;
    } finally {
      if (mounted) { // Check if the widget is still in the tree
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.6;

    return Scaffold(
      appBar: AppBar(
        title: Text("Final Dish"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: imageHeight,
              child: Card(
                elevation: 4.0,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                child: _buildImageContent(),
              ),
            ),
            SizedBox(height: 24),

            // Action Buttons - enable only if image loaded successfully
            ElevatedButton.icon(
              icon: Icon(Icons.article_outlined),
              label: Text("View Recipe Details"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                textStyle: TextStyle(fontSize: 16),
              ),
              onPressed: (_dishImage != null && !_isLoading) ? () {
                context.push('/recipe/mock-recipe-id');
              } : null, // Disable if no image or still loading
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.favorite_border,
                  label: "Favorite",
                  tooltip: "Save to Favorites",
                  onPressed: (_dishImage != null && !_isLoading) ? () {
                    print("Save to Favorites clicked for image: ${_dishImage!.id}");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Action: Save to Favorites (Not Implemented Yet)"))
                    );
                  } : null,
                ),
                _buildActionButton(
                  context,
                  icon: Icons.share,
                  label: "Share",
                  tooltip: "Share",
                  onPressed: (_dishImage != null && !_isLoading) ? () {
                    print("Share clicked for image: ${_dishImage!.id}");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Action: Share (Not Implemented Yet)"))
                    );
                  } : null,
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 60, color: Colors.red[400]),
              SizedBox(height: 12),
              Text(
                'Oops! Something went wrong.',
                style: TextStyle(color: Colors.red[700], fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                _error.toString(), // Can be more user-friendly
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else if (_dishImage != null) {
      return Image.network(
        _dishImage!.imageUrl,
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
          return Center( // This errorBuilder is for Image.network specific errors
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, size: 60, color: Colors.grey[600]),
                SizedBox(height: 12),
                Text('Failed to load image.', style: TextStyle(color: Colors.grey[700], fontSize: 16)),
              ],
            ),
          );
        },
      );
    } else {
      return Center( // Fallback for unexpected state (e.g. API returns no error but no image)
        child: Text(
          'No image to display.',
          style: TextStyle(color: Colors.grey[700], fontSize: 16),
        ),
      );
    }
  }

  Widget _buildActionButton(BuildContext context, {required IconData icon, required String label, String? tooltip, VoidCallback? onPressed}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, size: 28),
          tooltip: tooltip,
          onPressed: onPressed,
          color: onPressed != null ? Theme.of(context).colorScheme.primary : Colors.grey,
        ),
        Text(label, style: TextStyle(fontSize: 12, color: onPressed != null ? Theme.of(context).colorScheme.onSurface : Colors.grey))
      ],
    );
  }
}
