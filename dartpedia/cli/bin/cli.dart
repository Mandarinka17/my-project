import 'package:command_runner/command_runner.dart';

const String version = '0.0.1';

void main(List<String> arguments) async {
  final runner = CommandRunner(
    executableName: 'dartpedia',
    version: version,
    onOutput: (String output) async {
      // ПРИНУДИТЕЛЬНАЯ ЗАДЕРЖКА МЕЖДУ СТРОКАМИ
      final lines = output.split('\n');
      for (int i = 0; i < lines.length; i++) {
        print(lines[i]);
        if (i < lines.length - 1) { // не ждать после последней строки
          await Future.delayed(Duration(milliseconds: 500));
        }
      }
    },
    onError: (Object error) {
      if (error is Error) throw error;
      print('Ошибка: $error');
    },
  );

  runner
    ..addCommand(VersionCommand(version))
    ..addCommand(HelpCommand())
    ..addCommand(WikipediaCommand());

  await runner.run(arguments);
}
