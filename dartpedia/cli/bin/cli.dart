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

Future<void> fetchWikipediaSummary(String articleTitle) async {
  final url = Uri.parse(
      'https://ru.wikipedia.org/api/rest_v1/page/summary/${Uri.encodeComponent(articleTitle)}');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final extract = data['extract'];
      if (extract != null && extract.isNotEmpty) {
        print(extract);
      } else {
        print('Краткое содержание не найдено.');
      }
    } else if (response.statusCode == 404) {
      print('Статья "$articleTitle" не найдена на Википедии.');
    } else {
      print('Ошибка HTTP: ${response.statusCode}');
    }
  } catch (e) {
    print('Ошибка соединения: $e');
  }
}

void printUsage() {
  print(
    "The following commands are valid: 'help', 'version', 'search <ARTICLE-TITLE>' "
  );
}
