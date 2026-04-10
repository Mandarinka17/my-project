import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

const version = '0.0.1';

void main(List<String> arguments) async {
  if (arguments.isEmpty || arguments.first == 'help') {
    printUsage();
  } else if (arguments.first == 'version') {
    print('Dartpedia CLI version $version');
  } else if (arguments.first == 'search') {
    final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
    await searchWikipedia(inputArgs);
  } else {
    printUsage();
  }
}

Future<void> searchWikipedia(List<String>? arguments) async {
  final String articleTitle;

  if (arguments == null || arguments.isEmpty) {
    print('Please provide an article title.');
    articleTitle = stdin.readLineSync() ?? '';
  } else {
    articleTitle = arguments.join(' ');
  }

  await fetchWikipediaSummary(articleTitle);
}

Future<String> getWikipediaArticle(String articleTitle) async {
  final url = Uri.https(
    'ru.wikipedia.org',
    '/api/rest_v1/page/summary/$articleTitle',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return response.body;
  } else {
    return 'Error: Failed to fetch article "$articleTitle". Status code: ${response.statusCode}';
  }
}

Future<void> fetchWikipediaSummary(String articleTitle) async {
  final result = await getWikipediaArticle(articleTitle);

  if (result.startsWith('Error:')) {
    print(result);
    return;
  }

  try {
    final data = jsonDecode(result);
    final extract = data['extract'];
    if (extract != null && extract.isNotEmpty) {
      print(extract);
    } else {
      print('Краткое содержание не найдено.');
    }
  } catch (e) {
    print('Ошибка при обработке ответа: $e');
  }
}

void printUsage() {
  print(
    "The following commands are valid: 'help', 'version', 'search <ARTICLE-TITLE>' "
  );
}
