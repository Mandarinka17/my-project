import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../arguments.dart';

class WikipediaCommand extends Command {
  WikipediaCommand() {
    addFlag('help', abbr: 'h', help: 'Show help for this command');
    addOption('lang', abbr: 'l', defaultValue: 'ru', help: 'Language code (ru, en)');
  }

  @override
  String get name => 'wikipedia';

  @override
  String get description => 'Search Wikipedia for an article';

  @override
  FutureOr<Object?> run(ArgResults args) async {
    if (args.flag('help')) {
      print('Usage: wikipedia [options] <article title>');
      print('Options:');
      for (var opt in options) {
        print('  ${opt.usage}');
      }
      return null;
    }

    String articleTitle;
    if (args.commandArg == null || args.commandArg!.isEmpty) {
      print('Please provide an article title.');
      final input = stdin.readLineSync();
      if (input == null || input.isEmpty) {
        print('No article title provided. Exiting.');
        return null;
      }
      articleTitle = input;
    } else {
      articleTitle = args.commandArg!;
    }

    final lang = args.hasOption('lang')
        ? (args.getOption('lang').input as String)
        : 'ru';

    print('Looking up articles about "$articleTitle". Please wait.');

    final url = Uri.https(
      '$lang.wikipedia.org',
      '/api/rest_v1/page/summary/$articleTitle',
    );

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
    return null;
  }
}
