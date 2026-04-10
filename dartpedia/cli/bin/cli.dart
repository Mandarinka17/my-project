import 'dart:io';
const version = '0.0.1';

void main(List<String> arguments) {
  if (arguments.isEmpty || arguments.first == 'help') {
    printUsage();
  } else if (arguments.first == 'version') {
    print('Dartpedia CLI version $version');
  } else if (arguments.first == 'search') {
    final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
    searchWikipedia(inputArgs);
  } else {
    printUsage();
  }
}

void searchWikipedia(List<String>? arguments) {
  final String articleTitle;

  // Если аргументы не переданы или пустой список
  if (arguments == null || arguments.isEmpty) {
    print('Please provide an article title.');
    // Считываем строку из консоли, если null — заменяем на пустую строку
    articleTitle = stdin.readLineSync() ?? '';
  } else {
    // Объединяем все переданные слова в одну строку через пробел
    articleTitle = arguments.join(' ');
  }

  print('Looking up articles about "$articleTitle". Please wait.');
  print('Here ya go!');
  print('Pretend this is an article about "$articleTitle"');
}
void printUsage() {
  print(
    "The following commands are valid: 'help', 'version', 'search <ARTICLE-TITLE>' "
  );
}
