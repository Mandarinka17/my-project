import 'package:command_runner/command_runner.dart';

void main(List<String> arguments) async {
  const String version = '0.0.1';
  final CommandRunner runner = CommandRunner(version: version);
  await runner.run(arguments);
}
