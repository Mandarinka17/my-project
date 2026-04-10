import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

const version = '0.0.1';

void main(List<String> arguments) {
  if (arguments.isEmpty || arguments.first == 'help') {
    printUsage();
  } else if (arguments.first == 'version') {
    print('Dartpedia CLI version $version');
  } else if (arguments.first == 'wikipedia') {   // команда изменена на 'wikipedia'
    final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
    searchWikipedia(inputArgs);                   // вызов без await (main не async)
  } else {
    printUsage();
  }
}

Future<void> searchWikipedia(List<String>? arguments) async {
  final String articleTitle;

  if (arguments == null || arguments.isEmpty) {
    print('Please provide an article title.');
    final inputFromStdIn = stdin.readLineSync();
    if (inputFromStdIn == null || inputFromStdIn.isEmpty) {
      print('No article title provided. Exiting.');
      return;
    }
    articleTitle = inputFromStdIn;
  } else {
    articleTitle = arguments.join(' ');
  }

  print('Looking up articles about "$articleTitle". Please wait.');

  final articleContent = await getWikipediaArticle(articleTitle);

  if (articleContent.startsWith('Error:')) {
    print(articleContent);
    return;
  }

  try {
    final data = jsonDecode(articleContent);
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

void printUsage() {
  print(
    "The following commands are valid: 'help', 'version', 'wikipedia <ARTICLE-TITLE>' "
  );
}
