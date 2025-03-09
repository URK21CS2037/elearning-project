import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/study_material_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final offlineServiceProvider = Provider<OfflineService>((ref) => OfflineService());

class OfflineService {
  late Box<StudyMaterial> _materialsBox;
  late Box<QuizModel> _quizzesBox;
  late Box<StudyGuide> _guidesBox;

  Future<void> initialize() async {
    _materialsBox = await Hive.openBox<StudyMaterial>('materials');
    _quizzesBox = await Hive.openBox<QuizModel>('quizzes');
    _guidesBox = await Hive.openBox<StudyGuide>('guides');
  }

  Future<bool> isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> cacheMaterial(StudyMaterial material) async {
    await _materialsBox.put(material.id, material);
  }

  Future<void> cacheQuiz(QuizModel quiz) async {
    await _quizzesBox.put(quiz.id, quiz);
  }

  Future<void> cacheStudyGuide(StudyGuide guide) async {
    await _guidesBox.put(guide.id, guide);
  }

  Future<List<StudyMaterial>> getOfflineMaterials() async {
    return _materialsBox.values.toList();
  }

  Future<List<QuizModel>> getOfflineQuizzes() async {
    return _quizzesBox.values.toList();
  }

  Future<List<StudyGuide>> getOfflineStudyGuides() async {
    return _guidesBox.values.toList();
  }

  Future<void> syncWithServer() async {
    if (await isOnline()) {
      // Sync local changes with server
      // Implementation
    }
  }

  Future<void> clearCache() async {
    await _materialsBox.clear();
    await _quizzesBox.clear();
    await _guidesBox.clear();
  }
} 