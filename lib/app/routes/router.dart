import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../feature/home/presentation/home_screen.dart';

class AppRouter{
  static final goRouter = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const HomeScreen();
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