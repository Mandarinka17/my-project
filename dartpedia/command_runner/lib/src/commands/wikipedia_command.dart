import 'dart:async';
import 'dart:io';
import 'package:wikipedia/wikipedia.dart';
import '../arguments.dart';

class WikipediaCommand extends Command {
  WikipediaCommand() {
    addFlag('help', abbr: 'h', help: 'Show help for this command');
    addOption('lang', abbr: 'l', defaultValue: 'en', help: 'Language code (en, ru, etc.)');
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

    // Получаем название статьи
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

    // Язык (пока не используется, но можно расширить)
   

    print('Looking up articles about "$articleTitle". Please wait.');

    // Используем функцию из пакета wikipedia
    final summary = await getArticleSummaryByTitle(articleTitle);
    if (summary != null) {
      print(summary.extract);
    } else {
      print('Статья "$articleTitle" не найдена на Википедии.');
    }
    return null;
  }
}
