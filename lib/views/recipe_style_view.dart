import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapdish/utils/app_theme.dart';

class RecipeStyleView extends StatefulWidget {
  const RecipeStyleView({super.key});

  @override
  State<RecipeStyleView> createState() => _RecipeStyleViewState();
}

class _RecipeStyleViewState extends State<RecipeStyleView> {
  String? _selectedStyle;
  int _selectedTime = 20; // Default 20 minutes

  final List<Map<String, dynamic>> _styles = [
    {'id': 'chinese', 'name': '中式', 'icon': Icons.restaurant},
    {'id': 'japanese', 'name': '日式', 'icon': Icons.ramen_dining},
    {'id': 'western', 'name': '西式', 'icon': Icons.lunch_dining},
    {'id': 'korean', 'name': '韓式', 'icon': Icons.soup_kitchen},
  ];

  final List<int> _timeOptions = [10, 20, 30, 40];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('選擇風格與時間'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '料理風格',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _styles.length,
              itemBuilder: (context, index) {
                final style = _styles[index];
                final isSelected = style['id'] == _selectedStyle;
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedStyle = style['id'];
                      });
                    },
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryColor : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            style['icon'],
                            size: 32,
                            color: isSelected ? Colors.white : AppTheme.primaryColor,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            style['name'],
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '烹調時間',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _timeOptions.map((time) {
                    final isSelected = time == _selectedTime;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTime = time;
                        });
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.primaryColor : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$time',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
                              ),
                            ),
                            Text(
                              '分鐘',
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _selectedStyle != null
                  ? () {
                      // TODO: Generate recipe and navigate to recipe detail
                      context.go('/recipe/new');
                    }
                  : null,
              child: const Text('生成食譜'),
            ),
          ),
        ],
      ),
    );
  }
} 