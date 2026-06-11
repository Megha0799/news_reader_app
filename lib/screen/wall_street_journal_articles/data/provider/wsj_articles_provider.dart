import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:news_reader_app/screen/dashborad/data/model/news_model.dart';
import 'package:news_reader_app/screen/wall_street_journal_articles/data/repository/wsj_repository.dart';

class WSJArticlesNotifier extends StateNotifier<AsyncValue<List<Article>>> {
  final WSJRepository _repository;

  WSJArticlesNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchWSJArticles();
  }

  Future<void> fetchWSJArticles() async {
    state = const AsyncValue.loading();
    try {
      final articles = await _repository.getWSJArticles();
      state = AsyncValue.data(articles);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final wsjArticlesProvider = StateNotifierProvider<WSJArticlesNotifier, AsyncValue<List<Article>>>((ref) {
  final repository = ref.watch(wsjRepositoryProvider);
  return WSJArticlesNotifier(repository);
});
