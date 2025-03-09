import 'package:flutter/material.dart';

class QuizProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const QuizProgressBar({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: current / total,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Question $current of $total',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
} 