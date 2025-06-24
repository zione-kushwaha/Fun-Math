import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/data/difficulty_type.dart';

import '../../feature/games/brain_boost/view/brain_boost_view.dart';
import '../../feature/games/brain_boost/feature/magic_triangle/presentation/screen/magic_triangle_screen.dart';
import '../../feature/games/brain_boost/feature/number_pyramid/presentation/screen/number_pyramid_screen.dart';
import '../../feature/games/brain_boost/feature/picture_puzzle/presentation/screen/picture_puzzle_screen.dart';
import '../../feature/games/brain_boost/feature/pattern_master/presentation/screen/pattern_master_screen.dart';

import '../../feature/games/math_race/view/math_race_view.dart';
import '../../feature/games/math_race/feature/mental_arithmetic/presentation/screen/mental_arithmetic_screen.dart';
import '../../feature/games/math_race/feature/square_root/presentation/screen/square_root_screen.dart';
import '../../feature/games/math_race/feature/math_grid/presentation/screen/math_grid_screen.dart';
import '../../feature/games/math_race/feature/math_pairs/presentation/screen/math_pairs_screen.dart';

import '../../feature/games/memory_match/view/memory_match_view.dart';
import '../../feature/games/memory_match/feature/number_match/presentation/screen/number_match_screen.dart';
import '../../feature/games/memory_match/feature/equation_match/presentation/screen/equation_match_screen.dart';
import '../../feature/games/memory_match/feature/visual_memory/presentation/screen/visual_memory_screen.dart';
import '../../feature/games/memory_match/feature/speed_memory/presentation/screen/speed_memory_screen.dart';
import '../../feature/games/memory_match/feature/sequence_match/presentation/screen/sequence_match_screen.dart';
import '../../feature/games/memory_match/feature/pattern_memory/presentation/screen/pattern_memory_screen.dart';

import '../../feature/games/number_puzzle/view/number_puzzle_view.dart';
import '../../feature/games/number_puzzle/feature/calculator/presentation/screen/calculator_screen.dart';
import '../../feature/games/number_puzzle/feature/correct_answer/presentation/screen/correct_answer_screen.dart';
import '../../feature/games/number_puzzle/feature/guess_sign/presentation/screen/guess_sign_screen.dart';
import '../../feature/games/number_puzzle/feature/quick_calculation/presentation/screen/quick_calculation_screen.dart';
import '../../feature/games/number_puzzle/feature/math_memory/presentation/screen/math_memory_screen.dart';

import '../../feature/home/presentation/screen/home_screen.dart';
import '../../feature/learning/presentation/screens/learning_screen.dart';
import '../../feature/learning/addition/presentation/screens/addition_learning_screen.dart';
import '../../feature/learning/addition/presentation/screens/counting_adventure_screen.dart';
import '../../feature/learning/addition/presentation/screens/number_friends_screen.dart';
import '../../feature/learning/addition/presentation/screens/addition_machine_screen.dart';
import '../../feature/learning/addition/presentation/screens/ten_frame_screen.dart';
import '../../feature/practice/presentation/screens/practice_screen.dart';
import '../../feature/profile/presentation/screens/profile_screen.dart';
import '../../feature/settings/presentation/screens/settings_screen.dart';
import 'scaffold_with_bottom_nav.dart';

// Provider for the current navigation tab index
final navigationIndexProvider = StateProvider<int>((ref) => 0);

// Our main app router configuration
class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final shellNavigatorKey = GlobalKey<NavigatorState>();

  static final goRouter = GoRouter(
    initialLocation: '/',
    navigatorKey: rootNavigatorKey,
    routes: [
      // Main shell route with bottom navigation
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithBottomNav(child: child);
        },
        routes: [
          // Home Route (index 0)
          GoRoute(
            path: '/',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: const HomeScreen(),
              );
            },
          ),
          
          // Learning Route (index 1)
          GoRoute(
            path: '/learning',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: const LearningScreen(),
              );
            },
          ),
          
          // Practice Route (index 2)
          GoRoute(
            path: '/practice',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: const PracticeScreen(),
              );
            },
          ),
          
          // Profile Route (index 3)
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: const ProfileScreen(),
              );
            },
          ),
        ],
      ),
      
      // Routes that don't use the bottom navigation bar
      // Number Puzzle Route
      GoRoute(
        path: '/number_puzzle',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const NumberPuzzleViewScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
        // Brain Boost Route
      GoRoute(
        path: '/brain_boost',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const BrainBoostView(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      
      // Math Race Route
      GoRoute(
        path: '/math_race',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const MathRaceView(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      
      // Memory Match Route
      GoRoute(
        path: '/memory_match',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const MemoryMatchView(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
        // Settings Route
      GoRoute(
        path: '/settings',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const SettingsScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),        // Learning routes
      GoRoute(
        path: '/learning/addition',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const AdditionLearningScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
        // Number Puzzle sub-routes
      GoRoute(
        path: '/calculator',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const CalculatorScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/correct_answer',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const CorrectAnswerScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/guess_sign',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const GuessSignScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/quick_calculation',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const QuickCalculationScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/math_memory',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const MathMemoryScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
        // Brain Boost sub-routes
      GoRoute(
        path: '/magic_triangle',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const MagicTriangleScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/number_pyramid',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const NumberPyramidScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/picture_puzzle',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const PicturePuzzleScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/pattern_master',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const PatternMasterScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),// Math Race sub-routes
      GoRoute(
        path: '/mental_arithmetic',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final theme = Theme.of(context);
          return CustomTransitionPage(
            key: state.pageKey,
            child: MentalArithmeticScreen(
              difficulty: DifficultyType.medium,
              primaryColor: theme.colorScheme.primary,
              secondaryColor: theme.colorScheme.secondary,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/square_root',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final theme = Theme.of(context);
          return CustomTransitionPage(
            key: state.pageKey,
            child: SquareRootScreen(
              difficulty: DifficultyType.medium,
              primaryColor: theme.colorScheme.primary,
              secondaryColor: theme.colorScheme.secondary,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/math_grid',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final theme = Theme.of(context);
          return CustomTransitionPage(
            key: state.pageKey,
            child: MathGridScreen(
              primaryColor: theme.colorScheme.primary,
              secondaryColor: theme.colorScheme.secondary,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/math_pairs',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final theme = Theme.of(context);
          return CustomTransitionPage(
            key: state.pageKey,
            child: MathPairsScreen(
              primaryColor: theme.colorScheme.primary,
              secondaryColor: theme.colorScheme.secondary,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
        // Memory Match sub-routes
      GoRoute(
        path: '/number_match',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final theme = Theme.of(context);
          return CustomTransitionPage(
            key: state.pageKey,
            child: NumberMatchScreen(
              difficulty: DifficultyType.medium,
              primaryColor: theme.colorScheme.primary,
              secondaryColor: theme.colorScheme.secondary,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/equation_match',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final theme = Theme.of(context);
          return CustomTransitionPage(
            key: state.pageKey,
            child: EquationMatchScreen(
              difficulty: DifficultyType.medium,
              primaryColor: theme.colorScheme.primary,
              secondaryColor: theme.colorScheme.secondary,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/visual_memory',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final theme = Theme.of(context);
          return CustomTransitionPage(
            key: state.pageKey,
            child: VisualMemoryScreen(
              difficulty: DifficultyType.medium,
              primaryColor: theme.colorScheme.primary,
              secondaryColor: theme.colorScheme.secondary,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/speed_memory',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final theme = Theme.of(context);
          return CustomTransitionPage(
            key: state.pageKey,
            child: SpeedMemoryScreen(
              difficulty: DifficultyType.medium,
              primaryColor: theme.colorScheme.primary,
              secondaryColor: theme.colorScheme.secondary,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/sequence_match',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final theme = Theme.of(context);
          return CustomTransitionPage(
            key: state.pageKey,
            child: SequenceMatchScreen(
              difficulty: DifficultyType.medium,
              primaryColor: theme.colorScheme.primary,
              secondaryColor: theme.colorScheme.secondary,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/pattern_memory',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final theme = Theme.of(context);
          return CustomTransitionPage(
            key: state.pageKey,
            child: PatternMemoryScreen(
              difficulty: DifficultyType.medium,
              primaryColor: theme.colorScheme.primary,
              secondaryColor: theme.colorScheme.secondary,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
        // Addition Learning sub-routes
      GoRoute(
        path: '/counting_adventure',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const CountingAdventureScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/number_friends',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const NumberFriendsScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/addition_machine',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const AdditionMachineScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/ten_frame',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const TenFrameScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
    ],
  );
  
  // Bottom navigation items
  static List<BottomNavigationItem> get bottomNavItems => [
    BottomNavigationItem(
      path: '/',
      icon: Iconsax.home_2,
      selectedIcon: Iconsax.home_25,
      label: 'Home',
    ),
    BottomNavigationItem(
      path: '/learning',
      icon: Iconsax.book_1,
      selectedIcon: Iconsax.book5,
      label: 'Learn',
    ),
    BottomNavigationItem(
      path: '/practice',
      icon: Iconsax.teacher,
      selectedIcon: Iconsax.math,
      label: 'Practice',
    ),
    BottomNavigationItem(
      path: '/profile',
      icon: Iconsax.user,
      selectedIcon: Iconsax.user_tick,
      label: 'Profile',
    ),
  ];
}

// Class to represent bottom navigation items
class BottomNavigationItem {
  final String path;
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  BottomNavigationItem({
    required this.path,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
