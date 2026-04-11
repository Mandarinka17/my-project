import 'dart:async';
import '../arguments.dart';
import '../command_runner_base.dart';
import '../console.dart';
import '../exceptions.dart';

class HelpCommand extends Command {
  HelpCommand() {
    addFlag('verbose', abbr: 'v', help: 'Show detailed help for all commands.');
    addOption('command', abbr: 'c', help: 'Show detailed help only for the specified command.');
  }

  @override
  String get name => 'help';

  @override
  String get description => 'Prints usage information for the application or a specific command.';

  @override
  String? get help => 'Displays help. Use --verbose for details, --command <name> for command-specific help.';

  @override
  FutureOr<Object?> run(ArgResults args) async {
    final buffer = StringBuffer();
    buffer.writeln(runner.usage.titleText);

    if (args.hasOption('command')) {
      final commandName = (args.getOption('command').input as String);
      final command = runner.commands.firstWhere(
        (cmd) => cmd.name == commandName,
        orElse: () {
          throw ArgumentException(
            'Command "$commandName" is not a known command.',
            command: name,
            argumentName: commandName,
          );
        },
      );
      buffer.write(_renderCommandVerbose(command));
      print(buffer.toString());
      return null;
    }

    if (args.flag('verbose')) {
      for (var cmd in runner.commands) {
        buffer.write(_renderCommandVerbose(cmd));
      }
      print(buffer.toString());
      return null;
    }

    for (var cmd in runner.commands) {
      buffer.writeln(cmd.usage);
    }
    print(buffer.toString());
    return null;
  }

  String _renderCommandVerbose(Command cmd) {
    final indent = ' ' * 10; // 10 пробелов (не const!)
    final buffer = StringBuffer();
    buffer.writeln(cmd.usage.instructionText);
    if (cmd.help != null) {
      buffer.writeln('$indent${cmd.help}');
    }
    buffer.writeln('$indent Requires argument: ${cmd.requiresArgument}'); // пробел после $indent
    if (cmd.valueHelp != null) {
      buffer.writeln('$indent Argument type: ${cmd.valueHelp}'); // пробел после $indent
    }
    if (cmd.defaultValue != null) {
      buffer.writeln('$indent Default value: ${cmd.defaultValue}'); // пробел после $indent
    }
    if (cmd.options.isNotEmpty) {
      buffer.writeln('$indent Options:'); // пробел после $indent
      for (var opt in cmd.options) {
        buffer.writeln('$indent   ${opt.usage}');
      }
    }
    return buffer.toString();
  }
}
