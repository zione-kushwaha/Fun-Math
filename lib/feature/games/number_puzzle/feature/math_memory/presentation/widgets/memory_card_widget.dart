import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MemoryCardWidget extends StatefulWidget {
  final String value;
  final bool isFlipped;
  final bool isMatched;
  final bool isQuestion;
  final bool animated;
  final Function()? onTap;
  
  const MemoryCardWidget({
    super.key,
    required this.value,
    required this.isFlipped,
    required this.isMatched,
    required this.isQuestion,
    this.animated = true,
    this.onTap,
  });

  @override
  State<MemoryCardWidget> createState() => _MemoryCardWidgetState();
}

class _MemoryCardWidgetState extends State<MemoryCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _frontRotation;
  late Animation<double> _backRotation;
  bool _isFlipped = false;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _frontRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 0.5)
            .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(0.5),
          weight: 50.0,
        ),
      ],
    ).animate(_controller);

    _backRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(0.5),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: -0.5, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50.0,
        ),
      ],
    ).animate(_controller);
    
    // Set initial state based on props
    _isFlipped = widget.isFlipped;
    if (_isFlipped) {
      _controller.value = 1.0;
    }
  }
  
  @override
  void didUpdateWidget(MemoryCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      _isFlipped = widget.isFlipped;
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: widget.animated ? _buildAnimatedCard(context) : _buildStaticCard(context),
    );
  }
  
  Widget _buildAnimatedCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Back of card (hidden when flipped)
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateY(3.14159 * _frontRotation.value),
              alignment: Alignment.center,
              child: Visibility(
                visible: _frontRotation.value < 0.5,
                child: _buildCardBack(context, isDarkMode),
              ),
            ),
            // Front of card (visible when flipped)
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateY(3.14159 * _backRotation.value),
              alignment: Alignment.center,
              child: Visibility(
                visible: _backRotation.value <= 0,
                child: _buildCardFront(context, isDarkMode),
              ),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildStaticCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return widget.isFlipped
        ? _buildCardFront(context, isDarkMode)
        : _buildCardBack(context, isDarkMode);
  }
  
  Widget _buildCardBack(BuildContext context, bool isDarkMode) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: isDarkMode
              ? [theme.primaryColor, theme.primaryColor.withOpacity(0.7)]
              : [theme.primaryColor, Colors.blue.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.question_mark,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }
  
  Widget _buildCardFront(BuildContext context, bool isDarkMode) {
    final theme = Theme.of(context);
    
    // Determine background color based on matched status
    Color backgroundColor;
    if (widget.isMatched) {
      backgroundColor = Colors.green.withOpacity(isDarkMode ? 0.3 : 0.2);
    } else {
      backgroundColor = isDarkMode ? Colors.grey.shade800 : Colors.white;
    }
    
    // Determine border color
    Color borderColor;
    if (widget.isMatched) {
      borderColor = Colors.green;
    } else {
      borderColor = widget.isQuestion
          ? Colors.orangeAccent
          : Colors.blueAccent;
    }

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: widget.isQuestion
                  ? Colors.orange
                  : Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
