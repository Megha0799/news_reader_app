import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_reader_app/screen/dashborad/data/model/news_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';


// 1. Provider for the Dio Client
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  
  // Add Pretty Dio Logger
  dio.interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
    maxWidth: 90,
  ));
  
  return dio;
});

// 2. Provider for the Repository
final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepository(ref.read(dioProvider));
});

class NewsRepository {
  final Dio _dio;
  // Your API Key
  final String _apiKey = '86f0319744f6454ba08a562e19e9a843';
  final String _baseUrl = 'https://newsapi.org/v2/top-headlines';

  NewsRepository(this._dio);

  Future<List<Article>> getTopHeadlines() async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'country': 'us',
          'apiKey': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final newsResponse = NewsResponse.fromJson(response.data);
        return newsResponse.articles;
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors (timeouts, etc.)
      throw Exception(e.message ?? 'Unknown Network Error');
    }
  }
}
