import 'dart:convert';

import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_reader_app/screen/dashborad/data/model/news_model.dart';

class BookmarkNotifier extends StateNotifier<List<Article>> {
  BookmarkNotifier() : super([]) {
    _loadBookmarks();
  }

  static const String _bookmarkKey = 'bookmarks';

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkJson = prefs.getString(_bookmarkKey);
    if (bookmarkJson != null) {
      final List<dynamic> decoded = json.decode(bookmarkJson);
      final bookmarks = decoded.map((item) => Article.fromJson(item)).toList();
      state = bookmarks;
    }
  }

  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkJson = json.encode(state.map((article) => article.toJson()).toList());
    await prefs.setString(_bookmarkKey, bookmarkJson);
  }

  Future<void> addBookmark(Article article) async {
    final updatedArticle = Article(
      source: article.source,
      author: article.author,
      title: article.title,
      description: article.description,
      url: article.url,
      urlToImage: article.urlToImage,
      publishedAt: article.publishedAt,
      content: article.content,
      isBookmarked: true,
      isLiked: article.isLiked,
      isDisliked: article.isDisliked,
    );
    
    state = [...state, updatedArticle];
    await _saveBookmarks();
  }

  Future<void> removeBookmark(Article article) async {
    state = state.where((item) => item.url != article.url).toList();
    await _saveBookmarks();
  }

  Future<void> toggleBookmark(Article article) async {
    final exists = state.any((item) => item.url == article.url);
    if (exists) {
      await removeBookmark(article);
    } else {
      await addBookmark(article);
    }
  }

  bool isBookmarked(Article article) {
    return state.any((item) => item.url == article.url);
  }
}

final bookmarkProvider = StateNotifierProvider<BookmarkNotifier, List<Article>>((ref) {
  return BookmarkNotifier();
});
