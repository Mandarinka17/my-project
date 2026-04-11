import 'dart:async';
import '../arguments.dart';

class HelpCommand extends Command {
  @override
  String get name => 'help';

  @override
  String get description => 'Show this help message';

  @override
  FutureOr<Object?> run(ArgResults args) async {
    runner.showHelp();   // runner - dynamic, метод showHelp есть
    return null;
  }
}
