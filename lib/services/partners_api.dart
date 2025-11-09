import 'dart:convert';

import 'package:http/http.dart' as http;

class PartnerOpportunity {
  final String title;
  final List<String> bullets;
  final bool primary;

  const PartnerOpportunity({
    required this.title,
    required this.bullets,
    required this.primary,
  });

  factory PartnerOpportunity.fromJson(Map<String, dynamic> json) {
    return PartnerOpportunity(
      title: (json['title'] as String?)?.replaceAll('\\n', '\n') ?? '',
      bullets: (json['bullets'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .toList(),
      primary: json['primary'] as bool? ?? false,
    );
  }
}

class PartnersApiClient {
  final String endpoint;
  final http.Client _client;

  PartnersApiClient({
    this.endpoint =
        'https://raw.githubusercontent.com/DmK4real/KaalisMag/master/data/partners.json',
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<List<PartnerOpportunity>> fetchOpportunities() async {
    final uri = Uri.parse(endpoint);
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Partners API error: ${response.statusCode}');
    }
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final list = decoded['opportunities'] as List<dynamic>? ?? const [];
    return list.map((e) => PartnerOpportunity.fromJson(e as Map<String, dynamic>)).toList();
  }
}
