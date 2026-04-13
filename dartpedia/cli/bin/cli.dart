import 'package:command_runner/command_runner.dart';
import 'package:cli/cli.dart';

const String version = '0.0.1';

void main(List<String> arguments) async {
  final logger = initFileLogger('dartpedia');
  logger.info('Application started');

  final runner = CommandRunner(
    executableName: 'dartpedia',
    version: version,
    onOutput: (String output) async {
      final lines = output.split('\n');
      for (int i = 0; i < lines.length; i++) {
        print(lines[i]);
        if (i < lines.length - 1) {
          await Future.delayed(Duration(milliseconds: 500));
        }
      }
    },
    onError: (Object error) {
      if (error is Error) throw error;
      final msg = 'Ошибка: $error';
      print(msg);
      logger.severe(msg);
    },
  );

  runner
    ..addCommand(VersionCommand(version))
    ..addCommand(HelpCommand())
    ..addCommand(WikipediaCommand());

  await runner.run(arguments);
}
