import 'package:hive/hive.dart';

part 'quiz_model.g.dart';

@HiveType(typeId: 0)
class QuizModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String subject;

  @HiveField(2)
  final String topic;

  @HiveField(3)
  final String difficulty;

  @HiveField(4)
  final List<QuizQuestionModel> questions;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  int? score;

  @HiveField(7)
  DateTime? completedAt;

  QuizModel({
    required this.id,
    required this.subject,
    required this.topic,
    required this.difficulty,
    required this.questions,
    required this.createdAt,
    this.score,
    this.completedAt,
  });
}

@HiveType(typeId: 1)
class QuizQuestionModel {
  @HiveField(0)
  final String question;

  @HiveField(1)
  final List<String> options;

  @HiveField(2)
  final int correctAnswer;

  @HiveField(3)
  final String explanation;

  @HiveField(4)
  int? userAnswer;

  QuizQuestionModel({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    this.userAnswer,
  });
} 