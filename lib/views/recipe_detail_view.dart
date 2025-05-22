import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapdish/utils/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RecipeDetailView extends StatefulWidget {
  final String recipeId;

  const RecipeDetailView({
    super.key,
    required this.recipeId,
  });

  @override
  State<RecipeDetailView> createState() => _RecipeDetailViewState();
}

class _RecipeDetailViewState extends State<RecipeDetailView> {
  Map<String, dynamic>? _recipe;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  Future<void> _loadRecipe() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load recent recipes from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final String? recipesJson = prefs.getString('recent_recipes');
      
      if (recipesJson != null) {
        final List<dynamic> recipes = jsonDecode(recipesJson);
        // Find the recipe with the matching ID
        final recipe = recipes.firstWhere(
          (r) => r['id'] == widget.recipeId,
          orElse: () => null,
        );
        
        if (recipe != null) {
          setState(() {
            _recipe = Map<String, dynamic>.from(recipe);
          });
        } else {
          _error = '找不到食譜';
        }
      } else {
        _error = '尚無儲存的食譜';
      }
    } catch (e) {
      _error = '載入食譜時發生錯誤: $e';
      print(_error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If loading or error, show appropriate UI
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('食譜詳情'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _recipe == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('食譜詳情'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              _error ?? '無法載入食譜',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    // Fall back to default recipe if needed
    final Map<String, dynamic> mockRecipe = {
      'name': '蒜蓉炒青菜',
      'time': '10分鐘',
      'style': '中式',
      'ingredients': [
        '青菜 200g',
        '蒜頭 3瓣',
        '油 2湯匙',
        '鹽 適量',
      ],
      'steps': [
        '青菜洗淨切段',
        '蒜頭切碎',
        '熱鍋下油，爆香蒜末',
        '加入青菜快速翻炒',
        '觀察青菜熟度', 
        '加入適量鹽調味即可',
        '完成',
      ],
    };

    // Use loaded recipe or fallback
    final recipe = _recipe ?? mockRecipe;

    return Scaffold(
      appBar: AppBar(
        title: const Text('食譜詳情'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('收藏功能開發中')),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 80),
            children: [
              // Recipe image
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(
                    Icons.restaurant,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),
              
              // Recipe content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recipe title
                    Text(
                      recipe['name'],
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 8),
                    
                    // Recipe metadata
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color: AppTheme.textSecondaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          recipe['time'],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.restaurant,
                          size: 16,
                          color: AppTheme.textSecondaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          recipe['style'],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Ingredients section
                    Text(
                      '食材',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ...recipe['ingredients'].map<Widget>((ingredient) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.fiber_manual_record,
                            size: 8,
                            color: AppTheme.textSecondaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(ingredient),
                        ],
                      ),
                    )),
                    const SizedBox(height: 24),
                    
                    // Steps section
                    Text(
                      '步驟',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ...recipe['steps'].asMap().entries.map<Widget>((entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
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
                    
                    // Small space at the bottom to ensure content is above navigation bar
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 