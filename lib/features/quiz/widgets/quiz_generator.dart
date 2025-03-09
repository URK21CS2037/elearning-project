import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quiz_provider.dart';

class QuizGenerator extends ConsumerStatefulWidget {
  const QuizGenerator({super.key});

  @override
  ConsumerState<QuizGenerator> createState() => _QuizGeneratorState();
}

class _QuizGeneratorState extends ConsumerState<QuizGenerator> {
  final _formKey = GlobalKey<FormState>();
  String _subject = '';
  String _topic = '';
  String _difficulty = 'Medium';
  int _questionCount = 5;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Generate New Quiz',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a subject';
                }
                return null;
              },
              onSaved: (value) => _subject = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Topic',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a topic';
                }
                return null;
              },
              onSaved: (value) => _topic = value!,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Difficulty',
                border: OutlineInputBorder(),
              ),
              value: _difficulty,
              items: ['Easy', 'Medium', 'Hard']
                  .map((difficulty) => DropdownMenuItem(
                        value: difficulty,
                        child: Text(difficulty),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => _difficulty = value!);
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Number of Questions: '),
                Expanded(
                  child: Slider(
                    value: _questionCount.toDouble(),
                    min: 5,
                    max: 20,
                    divisions: 3,
                    label: _questionCount.toString(),
                    onChanged: (value) {
                      setState(() => _questionCount = value.round());
                    },
                  ),
                ),
                Text(_questionCount.toString()),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _generateQuiz,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: const Text('Generate Quiz'),
            ),
          ],
        ),
      ),
    );
  }

  void _generateQuiz() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      ref.read(quizProvider.notifier).generateQuiz(
        subject: _subject,
        topic: _topic,
        difficulty: _difficulty,
        questionCount: _questionCount,
      );
    }
  }
} 