import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/addition_learning_provider.dart';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'dart:async';

class NumberFriendsScreen extends ConsumerStatefulWidget {
  const NumberFriendsScreen({super.key});

  @override
  ConsumerState<NumberFriendsScreen> createState() => _NumberFriendsScreenState();
}

class _NumberFriendsScreenState extends ConsumerState<NumberFriendsScreen> with TickerProviderStateMixin {
  // Game state
  int _targetSum = 10;
  int _level = 1;
  int _score = 0;
  int _stars = 0;
  int _timeLeft = 60; // Starting time in seconds
  bool _gameOver = false;
  bool _levelComplete = false;
  
  // For dragging numbers
  int? _selectedNumber;
  
  // Animation controllers
  late AnimationController _bounceAnimation;
  late AnimationController _shakeAnimation;
  late AnimationController _scaleAnimation;
  late ConfettiController _confettiController;
  
  // Timer
  Timer? _timer;
  
  // Current numbers on the game board
  late List<int> _numbers;
  
  // Pairs that have been matched
  final List<List<int>> _matchedPairs = [];
  
  @override
  void initState() {
    super.initState();
    
    _bounceAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _shakeAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _scaleAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    
    _initializeGame();
    _startTimer();
  }
  
  @override
  void dispose() {
    _bounceAnimation.dispose();
    _shakeAnimation.dispose();
    _scaleAnimation.dispose();
    _confettiController.dispose();
    _timer?.cancel();
    super.dispose();
  }
  
  void _initializeGame() {
    // Level settings
    switch (_level) {
      case 1:
        _targetSum = 10;
        _timeLeft = 60;
        break;
      case 2:
        _targetSum = 15;
        _timeLeft = 50;
        break;
      case 3:
        _targetSum = 20;
        _timeLeft = 45;
        break;
    }
    
    // Generate 12 numbers that can form pairs summing to the target
    _numbers = _generateNumbers();
    
    // Reset game state
    _matchedPairs.clear();
    _gameOver = false;
    _levelComplete = false;
  }
  
  List<int> _generateNumbers() {
    final random = Random();
    final result = <int>[];
    final pairsNeeded = 6; // We want 12 numbers = 6 pairs
    
    // Generate pairs that sum to the target
    for (int i = 0; i < pairsNeeded; i++) {
      // For each pair, choose first number between 1 and target-1
      final firstNum = random.nextInt(_targetSum - 1) + 1;
      final secondNum = _targetSum - firstNum;
      
      // Add both numbers
      result.add(firstNum);
      result.add(secondNum);
    }
    
    // Shuffle for random arrangement
    result.shuffle();
    return result;
  }
  
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0 && !_gameOver && !_levelComplete) {
          _timeLeft--;
        } else if (_timeLeft == 0 && !_gameOver && !_levelComplete) {
          _gameOver = true;
          timer.cancel();
          _checkGameResult();
        }
      });
    });
  }
  
  void _checkForMatch(int selectedIndex) {
    if (_selectedNumber == null) {
      // First number selection
      setState(() {
        _selectedNumber = selectedIndex;
      });
      _scaleAnimation.reset();
      _scaleAnimation.forward();
    } else {
      // Second number selection - check for match
      final firstIndex = _selectedNumber!;
      final secondIndex = selectedIndex;
      
      // Prevent selecting the same number
      if (firstIndex == secondIndex) {
        setState(() {
          _selectedNumber = null; // Reset selection
        });
        return;
      }
      
      final first = _numbers[firstIndex];
      final second = _numbers[secondIndex];
      
      if (first + second == _targetSum) {
        // Match found!
        setState(() {
          _matchedPairs.add([firstIndex, secondIndex]);
          _score += 10;
          _selectedNumber = null;
          
          // Check if all pairs are found
          if (_matchedPairs.length * 2 == _numbers.length) {
            _levelComplete = true;
            _confettiController.play();
            _timer?.cancel();
            _updateStars();
            
            // Delay before level completion logic
            Future.delayed(const Duration(seconds: 3), () {
              if (_level < 3) {
                setState(() {
                  _level++;
                  _initializeGame();
                  _startTimer();
                });
              } else {
                // Game completed
                ref.read(additionLearningProvider.notifier)
                   .completeActivity('/learning/addition/number_friends', _stars);
              }
            });
          }
        });
      } else {
        // No match
        _shakeAnimation.reset();
        _shakeAnimation.forward();
        
        // Reset selection after a brief delay
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            _selectedNumber = null;
          });
        });
      }
    }
  }
  
  void _updateStars() {
    // Calculate stars based on score and time left
    if (_score >= 150) {
      _stars = 3;
    } else if (_score >= 100) {
      _stars = 2;
    } else {
      _stars = 1;
    }
    
    ref.read(additionLearningProvider.notifier)
       .completeActivity('/learning/addition/number_friends', _stars);
  }
  
  void _checkGameResult() {
    if (_gameOver) {
      // Time ran out - calculate stars based on progress
      final pairsFound = _matchedPairs.length;
      final totalPairs = _numbers.length ~/ 2;
      
      if (pairsFound >= totalPairs) {
        _stars = 3;
      } else if (pairsFound >= totalPairs / 2) {
        _stars = 2;
      } else if (pairsFound > 0) {
        _stars = 1;
      }
      
      ref.read(additionLearningProvider.notifier)
         .completeActivity('/learning/addition/number_friends', _stars);
    }
  }
  
  void _restartGame() {
    setState(() {
      _level = 1;
      _score = 0;
      _gameOver = false;
      _levelComplete = false;
      _initializeGame();
      _startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
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
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: colorScheme.primary,
                          size: 28,
                        ),
                      ),
                      Text(
                        'Number Friends',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Show help dialog
                          _showHelpDialog();
                        },
                        icon: Icon(
                          Icons.help_rounded,
                          color: colorScheme.primary,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),

                // Game status area
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      // Target sum
                      Expanded(
                        child: _buildStatusCard(
                          title: 'Target',
                          value: '$_targetSum',
                          color: Colors.blue,
                          icon: Icons.add_circle_outline,
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Score
                      Expanded(
                        child: _buildStatusCard(
                          title: 'Score',
                          value: '$_score',
                          color: Colors.green,
                          icon: Icons.star_outline,
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Time left
                      Expanded(
                        child: _buildStatusCard(
                          title: 'Time',
                          value: '$_timeLeft',
                          color: _timeLeft > 10 ? Colors.orange : Colors.red,
                          icon: Icons.timer_outlined,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Level indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Text(
                        'Level $_level',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      
                      // Level bullets
                      Row(
                        children: List.generate(3, (index) {
                          return Container(
                            width: 12,
                            height: 12,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index < _level ? colorScheme.primary : colorScheme.primary.withOpacity(0.2),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Game instruction
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Find pairs of numbers that add up to $_targetSum',
                    style: textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Game grid
                Expanded(
                  child: _gameOver || _levelComplete
                      ? _buildGameOverScreen()
                      : _buildNumberGrid(),
                ),
              ],
            ),
          ),
          
          // Confetti overlay for completion
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2, // straight down
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              maxBlastForce: 20,
              minBlastForce: 10,
              gravity: 0.1,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.yellow,
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatusCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black12 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNumberGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: _numbers.length,
        itemBuilder: (context, index) {
          // Check if this number is already matched
          final isMatched = _matchedPairs.any(
            (pair) => pair.contains(index),
          );
          
          // Check if this is the currently selected number
          final isSelected = _selectedNumber == index;
          
          return _buildNumberCard(
            number: _numbers[index],
            isMatched: isMatched,
            isSelected: isSelected,
            onTap: isMatched ? null : () => _checkForMatch(index),
          );
        },
      ),
    );
  }
  
  Widget _buildNumberCard({
    required int number,
    required bool isMatched,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    
    // Determine card color based on state
    Color cardColor;
    if (isMatched) {
      cardColor = Colors.green;
    } else if (isSelected) {
      cardColor = colorScheme.primary;
    } else {
      cardColor = isDarkMode ? Colors.grey[800]! : Colors.white;
    }
    
    // Determine text color
    final textColor = isMatched || isSelected ? Colors.white : (isDarkMode ? Colors.white : Colors.black);
    
    return AnimatedBuilder(
      animation: isSelected ? _scaleAnimation : _shakeAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isSelected ? 1.0 + (_scaleAnimation.value * 0.1) : 1.0,
          child: Transform.translate(
            offset: isSelected ? Offset.zero : 
                   (_selectedNumber != null && !isMatched) ? 
                   Offset(sin(_shakeAnimation.value * 2 * pi) * 5, 0) : 
                   Offset.zero,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: isSelected ? Colors.yellow : cardColor,
              width: isSelected ? 3 : 1,
            ),
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildGameOverScreen() {
    final textTheme = Theme.of(context).textTheme;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Game result title
          Text(
            _levelComplete ? 'Level Complete!' : 'Game Over',
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _levelComplete ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 24),
          
          // Score and stars
          Text(
            'Score: $_score',
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          
          // Star rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Icon(
                index < _stars ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 40,
              );
            }),
          ),
          const SizedBox(height: 24),
          
          // Game stats
          _buildStatCard('Pairs Found', '${_matchedPairs.length}/${_numbers.length ~/ 2}'),
          const SizedBox(height: 8),
          _buildStatCard('Time Left', '$_timeLeft seconds'),
          const SizedBox(height: 32),
          
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Back to home button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.home),
                label: const Text('Home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              const SizedBox(width: 16),
              
              // Play again button
              ElevatedButton.icon(
                onPressed: _restartGame,
                icon: const Icon(Icons.replay),
                label: const Text('Play Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatCard(String title, String value) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800]!.withOpacity(0.5) : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
  
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Play'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHelpItem(
                icon: Icons.touch_app,
                text: 'Tap two numbers that add up to $_targetSum',
              ),
              const SizedBox(height: 12),
              _buildHelpItem(
                icon: Icons.check_circle_outline,
                text: 'When numbers match, they will turn green',
              ),
              const SizedBox(height: 12),
              _buildHelpItem(
                icon: Icons.timer,
                text: 'Complete the level before time runs out',
              ),
              const SizedBox(height: 12),
              _buildHelpItem(
                icon: Icons.star,
                text: 'Earn up to 3 stars based on your score',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got It!'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHelpItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text),
        ),
      ],
    );
  }
}
