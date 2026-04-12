import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/summary.dart';

/// Получает случайную статью (краткое содержание).
Future<Summary?> getRandomArticleSummary() async {
  final client = http.Client();
  try {
    final url = Uri.https('en.wikipedia.org', '/api/rest_v1/page/random/summary');
    final response = await client.get(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return Summary.fromJson(jsonData);
    } else {
      throw HttpException(
        'getRandomArticleSummary failed: statusCode=${response.statusCode}, body=${response.body}',
      );
    }
  } on FormatException {
    rethrow;
  } finally {
    client.close();
  }
}

/// Получает краткое содержание статьи по названию.
Future<Summary?> getArticleSummaryByTitle(String articleTitle) async {
  final client = http.Client();
  try {
    final url = Uri.https('en.wikipedia.org', '/api/rest_v1/page/summary/$articleTitle');
    final response = await client.get(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return Summary.fromJson(jsonData);
    } else {
      throw HttpException(
        'getArticleSummaryByTitle failed: statusCode=${response.statusCode}, body=${response.body}',
      );
    }
  } on FormatException {
    rethrow;
  } finally {
    client.close();
  }
}
