import 'package:command_runner/command_runner.dart';

const version = '0.0.1';

void main(List<String> arguments) {
  final runner = CommandRunner(
    executableName: 'dartpedia',
    version: version,
    onError: (Object error) {
      // Критические ошибки (Error) пробрасываем дальше
      if (error is Error) {
        throw error;
      }
      // Исключения выводим красным цветом
      if (error is Exception) {
        print(ConsoleColor.red.applyForeground('Ошибка: $error'));
      }
    },
  );

  runner
    ..addCommand(VersionCommand(version))
    ..addCommand(HelpCommand())
    ..addCommand(WikipediaCommand());

  runner.run(arguments);
}
