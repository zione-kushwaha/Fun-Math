import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fun_math/app/navigation/router.dart';
import 'package:fun_math/core/theme/theme.dart' as app_theme;
import 'package:fun_math/core/localization/app_localizations.dart';
import '../../core/theme/provider/theme_provider.dart' as theme_provider;

class FunMathApp extends ConsumerWidget {
  const FunMathApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(theme_provider.themeProvider);
    final currentLocale = ref.watch(languageProvider);
    
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Fun Math',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: app_theme.AppTheme.lightTheme,
      darkTheme: app_theme.AppTheme.darkTheme,
      routerConfig: AppRouter.goRouter,
      
      // Localization support
      locale: currentLocale,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ne', 'NP'),
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}