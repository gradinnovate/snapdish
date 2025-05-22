import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snapdish/utils/app_theme.dart';
import 'package:snapdish/widgets/camera_button.dart';
import 'package:snapdish/widgets/recent_recipes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('今日煮意 AI'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // 大型相機按鈕
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CameraButton(
                onPressed: () => context.push('/ingredients-identification'),
              ),
            ),
            const SizedBox(height: 30),
            // 最近使用的食譜
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '最近使用的食譜',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 16),
                    const Expanded(
                      child: RecentRecipes(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 