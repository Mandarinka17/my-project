import 'dart:io';
import 'package:logging/logging.dart';

Logger initFileLogger(String name) {
  hierarchicalLoggingEnabled = true;
  final logger = Logger(name);
  final now = DateTime.now();

  final currentDir = Directory.current.path;
  final logsDir = Directory('$currentDir/logs');
  if (!logsDir.existsSync()) {
    logsDir.createSync();
  }

  final logFile = File(
    '${logsDir.path}/${now.year}_${now.month}_${now.day}_$name.txt',
  );

  logger.level = Level.ALL;
  logger.onRecord.listen((record) {
    final msg = '[${record.time}] ${record.level.name}: ${record.message}';
    logFile.writeAsStringSync('$msg\n', mode: FileMode.append);
  });

  return logger;
}
