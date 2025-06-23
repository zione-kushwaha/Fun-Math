import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/addition_learning_provider.dart';
import '../widgets/animated_addition_visual.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class CountingAdventureScreen extends ConsumerStatefulWidget {
  const CountingAdventureScreen({super.key});

  @override
  ConsumerState<CountingAdventureScreen> createState() => _CountingAdventureScreenState();
}

class _CountingAdventureScreenState extends ConsumerState<CountingAdventureScreen> with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _characterAnimation;
  late final AnimationController _bounceAnimation;
  late final ConfettiController _confettiController;
  int _currentPage = 0;  // Flag to track animation and UI state changes when lesson is completed
  bool _lessonCompleted = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    _characterAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _bounceAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _characterAnimation.dispose();
    _bounceAnimation.dispose();
    _confettiController.dispose();
    super.dispose();
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
                        'Counting Adventure',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Show help dialog
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

                // Page indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      for (int i = 0; i < _lessonPages.length; i++)
                        Expanded(
                          child: Container(
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: i <= _currentPage
                                  ? colorScheme.primary
                                  : colorScheme.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Main content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page;
                      });
                      
                      // Animation trigger for character jumping
                      if (_currentPage == 1 || _currentPage == 3) {
                        _characterAnimation.reset();
                        _characterAnimation.forward();
                      }
                      
                      // Show confetti on lesson completion
                      if (_currentPage == _lessonPages.length - 1) {
                        _confettiController.play();
                        setState(() {
                          _lessonCompleted = true;
                        });
                        
                        // Complete the lesson in state
                        ref.read(additionLearningProvider.notifier)
                           .completeLesson("Counting Adventure");
                      }
                    },
                    itemCount: _lessonPages.length,
                    itemBuilder: (context, index) {
                      return _lessonPages[index];
                    },
                  ),
                ),

                // Navigation buttons
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage > 0)
                        OutlinedButton.icon(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Previous'),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 100),
                      _currentPage < _lessonPages.length - 1
                          ? ElevatedButton.icon(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              icon: const Text('Next'),
                              label: const Icon(Icons.arrow_forward),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Text('Finish'),
                              label: const Icon(Icons.check),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                    ],
                  ),
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

  // Lesson pages
  List<Widget> get _lessonPages => [
        // Page 1: Introduction
        _buildIntroductionPage(),
        
        // Page 2: Basic Counting
        _buildCountingPage(),
        
        // Page 3: Adding Objects
        _buildAddingObjectsPage(),
        
        // Page 4: Number Line
        _buildNumberLinePage(),
        
        // Page 5: Practice
        _buildPracticePage(),

        // Page 6: Completion
        _buildCompletionPage(),
      ];

  Widget _buildIntroductionPage() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/learning/addition/intro_character.png',
            height: 180,
            errorBuilder: (context, error, stackTrace) => _buildCharacter(180),
          ),
          const SizedBox(height: 24),
          Text(
            "Let's Learn Addition!",
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "Addition is about combining groups and counting them all together.",
            style: textTheme.titleMedium?.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white10 : Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode ? Colors.white24 : Colors.blue.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb,
                  color: Colors.amber,
                  size: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "When you add numbers together, you're finding the total!",
                    style: textTheme.bodyLarge?.copyWith(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountingPage() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            "Counting Objects",
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Let's count some apples together!",
            style: textTheme.titleMedium?.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // First group (2 apples)
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        for (int i = 0; i < 2; i++)
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset(
                              'assets/learning/addition/apple.png',
                              height: 40,
                              errorBuilder: (context, error, stackTrace) => _buildApple(Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "2 apples",
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(width: 16),
              
              // Plus sign
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "+",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Second group (3 apples)
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        for (int i = 0; i < 3; i++)
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset(
                              'assets/learning/addition/apple.png',
                              height: 40,
                              errorBuilder: (context, error, stackTrace) => _buildApple(Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "3 apples",
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Equals sign and result
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    "=",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        for (int i = 0; i < 5; i++)
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset(
                              'assets/learning/addition/apple.png',
                              height: 40,
                              errorBuilder: (context, error, stackTrace) => _buildApple(Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "5 apples in total",
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.amber.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              "2 apples + 3 apples = 5 apples",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.amber : Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddingObjectsPage() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            "Adding Different Objects",
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "We can add any objects together, not just the same kind!",
            style: textTheme.titleMedium?.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Interactive animated addition
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [Colors.purple.withOpacity(0.3), Colors.blue.withOpacity(0.2)]
                    : [Colors.purple.withOpacity(0.1), Colors.blue.withOpacity(0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
              ),
            ),
            child: Column(
              children: [
                Text(
                  "Drag objects to count them together",
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Center(
                    child: AnimatedAdditionVisual(), // This would be the interactive widget
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Example equations
          _buildEquationCard(context, "3", "2", "5"),
          const SizedBox(height: 12),
          _buildEquationCard(context, "4", "1", "5"),
          const SizedBox(height: 12),
          _buildEquationCard(context, "0", "5", "5"),
        ],
      ),
    );
  }

  Widget _buildNumberLinePage() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            "Adding on a Number Line",
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Think of addition as jumping forward on a number line!",
            style: textTheme.titleMedium?.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Number line visualization
          Container(
            height: 160,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white10 : Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      // Number line
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 4,
                          color: colorScheme.primary.withOpacity(0.5),
                        ),
                      ),
                      
                      // Number markers
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(11, (index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 2,
                                height: 16,
                                color: colorScheme.primary.withOpacity(0.5),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                index.toString(),
                                style: TextStyle(
                                  fontWeight: index == 3 || index == 5 || index == 8
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: index == 3 || index == 5 || index == 8
                                      ? colorScheme.primary
                                      : isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                      
                      // Jumps/Arrows for 3 + 5 = 8
                      Positioned(
                        top: 40,
                        left: 3 * MediaQuery.of(context).size.width / 11 - 10,
                        child: Column(
                          children: [
                            const Icon(
                              Icons.arrow_drop_up,
                              color: Colors.green,
                              size: 30,
                            ),
                            Text(
                              "Start",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      Positioned(
                        top: 20,
                        left: 3.5 * MediaQuery.of(context).size.width / 11,
                        child: Container(
                          width: 5 * MediaQuery.of(context).size.width / 11 - 20,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 2,
                                  color: Colors.orange,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.orange,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      Positioned(
                        top: 10,
                        left: 4.5 * MediaQuery.of(context).size.width / 11,
                        child: Text(
                          "Jump 5 spaces",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      Positioned(
                        top: 40,
                        left: 8 * MediaQuery.of(context).size.width / 11 - 10,
                        child: Column(
                          children: [
                            const Icon(
                              Icons.arrow_drop_up,
                              color: Colors.red,
                              size: 30,
                            ),
                            Text(
                              "End",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                Text(
                  "3 + 5 = 8",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Tips for number line
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white10 : Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode ? Colors.white24 : Colors.blue.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Number Line Tips:",
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTipRow("Start at the first number (3)"),
                const SizedBox(height: 4),
                _buildTipRow("Jump forward by the second number (5 spaces)"),
                const SizedBox(height: 4),
                _buildTipRow("Where you land is your answer (8)"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticePage() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            "Let's Practice!",
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Try solving these addition problems:",
            style: textTheme.titleMedium?.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Practice problems
          _buildInteractiveProblem(context, "2", "2", "4"),
          const SizedBox(height: 16),
          _buildInteractiveProblem(context, "3", "4", "7"),
          const SizedBox(height: 16),
          _buildInteractiveProblem(context, "5", "5", "10"),
          
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.green.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Great job practicing addition! Remember: addition is about combining groups and counting the total.",
                    style: textTheme.bodyMedium?.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionPage() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/learning/addition/victory_character.png',
            height: 180,
            errorBuilder: (context, error, stackTrace) => _buildCharacter(180, isHappy: true),
          ),
          const SizedBox(height: 24),
          Text(
            "Congratulations!",
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.amber : Colors.orange,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "You've completed the Counting Adventure lesson and learned the basics of addition!",
            style: textTheme.titleMedium?.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  "What You Learned:",
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildLearningPoint(
                  icon: Icons.check_circle,
                  text: "Addition means combining groups and counting the total",
                ),
                const SizedBox(height: 8),
                _buildLearningPoint(
                  icon: Icons.check_circle,
                  text: "Using a number line to visualize addition",
                ),
                const SizedBox(height: 8),
                _buildLearningPoint(
                  icon: Icons.check_circle,
                  text: "Solving simple addition problems",
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Unlock the next activity
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Play Number Friends Game",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.sports_esports),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquationCard(BuildContext context, String a, String b, String result) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white10 : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNumberCircle(a, Colors.blue),
          const SizedBox(width: 12),
          Icon(
            Icons.add,
            color: colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          _buildNumberCircle(b, Colors.green),
          const SizedBox(width: 12),
          Icon(
            Icons.drag_handle,
            color: Colors.orange,
            size: 24,
          ),
          const SizedBox(width: 12),
          _buildNumberCircle(result, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildNumberCircle(String number, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.2),
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildTipRow(String text) {
    return Row(
      children: [
        const Icon(
          Icons.arrow_right,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text),
        ),
      ],
    );
  }

  Widget _buildInteractiveProblem(
    BuildContext context,
    String a,
    String b,
    String result,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white10 : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNumberCircle(a, Colors.blue),
              const SizedBox(width: 16),
              Icon(
                Icons.add,
                color: colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 16),
              _buildNumberCircle(b, Colors.green),
              const SizedBox(width: 16),
              Icon(
                Icons.drag_handle,
                color: Colors.orange,
                size: 24,
              ),
              const SizedBox(width: 16),
              Container(
                width: 40,
                height: 40,                  decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple.withOpacity(0.2),
                  border: Border.all(
                    color: Colors.purple,
                    width: isDarkMode ? 1 : 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Center(
                  child: Text(
                    "?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Option buttons
              _buildAnswerOption(context, result, true), // Correct
              const SizedBox(width: 16),
              _buildAnswerOption(context, (int.parse(result) + 1).toString(), false), // Wrong
              const SizedBox(width: 16),
              _buildAnswerOption(context, (int.parse(result) - 1).toString(), false), // Wrong
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerOption(BuildContext context, String answer, bool isCorrect) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return ElevatedButton(
      onPressed: () {
        // Show correct/wrong feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isCorrect ? 'Correct!' : 'Try again!',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: isCorrect ? Colors.green : Colors.red,
            duration: const Duration(milliseconds: 1000),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? Colors.white24 : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        answer,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCharacter(double height, {bool isHappy = false}) {
    return Container(
      width: height,
      height: height,
      decoration: BoxDecoration(
        color: Colors.amber,
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: [
          // Face
          Center(
            child: Container(
              width: height * 0.7,
              height: height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Eyes
          Positioned(
            top: height * 0.35,
            left: height * 0.3,
            child: Container(
              width: height * 0.12,
              height: height * 0.12,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          Positioned(
            top: height * 0.35,
            right: height * 0.3,
            child: Container(
              width: height * 0.12,
              height: height * 0.12,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Smile
          Positioned(
            bottom: height * 0.25,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: height * 0.4,
                height: isHappy ? height * 0.2 : height * 0.1,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black,
                      width: height * 0.04,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(height * 0.1),
                ),
              ),
            ),
          ),
          
          // Animation for happy face
          if (isHappy)
            Positioned(
              top: height * 0.15,
              left: height * 0.25,
              right: height * 0.25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.pink,
                    size: height * 0.15,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.blue,
                    size: height * 0.15,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildApple(Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.circle,
          color: color,
          size: 40,
        ),
        Positioned(
          top: 0,
          child: Icon(
            Icons.eco,
            color: Colors.green,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildLearningPoint({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.green, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text),
        ),
      ],
    );
  }
}
