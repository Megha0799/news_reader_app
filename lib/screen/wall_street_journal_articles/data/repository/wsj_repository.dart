import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_reader_app/screen/dashborad/data/model/news_model.dart';
import 'package:news_reader_app/screen/dashborad/data/repository/artical_repo.dart';

// Provider for the WSJ Repository
final wsjRepositoryProvider = Provider<WSJRepository>((ref) {
  return WSJRepository(ref.read(dioProvider));
});

class WSJRepository {
  final Dio _dio;
  final String _apiKey = '86f0319744f6454ba08a562e19e9a843';
  final String _baseUrl = 'https://newsapi.org/v2/everything';

  WSJRepository(this._dio);

  Future<List<Article>> getWSJArticles() async {
    try {
      // Calculate date 6 months ago
      final sixMonthsAgo = DateTime.now().subtract(const Duration(days: 180));
      final fromDate = '${sixMonthsAgo.year}-${sixMonthsAgo.month.toString().padLeft(2, '0')}-${sixMonthsAgo.day.toString().padLeft(2, '0')}';

      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'domains': 'wsj.com',
          
          'apiKey': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final newsResponse = NewsResponse.fromJson(response.data);
        return newsResponse.articles;
      } else {
        throw Exception('Failed to load WSJ articles: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Unknown Network Error');
    }
  }
}
