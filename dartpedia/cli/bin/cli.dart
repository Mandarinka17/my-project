import 'package:command_runner/command_runner.dart';
import 'package:cli/cli.dart'; // даёт initFileLogger и write (если экспортирован)

const String version = '0.0.1';

void main(List<String> arguments) async {
  // Инициализируем два логгера: один для общего логирования, другой для ошибок
  final appLogger = initFileLogger('dartpedia');
  final errorLogger = initFileLogger('errors');

  appLogger.info('Application started');

  final runner = CommandRunner(
    executableName: 'dartpedia',
    version: version,
    onOutput: (String output) async {
      // Используем write из console.dart для построчного вывода с задержкой
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
    ..addCommand(WikipediaCommand());

  await runner.run(arguments);
}
