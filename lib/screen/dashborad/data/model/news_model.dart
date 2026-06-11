import 'package:json_annotation/json_annotation.dart';

part 'news_model.g.dart';

@JsonSerializable()

class NewsResponse {
  final String status;
  final int totalResults;
  final List<Article> articles;

  NewsResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) =>
      _$NewsResponseFromJson(json);
}

@JsonSerializable()
class Article {
  final Source source;
  final String? author;
  final String title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  // Local UI states (excluded from API parsing)
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isBookmarked;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isLiked;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isDisliked;

  Article({
    required this.source,
    this.author,
    required this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.isBookmarked = false,
    this.isLiked = false,
    this.isDisliked = false,
  });

  // Helper for your UI logic
  bool get isWallStreetJournal => source.name == 'The Wall Street Journal';
  
  // Helper to format date if needed, or return raw string
  String get date => publishedAt ?? '';

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}

@JsonSerializable()
class Source {
  final String? id;
  final String? name;

  Source({this.id, this.name});

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);

  Map<String, dynamic> toJson() => _$SourceToJson(this);
}
