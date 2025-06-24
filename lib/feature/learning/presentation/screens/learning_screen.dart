import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class LearningScreen extends ConsumerWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Center'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.setting_2),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Premium learning path card
              _buildPremiumCard(context, isDarkMode, textTheme),
              const SizedBox(height: 24),
              
              // Learning categories
              Text(
                'Math Topics',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              
              // Learning categories grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildTopicCard(
                    context,
                    title: 'Addition',
                    icon: Iconsax.add,
                    color: const Color(0xFF6A5AE0),
                    route: '/learning/addition',
                  ),
                  _buildTopicCard(
                    context,
                    title: 'Subtraction',
                    icon: Iconsax.minus,
                    color: const Color(0xFFFF8FA2),
                    route: '/learning/subtraction',
                    isComingSoon: true,
                  ),
                  _buildTopicCard(
                    context,
                    title: 'Multiplication',
                    icon: Iconsax.close_circle,
                    color: const Color(0xFFFFD56F),
                    route: '/learning/multiplication',
                    isComingSoon: true,
                  ),
                  _buildTopicCard(
                    context,
                    title: 'Division',
                    icon: Iconsax.slash,
                    color: const Color(0xFF92E3A9),
                    route: '/learning/division',
                    isComingSoon: true,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              Text(
                'Additional Learning',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              
              // Learning resources
              _buildLearningResourceCard(
                context,
                title: 'Interactive Tutorials',
                description: 'Step-by-step guided tutorials',
                icon: Iconsax.teacher,
                isDarkMode: isDarkMode,
              ),
              
              const SizedBox(height: 12),
              
              _buildLearningResourceCard(
                context,
                title: 'Math Videos',
                description: 'Visual explanations of math concepts',
                icon: Iconsax.video,
                isDarkMode: isDarkMode,
              ),
              
              const SizedBox(height: 12),
              
              _buildLearningResourceCard(
                context,
                title: 'Practice Worksheets',
                description: 'Printable worksheets for extra practice',
                icon: Iconsax.document,
                isDarkMode: isDarkMode,
                isLocked: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPremiumCard(BuildContext context, bool isDarkMode, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6A5AE0),
            const Color(0xFF8D7BFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.crown_1,
                color: Colors.amber,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                'Premium Learning Path',
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Unlock personalized learning paths tailored to your skill level with customized lessons and practice exercises.',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Premium subscription action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Premium feature coming soon!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF6A5AE0),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Unlock Premium'),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String route,
    bool isComingSoon = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (isComingSoon) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$title coming soon!')),
              );
              return;
            }
            context.go(route);
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Learn & Practice',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDarkMode 
                          ? Colors.grey.shade400 
                          : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              if (isComingSoon)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Coming Soon',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildLearningResourceCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required bool isDarkMode,
    bool isLocked = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (isLocked) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('This is a premium feature')),
              );
              return;
            }
            // Action for learning resource
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opening $title')),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDarkMode 
                            ? Colors.grey.shade400 
                            : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLocked)
                  Icon(
                    Iconsax.lock_1,
                    color: Colors.amber,
                    size: 20,
                  )
                else
                  Icon(
                    Iconsax.arrow_right_3,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
