import 'package:flutter/material.dart';
import 'package:fun_math/feature/games/number_puzzle/feature/puzzle/presentation/screen/number_puzzle_screen.dart';
import 'package:go_router/go_router.dart';
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