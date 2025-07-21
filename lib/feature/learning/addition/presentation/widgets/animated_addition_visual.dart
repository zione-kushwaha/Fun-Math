import 'package:flutter/material.dart';

class AnimatedAdditionVisual extends StatefulWidget {
  const AnimatedAdditionVisual({super.key});

  @override
  State<AnimatedAdditionVisual> createState() => _AnimatedAdditionVisualState();
}

class _AnimatedAdditionVisualState extends State<AnimatedAdditionVisual> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  // Objects to be added
  final List<Item> _leftItems = [
    Item(icon: Icons.star, color: Colors.amber, size: 30, position: const Offset(30, 30)),
    Item(icon: Icons.favorite, color: Colors.red, size: 30, position: const Offset(70, 50)),
    Item(icon: Icons.pets, color: Colors.brown, size: 30, position: const Offset(40, 90)),
  ];
  
  final List<Item> _rightItems = [
    Item(icon: Icons.light_mode, color: Colors.orange, size: 30, position: const Offset(150, 40)),
    Item(icon: Icons.eco, color: Colors.green, size: 30, position: const Offset(190, 70)),
  ];
  
  final List<Item> _resultItems = [];
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    
    // Initialize result items (hidden initially)
    _resultItems.addAll([..._leftItems, ..._rightItems]);
    
    // Adjust positions for the result items to be centered
    for (var i = 0; i < _resultItems.length; i++) {
      _resultItems[i] = _resultItems[i].copyWith(
        position: Offset(50 + (i * 40), 50),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Left side items
        ..._leftItems.map((item) => _buildDraggableItem(item, isLeft: true)),
        
        // Right side items
        ..._rightItems.map((item) => _buildDraggableItem(item, isLeft: false)),
        
        // Dividing line
        Center(
          child: Container(
            width: 2,
            height: double.infinity,
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
        
        // Addition result area
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: _showResult
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${_leftItems.length} + ${_rightItems.length} = ${_leftItems.length + _rightItems.length}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ],
                    )
                  : OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showResult = true;
                        });
                        _controller.reset();
                        _controller.forward();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Add Together"),
                    ),
            ),
          ),
        ),
        
        // Result item animation
        if (_showResult)
          ..._resultItems.asMap().entries.map(
                (entry) {
                  final index = entry.key;
                  final item = entry.value;
                  
                  return AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      // Staggered animation for each item
                      final delay = index * 0.2;
                      final animationValue = (_animation.value - delay).clamp(0.0, 1.0) / (1.0 - delay);
                      
                      return Positioned(
                        left: item.position.dx,
                        top: item.position.dy - (animationValue * 10),
                        child: Opacity(
                          opacity: animationValue,
                          child: _buildItem(item),
                        ),
                      );
                    },
                  );
                },
              ),
      ],
    );
  }

  Widget _buildDraggableItem(Item item, {required bool isLeft}) {
    return Positioned(
      left: item.position.dx,
      top: item.position.dy,
      child: Draggable<Item>(
        data: item,
        feedback: _buildItem(item),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: _buildItem(item),
        ),
        onDragEnd: (details) {
          // Update the position when dragged
          setState(() {
            final index = isLeft
                ? _leftItems.indexOf(item)
                : _rightItems.indexOf(item);
            
            if (index != -1) {
              final newPosition = Offset(
                details.offset.dx - 40, // Adjust for widget center
                details.offset.dy - 40,
              );
              
              if (isLeft) {
                _leftItems[index] = item.copyWith(position: newPosition);
              } else {
                _rightItems[index] = item.copyWith(position: newPosition);
              }
            }
          });
        },
        child: _buildItem(item),
      ),
    );
  }

  Widget _buildItem(Item item) {
    return Container(
      width: item.size + 10,
      height: item.size + 10,
      decoration: BoxDecoration(
        color: item.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(item.size / 2),
      ),
      child: Center(
        child: Icon(
          item.icon,
          color: item.color,
          size: item.size,
        ),
      ),
    );
  }
}

class Item {
  final IconData icon;
  final Color color;
  final double size;
  final Offset position;

  Item({
    required this.icon,
    required this.color,
    required this.size,
    required this.position,
  });

  Item copyWith({
    IconData? icon,
    Color? color,
    double? size,
    Offset? position,
  }) {
    return Item(
      icon: icon ?? this.icon,
      color: color ?? this.color,
      size: size ?? this.size,
      position: position ?? this.position,
    );
  }
}
