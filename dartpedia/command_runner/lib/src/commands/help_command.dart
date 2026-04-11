import 'dart:async';
import '../arguments.dart';

class HelpCommand extends Command {
  HelpCommand() {
    addFlag(
      'verbose',
      abbr: 'v',
      help: 'When true, prints each command and its options.',
    );
    addOption(
      'command',
      abbr: 'c',
      help: 'When a command is passed as an argument, prints only that command\'s verbose usage.',
    );
  }

  @override
  String get name => 'help';

  @override
  String get description => 'Prints usage information to the command line.';

  @override
  String? get help => 'Prints this usage information';

  @override
  FutureOr<Object?> run(ArgResults args) async {
    final verbose = args.flag('verbose');
    final commandName = args.hasOption('command')
        ? (args.getOption('command').input as String?)
        : null;

    // Если указана конкретная команда
    if (commandName != null) {
      final command = runner.getCommand(commandName);
      if (command == null) {
        print('Unknown command: $commandName');
        return null;
      }
      print(runner.commandUsage(command));
      return null;
    }

    // Общая справка
    print(runner.usage);
    print('Available commands:');
    for (var cmd in runner.commands) {
      if (verbose) {
        print(runner.commandUsage(cmd));
      } else {
        print('  ${cmd.name} - ${cmd.description}');
      }
    }
    return null;
  }
}
