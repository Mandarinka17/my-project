import 'dart:async';
import '../arguments.dart';

class VersionCommand extends Command {
  final String version;

  VersionCommand(this.version) {
    // Переопределяем геттеры через поля (см. ниже)
  }

  @override
  String get name => 'version';

  @override
  String get description => 'Show version information';

  @override
  FutureOr<Object?> run(ArgResults args) async {
    print('Dartpedia CLI version $version');
    return null; // явно возвращаем null
  }
}
