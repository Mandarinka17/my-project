import 'package:command_runner/command_runner.dart';

void main(List<String> arguments) async {
  const String version = '0.0.1';
  final CommandRunner runner = CommandRunner(executableName: 'dartpedia', version: version);

  runner.addCommand(VersionCommand(version));
  runner.addCommand(HelpCommand());
  runner.addCommand(WikipediaCommand());

  await runner.run(arguments);
}
