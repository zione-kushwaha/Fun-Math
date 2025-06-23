import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fun_math/feature/games/math_race/feature/mental_arithmetic/domain/model/mental_arithmetic.dart';

class MentalArithmeticQuestionView extends StatefulWidget {
  final MentalArithmetic currentProblem;

  const MentalArithmeticQuestionView({Key? key, required this.currentProblem})
    : super(key: key);

  @override
  _MentalArithmeticQuestionViewState createState() =>
      _MentalArithmeticQuestionViewState();
}

class _MentalArithmeticQuestionViewState
    extends State<MentalArithmeticQuestionView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<AlignmentGeometry> _animation;
  late Animation<AlignmentGeometry> _animation1;
  late final Animation<double> _opacityAnimationOut;
  late final Animation<double> _opacityAnimationIn;
  int index = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (index < widget.currentProblem.questionList.length - 1) {
          index++;
          _controller.forward(from: 0);
        }
      }
    })..forward();

    _animation = Tween<AlignmentGeometry>(
      begin: Alignment.centerRight,
      end: Alignment.center,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeInOutBack),
      ),
    );

    _animation1 = Tween<AlignmentGeometry>(
      begin: Alignment.center,
      end: Alignment.centerLeft,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0, curve: Curves.easeInOutBack),
      ),
    );

    _opacityAnimationOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 0.7, curve: Curves.easeOut),
      ),
    );

    _opacityAnimationIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void didUpdateWidget(MentalArithmeticQuestionView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentProblem != widget.currentProblem) {
      index = 0;
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated question display
          AlignTransition(
            alignment: _animation,
            child: FadeTransition(
              opacity: _opacityAnimationOut,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.currentProblem.currentQuestion,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Show next question if available
          if (index > 0 && index < widget.currentProblem.questionList.length)
            AlignTransition(
              alignment: _animation1,
              child: FadeTransition(
                opacity: _opacityAnimationIn,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    widget.currentProblem.questionList[index],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
