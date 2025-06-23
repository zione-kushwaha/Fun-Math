import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/addition_learning_provider.dart';
import 'dart:math';
import 'dart:async';
import 'package:confetti/confetti.dart';

class TenFrameScreen extends ConsumerStatefulWidget {
  const TenFrameScreen({super.key});

  @override
  ConsumerState<TenFrameScreen> createState() => _TenFrameScreenState();
}

class _TenFrameScreenState extends ConsumerState<TenFrameScreen> with TickerProviderStateMixin {
  // Lesson state
  int _currentPage = 0;
  bool _lessonCompleted = false;
  
  // Animation controllers
  late final AnimationController _bounceAnimation;
  late final AnimationController _fadeAnimation;
  late final PageController _pageController;
  late final ConfettiController _confettiController;

  // Practice state
  int? _selectedAnswer;
  bool _isCorrectAnswer = false;
  bool _showResult = false;
  
  // Ten frame problems
  final List<TenFrameProblem> _problems = [
    TenFrameProblem(leftCount: 5, rightCount: 3),
    TenFrameProblem(leftCount: 4, rightCount: 6),
    TenFrameProblem(leftCount: 7, rightCount: 2),
    TenFrameProblem(leftCount: 2, rightCount: 8),
    TenFrameProblem(leftCount: 6, rightCount: 4),
  ];

  @override
  void initState() {
    super.initState();
    
    _pageController = PageController();
    
    _bounceAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _fadeAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bounceAnimation.dispose();
    _fadeAnimation.dispose();
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
                        'Ten Frame Fun',
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
                      
                      // Check if we've reached the last page for completion
                      if (_currentPage == _lessonPages.length - 1) {
                        _confettiController.play();
                        setState(() {
                          _lessonCompleted = true;
                        });
                        
                        // Complete the lesson in provider
                        ref.read(additionLearningProvider.notifier)
                           .completeLesson("Ten Frame Fun");
                           
                        // Give 2 stars for completing this lesson
                        ref.read(additionLearningProvider.notifier)
                           .completeActivity("/learning/addition/ten_frame", 2);
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
        // Introduction page
        _buildIntroductionPage(),
        
        // What is a Ten Frame
        _buildWhatIsPage(),
        
        // How Ten Frames Help Addition
        _buildHowItHelpsPage(),
        
        // Example Page
        _buildExamplePage(),
        
        // Interactive practice
        _buildPracticePage(),
        
        // Completion page
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
            'assets/learning/addition/ten_frame.png',
            height: 180,
            errorBuilder: (context, error, stackTrace) => _buildCharacter(180),
          ),
          const SizedBox(height: 24),
          Text(
            "Ten Frames!",
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "A ten frame is a simple tool that helps us understand numbers and addition.",
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
                    "Ten frames make addition easier by helping us visualize numbers!",
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

  Widget _buildWhatIsPage() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What is a Ten Frame?",
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          
          // Ten frame visualization
          Center(
            child: Container(
              width: 300,
              height: 150,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (index) => _buildTenFrameCell(index < 3)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (index) => _buildTenFrameCell(false)),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text(
            "A ten frame is a 2 by 5 grid with 10 boxes total.",
            style: textTheme.titleMedium?.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            "We use counters or dots to show numbers from 1 to 10. Each counter represents 1.",
            style: textTheme.titleMedium?.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white10 : Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode ? Colors.white24 : Colors.purple.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              "The example above shows 3 counters, representing the number 3.",
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white70 : Colors.purple[800],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItHelpsPage() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "How Ten Frames Help Addition",
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          
          Text(
            "Ten frames help us see:",
            style: textTheme.titleMedium?.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildPointItem(
            icon: Icons.looks_one,
            text: "How many counters are there (the number itself)",
            color: colorScheme.primary,
          ),
          const SizedBox(height: 8),
          
          _buildPointItem(
            icon: Icons.looks_two,
            text: "How many more to make 10 (the empty spaces)",
            color: Colors.orange,
          ),
          const SizedBox(height: 8),
          
          _buildPointItem(
            icon: Icons.looks_3,
            text: "The relationship between numbers (like 7 is 5 + 2)",
            color: Colors.green,
          ),
          
          const SizedBox(height: 24),
          
          // Ten frame example for addition
          Center(
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black12 : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDarkMode ? Colors.white24 : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSmallTenFrame([true, true, true, false, false], [false, false, false, false, false], Colors.blue),
                      const Text("+", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      _buildSmallTenFrame([false, false, false, false, false], [true, true, false, false, false], Colors.green),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "3 + 2 = 5",
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamplePage() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Addition with Ten Frames",
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            "Ten frames help us break numbers into parts and see the sum more easily.",
            style: textTheme.titleMedium?.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          
          // Example with animation
          Center(
            child: Column(
              children: [
                // First frame shows 4
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      _buildFullTenFrame([true, true, true, true, false], [false, false, false, false, false], Colors.blue),
                      const SizedBox(height: 8),
                      Text("4 counters", style: textTheme.bodyLarge),
                    ],
                  ),
                ),
                
                const Icon(Icons.add, size: 32),
                const SizedBox(height: 16),
                
                // Second frame shows 5
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      _buildFullTenFrame([true, true, true, true, true], [false, false, false, false, false], Colors.green),
                      const SizedBox(height: 8),
                      Text("5 counters", style: textTheme.bodyLarge),
                    ],
                  ),
                ),
                
                const Icon(Icons.drag_handle, size: 32),
                const SizedBox(height: 16),
                
                // Result frame shows 9
                AnimatedBuilder(
                  animation: _bounceAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _bounceAnimation.value * 5),
                      child: child,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.purple,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        _buildFullTenFrame([true, true, true, true, true], [true, true, true, true, false], Colors.purple),
                        const SizedBox(height: 8),
                        Text(
                          "9 counters in total",
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ],
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

  Widget _buildPracticePage() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Get a random problem from our list
    final problem = _problems[_currentPage % _problems.length];
    final correctAnswer = problem.leftCount + problem.rightCount;
    
    // Generate answer options
    final answers = [correctAnswer];
    while (answers.length < 4) {
      final randomOffset = Random().nextInt(5) - 2; // -2 to +2
      final newAnswer = correctAnswer + randomOffset;
      if (newAnswer > 0 && newAnswer <= 20 && !answers.contains(newAnswer)) {
        answers.add(newAnswer);
      }
    }
    answers.shuffle();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            "Count the dots in each ten frame and find the sum.",
            style: textTheme.titleMedium?.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.black87,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),
          
          // Problem display
          Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildMediumTenFrame(problem.leftFilledRow1, problem.leftFilledRow2, Colors.blue),
                    const SizedBox(width: 12),
                    const Text("+", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    _buildMediumTenFrame(problem.rightFilledRow1, problem.rightFilledRow2, Colors.green),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Answer options
                _showResult
                    ? _buildResultWidget(correctAnswer)
                    : GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 2.5,
                        children: answers.map((answer) {
                          return ElevatedButton(
                            onPressed: _showResult
                                ? null
                                : () => _checkAnswer(answer, correctAnswer),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedAnswer == answer
                                  ? colorScheme.primary
                                  : isDarkMode ? Colors.grey[800] : Colors.white,
                              foregroundColor: _selectedAnswer == answer
                                  ? Colors.white
                                  : isDarkMode ? Colors.white : Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              answer.toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
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
            "Great Job!",
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.amber : Colors.orange,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "You've learned how to use ten frames for addition!",
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
                  text: "What a ten frame is and how it works",
                ),
                const SizedBox(height: 8),
                _buildLearningPoint(
                  icon: Icons.check_circle,
                  text: "How to add numbers using ten frames",
                ),
                const SizedBox(height: 8),
                _buildLearningPoint(
                  icon: Icons.check_circle,
                  text: "Visualizing numbers from 1 to 10",
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Stars earned
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Icon(
                index < 2 ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 32,
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            "2 Stars Earned!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTenFrameCell(bool filled) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[700] : Colors.white,
        border: Border.all(
          color: isDarkMode ? Colors.white54 : Colors.black54,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: filled
          ? Center(
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildFullTenFrame(List<bool> topRow, List<bool> bottomRow, Color dotColor) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return _buildFrameCell(topRow[index], dotColor);
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return _buildFrameCell(bottomRow[index], dotColor);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMediumTenFrame(List<bool> topRow, List<bool> bottomRow, Color dotColor) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[700] : Colors.white,
                  border: Border.all(
                    color: isDarkMode ? Colors.white54 : Colors.black54,
                    width: 1,
                  ),
                ),
                child: topRow[index]
                    ? Center(
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: dotColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              );
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[700] : Colors.white,
                  border: Border.all(
                    color: isDarkMode ? Colors.white54 : Colors.black54,
                    width: 1,
                  ),
                ),
                child: bottomRow[index]
                    ? Center(
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: dotColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallTenFrame(List<bool> topRow, List<bool> bottomRow, Color dotColor) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[700] : Colors.white,
                  border: Border.all(
                    color: isDarkMode ? Colors.white54 : Colors.black54,
                    width: 1,
                  ),
                ),
                child: topRow[index]
                    ? Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: dotColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              );
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[700] : Colors.white,
                  border: Border.all(
                    color: isDarkMode ? Colors.white54 : Colors.black54,
                    width: 1,
                  ),
                ),
                child: bottomRow[index]
                    ? Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: dotColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFrameCell(bool filled, Color dotColor) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: 35,
      height: 35,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[700] : Colors.white,
        border: Border.all(
          color: isDarkMode ? Colors.white54 : Colors.black54,
          width: 1,
        ),
      ),
      child: filled
          ? Center(
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildPointItem({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }

  void _checkAnswer(int answer, int correctAnswer) {
    setState(() {
      _selectedAnswer = answer;
      _isCorrectAnswer = answer == correctAnswer;
      _showResult = true;
    });
    
    _fadeAnimation.reset();
    _fadeAnimation.forward();
    
    if (_isCorrectAnswer) {
      _confettiController.play();
    }
    
    // After a delay, allow moving to the next page
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        // Reset for next time we visit this page
        _showResult = false;
        _selectedAnswer = null;
      });
      
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Widget _buildResultWidget(int correctAnswer) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isCorrectAnswer ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isCorrectAnswer ? Colors.green : Colors.red,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              _isCorrectAnswer ? Icons.check_circle : Icons.cancel,
              color: _isCorrectAnswer ? Colors.green : Colors.red,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              _isCorrectAnswer ? "Correct!" : "Not quite right",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _isCorrectAnswer ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "The answer is $correctAnswer",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildCharacter(double height, {bool isHappy = false}) {
    return Container(
      width: height,
      height: height,
      decoration: BoxDecoration(
        color: Colors.blue,
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
        ],
      ),
    );
  }
  
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Ten Frames'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ten frames are a powerful visual tool to help understand numbers and addition.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildHelpItem(
                icon: Icons.grid_on,
                text: 'A ten frame is a 2×5 grid with 10 cells total',
              ),
              const SizedBox(height: 12),
              _buildHelpItem(
                icon: Icons.circle,
                text: 'Each filled circle represents the number 1',
              ),
              const SizedBox(height: 12),
              _buildHelpItem(
                icon: Icons.add_circle,
                text: 'To add numbers, count all the filled circles from both frames',
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

// Helper class to store ten frame problem
class TenFrameProblem {
  final int leftCount;
  final int rightCount;
  
  TenFrameProblem({required this.leftCount, required this.rightCount});
  
  List<bool> get leftFilledRow1 => List.generate(5, (index) => index < min(leftCount, 5));
  List<bool> get leftFilledRow2 => List.generate(5, (index) => leftCount > 5 && index < (leftCount - 5));
  
  List<bool> get rightFilledRow1 => List.generate(5, (index) => index < min(rightCount, 5));
  List<bool> get rightFilledRow2 => List.generate(5, (index) => rightCount > 5 && index < (rightCount - 5));
}
