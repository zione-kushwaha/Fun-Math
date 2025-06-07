import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fun_math/app/routes/router.dart';
import 'package:fun_math/core/theme/theme.dart';

import '../core/theme/provider/theme_provider.dart';

class FunMathApp extends ConsumerWidget{
  const FunMathApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Fun Math',
      themeMode: ref.watch(themeProvider) ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: AppRouter.goRouter,
    );
  }
}