import 'dart:async';
import 'dart:io';
import 'package:command_runner/command_runner.dart';
import 'package:logging/logging.dart';
import 'package:wikipedia/wikipedia.dart';

/// Команда для поиска статей в Википедии.
class SearchCommand extends Command {
  SearchCommand({required this.logger}) {
    addFlag(
      'im-feeling-lucky',
      abbr: 'l',
      help: 'If true, prints the summary of the top article that the search returns.',
    );
  }

  final Logger logger;

  @override
  String get description => 'Search for Wikipedia articles.';

  @override
  bool get requiresArgument => true;

  @override
  String get name => 'search';

  @override
  String get valueHelp => 'STRING';

  @override
  String get help =>
      'Prints a list of links to Wikipedia articles that match the given term.';

  @override
  FutureOr<String> run(ArgResults args) async {
    if (requiresArgument && (args.commandArg == null || args.commandArg!.isEmpty)) {
      return 'Please include a search term';
    }

    final buffer = StringBuffer('Search results:\n');
    try {
      final results = await search(args.commandArg!);

      if (args.flag('im-feeling-lucky')) {
        if (results.results.isEmpty) {
          buffer.writeln('No results found.');
        } else {
          final title = results.results.first.title;
          final article = await getArticleSummaryByTitle(title);
          if (article != null) {
            buffer.writeln('Lucky you!');
            // Используем поле canonical (или normalized, если оно у вас)
            // Если titles может быть null, используйте ?. , но в вашей модели скорее всего не null
            buffer.writeln(article.titles.canonical ?? title);
            final description = article.description;
            if (description != null && description.isNotEmpty) {
              buffer.writeln(description);
            }
            buffer.writeln(article.extract ?? '');
            buffer.writeln();
          } else {
            buffer.writeln('Could not fetch article summary.');
          }
          buffer.writeln('All results:');
        }
      }

      for (var result in results.results) {
        buffer.writeln('${result.title} - ${result.url}');
      }
      return buffer.toString();
    } on HttpException catch (e) {
      logger
        ..warning(e.message)
        ..warning(e.uri?.toString() ?? '')
        ..info(usage);
      return 'Network error: ${e.message}';
    } on FormatException catch (e) {
      logger
        ..warning(e.message)
        ..warning(e.source ?? '')
        ..info(usage);
      return 'Data format error: ${e.message}';
    } catch (e) {
      logger.severe(e.toString());
      return 'Unexpected error: $e';
    }
  }
}
