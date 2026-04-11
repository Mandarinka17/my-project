import 'package:command_runner/command_runner.dart';

const version = '0.0.1';

void main(List<String> arguments) {
  final runner = CommandRunner(
    executableName: 'dartpedia',
    version: version,
    onError: (Object error) {
      // Если это критическая ошибка (Error), перебрасываем её
      if (error is Error) {
        throw error;
      }
      // Если это исключение (Exception) – выводим понятное сообщение
      if (error is Exception) {
        print('Ошибка: $error');
      }
    },
  );

  runner
    ..addCommand(VersionCommand(version))
    ..addCommand(HelpCommand())
    ..addCommand(WikipediaCommand());

  runner.run(arguments);
}
