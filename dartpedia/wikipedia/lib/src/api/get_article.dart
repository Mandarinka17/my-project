import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/article.dart';

/// Получает полную статью (extract) по названию.
Future<List<Article>> getArticleByTitle(String title) async {
  final client = http.Client();
  try {
    final url = Uri.https(
      'en.wikipedia.org',
      '/w/api.php',
      {
        'action': 'query',
        'format': 'json',
        'titles': title.trim(),
        'prop': 'extracts',
        'explaintext': '',
      },
    );
    final response = await client.get(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return Article.listFromJson(jsonData);
    } else {
      throw HttpException(
        'getArticleByTitle failed: statusCode=${response.statusCode}, body=${response.body}',
      );
    }
  } on FormatException {
    rethrow;
  } finally {
    client.close();
  }
}
