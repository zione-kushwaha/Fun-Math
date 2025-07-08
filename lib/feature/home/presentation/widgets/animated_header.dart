import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fun_math/core/utils/extensions.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AnimatedHeader extends StatelessWidget {
  const AnimatedHeader({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20).copyWith(
        top: 40
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
                  colorScheme.primary.withOpacity(0.7),
                  colorScheme.secondary.withOpacity(0.7),
                ]
              : [
                  colorScheme.primary,
                  colorScheme.secondary,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Iconsax.emoji_happy, color: Colors.white, size: 28)
                      .animate()
                      .scale(
                        duration: 400.ms,
                        curve: Curves.easeOut,
                        delay: 200.ms,
                      )
                      .then()
                      .shake(duration: 700.ms, hz: 1),
                  const SizedBox(width: 12),
                  Text(
                    'Hello, Learner!',
                    style: textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.notification,
                  color: Colors.white,
                  size: 24,
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
            ],
          ),
          const SizedBox(height: 20),
          DefaultTextStyle(
            style: textTheme.headlineSmall!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Ready for some math fun?',
                  speed: const Duration(milliseconds: 100),
                ),
                TypewriterAnimatedText(
                  'Let\'s train your brain!',
                  speed: const Duration(milliseconds: 100),
                ),
                TypewriterAnimatedText(
                  'Math is awesome!',
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              repeatForever: true,
              displayFullTextOnTap: true,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Continue your math journey today',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ).animate().fadeIn(duration: 800.ms, delay: 500.ms),
        
        ],
      ),
    );
  }

 
}
