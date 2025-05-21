import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapdish/utils/app_theme.dart';

class RecentRecipes extends StatelessWidget {
  const RecentRecipes({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual data from state management
    final List<Map<String, dynamic>> mockRecipes = [
      {
        'id': '1',
        'name': '蒜蓉炒青菜',
        'image': 'https://picsum.photos/200',
        'time': '10分鐘',
      },
      {
        'id': '2',
        'name': '清蒸魚片',
        'image': 'https://picsum.photos/201',
        'time': '20分鐘',
      },
      {
        'id': '3',
        'name': '番茄炒蛋',
        'image': 'https://picsum.photos/202',
        'time': '15分鐘',
      },
    ];

    return ListView.builder(
      itemCount: mockRecipes.length,
      itemBuilder: (context, index) {
        final recipe = mockRecipes[index];
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