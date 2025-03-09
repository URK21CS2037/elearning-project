import 'package:flutter/material.dart';
import '../models/quiz_model.dart';

class QuizQuestionCard extends StatelessWidget {
  final QuizQuestionModel question;
  final Function(int) onAnswerSelected;

  const QuizQuestionCard({
    super.key,
    required this.question,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                question.question,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ...question.options.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ElevatedButton(
                onPressed: () => onAnswerSelected(entry.key),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                ),
                child: Text(
                  '${String.fromCharCode(65 + entry.key)}. ${entry.value}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
} 