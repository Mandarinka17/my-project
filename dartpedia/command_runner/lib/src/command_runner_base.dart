import 'dart:async';
import 'arguments.dart';

class CommandRunner {
  final Map<String, Command> _commands = {};
  final String? executableName;
  final String version;

  CommandRunner({this.executableName, required this.version});

  void addCommand(Command command) {
    command.runner = this;
    _commands[command.name] = command;
  }

  Future<void> run(List<String> arguments) async {
    if (arguments.isEmpty) {
      showHelp();
      return;
    }

    final commandName = arguments.first;
    final commandArgs = arguments.skip(1).toList();

    final command = _commands[commandName];
    if (command == null) {
      print('Unknown command: $commandName');
      showHelp();
      return;
    }

    final argResults = _parseArguments(command, commandArgs);
    await command.run(argResults);
  }

  ArgResults _parseArguments(Command command, List<String> args) {
    final optionsMap = <Option, Object?>{};
    String? commandArg;

    for (int i = 0; i < args.length; i++) {
      final arg = args[i];
      if (arg.startsWith('--')) {
        final optionName = arg.substring(2);
        final option = command.options.firstWhere(
          (opt) => opt.name == optionName,
          orElse: () => throw Exception('Unknown option: --$optionName'),
        );
        if (option.type == OptionType.flag) {
          optionsMap[option] = true;
        } else {
          if (i + 1 < args.length) {
            optionsMap[option] = args[i + 1];
            i++;
          } else {
            throw Exception('Missing value for option: --$optionName');
          }
        }
      } else if (arg.startsWith('-')) {
        final abbr = arg.substring(1);
        final option = command.options.firstWhere(
          (opt) => opt.abbr == abbr,
          orElse: () => throw Exception('Unknown option: -$abbr'),
        );
        if (option.type == OptionType.flag) {
          optionsMap[option] = true;
        } else {
          if (i + 1 < args.length) {
            optionsMap[option] = args[i + 1];
            i++;
          } else {
            throw Exception('Missing value for option: -$abbr');
          }
        }
      } else {
        if (commandArg == null) {
          commandArg = arg;
        } else {
          throw Exception('Too many positional arguments');
        }
      }
    }

    return ArgResults()
      ..command = command
      ..commandArg = commandArg
      ..options = optionsMap;
  }

  void showHelp() {
    print('Usage: ${executableName ?? "dart run bin/cli.dart"} <command> [options]');
    print('Available commands:');
    for (var cmd in _commands.values) {
      print('  ${cmd.name} - ${cmd.description}');
    }
  }
}
