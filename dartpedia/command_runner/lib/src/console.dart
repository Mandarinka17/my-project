import 'dart:io';

/// ANSI escape-последовательность для управления цветом.
const String ansiEscape = '\x1B';

/// Печатает текст построчно с задержкой (для эффекта печати).
Future<void> write(String text, {int duration = 50}) async {
  final lines = text.split('\n');
  for (final line in lines) {
    await _delayedPrint('$line\n', duration: duration);
  }
}

Future<void> _delayedPrint(String text, {int duration = 0}) async {
  return Future<void>.delayed(
    Duration(milliseconds: duration),
    () => stdout.write(text),
  );
}

/// Цвета для оформления вывода в консоли (RGB).
enum ConsoleColor {
  lightBlue(184, 234, 254), // #b8eafe
  red(242, 93, 80),        // #F25D50
  yellow(249, 248, 196),   // #F9F8C4
  grey(240, 240, 240),     // #F8F9FA
  white(255, 255, 255);

  const ConsoleColor(this.r, this.g, this.b);
  final int r;
  final int g;
  final int b;

  /// Включает цвет текста для всего последующего вывода (до сброса).
  String get enableForeground => '$ansiEscape[38;2;$r;$g;${b}m';

  /// Включает цвет фона для всего последующего вывода (до сброса).
  String get enableBackground => '$ansiEscape[48;2;$r;$g;${b}m';

  /// Сбрасывает цвет текста и фона к стандартным настройкам терминала.
  static String get reset => '${ansiEscape}[0m';

  /// Применяет цвет только к указанному тексту (автоматический сброс).
  String applyForeground(String text) => '$enableForeground$text$reset';

  /// Применяет цвет фона только к указанному тексту (автоматический сброс).
  String applyBackground(String text) => '$enableBackground$text$reset';
}
