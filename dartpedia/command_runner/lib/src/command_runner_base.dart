import 'dart:collection';
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

  Command? getCommand(String name) => _commands[name];

  String get usage {
    final exeName = executableName ?? 'dart run bin/cli.dart';
    return 'Usage: $exeName <command> [options]';
  }

  String commandUsage(Command command) {
    final buffer = StringBuffer();
    buffer.writeln('Command: ${command.name} - ${command.description}');
    if (command.options.isNotEmpty) {
      buffer.writeln('Options:');
      for (var opt in command.options) {
        buffer.writeln('  ${opt.usage}');
      }
    }
    return buffer.toString();
  }

  void showHelp() {
    print(usage);
    print('Available commands:');
    for (var cmd in _commands.values) {
      print('  ${cmd.name} - ${cmd.description}');
    }
  }

  Future<void> run(List<String> arguments) async {
    if (arguments.isEmpty) {
      showHelp();
      return;
    }

    final commandName = arguments.first;
    final command = _commands[commandName];
    if (command == null) {
      print('Unknown command: $commandName');
      showHelp();
      return;
    }

    // Передаём остальные аргументы как commandArg (упрощённо)
    final args = arguments.skip(1).toList();
    final argResults = ArgResults()..command = command;
    if (args.isNotEmpty) {
      argResults.commandArg = args.join(' ');
    }
    await command.run(argResults);
  }
}
