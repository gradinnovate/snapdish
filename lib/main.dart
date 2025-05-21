import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapdish/utils/app_theme.dart';
import 'package:snapdish/utils/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  runApp(
    const ProviderScope(
      child: SnapDishApp(),
    ),
  );
}

class SnapDishApp extends StatelessWidget {
  const SnapDishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SnapDish',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      locale: const Locale('zh', 'TW'),
    );
  }
}
