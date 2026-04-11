import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'arguments.dart';
import 'exceptions.dart';

class CommandRunner {
  final Map<String, Command> _commands = {};
  final String? executableName;
  final String version;
  
  /// Обработчик ошибок (опциональный). Вызывается при возникновении исключения.
  FutureOr<void> Function(Object)? onError;

  CommandRunner({this.executableName, required this.version, this.onError});

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

  /// Удаляет один или два дефиса из начала строки опции.
  String _removeDash(String arg) {
    if (arg.startsWith('--')) return arg.substring(2);
    if (arg.startsWith('-')) return arg.substring(1);
    return arg;
  }

  /// Парсит аргументы, выбрасывает ArgumentException при ошибках.
  ArgResults parse(List<String> input) {
    final results = ArgResults();
    if (input.isEmpty) return results;

    // 1. Проверка: первый аргумент – известная команда
    final commandName = input.first;
    final command = _commands[commandName];
    if (command == null) {
      throw ArgumentException(
        'The first word of input must be a command.',
        command: null,
        argumentName: commandName,
      );
    }
    results.command = command;
    input = input.sublist(1);

    // 2. Проверка: только одна команда
    if (input.isNotEmpty && _commands.containsKey(input.first)) {
      throw ArgumentException(
        'Input can only contain one command. Got ${input.first} and ${command.name}',
        command: command.name,
        argumentName: input.first,
      );
    }

    final Map<Option, Object?> inputOptions = {};
    int i = 0;
    while (i < input.length) {
      final arg = input[i];
      if (arg.startsWith('-')) {
        final base = _removeDash(arg);
        final option = command.options.firstWhere(
          (opt) => opt.name == base || opt.abbr == base,
          orElse: () {
            throw ArgumentException(
              'Unknown option $arg',
              command: command.name,
              argumentName: arg,
            );
          },
        );

        if (option.type == OptionType.flag) {
          inputOptions[option] = true;
          i++;
          continue;
        }

        if (option.type == OptionType.option) {
          // Проверка: после опции должно быть значение
          if (i + 1 >= input.length) {
            throw ArgumentException(
              'Option ${option.name} requires an argument',
              command: command.name,
              argumentName: option.name,
            );
          }
          final next = input[i + 1];
          if (next.startsWith('-')) {
            throw ArgumentException(
              'Option ${option.name} requires an argument, but got another option $next',
              command: command.name,
              argumentName: option.name,
            );
          }
          inputOptions[option] = next;
          i += 2;
          continue;
        }
      } else {
        // Позиционный аргумент (commandArg)
        if (results.commandArg != null) {
          throw ArgumentException(
            'Commands can only have up to one positional argument.',
            command: command.name,
            argumentName: arg,
          );
        }
        results.commandArg = arg;
        i++;
      }
    }

    results.options = inputOptions;
    return results;
  }

  /// Запускает парсер и выполнение команды с обработкой ошибок.
  Future<void> run(List<String> arguments) async {
    try {
      if (arguments.isEmpty) {
        showHelp();
        return;
      }

      final results = parse(arguments);
      if (results.command != null) {
        final output = await results.command!.run(results);
        if (output != null) print(output);
      }
    } on Exception catch (e) {
      if (onError != null) {
        await onError!(e);
      } else {
        rethrow;
      }
    }
  }
}
