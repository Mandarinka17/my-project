import 'dart:collection';
import 'dart:io';
import 'arguments.dart';

class CommandRunner {
  final Map<String, Command> _commands = {};
  final String? executableName;
  final String version;

  CommandRunner({this.executableName, required this.version});

  UnmodifiableSetView<Command> get commands =>
      UnmodifiableSetView(_commands.values.toSet());

  void addCommand(Command command) {
    _commands[command.name] = command;
    command.runner = this;
  }

  ArgResults parse(List<String> input) {
    final results = ArgResults();
    if (input.isEmpty) {
      return results;
    }
    final commandName = input.first;
    final command = _commands[commandName];
    if (command != null) {
      results.command = command;
      // Здесь можно добавить парсинг аргументов команды,
      // но для простоты оставим как есть – вы передадите commandArg позже.
      if (input.length > 1) {
        results.commandArg = input.skip(1).join(' ');
      }
    }
    return results;
  }

  Future<void> run(List<String> arguments) async {
    if (arguments.isEmpty) {
      showHelp();
      return;
    }

    final results = parse(arguments);
    if (results.command != null) {
      await results.command!.run(results);
    } else {
      print('Unknown command: ${arguments.first}');
      showHelp();
    }
  }

  void showHelp() {
    print('Usage: ${executableName ?? "dart run bin/cli.dart"} <command> [options]');
    print('Available commands:');
    for (var cmd in _commands.values) {
      print('  ${cmd.name} - ${cmd.description}');
    }
  }
}
