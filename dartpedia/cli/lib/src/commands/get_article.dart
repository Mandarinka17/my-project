import 'dart:async';
import 'dart:io';
import 'package:command_runner/command_runner.dart';
import 'package:logging/logging.dart';
import 'package:wikipedia/wikipedia.dart';

/// Команда для получения полной статьи по точному названию.
class GetArticleCommand extends Command {
  GetArticleCommand({required this.logger});

  final Logger logger;

  @override
  String get description => 'Read an article from Wikipedia';

  @override
  String get name => 'article';

  @override
  String get help => 'Gets an article by exact canonical Wikipedia title.';

  @override
  String get defaultValue => 'cat'; // статья по умолчанию, если не указан аргумент

  @override
  String get valueHelp => 'STRING';

  @override
  bool get requiresArgument => false; // может работать без аргумента (использует defaultValue)

  @override
  FutureOr<String> run(ArgResults args) async {
    try {
      // Если аргумент не передан, используем defaultValue
      final title = args.commandArg ?? defaultValue;
      final List<Article> articles = await getArticleByTitle(title);
      
      if (articles.isEmpty) {
        return 'Article not found.';
      }
      
      // Берём первый результат (наиболее точное совпадение)
      final article = articles.first;
      final buffer = StringBuffer('\n=== ${article.title} ===\n\n');
      
      // Ограничиваем вывод первыми 500 словами (или можно выводить весь extract)
      final words = article.extract.split(' ');
      final limitedExtract = words.take(500).join(' ');
      buffer.write(limitedExtract);
      
      if (words.length > 500) {
        buffer.write('...\n\n(Article truncated, use --full to see all)');
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
