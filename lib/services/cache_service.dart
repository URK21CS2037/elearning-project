class CacheService {
  static const Duration defaultExpiration = Duration(hours: 24);

  Future<void> cacheData(String key, dynamic data) async {
    final box = await Hive.openBox('cache');
    await box.put(key, {
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<dynamic> getCachedData(String key) async {
    final box = await Hive.openBox('cache');
    final cached = box.get(key);
    
    if (cached != null) {
      final timestamp = DateTime.parse(cached['timestamp']);
      if (DateTime.now().difference(timestamp) < defaultExpiration) {
        return cached['data'];
      }
    }
    return null;
  }
} 