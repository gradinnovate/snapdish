import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapdish/utils/app_theme.dart';

class IngredientResultView extends StatefulWidget {
  const IngredientResultView({super.key});

  @override
  State<IngredientResultView> createState() => _IngredientResultViewState();
}

class _IngredientResultViewState extends State<IngredientResultView> {
  // TODO: Replace with actual data from state management
  final List<String> _ingredients = [
    '白菜',
    '胡蘿蔔',
    '豬肉',
    '蒜頭',
    '薑',
  ];

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  void _addIngredient() {
    // TODO: Implement add ingredient dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加食材'),
        content: const Text('此功能正在開發中'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('確定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('識別結果'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _ingredients.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.restaurant,
                        color: AppTheme.primaryColor,
                      ),
                      title: Text(_ingredients[index]),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.grey,
                        ),
                        onPressed: () => _removeIngredient(index),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                OutlinedButton(
                  onPressed: _addIngredient,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    side: const BorderSide(color: AppTheme.primaryColor),
                  ),
                  child: const Text('添加食材'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go('/recipe-style'),
                  child: const Text('繼續'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 