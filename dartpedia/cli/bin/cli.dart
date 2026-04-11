import 'package:command_runner/command_runner.dart';

const version = '0.0.1';

void main(List<String> arguments) {
  final runner = CommandRunner(
    executableName: 'dartpedia',
    version: version,
    onError: (Object error) {
      // Выводим ошибку красным цветом
      print(ConsoleColor.red.applyForeground('Ошибка: $error'));
      if (error is Error) {
        // Для критических ошибок можно вывести стек и завершить
        print(error.stackTrace);
        // exit(1);
      }
    },
  );

  runner
    ..addCommand(VersionCommand(version))
    ..addCommand(HelpCommand())
    ..addCommand(WikipediaCommand());

  runner.run(arguments);
}
