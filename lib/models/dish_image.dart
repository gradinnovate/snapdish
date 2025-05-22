class DishImage {
  final String id;
  final String imageUrl;
  // final String recipeId; // To link to a recipe

  DishImage({required this.id, required this.imageUrl});

  // Optional: For easier comparison if objects are recreated
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DishImage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode => id.hashCode ^ imageUrl.hashCode;
}
