import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/ai_service.dart';
import '../../../models/quiz_model.dart';
import 'package:uuid/uuid.dart';

final quizProvider = StateNotifierProvider<QuizNotifier, AsyncValue<QuizModel?>>(
  (ref) => QuizNotifier(ref.read(aiServiceProvider)),
);

class QuizNotifier extends StateNotifier<AsyncValue<QuizModel?>> {
  final AIService _aiService;
  final _uuid = const Uuid();

  QuizNotifier(this._aiService) : super(const AsyncValue.data(null));

  Future<void> generateQuiz({
    required String subject,
    required String topic,
    required String difficulty,
    required int questionCount,
  }) async {
    state = const AsyncValue.loading();

    try {
      final questions = await _aiService.generateQuiz(
        subject: subject,
        topic: topic,
        difficulty: difficulty,
        questionCount: questionCount,
      );

      final quiz = QuizModel(
        id: _uuid.v4(),
        subject: subject,
        topic: topic,
        difficulty: difficulty,
        questions: questions.map((q) => QuizQuestionModel(
          question: q.question,
          options: q.options,
          correctAnswer: q.correctAnswer,
          explanation: q.explanation,
        )).toList(),
        createdAt: DateTime.now(),
      );

      state = AsyncValue.data(quiz);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void saveQuiz(QuizModel quiz) async {
    final box = await Hive.openBox<QuizModel>('quizzes');
    await box.put(quiz.id, quiz);
  }

  void clearQuiz() {
    state = const AsyncValue.data(null);
  }
} 