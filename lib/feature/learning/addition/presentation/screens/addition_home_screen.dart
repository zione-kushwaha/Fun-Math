import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/addition_learning_provider.dart';
import '../widgets/concept_card.dart';
import '../widgets/activity_card.dart';
import '../widgets/animated_number.dart';
import '../widgets/progress_path.dart';

class AdditionHomeScreen extends ConsumerWidget {
  const AdditionHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final additionState = ref.watch(additionLearningProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDarkMode
                    ? [
                        const Color(0xFF282356),
                        const Color(0xFF121212),
                      ]
                    : [
                        const Color(0xFFE9EFFF),
                        Colors.white,
                      ],
              ),
            ),
          ),
          
          // Floating math symbols for decoration
          Positioned(
            top: 100,
            right: 30,
            child: _buildFloatingSymbol('+', Colors.pink, 35),
          ),
          Positioned(
            bottom: 120,
            left: 40,
            child: _buildFloatingSymbol('+', Colors.purple, 25),
          ),
          Positioned(
            top: 200,
            left: 30,
            child: _buildFloatingSymbol('+', Colors.orange, 20),
          ),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: colorScheme.primary,
                          size: 28,
                        ),
                      ),
                      Text(
                        'Addition Adventure',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      // Stats button
                      Container(
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.emoji_events_rounded,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main content area
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Level and Progress Section
                          _buildProgressSection(context, additionState.currentLevel, additionState.totalStars),
                          const SizedBox(height: 16),

                          // Learning Path
                          const ProgressPath(),
                          const SizedBox(height: 24),

                          // Concepts Section
                          _buildSectionHeader(context, 'Addition Concepts'),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 190,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: additionState.unlockedConcepts.length,
                              itemBuilder: (context, index) {
                                final concept = additionState.unlockedConcepts[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: ConceptCard(concept: concept),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Activities Section
                          _buildSectionHeader(context, 'Fun Activities'),
                          const SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: additionState.unlockedActivities.length,
                            itemBuilder: (context, index) {
                              final activity = additionState.unlockedActivities[index];
                              final stars = additionState.activityStars[activity.routeName] ?? 0;
                              return ActivityCard(
                                activity: activity,
                                stars: stars,
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context, int level, int stars) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? colorScheme.primary.withOpacity(0.2)
            : colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          // Level display
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                level.toString(),
                style: textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Level $level Explorer',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Keep going to unlock more activities!',
                  style: textTheme.bodyMedium?.copyWith(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    AnimatedNumber(value: stars),
                    const SizedBox(width: 4),
                    Text(
                      'stars',
                      style: textTheme.bodySmall?.copyWith(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.trending_up_rounded, 
                      color: isDarkMode ? Colors.greenAccent : Colors.green, 
                      size: 18
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Next: ${(level + 1) * 5} stars',
                      style: textTheme.bodySmall?.copyWith(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: Text('See All'),
        ),
      ],
    );
  }

  Widget _buildFloatingSymbol(String symbol, Color color, double size) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Text(
        symbol,
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
