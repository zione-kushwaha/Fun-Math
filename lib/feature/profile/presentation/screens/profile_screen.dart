import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fl_chart/fl_chart.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // User profile section
              _buildProfileHeader(context, isDarkMode),
              const SizedBox(height: 24),
              
              // Stats and Progress
              _buildStatsCard(context, isDarkMode),
              const SizedBox(height: 24),
              
              // Progress chart
              _buildProgressChart(context, isDarkMode),
              const SizedBox(height: 24),
              
              // Achievements
              _buildSection(
                context,
                title: 'Your Achievements',
                icon: Iconsax.medal_star,
              ),
              const SizedBox(height: 12),
              
              _buildAchievements(context, isDarkMode),
              const SizedBox(height: 24),
              
              // Badges
              _buildSection(
                context,
                title: 'Your Badges',
                icon: Iconsax.award,
              ),
              const SizedBox(height: 12),
              
              _buildBadges(context, isDarkMode),
              const SizedBox(height: 24),
              
              // Activity History
              _buildSection(
                context,
                title: 'Activity History',
                icon: Iconsax.calendar_1,
              ),
              const SizedBox(height: 12),
              
              _buildActivityHistory(context, isDarkMode),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildProfileHeader(BuildContext context, bool isDarkMode) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile picture
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: colorScheme.primary.withOpacity(0.1),
                child: Icon(
                  Iconsax.user,
                  size: 60,
                  color: colorScheme.primary,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Iconsax.edit_2,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // User name
          Text(
            'Math Explorer',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // User level and points
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Level 5',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Iconsax.star_1,
                color: Colors.amber,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '325 Points',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Level progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Level Progress',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '325 / 500 XP',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: 0.65,
                  minHeight: 10,
                  backgroundColor: colorScheme.primary.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatsCard(BuildContext context, bool isDarkMode) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    final stats = [
      {
        'title': 'Days Streak',
        'value': '7',
        'icon': Iconsax.calendar_1,
        'color': Colors.blue,
      },
      {
        'title': 'Problems Solved',
        'value': '243',
        'icon': Iconsax.tick_square,
        'color': Colors.green,
      },
      {
        'title': 'Avg Accuracy',
        'value': '87%',
        'icon': Iconsax.chart_success,
        'color': Colors.orange,
      },
      {
        'title': 'Time Spent',
        'value': '8.5h',
        'icon': Iconsax.timer_1,
        'color': Colors.purple,
      },
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
          context,
          title: 'Your Stats',
          icon: Iconsax.chart_2,
        ),
        const SizedBox(height: 12),
        Container(
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
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              final stat = stats[index];
              final Color color = stat['color'] as Color;
              
              return Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode 
                      ? Colors.grey.shade900
                      : color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      stat['icon'] as IconData,
                      color: color,
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      stat['value'] as String,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stat['title'] as String,
                      style: textTheme.bodySmall?.copyWith(
                        color: isDarkMode 
                            ? Colors.white.withOpacity(0.7)
                            : Colors.black.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildProgressChart(BuildContext context, bool isDarkMode) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
          context,
          title: 'Weekly Progress',
          icon: Iconsax.activity,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // The chart
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    barGroups: _getBarGroups(),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                days[value.toInt()],
                                style: TextStyle(
                                  color: isDarkMode 
                                      ? Colors.white.withOpacity(0.7)
                                      : Colors.black.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: colorScheme.primary,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${rod.toY.round()} points',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  List<BarChartGroupData> _getBarGroups() {
    return [
      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 20, color: Colors.blue)]),
      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 35, color: Colors.blue)]),
      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 15, color: Colors.blue)]),
      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 45, color: Colors.blue)]),
      BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 30, color: Colors.blue)]),
      BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 55, color: Colors.blue)]),
      BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 40, color: Colors.blue)]),
    ];
  }
  
  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Widget _buildAchievements(BuildContext context, bool isDarkMode) {
    final achievements = [
      {
        'title': 'Math Prodigy',
        'description': 'Solve 200 math problems',
        'progress': 1.0,
        'icon': Iconsax.award,
        'color': Colors.amber,
      },
      {
        'title': 'Week Warrior',
        'description': 'Complete 7 days streak',
        'progress': 1.0,
        'icon': Iconsax.calendar_1,
        'color': Colors.green,
      },
      {
        'title': 'Perfect Score',
        'description': 'Get 100% accuracy in 5 challenges',
        'progress': 0.6,
        'icon': Iconsax.medal_star,
        'color': Colors.purple,
      },
      {
        'title': 'Speed Demon',
        'description': 'Complete 10 quick calculation challenges',
        'progress': 0.3,
        'icon': Iconsax.timer_1,
        'color': Colors.red,
      },
    ];
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        final Color color = achievement['color'] as Color;
        final double progress = achievement['progress'] as double;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey.shade800 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  achievement['icon'] as IconData,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      achievement['title'] as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      achievement['description'] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDarkMode 
                            ? Colors.white.withOpacity(0.7)
                            : Colors.black.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: color.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildBadges(BuildContext context, bool isDarkMode) {
    final badges = [
      {
        'title': 'Math Wizard',
        'isUnlocked': true,
        'color': Colors.deepPurple,
      },
      {
        'title': 'Number Ninja',
        'isUnlocked': true,
        'color': Colors.red,
      },
      {
        'title': 'Addition Master',
        'isUnlocked': true,
        'color': Colors.blue,
      },
      {
        'title': 'Problem Solver',
        'isUnlocked': false,
        'color': Colors.green,
      },
      {
        'title': 'Calculation Hero',
        'isUnlocked': false,
        'color': Colors.amber,
      },
      {
        'title': 'Speed Champion',
        'isUnlocked': false,
        'color': Colors.orange,
      },
    ];
    
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: badges.map((badge) {
          final bool isUnlocked = badge['isUnlocked'] as bool;
          final Color color = badge['color'] as Color;
          
          return Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? color.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isUnlocked
                    ? color
                    : Colors.grey,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isUnlocked ? Iconsax.medal_star : Iconsax.lock,
                  color: isUnlocked ? color : Colors.grey,
                  size: 36,
                ),
                const SizedBox(height: 8),
                Text(
                  badge['title'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isUnlocked
                        ? color
                        : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildActivityHistory(BuildContext context, bool isDarkMode) {
    final activities = [
      {
        'title': 'Quick Calculation',
        'score': '8/10',
        'time': '2 hours ago',
        'icon': Iconsax.calculator,
      },
      {
        'title': 'Addition Practice',
        'score': '15/20',
        'time': '4 hours ago',
        'icon': Iconsax.add,
      },
      {
        'title': 'Daily Challenge',
        'score': '90%',
        'time': 'Yesterday',
        'icon': Iconsax.calendar_1,
      },
      {
        'title': 'Number Pyramid',
        'score': 'Level 4',
        'time': 'Yesterday',
        'icon': Iconsax.triangle,
      },
    ];
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey.shade800 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  activity['icon'] as IconData,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity['title'] as String,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Score: ${activity['score']}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDarkMode 
                            ? Colors.white.withOpacity(0.7)
                            : Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                activity['time'] as String,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDarkMode 
                      ? Colors.white.withOpacity(0.5)
                      : Colors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
