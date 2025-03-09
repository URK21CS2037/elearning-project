import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/analytics_model.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) => AnalyticsService());

class AnalyticsService {
  late Box<StudySession> _sessionsBox;
  late Box<QuizAttempt> _quizAttemptsBox;
  late Box<SubjectProgress> _progressBox;

  Future<void> initialize() async {
    _sessionsBox = await Hive.openBox<StudySession>('study_sessions');
    _quizAttemptsBox = await Hive.openBox<QuizAttempt>('quiz_attempts');
    _progressBox = await Hive.openBox<SubjectProgress>('subject_progress');
  }

  // Study session tracking
  Future<void> trackStudySession({
    required String subject,
    required String topic,
    required Duration duration,
    required MaterialType materialType,
  }) async {
    final session = StudySession(
      id: DateTime.now().toString(),
      subject: subject,
      topic: topic,
      duration: duration,
      materialType: materialType,
      timestamp: DateTime.now(),
    );

    await _sessionsBox.add(session);
    await _updateSubjectProgress(subject, duration);
  }

  // Quiz attempt tracking
  Future<void> trackQuizAttempt({
    required String subject,
    required String topic,
    required int score,
    required Duration duration,
    required int questionCount,
    required int correctAnswers,
  }) async {
    final attempt = QuizAttempt(
      id: DateTime.now().toString(),
      subject: subject,
      topic: topic,
      score: score,
      duration: duration,
      questionCount: questionCount,
      correctAnswers: correctAnswers,
      timestamp: DateTime.now(),
    );

    await _quizAttemptsBox.add(attempt);
    await _updateSubjectProgress(
      subject,
      duration,
      quizScore: score,
      quizCount: 1,
    );
  }

  // Progress tracking
  Future<void> _updateSubjectProgress(
    String subject,
    Duration duration, {
    int? quizScore,
    int? quizCount,
  }) async {
    final progress = _progressBox.get(subject) ?? SubjectProgress(
      subject: subject,
      totalStudyTime: Duration.zero,
      quizzesTaken: 0,
      averageScore: 0,
      lastStudied: DateTime.now(),
    );

    progress.totalStudyTime += duration;
    progress.lastStudied = DateTime.now();

    if (quizScore != null && quizCount != null) {
      progress.quizzesTaken += quizCount;
      progress.averageScore = ((progress.averageScore * (progress.quizzesTaken - 1) + quizScore) / progress.quizzesTaken);
    }

    await _progressBox.put(subject, progress);
  }

  // Analytics retrieval
  Future<AnalyticsSummary> getAnalyticsSummary() async {
    final sessions = _sessionsBox.values.toList();
    final attempts = _quizAttemptsBox.values.toList();
    final progress = _progressBox.values.toList();

    return AnalyticsSummary(
      totalStudyTime: _calculateTotalStudyTime(sessions),
      averageQuizScore: _calculateAverageQuizScore(attempts),
      subjectProgress: progress,
      weeklyActivity: _calculateWeeklyActivity(sessions, attempts),
      strengthAreas: _identifyStrengthAreas(progress),
      improvementAreas: _identifyImprovementAreas(progress),
    );
  }

  Duration _calculateTotalStudyTime(List<StudySession> sessions) {
    return sessions.fold(
      Duration.zero,
      (total, session) => total + session.duration,
    );
  }

  double _calculateAverageQuizScore(List<QuizAttempt> attempts) {
    if (attempts.isEmpty) return 0;
    final total = attempts.fold(
      0,
      (sum, attempt) => sum + attempt.score,
    );
    return total / attempts.length;
  }

  Map<DateTime, Duration> _calculateWeeklyActivity(
    List<StudySession> sessions,
    List<QuizAttempt> attempts,
  ) {
    final weeklyActivity = <DateTime, Duration>{};
    // Group sessions and attempts by week
    // Implementation
    return weeklyActivity;
  }

  List<String> _identifyStrengthAreas(List<SubjectProgress> progress) {
    return progress
        .where((p) => p.averageScore >= 80)
        .map((p) => p.subject)
        .toList();
  }

  List<String> _identifyImprovementAreas(List<SubjectProgress> progress) {
    return progress
        .where((p) => p.averageScore < 60)
        .map((p) => p.subject)
        .toList();
  }
} 