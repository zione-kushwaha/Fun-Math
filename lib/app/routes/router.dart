import 'package:flutter/material.dart';
import 'package:fun_math/core/data/difficulty_type.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/puzzle/presentation/screen/number_puzzle_screen.dart';
import 'package:go_router/go_router.dart';
import '../../feature/games/brain_boost/view/brain_boost_view.dart';
import '../../feature/games/brain_boost/feature/magic_triangle/presentation/screen/magic_triangle_screen.dart';
import '../../feature/games/brain_boost/feature/number_pyramid/presentation/screen/number_pyramid_screen.dart';
import '../../feature/games/brain_boost/feature/picture_puzzle/presentation/screen/picture_puzzle_screen.dart';
import '../../feature/games/brain_boost/feature/pattern_master/presentation/screen/pattern_master_screen.dart';
// MathRaceScreen import removed as it's not needed
import '../../feature/games/math_race/view/math_race_view.dart';
import '../../feature/games/math_race/feature/race/presentation/screen/race_screen.dart';
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
import '../../feature/home/presentation/screen/home_screen.dart';
import '../../feature/games/number_puzzle/feature/calculator/presentation/screen/calculator_screen.dart';
import '../../feature/games/number_puzzle/feature/correct_answer/presentation/screen/correct_answer_screen.dart';
import '../../feature/games/number_puzzle/feature/guess_sign/presentation/screen/guess_sign_screen.dart';
import '../../feature/games/number_puzzle/feature/quick_calculation/presentation/screen/quick_calculation_screen.dart';
import '../../feature/games/number_puzzle/feature/math_memory/presentation/screen/math_memory_screen.dart';

class AppRouter{
  static final goRouter = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const HomeScreen();
        },
      ),      GoRoute(
        path: '/number_puzzle',
        builder: (context, state) {
          return const NumberPuzzleViewScreen();
        },
      ),
       GoRoute(
        path: '/puzzle_game',
        builder: (context, state) {
          return const NumberPuzzleScreen();
        },
      ),
      GoRoute(
        path: '/calculator',
        builder: (context, state) {
          return const CalculatorScreen();
        },
      ),
      GoRoute(
        path: '/correct_answer',
        builder: (context, state) {
          return const CorrectAnswerScreen();
        },
      ),
      GoRoute(
        path: '/guess_sign',
        builder: (context, state) {
          return const GuessSignScreen();
        },
      ),
      GoRoute(
        path: '/quick_calculation',
        builder: (context, state) {
          return const QuickCalculationScreen();
        },
      ),
      GoRoute(
        path: '/math_memory',
        builder: (context, state) {
          return const MathMemoryScreen();
        },
      ),

       GoRoute(
        path: '/brain_boost',
        builder: (context, state) {
          return const BrainBoostView();
        },
      ),
      GoRoute(
        path: '/magic_triangle',
        builder: (context, state) {
          return const MagicTriangleScreen();
        },
      ),
      GoRoute(
        path: '/number_pyramid',
        builder: (context, state) {
          return const NumberPyramidScreen();
        },
      ),
      GoRoute(
        path: '/picture_puzzle',
        builder: (context, state) {
          return const PicturePuzzleScreen();
        },
      ),
      GoRoute(
        path: '/pattern_master',
        builder: (context, state) {
          return const PatternMasterScreen();
        },
      ),       GoRoute(
        path: '/math_race',
        builder: (context, state) {
          return const MathRaceView();
        },
      ),      GoRoute(
        path: '/math/race',
        builder: (context, state) {
          final difficulty = state.uri.queryParameters['difficulty'];
          return RaceScreen(
            difficulty: difficulty == 'medium' 
                ? DifficultyType.medium 
                : (difficulty == 'hard' ? DifficultyType.hard : DifficultyType.easy),
          );
        },
      ),
      GoRoute(
        path: '/math/mental_arithmetic',
        builder: (context, state) {
          return const MentalArithmeticScreen();
        },
      ),
      GoRoute(
        path: '/math/square_root',
        builder: (context, state) {
          return const SquareRootScreen();
        },
      ),
      GoRoute(
        path: '/math/math_grid',
        builder: (context, state) {
          return const MathGridScreen(
            primaryColor: Colors.orange,
            secondaryColor: Colors.deepOrange,
          );
        },
      ),
      GoRoute(
        path: '/math/math_pairs',
        builder: (context, state) {
          return const MathPairsScreen(
            primaryColor: Colors.red,
            secondaryColor: Colors.redAccent,
          );
        },
      ),      GoRoute(
        path: '/memory_match',
        builder: (context, state) {
          return const MemoryMatchView();
        },
      ),
      GoRoute(
        path: '/memory/number_match',
        builder: (context, state) {
          final difficulty = state.uri.queryParameters['difficulty'];
          return NumberMatchScreen(
            difficulty: difficulty == 'medium' 
                ? DifficultyType.medium 
                : (difficulty == 'hard' ? DifficultyType.hard : DifficultyType.easy),
            primaryColor: Colors.purple,
            secondaryColor: Colors.purpleAccent,
          );
        },
      ),
      GoRoute(
        path: '/memory/equation_match',
        builder: (context, state) {
          final difficulty = state.uri.queryParameters['difficulty'];
          return EquationMatchScreen(
            difficulty: difficulty == 'medium' 
                ? DifficultyType.medium 
                : (difficulty == 'hard' ? DifficultyType.hard : DifficultyType.easy),
            primaryColor: Colors.indigo,
            secondaryColor: Colors.indigoAccent,
          );
        },
      ),
      GoRoute(
        path: '/memory/visual_memory',
        builder: (context, state) {
          final difficulty = state.uri.queryParameters['difficulty'];
          return VisualMemoryScreen(
            difficulty: difficulty == 'medium' 
                ? DifficultyType.medium 
                : (difficulty == 'hard' ? DifficultyType.hard : DifficultyType.easy),
            primaryColor: Colors.teal,
            secondaryColor: Colors.tealAccent,
          );
        },
      ),
      GoRoute(
        path: '/memory/speed_memory',
        builder: (context, state) {
          final difficulty = state.uri.queryParameters['difficulty'];
          return SpeedMemoryScreen(
            difficulty: difficulty == 'medium' 
                ? DifficultyType.medium 
                : (difficulty == 'hard' ? DifficultyType.hard : DifficultyType.easy),
            primaryColor: Colors.amber,
            secondaryColor: Colors.amberAccent,
          );
        },
      ),
      GoRoute(
        path: '/memory/sequence_match',
        builder: (context, state) {
          final difficulty = state.uri.queryParameters['difficulty'];
          return SequenceMatchScreen(
            difficulty: difficulty == 'medium' 
                ? DifficultyType.medium 
                : (difficulty == 'hard' ? DifficultyType.hard : DifficultyType.easy),
            primaryColor: Colors.pink,
            secondaryColor: Colors.pinkAccent,
          );
        },
      ),
      GoRoute(
        path: '/memory/pattern_memory',
        builder: (context, state) {
          final difficulty = state.uri.queryParameters['difficulty'];
          return PatternMemoryScreen(
            difficulty: difficulty == 'medium' 
                ? DifficultyType.medium 
                : (difficulty == 'hard' ? DifficultyType.hard : DifficultyType.easy),
            primaryColor: Colors.green,
            secondaryColor: Colors.greenAccent,
          );
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
            ),
            body: const Center(
              child: Text('Welcome to the Settings Screen!'),
            ),
          );
        },
      ),
    ],
  );
}