import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quiz_provider.dart';
import '../widgets/quiz_generator.dart';
import '../widgets/quiz_question_card.dart';
import '../widgets/quiz_progress_bar.dart';
import '../widgets/quiz_result_screen.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showResults = false;

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _showExitDialog,
        ),
      ),
      body: quizState.when(
        data: (quiz) {
          if (quiz == null) {
            return const QuizGeneratorScreen();
          }

          if (_showResults) {
            return QuizResultScreen(
              quiz: quiz,
              onRetry: () {
                setState(() {
                  _showResults = false;
                  _currentPage = 0;
                });
                _pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              onNewQuiz: () {
                ref.read(quizProvider.notifier).clearQuiz();
              },
            );
          }

          return Column(
            children: [
              QuizProgressBar(
                current: _currentPage + 1,
                total: quiz.questions.length,
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: quiz.questions.length,
                  onPageChanged: (page) {
                    setState(() => _currentPage = page);
                  },
                  itemBuilder: (context, index) {
                    return QuizQuestionCard(
                      question: quiz.questions[index],
                      onAnswerSelected: (answer) {
                        _handleAnswer(quiz, index, answer);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  void _handleAnswer(QuizModel quiz, int questionIndex, int answer) {
    quiz.questions[questionIndex].userAnswer = answer;

    if (questionIndex < quiz.questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      setState(() => _showResults = true);
      _calculateAndSaveScore(quiz);
    }
  }

  void _calculateAndSaveScore(QuizModel quiz) {
    final correctAnswers = quiz.questions
        .where((q) => q.userAnswer == q.correctAnswer)
        .length;
    final score = (correctAnswers / quiz.questions.length * 100).round();
    
    quiz.score = score;
    quiz.completedAt = DateTime.now();
    
    ref.read(quizProvider.notifier).saveQuiz(quiz);
  }

  Future<void> _showExitDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Quiz?'),
        content: const Text(
          'Are you sure you want to exit? Your progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      ref.read(quizProvider.notifier).clearQuiz();
      context.go('/dashboard');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
} 