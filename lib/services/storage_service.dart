import 'package:hive_flutter/hive_flutter.dart';
import '../models/quiz_model.dart';
import '../models/user_progress_model.dart';
import '../models/study_material_model.dart';
import '../models/cache_item.dart';

class StorageService {
  static const String _cacheBox = 'cache';
  static const String _userBox = 'user';
  static const Duration _defaultExpiration = Duration(hours: 24);

  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(QuizModelAdapter());
    Hive.registerAdapter(UserProgressModelAdapter());
    Hive.registerAdapter(StudyMaterialModelAdapter());
    Hive.registerAdapter(CacheItemAdapter());
    
    // Open boxes
    await Hive.openBox<QuizModel>('quizzes');
    await Hive.openBox<UserProgressModel>('progress');
    await Hive.openBox<StudyMaterialModel>('materials');
    await Hive.openBox('user_preferences');
    await Hive.openBox(_cacheBox);
    await Hive.openBox(_userBox);
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
  Future<void> saveUserPreference(String key, dynamic value) async {
    final box = Hive.box(_userBox);
    await box.put(key, value);
  }

  dynamic getUserPreference(String key) {
    final box = Hive.box(_userBox);
    return box.get(key);
  }

  Future<void> cacheData({
    required String key,
    required dynamic data,
    Duration? expiration,
  }) async {
    final box = Hive.box(_cacheBox);
    final cacheItem = CacheItem(
      data: data,
      timestamp: DateTime.now(),
      expiration: expiration ?? _defaultExpiration,
    );
    await box.put(key, cacheItem);
  }

  Future<T?> getCachedData<T>(String key) async {
    final box = Hive.box(_cacheBox);
    final cacheItem = box.get(key) as CacheItem?;

    if (cacheItem != null) {
      final isExpired = DateTime.now().difference(cacheItem.timestamp) > 
                       cacheItem.expiration;
      if (!isExpired) {
        return cacheItem.data as T?;
      }
      await box.delete(key);
    }
    return null;
  }

  Future<void> clearCache() async {
    final box = Hive.box(_cacheBox);
    await box.clear();
  }
} 