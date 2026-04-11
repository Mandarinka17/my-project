import 'package:command_runner/command_runner.dart';

void main(List<String> arguments) async {
  const version = '0.0.1';
  
  final runner = CommandRunner(
    executableName: 'dartpedia',
    version: version,
    onError: (error) {
      // Пользовательская обработка ошибок – выводим сообщение без аварийного завершения
      print('Ошибка: $error');
      // Можно также показать справку или завершить с кодом 1
      // exit(1);
    },
  );

  runner
    ..addCommand(VersionCommand(version))
    ..addCommand(HelpCommand())
    ..addCommand(WikipediaCommand());

  await runner.run(arguments);
}
