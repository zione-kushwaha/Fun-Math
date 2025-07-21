import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/addition_learning_provider.dart';
import 'addition_home_screen.dart';

class AdditionLearningScreen extends ConsumerWidget {
  const AdditionLearningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We're using the AdditionHomeScreen directly here
    // In a larger application, you might have an additional router
    // to handle different addition learning sub-screens
    return const AdditionHomeScreen();
  }
}
