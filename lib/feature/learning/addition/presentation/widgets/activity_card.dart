import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/addition_activity.dart';


class ActivityCard extends StatelessWidget {
  final AdditionActivity activity;
  final int stars;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.stars,
  });

  @override
  Widget build(BuildContext context) {    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Using theme for styling elements
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(20),
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
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: activity.isLocked
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'This activity will unlock at level ${activity.level}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              : () {                  // Navigate to activity
                  context.push(activity.routeName);
                },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Activity Image/Icon
                    Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: _getTypeColor(activity.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Image.asset(
                          activity.imagePath,
                          height: 60,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            _getTypeIcon(activity.type),
                            size: 40,
                            color: _getTypeColor(activity.type),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Activity title
                    Text(
                      activity.title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    // Activity type badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getTypeColor(activity.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _getTypeLabel(activity.type),
                        style: TextStyle(
                          color: _getTypeColor(activity.type),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Stars (if completed activity)
                    if (stars > 0) _buildStars(stars),
                  ],
                ),
              ),
              
              // Lock overlay for locked activities
              if (activity.isLocked)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Unlock at Level ${activity.level}',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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

  Widget _buildStars(int count) {
    return Row(
      children: [
        for (int i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              i < count ? Icons.star_rounded : Icons.star_border_rounded,
              color: Colors.amber,
              size: 18,
            ),
          ),
      ],
    );
  }

  Color _getTypeColor(ActivityType type) {
    switch (type) {
      case ActivityType.lesson:
        return Colors.blue;
      case ActivityType.game:
        return Colors.green;
      case ActivityType.quiz:
        return Colors.orange;
      case ActivityType.challenge:
        return Colors.red;
    }
  }

  IconData _getTypeIcon(ActivityType type) {
    switch (type) {
      case ActivityType.lesson:
        return Icons.book_rounded;
      case ActivityType.game:
        return Icons.sports_esports_rounded;
      case ActivityType.quiz:
        return Icons.quiz_rounded;
      case ActivityType.challenge:
        return Icons.emoji_events_rounded;
    }
  }

  String _getTypeLabel(ActivityType type) {
    switch (type) {
      case ActivityType.lesson:
        return 'LESSON';
      case ActivityType.game:
        return 'GAME';
      case ActivityType.quiz:
        return 'QUIZ';
      case ActivityType.challenge:
        return 'CHALLENGE';
    }
  }
}
