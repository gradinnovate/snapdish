import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapdish/utils/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RecentRecipes extends StatefulWidget {
  const RecentRecipes({super.key});

  @override
  State<RecentRecipes> createState() => _RecentRecipesState();
}

class _RecentRecipesState extends State<RecentRecipes> {
  List<Map<String, dynamic>> _recentRecipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentRecipes();
  }

  Future<void> _loadRecentRecipes() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? recipesJson = prefs.getString('recent_recipes');
      
      if (recipesJson != null) {
        final List<dynamic> decoded = jsonDecode(recipesJson);
        setState(() {
          _recentRecipes = List<Map<String, dynamic>>.from(decoded);
        });
      } else {
        // Use mock data if no saved recipes exist
        setState(() {
          _recentRecipes = [
            {
              'id': '1',
              'name': '蒜蓉炒青菜',
              'image': 'https://picsum.photos/seed/recipe1/200',
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
            },
            {
              'id': '2',
              'name': '清蒸魚片',
              'image': 'https://picsum.photos/seed/recipe2/200',
              'time': '20分鐘',
              'style': '粵式',
              'ingredients': [
                '魚片 300g',
                '薑 20g',
                '蔥 2根',
                '醬油 2湯匙',
              ],
              'steps': [
                '魚片洗淨，薑蔥切絲',
                '魚片上放薑蔥絲',
                '蒸鍋水滾後，放入魚片',
                '中火蒸10分鐘',
                '淋上醬油即可',
              ],
            },
            {
              'id': '3',
              'name': '番茄炒蛋',
              'image': 'https://picsum.photos/seed/recipe3/200',
              'time': '15分鐘',
              'style': '家常',
              'ingredients': [
                '雞蛋 3個',
                '番茄 2個',
                '油 2湯匙',
                '鹽 適量',
                '糖 少許',
              ],
              'steps': [
                '雞蛋打散，番茄切塊',
                '熱鍋下油，倒入蛋液快炒',
                '蛋熟後盛出備用',
                '鍋中加入番茄炒軟',
                '加入炒好的雞蛋',
                '調味後快速翻炒均勻',
                '出鍋裝盤',
              ],
            },
          ];
        });
        
        // Save the mock data for future use
        await _saveRecentRecipes();
      }
    } catch (e) {
      print('Error loading recent recipes: $e');
      // Use mock data if loading fails
      setState(() {
        _recentRecipes = [
          {
            'id': '1',
            'name': '蒜蓉炒青菜',
            'image': 'https://picsum.photos/seed/recipe1/200',
            'time': '10分鐘',
          },
        ];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveRecentRecipes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String jsonData = jsonEncode(_recentRecipes);
      await prefs.setString('recent_recipes', jsonData);
    } catch (e) {
      print('Error saving recent recipes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_recentRecipes.isEmpty) {
      return const Center(child: Text('尚無最近使用的食譜'));
    }

    return ListView.builder(
      itemCount: _recentRecipes.length,
      itemBuilder: (context, index) {
        final recipe = _recentRecipes[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () => context.go('/recipe/${recipe['id']}'),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    child: Image.network(
                      recipe['image'],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          recipe['name'],
                          style: Theme.of(context).textTheme.bodyLarge,
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
                              recipe['time'],
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.chevron_right,
                    color: AppTheme.textSecondaryColor,
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 