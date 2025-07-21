import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';

class BottomNav {
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