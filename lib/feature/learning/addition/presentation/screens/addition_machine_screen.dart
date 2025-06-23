import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/addition_learning_provider.dart';
import 'dart:math';
import 'dart:async';
import 'package:confetti/confetti.dart';

class AdditionMachineScreen extends ConsumerStatefulWidget {
  const AdditionMachineScreen({super.key});

  @override
  ConsumerState<AdditionMachineScreen> createState() => _AdditionMachineScreenState();
}

class _AdditionMachineScreenState extends ConsumerState<AdditionMachineScreen> with TickerProviderStateMixin {
  // Game state
  int _level = 1;
  int _score = 0;
  int _correctAnswers = 0;
  int _totalQuestions = 0;
  int _stars = 0;
  bool _gameActive = true;
  
  // Current problem
  late int _num1;
  late int _num2;
  late int _correctAnswer;
  late List<int> _answerOptions;
  
  // Animation controllers
  late AnimationController _machineAnimation;
  late AnimationController _numberDropAnimation;
  late AnimationController _resultAnimation;
  late ConfettiController _confettiController;
  
  // Animation values
  bool _isProcessing = false;
  bool _showResult = false;
  bool _isCorrect = false;
  
  // Number limits based on level
  late int _maxNumber;

  @override
  void initState() {
    super.initState();
    
    _machineAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _numberDropAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    _resultAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    
    _initializeLevel();
    _generateProblem();
  }
  
  @override
  void dispose() {
    _machineAnimation.dispose();
    _numberDropAnimation.dispose();
    _resultAnimation.dispose();
    _confettiController.dispose();
    super.dispose();
  }
  
  void _initializeLevel() {
    // Set difficulty based on level
    switch (_level) {
      case 1:
        _maxNumber = 5; // Numbers up to 5
        break;
      case 2:
        _maxNumber = 10; // Numbers up to 10
        break;
      case 3:
        _maxNumber = 20; // Numbers up to 20
        break;
    }
  }
  
  void _generateProblem() {
    final random = Random();
    
    // Generate two random numbers based on current level
    _num1 = random.nextInt(_maxNumber) + 1;
    _num2 = random.nextInt(_maxNumber) + 1;
    _correctAnswer = _num1 + _num2;
    
    // Generate answer options
    _answerOptions = _generateAnswerOptions();
    
    // Reset animation states
    _isProcessing = false;
    _showResult = false;
    setState(() {});
  }
  
  List<int> _generateAnswerOptions() {
    final random = Random();
    final options = <int>{_correctAnswer};
    
    // Generate 3 unique wrong answers
    while (options.length < 4) {
      // Generate values within a reasonable range of the correct answer
      int wrongAnswer;
      if (random.nextBool()) {
        // Add a small number to the correct answer
        wrongAnswer = _correctAnswer + random.nextInt(5) + 1;
      } else {
        // Subtract a small number from the correct answer, but ensure it's positive
        wrongAnswer = max(1, _correctAnswer - random.nextInt(5) - 1);
      }
      
      // Only add if it's not the correct answer
      if (wrongAnswer != _correctAnswer) {
        options.add(wrongAnswer);
      }
    }
    
    // Convert to list and shuffle
    final optionsList = options.toList();
    optionsList.shuffle();
    return optionsList;
  }
  
  void _processAnswer(int selectedAnswer) {
    if (_isProcessing) return; // Prevent multiple selections
    
    setState(() {
      _isProcessing = true;
    });
    
    // Start machine animation
    _machineAnimation.reset();
    _machineAnimation.forward();
    
    // Animate numbers dropping
    _numberDropAnimation.reset();
    _numberDropAnimation.forward();
    
    // Determine if the answer is correct
    _isCorrect = selectedAnswer == _correctAnswer;
    
    // Update score and stats
    _totalQuestions++;
    if (_isCorrect) {
      _score += (_level * 10);
      _correctAnswers++;
    }
    
    // Show result after a delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _showResult = true;
      });
      
      _resultAnimation.reset();
      _resultAnimation.forward();
      
      // If correct, possibly trigger confetti
      if (_isCorrect && (_correctAnswers % 5 == 0)) { // Every 5 correct answers
        _confettiController.play();
      }
      
      // Move to next level if enough correct answers
      if (_correctAnswers == 10 && _level < 3) {
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _level++;
            _initializeLevel();
          });
          _generateProblem();
        });
      }
      // Check for game completion
      else if (_correctAnswers >= 30 || _totalQuestions >= 40) {
        _gameActive = false;
        _calculateStars();
        _confettiController.play();
      }
      // Otherwise, generate a new problem after delay
      else {
        Future.delayed(const Duration(seconds: 2), () {
          _generateProblem();
        });
      }
    });
  }
  
  void _calculateStars() {
    // Calculate stars based on correct answers ratio
    final accuracy = _correctAnswers / _totalQuestions;
    
    if (accuracy >= 0.9) {
      _stars = 3;
    } else if (accuracy >= 0.7) {
      _stars = 2;
    } else if (accuracy >= 0.5) {
      _stars = 1;
    }
    
    // Update provider with stars earned
    ref.read(additionLearningProvider.notifier)
       .completeActivity('/learning/addition/addition_machine', _stars);
  }
  
  void _resetGame() {
    setState(() {
      _level = 1;
      _score = 0;
      _correctAnswers = 0;
      _totalQuestions = 0;
      _gameActive = true;
      
      _initializeLevel();
      _generateProblem();
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
                        'Addition Machine',
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
                      // Level indicator
                      Expanded(
                        child: _buildStatusCard(
                          title: 'Level',
                          value: '$_level',
                          color: Colors.purple,
                          icon: Icons.trending_up,
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Score
                      Expanded(
                        child: _buildStatusCard(
                          title: 'Score',
                          value: '$_score',
                          color: Colors.green,
                          icon: Icons.star,
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Correct count
                      Expanded(
                        child: _buildStatusCard(
                          title: 'Correct',
                          value: '$_correctAnswers',
                          color: Colors.blue,
                          icon: Icons.check_circle,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Main game content
                Expanded(
                  child: _gameActive
                      ? _buildGameContent()
                      : _buildGameCompleteScreen(),
                ),
              ],
            ),
          ),
          
          // Confetti overlay
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
  
  Widget _buildGameContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Problem statement
          Text(
            'Feed these numbers to the machine:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          
          // Number inputs
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNumberBubble(_num1, Colors.blue),
              const SizedBox(width: 16),
              const Icon(Icons.add, size: 32),
              const SizedBox(width: 16),
              _buildNumberBubble(_num2, Colors.green),
            ],
          ),
          const SizedBox(height: 24),
          
          // The machine
          Expanded(
            flex: 3,
            child: _buildAdditionMachine(),
          ),
          
          // Answer options
          Expanded(
            flex: 2,
            child: _showResult 
                ? _buildResultDisplay()
                : _buildAnswerOptions(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNumberBubble(int number, Color color) {
    return AnimatedBuilder(
      animation: _numberDropAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: _isProcessing 
              ? Offset(0, _numberDropAnimation.value * 100)
              : Offset.zero,
          child: Opacity(
            opacity: _isProcessing
                ? 1.0 - _numberDropAnimation.value
                : 1.0,
            child: child,
          ),
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: color,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '$number',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildAdditionMachine() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final machineWidth = constraints.maxWidth * 0.9;
        final machineHeight = constraints.maxHeight * 0.9;
        
        return Stack(
          alignment: Alignment.center,
          children: [
            // Machine body
            AnimatedBuilder(
              animation: _machineAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_machineAnimation.value * 0.05),
                  child: child,
                );
              },
              child: Container(
                width: machineWidth,
                height: machineHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDarkMode
                        ? [Colors.grey[850]!, Colors.grey[900]!]
                        : [Colors.orange[300]!, Colors.orange[400]!],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(
                    color: isDarkMode 
                        ? Colors.grey[700]!
                        : Colors.orange[600]!,
                    width: 4,
                  ),
                ),
                child: Column(
                  children: [
                    // Machine input funnel
                    Container(
                      height: 40,
                      width: machineWidth * 0.4,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[700] : Colors.orange[500],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),
                    
                    Expanded(
                      child: Center(
                        child: Text(
                          _isProcessing ? 'PROCESSING...' : 'Ready!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    
                    // Machine output slot
                    Container(
                      height: 50,
                      width: machineWidth * 0.7,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.orange[200],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        border: Border.all(
                          color: isDarkMode ? Colors.grey[700]! : Colors.orange[300]!,
                          width: 2,
                        ),
                      ),
                      child: _showResult
                          ? Center(
                              child: AnimatedBuilder(
                                animation: _resultAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _resultAnimation.value,
                                    child: Text(
                                      '$_correctAnswer',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            
            // Machine gears and decorations
            Positioned(
              top: machineHeight * 0.2,
              left: machineWidth * 0.15,
              child: _buildGear(40, Colors.grey, _machineAnimation),
            ),
            
            Positioned(
              top: machineHeight * 0.3,
              right: machineWidth * 0.15,
              child: _buildGear(30, Colors.grey, _machineAnimation, reverse: true),
            ),
            
            // Display panel
            if (_isProcessing)
              Positioned(
                top: machineHeight * 0.35,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    '$_num1 + $_num2 = ?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.green : Colors.purple,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
  
  Widget _buildGear(double size, Color color, Animation<double> animation, {bool reverse = false}) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: reverse 
              ? -animation.value * 2 * pi
              : animation.value * 2 * pi,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
            child: Center(
              child: Container(
                width: size * 0.3,
                height: size * 0.3,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildAnswerOptions() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _answerOptions.length,
      itemBuilder: (context, index) {
        return _buildAnswerButton(_answerOptions[index]);
      },
    );
  }
  
  Widget _buildAnswerButton(int answer) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return ElevatedButton(
      onPressed: _isProcessing ? null : () => _processAnswer(answer),
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        elevation: 3,
      ),
      child: Text(
        answer.toString(),
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildResultDisplay() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _isCorrect ? 'Correct!' : 'Not Quite Right!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: _isCorrect ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$_num1 + $_num2 = $_correctAnswer',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Next button or instruction
          if (_gameActive)
            Text(
              'Next problem coming up...',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildGameCompleteScreen() {
    final textTheme = Theme.of(context).textTheme;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Game complete title
          Text(
            'Addition Master!',
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 24),
          
          // Score and stats
          Text(
            'Final Score: $_score',
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
          _buildStatCard('Correct Answers', '$_correctAnswers out of $_totalQuestions'),
          const SizedBox(height: 8),
          _buildStatCard(
            'Accuracy', 
            '${(_correctAnswers / _totalQuestions * 100).toStringAsFixed(1)}%',
          ),
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
                onPressed: _resetGame,
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800]!.withOpacity(0.5) : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$title: ',
            style: TextStyle(fontWeight: FontWeight.bold),
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
                icon: Icons.calculate,
                text: 'Feed numbers to the addition machine',
              ),
              const SizedBox(height: 12),
              _buildHelpItem(
                icon: Icons.touch_app,
                text: 'Tap the correct answer after processing',
              ),
              const SizedBox(height: 12),
              _buildHelpItem(
                icon: Icons.trending_up,
                text: 'Progress through 3 levels of difficulty',
              ),
              const SizedBox(height: 12),
              _buildHelpItem(
                icon: Icons.star,
                text: 'Earn stars based on your accuracy',
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
