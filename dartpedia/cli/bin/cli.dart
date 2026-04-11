import 'package:command_runner/command_runner.dart';

void main(List<String> arguments) async {
  const version = '0.0.1';
  final runner = CommandRunner(executableName: 'dartpedia', version: version);

  runner.addCommand(VersionCommand(version));
  runner.addCommand(HelpCommand());
  runner.addCommand(WikipediaCommand());

  await runner.run(arguments);
}
