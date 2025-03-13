import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sync_conflict_model.dart';

final conflictResolutionProvider = Provider<ConflictResolutionService>(
  (ref) => ConflictResolutionService(),
);

class ConflictResolutionService {
  Future<ResolvedData> resolveConflict(SyncConflict conflict) async {
    switch (conflict.type) {
      case ConflictType.quiz:
        return _resolveQuizConflict(conflict);
      case ConflictType.progress:
        return _resolveProgressConflict(conflict);
      case ConflictType.material:
        return _resolveMaterialConflict(conflict);
      default:
        throw UnimplementedError('Conflict type not supported');
    }
  }

  Future<ResolvedData> _resolveQuizConflict(SyncConflict conflict) async {
    // Keep the version with the most recent completion date
    final localData = conflict.localData as QuizData;
    final serverData = conflict.serverData as QuizData;
    
    return localData.completedAt.isAfter(serverData.completedAt)
        ? conflict.localData
        : conflict.serverData;
  }

  Future<ResolvedData> _resolveProgressConflict(SyncConflict conflict) async {
    // Merge progress data by taking the highest values
    final localData = conflict.localData as ProgressData;
    final serverData = conflict.serverData as ProgressData;
    
    return ProgressData(
      totalTime: localData.totalTime > serverData.totalTime
          ? localData.totalTime
          : serverData.totalTime,
      score: localData.score > serverData.score
          ? localData.score
          : serverData.score,
      completedItems: {...localData.completedItems, ...serverData.completedItems},
    );
  }

  Future<ResolvedData> _resolveMaterialConflict(SyncConflict conflict) async {
    // Keep the version with the most recent modification
    final localData = conflict.localData as MaterialData;
    final serverData = conflict.serverData as MaterialData;
    
    return localData.modifiedAt.isAfter(serverData.modifiedAt)
        ? conflict.localData
        : conflict.serverData;
  }
} 