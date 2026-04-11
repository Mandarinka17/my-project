import 'dart:async';
import 'package:command_runner/command_runner.dart';

class PrettyEcho extends Command {
  PrettyEcho() {
    addFlag('blue-only', abbr: 'b', help: 'When true, the echoed text will all be blue.');
  }

  @override
  String get name => 'echo';
  @override
  bool get requiresArgument => true;
  @override
  String get description => 'Print input, but colorful.';
  @override
  String? get help => 'Echos a String provided as an argument with ANSI coloring.';
  @override
  String? get valueHelp => 'STRING';

  @override
  FutureOr<String> run(ArgResults arg) {
    if (arg.commandArg == null) {
      throw ArgumentException(
        'This command requires one positional argument',
        command: name,
        argumentName: 'text',
      );
    }

    final words = arg.commandArg!.split(' ');
    final prettyWords = <String>[];

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      switch (i % 3) {
        case 0:
          prettyWords.add(word.titleText);
          break;
        case 1:
          prettyWords.add(word.instructionText);
          break;
        case 2:
          prettyWords.add(word.errorText);
          break;
      }
    }
    return prettyWords.join(' ');
  }
}

void main(List<String> arguments) {
  final runner = CommandRunner(version: '0.0.1')
    ..addCommand(PrettyEcho());   // без command:
  runner.run(arguments);          // без arguments:
}
