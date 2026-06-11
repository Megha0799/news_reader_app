import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:news_reader_app/screen/dashborad/data/model/news_model.dart';
import 'package:news_reader_app/screen/dashborad/data/repository/artical_repo.dart';

class NewsNotifier extends StateNotifier<AsyncValue<List<Article>>> {
  final NewsRepository _repository;

  NewsNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchNews();
  }

  Future<void> fetchNews() async {
    state = const AsyncValue.loading();
    try {
      final articles = await _repository.getTopHeadlines();
      state = AsyncValue.data(articles);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void toggleBookmark(int index) {
    state.whenData((articles) {
      final updatedArticles = List<Article>.from(articles);
      updatedArticles[index] = Article(
        source: articles[index].source,
        author: articles[index].author,
        title: articles[index].title,
        description: articles[index].description,
        url: articles[index].url,
        urlToImage: articles[index].urlToImage,
        publishedAt: articles[index].publishedAt,
        content: articles[index].content,
        isBookmarked: !articles[index].isBookmarked,
        isLiked: articles[index].isLiked,
        isDisliked: articles[index].isDisliked,
      );
      state = AsyncValue.data(updatedArticles);
    });
  }

  void toggleLike(int index) {
    state.whenData((articles) {
      final updatedArticles = List<Article>.from(articles);
      updatedArticles[index] = Article(
        source: articles[index].source,
        author: articles[index].author,
        title: articles[index].title,
        description: articles[index].description,
        url: articles[index].url,
        urlToImage: articles[index].urlToImage,
        publishedAt: articles[index].publishedAt,
        content: articles[index].content,
        isBookmarked: articles[index].isBookmarked,
        isLiked: !articles[index].isLiked,
        isDisliked: false,
      );
      state = AsyncValue.data(updatedArticles);
    });
  }

  void toggleDislike(int index) {
    state.whenData((articles) {
      final updatedArticles = List<Article>.from(articles);
      updatedArticles[index] = Article(
        source: articles[index].source,
        author: articles[index].author,
        title: articles[index].title,
        description: articles[index].description,
        url: articles[index].url,
        urlToImage: articles[index].urlToImage,
        publishedAt: articles[index].publishedAt,
        content: articles[index].content,
        isBookmarked: articles[index].isBookmarked,
        isLiked: false,
        isDisliked: !articles[index].isDisliked,
      );
      state = AsyncValue.data(updatedArticles);
    });
  }
}

final newsListProvider = StateNotifierProvider<NewsNotifier, AsyncValue<List<Article>>>((ref) {
  final repository = ref.watch(newsRepositoryProvider);
  return NewsNotifier(repository);
});
