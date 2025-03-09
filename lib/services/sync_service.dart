import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/sync_queue_model.dart';
import 'storage_service.dart';

final syncServiceProvider = Provider<SyncService>((ref) => SyncService());

class SyncService {
  final _storage = StorageService();
  final _connectivity = Connectivity();
  bool _isSyncing = false;

  Stream<bool> get connectivityStream => _connectivity.onConnectivityChanged
      .map((status) => status != ConnectivityResult.none);

  Future<void> initialize() async {
    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen((status) {
      if (status != ConnectivityResult.none) {
        syncPendingChanges();
      }
    });
  }

  Future<void> addToSyncQueue(SyncQueueItem item) async {
    await _storage.addToSyncQueue(item);
    await syncPendingChanges();
  }

  Future<void> syncPendingChanges() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final hasConnection = await _checkConnectivity();
      if (!hasConnection) {
        _isSyncing = false;
        return;
      }

      final pendingItems = await _storage.getSyncQueue();
      for (final item in pendingItems) {
        try {
          await _processSyncItem(item);
          await _storage.removeSyncQueueItem(item.id);
        } catch (e) {
          print('Error syncing item ${item.id}: $e');
          // Increment retry count or mark as failed after max retries
          await _storage.updateSyncQueueItem(
            item.copyWith(
              retryCount: item.retryCount + 1,
              lastError: e.toString(),
            ),
          );
        }
      }
    } finally {
      _isSyncing = false;
    }
  }

  Future<bool> _checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> _processSyncItem(SyncQueueItem item) async {
    switch (item.type) {
      case SyncType.quiz:
        await _syncQuiz(item);
        break;
      case SyncType.progress:
        await _syncProgress(item);
        break;
      case SyncType.material:
        await _syncMaterial(item);
        break;
    }
  }

  Future<void> _syncQuiz(SyncQueueItem item) async {
    // Sync quiz data with server
    // Implementation
  }

  Future<void> _syncProgress(SyncQueueItem item) async {
    // Sync progress data with server
    // Implementation
  }

  Future<void> _syncMaterial(SyncQueueItem item) async {
    // Sync study material data with server
    // Implementation
  }
} 