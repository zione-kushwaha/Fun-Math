import 'package:flutter_riverpod/flutter_riverpod.dart';


// theme provider
final themeProvider = StateNotifierProvider<ThemeProvider, bool>((ref) {
  return ThemeProvider();
});

// theme state notifier
class ThemeProvider extends StateNotifier<bool> {
  ThemeProvider() : super(true);

  void toggleTheme() {
    state = !state;
  }

  bool get isDarkMode => state;
}