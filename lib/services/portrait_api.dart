import 'dart:convert';

import 'package:http/http.dart' as http;

class PortraitSpotlight {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String date;

  const PortraitSpotlight({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.date,
  });

  factory PortraitSpotlight.fromJson(Map<String, dynamic> json) {
    return PortraitSpotlight(
      imageUrl: json['imageUrl'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      date: json['date'] as String? ?? '',
    );
  }
}

class PortraitFeature {
  final String title;
  final String date;
  final String imageUrl;
  final bool grayscale;

  const PortraitFeature({
    required this.title,
    required this.date,
    required this.imageUrl,
    this.grayscale = false,
  });

  factory PortraitFeature.fromJson(Map<String, dynamic> json) {
    return PortraitFeature(
      title: json['title'] as String? ?? '',
      date: json['date'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      grayscale: json['grayscale'] as bool? ?? false,
    );
  }
}

class PortraitData {
  final List<PortraitSpotlight> spotlights;
  final List<PortraitFeature> features;

  const PortraitData({required this.spotlights, required this.features});

  factory PortraitData.fromJson(Map<String, dynamic> json) {
    final spotlights = (json['spotlights'] as List<dynamic>? ?? const [])
        .map((e) => PortraitSpotlight.fromJson(e as Map<String, dynamic>))
        .toList();
    final features = (json['features'] as List<dynamic>? ?? const [])
        .map((e) => PortraitFeature.fromJson(e as Map<String, dynamic>))
        .toList();
    return PortraitData(spotlights: spotlights, features: features);
  }
}

class PortraitApiClient {
  final String endpoint;
  final http.Client _client;

  PortraitApiClient({
    this.endpoint =
        'https://raw.githubusercontent.com/DmK4real/KaalisMag/master/data/portrait.json',
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<PortraitData> fetch() async {
    final response = await _client.get(Uri.parse(endpoint));
    if (response.statusCode != 200) {
      throw Exception('Portrait API error: ${response.statusCode}');
    }
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return PortraitData.fromJson(decoded);
  }
}

class PortraitRepository {
  PortraitRepository._();
  static final PortraitRepository instance = PortraitRepository._();
  final PortraitApiClient _client = PortraitApiClient();
  Future<PortraitData>? _cache;

  Future<PortraitData> fetch() {
    return _cache ??= _client.fetch();
  }
}
