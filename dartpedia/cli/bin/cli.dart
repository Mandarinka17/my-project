import 'package:command_runner/command_runner.dart';
import 'package:cli/cli.dart';

const String version = '0.0.1';

void main(List<String> arguments) async {
  final appLogger = initFileLogger('dartpedia');
  final errorLogger = initFileLogger('errors');

  appLogger.info('Application started');

  final runner = CommandRunner(
    executableName: 'dartpedia',
    version: version,
    onOutput: (String output) async {
      await write(output, duration: 50);
    },
    onError: (Object error) {
      if (error is Error) {
        errorLogger.severe('[Error] ${error.toString()}\n${error.stackTrace}');
        throw error;
      }
      if (error is Exception) {
        errorLogger.warning(error.toString());
        print('Ошибка: $error');
      }
    },
  );

  runner
    ..addCommand(VersionCommand(version))
    ..addCommand(HelpCommand())
    ..addCommand(WikipediaCommand())
    ..addCommand(SearchCommand(logger: appLogger))
    ..addCommand(GetArticleCommand(logger: appLogger));

  await runner.run(arguments);
}
