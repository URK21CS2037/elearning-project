import 'package:hive_flutter/hive_flutter.dart';
import '../models/quiz_model.dart';
import '../models/user_progress_model.dart';
import '../models/study_material_model.dart';

class StorageService {
  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(QuizModelAdapter());
    Hive.registerAdapter(UserProgressModelAdapter());
    Hive.registerAdapter(StudyMaterialModelAdapter());
    
    // Open boxes
    await Hive.openBox<QuizModel>('quizzes');
    await Hive.openBox<UserProgressModel>('progress');
    await Hive.openBox<StudyMaterialModel>('materials');
    await Hive.openBox('user_preferences');
  }

  // Quiz storage methods
  Future<void> saveQuiz(QuizModel quiz) async {
    final box = Hive.box<QuizModel>('quizzes');
    await box.put(quiz.id, quiz);
  }

  Future<List<QuizModel>> getQuizHistory() async {
    final box = Hive.box<QuizModel>('quizzes');
    return box.values.toList();
  }

  // Progress tracking methods
  Future<void> updateProgress(UserProgressModel progress) async {
    final box = Hive.box<UserProgressModel>('progress');
    await box.put(progress.subject, progress);
  }

  Future<UserProgressModel?> getProgress(String subject) async {
    final box = Hive.box<UserProgressModel>('progress');
    return box.get(subject);
  }

  // Study materials methods
  Future<void> saveMaterial(StudyMaterialModel material) async {
    final box = Hive.box<StudyMaterialModel>('materials');
    await box.put(material.id, material);
  }

  Future<List<StudyMaterialModel>> getSavedMaterials() async {
    final box = Hive.box<StudyMaterialModel>('materials');
    return box.values.toList();
  }

  // User preferences methods
  Future<void> savePreference(String key, dynamic value) async {
    final box = Hive.box('user_preferences');
    await box.put(key, value);
  }

  dynamic getPreference(String key, {dynamic defaultValue}) {
    final box = Hive.box('user_preferences');
    return box.get(key, defaultValue: defaultValue);
  }
} 