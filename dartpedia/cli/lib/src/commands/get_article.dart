import 'dart:async';
import 'dart:io';
import 'package:command_runner/command_runner.dart';
import 'package:logging/logging.dart';
import 'package:wikipedia/wikipedia.dart';

/// Команда для получения полной статьи по названию.
class GetArticleCommand extends Command {
  GetArticleCommand({required this.logger});

  final Logger logger;

  @override
  String get description => 'Get full article text from Wikipedia.';

  @override
  bool get requiresArgument => true;

  @override
  String get name => 'get-article';

  @override
  String get valueHelp => 'ARTICLE_TITLE';

  @override
  String get help => 'Fetches the full extract of a Wikipedia article.';

  @override
  FutureOr<String> run(ArgResults args) async {
    if (requiresArgument && (args.commandArg == null || args.commandArg!.isEmpty)) {
      return 'Please provide an article title.';
    }

    try {
      final articles = await getArticleByTitle(args.commandArg!);
      if (articles.isEmpty) {
        return 'Article not found.';
      }
      final article = articles.first;
      final buffer = StringBuffer();
      buffer.writeln('Title: ${article.title}');
      buffer.writeln('Extract:');
      buffer.writeln(article.extract);
      return buffer.toString();
    } on HttpException catch (e) {
      logger.warning(e.message);
      return 'Network error: ${e.message}';
    } on FormatException catch (e) {
      logger.warning(e.message);
      return 'Data format error: ${e.message}';
    } catch (e) {
      logger.severe(e.toString());
      return 'Unexpected error: $e';
    }
  }
}
