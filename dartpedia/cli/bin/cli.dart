const version = '0.0.1';

void main(List<String> arguments) {
  if (arguments.isEmpty || arguments.first == 'help') {
    printUsage();  // вместо 'Hello, Dart!'
  } else if (arguments.first == 'version') {
    print('Dartpedia CLI version $version');
  } else {
    printUsage();  // для всех неизвестных команд
  }
}

void printUsage() {
  print(
    "The following commands are valid: 'help', 'version', 'search <ARTICLE-TITLE>' "
  );
}
