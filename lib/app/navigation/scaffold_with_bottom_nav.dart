import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'router.dart';

class ScaffoldWithBottomNav extends ConsumerStatefulWidget {
  final Widget child;

  const ScaffoldWithBottomNav({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<ScaffoldWithBottomNav> createState() => _ScaffoldWithBottomNavState();
}

class _ScaffoldWithBottomNavState extends ConsumerState<ScaffoldWithBottomNav> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    
    // Create animation for bottom nav
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    
    if (location.startsWith('/')) {
      final String path = location;
      
      if (path == '/') return 0;
      if (path.startsWith('/learning')) return 1;
      if (path.startsWith('/practice')) return 2;
      if (path.startsWith('/profile')) return 3;
    }
    
    return 0;
  }
  
  void _onItemTapped(int index, BuildContext context) {
    // Set the index in provider
    ref.read(navigationIndexProvider.notifier).state = index;
    
    // Navigate to the appropriate route
    switch (index) {
      case 0:
        GoRouter.of(context).go('/');
        break;
      case 1:
        GoRouter.of(context).go('/learning');
        break;
      case 2:
        GoRouter.of(context).go('/practice');
        break;
      case 3:
        GoRouter.of(context).go('/profile');
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(_animation),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? colorScheme.surface : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .05),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, -5),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: BottomNavigationBar(
                items: AppRouter.bottomNavItems.map((item) {
                  return BottomNavigationBarItem(
                    icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 4),
                        Icon(item.icon),
                      ],
                    ),
                    activeIcon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 24,
                          height: 4,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Icon(item.selectedIcon),
                      ],
                    ),
                    label: item.label,
                  );
                }).toList(),
                currentIndex: _calculateSelectedIndex(context),
                onTap: (index) => _onItemTapped(index, context),
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                selectedItemColor: colorScheme.primary,
                unselectedItemColor: isDarkMode
                    ? Colors.white.withValues(alpha: .6)
                    : Colors.black.withValues(alpha: .4),
                elevation: 0,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
