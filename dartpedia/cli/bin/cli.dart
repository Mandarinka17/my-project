import 'package:command_runner/command_runner.dart';

void main(List<String> arguments) {
  final runner = CommandRunner(
    executableName: 'dartpedia',
    version: '0.0.1',
    onOutput: (String text) {
      print('[OUTPUT] $text');   // без именованных аргументов
    },
    onError: (Object error) {
      if (error is Error) {
        throw error;
      }
      print('Ошибка: $error');
    },
  );

  runner
    ..addCommand(VersionCommand('0.0.1'))
    ..addCommand(HelpCommand())
    ..addCommand(WikipediaCommand());
    // ..addCommand(EchoCommand()); // закомментировано, т.к. не определён

  runner.run(arguments);   // без arguments:
}
