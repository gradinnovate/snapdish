import 'package:flutter/material.dart';
import 'package:snapdish/widgets/recent_recipes.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('使用記錄'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: RecentRecipes(), // Reusing the same widget for now
      ),
    );
  }
} 