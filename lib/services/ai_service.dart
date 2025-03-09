import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../config/env.dart';
import '../models/study_material_model.dart';
import '../models/quiz_model.dart';
import '../models/content_model.dart';

final aiServiceProvider = Provider<AIService>((ref) => AIService());

class AIService {
  late final GenerativeModel _model;

  AIService() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: EnvConfig.geminiApiKey,
    );
  }

  Future<StudyGuide> generateStudyGuide({
    required String subject,
    required String topic,
    required String level,
  }) async {
    try {
      final prompt = '''
        Create a comprehensive study guide for $topic in $subject at $level level.
        Include:
        1. Key concepts
        2. Important definitions
        3. Main theories or principles
        4. Examples
        5. Practice problems
        Format as structured markdown with clear sections.
      ''';

      final response = await _model.generateContent(prompt);
      return _parseStudyGuide(response.text);
    } catch (e) {
      throw Exception('Failed to generate study guide: $e');
    }
  }

  Future<List<Flashcard>> generateFlashcards({
    required String topic,
    required int count,
  }) async {
    try {
      final prompt = '''
        Generate $count flashcards for studying $topic.
        Format each flashcard as:
        {
          "front": "Question or concept",
          "back": "Answer or explanation"
        }
        Return as JSON array.
      ''';

      final response = await _model.generateContent(prompt);
      return _parseFlashcards(response.text);
    } catch (e) {
      throw Exception('Failed to generate flashcards: $e');
    }
  }

  Future<LearningPath> generateLearningPath({
    required String subject,
    required String goal,
    required String timeframe,
  }) async {
    try {
      final prompt = '''
        Create a structured learning path for $subject to achieve: $goal
        Timeframe: $timeframe
        Include:
        1. Milestones
        2. Resources needed
        3. Estimated time per topic
        4. Prerequisites
        Format as structured JSON.
      ''';

      final response = await _model.generateContent(prompt);
      return _parseLearningPath(response.text);
    } catch (e) {
      throw Exception('Failed to generate learning path: $e');
    }
  }

  Future<List<QuizQuestion>> generateQuiz({
    required String topic,
    required String difficulty,
    required int questionCount,
  }) async {
    try {
      final prompt = '''
        Generate $questionCount multiple choice questions about $topic.
        Difficulty: $difficulty
        Format: JSON array of questions with:
        - question text
        - 4 options
        - correct answer index (0-3)
        - explanation
      ''';

      final response = await _model.generateContent(prompt);
      return _parseQuizQuestions(response.text);
    } catch (e) {
      throw Exception('Failed to generate quiz: $e');
    }
  }

  Future<ContentSummary> generateSummary(String topic) async {
    try {
      final prompt = '''
        Create a comprehensive summary of $topic including:
        1. Main concepts
        2. Key points
        3. Examples
        4. Common applications
        Format as structured markdown.
      ''';

      final response = await _model.generateContent(prompt);
      return ContentSummary(
        topic: topic,
        content: response.text,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to generate summary: $e');
    }
  }

  // Helper methods for parsing AI responses
  StudyGuide _parseStudyGuide(String content) {
    // Implementation of parsing logic
    return StudyGuide(/* parsed data */);
  }

  List<Flashcard> _parseFlashcards(String content) {
    // Implementation of parsing logic
    return [];
  }

  LearningPath _parseLearningPath(String content) {
    // Implementation of parsing logic
    return LearningPath(/* parsed data */);
  }

  List<QuizQuestion> _parseQuizQuestions(String content) {
    // Implementation of parsing logic
    // This would parse the AI response into QuizQuestion objects
    return [];
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });
} 