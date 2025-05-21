// lib/models/recipe.dart

class Recipe {
  final String id;
  final String name;
  final String time;
  final String style;
  final List<String> ingredients;
  final List<String> steps;
  final String? imageUrl;
  final bool isFavorite;

  Recipe({
    required this.id,
    required this.name,
    required this.time,
    required this.style,
    required this.ingredients,
    required this.steps,
    this.imageUrl,
    this.isFavorite = false, // Default value for isFavorite
  });

  // Example mock recipe
  static Recipe get mockRecipe => Recipe(
    id: 'mock001',
    name: '蒜蓉炒青菜',
    time: '10分鐘',
    style: '中式',
    imageUrl: 'https://images.unsplash.com/photo-1528712306095-dba7963e85e8?q=80&w=1470&auto=format&fit=crop',
    ingredients: [
      '青菜 200g',
      '蒜頭 3瓣',
      '油 2湯匙',
      '鹽 適量',
    ],
    steps: [
      '青菜洗淨切段。',
      '蒜頭切碎。',
      '熱鍋下油，爆香蒜末。',
      '加入青菜快速翻炒。',
      '加入適量鹽調味即可。',
    ],
    isFavorite: false, // Initialize isFavorite for mockRecipe
  );

  // copyWith method
  Recipe copyWith({
    String? id,
    String? name,
    String? time,
    String? style,
    List<String>? ingredients,
    List<String>? steps,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      time: time ?? this.time,
      style: style ?? this.style,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
