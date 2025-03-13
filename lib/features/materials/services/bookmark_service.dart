import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/bookmark_model.dart';

final bookmarkServiceProvider = Provider<BookmarkService>((ref) => BookmarkService());

class BookmarkService {
  late Box<Bookmark> _bookmarkBox;

  Future<void> initialize() async {
    _bookmarkBox = await Hive.openBox<Bookmark>('bookmarks');
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    await _bookmarkBox.put(bookmark.id, bookmark);
  }

  Future<void> removeBookmark(String id) async {
    await _bookmarkBox.delete(id);
  }

  List<Bookmark> getBookmarks() {
    return _bookmarkBox.values.toList();
  }

  bool isBookmarked(String materialId) {
    return _bookmarkBox.values.any((bookmark) => bookmark.materialId == materialId);
  }
} 