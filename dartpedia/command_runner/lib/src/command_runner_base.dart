import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommandRunner {
  final String version;
  final Map<String, Future<void> Function(List<String>)> _commands = {};

  CommandRunner({required this.version}) {
    addCommand('version', _handleVersion);
    addCommand('help', _handleHelp);
    addCommand('wikipedia', _handleWikipedia);
  }

  void addCommand(String name, Future<void> Function(List<String>) handler) {
    _commands[name] = handler;
  }

  Future<void> run(List<String> arguments) async {
    if (arguments.isEmpty) {
      await _handleHelp([]);
      return;
    }

    final String command = arguments.first;
    final List<String> args = arguments.skip(1).toList();

    if (_commands.containsKey(command)) {
      await _commands[command]!(args);
    } else {
      print('Unknown command: $command');
      await _handleHelp([]);
    }
  }

  Future<void> _handleVersion(List<String> _) async {
    print('Dartpedia CLI version $version');
  }

  Future<void> _handleHelp(List<String> _) async {
    print('Available commands:');
    for (final String cmd in _commands.keys) {
      print('  $cmd');
    }
    print('Usage: dart run bin/cli.dart <command> [arguments]');
  }

  Future<void> _handleWikipedia(List<String> args) async {
    String articleTitle;
    if (args.isEmpty) {
      print('Please provide an article title.');
      final input = stdin.readLineSync();
      if (input == null || input.isEmpty) {
        print('No article title provided. Exiting.');
        return;
      }
      articleTitle = input;
    } else {
      articleTitle = args.join(' ');
    }

    print('Looking up articles about "$articleTitle". Please wait.');

    final url = Uri.https(
      'ru.wikipedia.org',
      '/api/rest_v1/page/summary/$articleTitle',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final extract = data['extract'];
        if (extract != null && extract.isNotEmpty) {
          print(extract);
        } else {
          print('Краткое содержание не найдено.');
        }
      } else if (response.statusCode == 404) {
        print('Статья "$articleTitle" не найдена на Википедии.');
      } else {
        print('Ошибка HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка соединения: $e');
    }
  }
}
