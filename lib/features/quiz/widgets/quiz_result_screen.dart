import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import 'package:confetti/confetti.dart';

class QuizResultScreen extends StatefulWidget {
  final QuizModel quiz;
  final VoidCallback onRetry;
  final VoidCallback onNewQuiz;

  const QuizResultScreen({
    super.key,
    required this.quiz,
    required this.onRetry,
    required this.onNewQuiz,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    if (widget.quiz.score! >= 70) {
      _confettiController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildScoreCard(),
              const SizedBox(height: 24),
              _buildAnswerReview(),
              const SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirection: -pi / 2,
          emissionFrequency: 0.05,
          numberOfParticles: 20,
          maxBlastForce: 100,
          minBlastForce: 50,
          gravity: 0.2,
        ),
      ],
    );
  }

  Widget _buildScoreCard() {
    final score = widget.quiz.score!;
    final isGoodScore = score >= 70;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              isGoodScore ? Icons.emoji_events : Icons.school,
              size: 64,
              color: isGoodScore ? Colors.amber : Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              'Your Score',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '$score%',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: isGoodScore ? Colors.green : Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _getScoreMessage(score),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerReview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Review Your Answers',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...widget.quiz.questions.asMap().entries.map((entry) {
          final question = entry.value;
          final isCorrect = question.userAnswer == question.correctAnswer;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: isCorrect ? Colors.green : Colors.red,
                        child: Icon(
                          isCorrect ? Icons.check : Icons.close,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Question ${entry.key + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(question.question),
                  const SizedBox(height: 8),
                  Text(
                    'Your Answer: ${question.options[question.userAnswer ?? 0]}',
                    style: TextStyle(
                      color: isCorrect ? Colors.green : Colors.red,
                    ),
                  ),
                  if (!isCorrect) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Correct Answer: ${question.options[question.correctAnswer]}',
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    'Explanation: ${question.explanation}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: widget.onRetry,
            icon: const Icon(Icons.replay),
            label: const Text('Try Again'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: widget.onNewQuiz,
            icon: const Icon(Icons.add),
            label: const Text('New Quiz'),
          ),
        ),
      ],
    );
  }

  String _getScoreMessage(int score) {
    if (score >= 90) return 'Excellent! You\'re mastering this topic!';
    if (score >= 70) return 'Great job! Keep up the good work!';
    if (score >= 50) return 'Good effort! Room for improvement.';
    return 'Keep practicing! You\'ll get better.';
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }
} 