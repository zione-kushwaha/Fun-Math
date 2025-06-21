import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/app/routes/router.dart';
import 'package:fun_math/core/theme/theme.dart' as app_theme;
import '../core/theme/provider/theme_provider.dart' as theme_provider;

class FunMathApp extends ConsumerWidget{
  const FunMathApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(theme_provider.themeProvider);
    
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Fun Math',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: app_theme.AppTheme.lightTheme,
      darkTheme: app_theme.AppTheme.darkTheme,
      routerConfig: AppRouter.goRouter,
    );
  }
}