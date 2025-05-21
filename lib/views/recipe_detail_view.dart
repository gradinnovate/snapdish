import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapdish/utils/app_theme.dart';

class RecipeDetailView extends StatelessWidget {
  final String recipeId;

  const RecipeDetailView({
    super.key,
    required this.recipeId,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual data from state management
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
        '加入適量鹽調味即可',
      ],
    };

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
              // TODO: Implement favorite functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('收藏功能開發中')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mockRecipe['name'],
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
                        mockRecipe['time'],
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
                        mockRecipe['style'],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '食材',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...mockRecipe['ingredients'].map<Widget>((ingredient) => Padding(
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
                  Text(
                    '步驟',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...mockRecipe['steps'].asMap().entries.map<Widget>((entry) => Padding(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 