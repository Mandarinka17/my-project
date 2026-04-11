import 'package:command_runner/command_runner.dart';

const version = '0.0.1';

void main(List<String> arguments) async {
  final runner = CommandRunner(executableName: 'dartpedia', version: version)
    ..addCommand(HelpCommand())
    ..addCommand(VersionCommand(version))
    ..addCommand(WikipediaCommand());

  await runner.run(arguments);
}
