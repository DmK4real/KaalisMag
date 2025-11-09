import 'dart:convert';

import 'package:http/http.dart' as http;

class OpinionHomeCard {
  final String imageUrl;
  final String title;
  final String date;
  final String description;

  const OpinionHomeCard({
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.description,
  });

  factory OpinionHomeCard.fromJson(Map<String, dynamic> json) {
    return OpinionHomeCard(
      imageUrl: json['imageUrl'] as String? ?? '',
      title: json['title'] as String? ?? '',
      date: json['date'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}

class OpinionArticle {
  final String title;
  final String date;
  final String imageUrl;

  const OpinionArticle({
    required this.title,
    required this.date,
    required this.imageUrl,
  });

  factory OpinionArticle.fromJson(Map<String, dynamic> json) {
    return OpinionArticle(
      title: json['title'] as String? ?? '',
      date: json['date'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }
}

class OpinionData {
  final List<OpinionHomeCard> homeCards;
  final List<OpinionArticle> articles;

  const OpinionData({required this.homeCards, required this.articles});

  factory OpinionData.fromJson(Map<String, dynamic> json) {
    final homeCards = (json['home_cards'] as List<dynamic>? ?? const [])
        .map((e) => OpinionHomeCard.fromJson(e as Map<String, dynamic>))
        .toList();
    final articles = (json['articles'] as List<dynamic>? ?? const [])
        .map((e) => OpinionArticle.fromJson(e as Map<String, dynamic>))
        .toList();
    return OpinionData(homeCards: homeCards, articles: articles);
  }
}

class OpinionApiClient {
  final String endpoint;
  final http.Client _client;

  OpinionApiClient({
    this.endpoint =
        'https://raw.githubusercontent.com/DmK4real/KaalisMag/master/data/opinion.json',
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<OpinionData> fetch() async {
    final response = await _client.get(Uri.parse(endpoint));
    if (response.statusCode != 200) {
      throw Exception('Opinion API error: ${response.statusCode}');
    }
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return OpinionData.fromJson(decoded);
  }
}

class OpinionRepository {
  OpinionRepository._();
  static final OpinionRepository instance = OpinionRepository._();
  final OpinionApiClient _client = OpinionApiClient();
  Future<OpinionData>? _cache;

  Future<OpinionData> fetch() {
    return _cache ??= _client.fetch();
  }
}
