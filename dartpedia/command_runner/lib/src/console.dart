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
/// Расширение для строк, добавляющее методы цветного форматирования и разбивки по длине.
extension TextRendererUtils on String {
  /// Применяет красный цвет (для ошибок).
  String get errorText => ConsoleColor.red.applyForeground(this);

  /// Применяет жёлтый цвет (для инструкций).
  String get instructionText => ConsoleColor.yellow.applyForeground(this);

  /// Применяет светло-голубой цвет (для заголовков).
  String get titleText => ConsoleColor.lightBlue.applyForeground(this);

  /// Разбивает строку на список строк, каждая из которых не длиннее [maxLength].
  /// Слова не разрываются, а переносятся целиком.
  List<String> splitLinesByLength(int maxLength) {
    final words = split(' ');
    final lines = <String>[];
    final buffer = StringBuffer();

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      // Если добавление этого слова с пробелом не превышает длину
      if (buffer.length + word.length + (buffer.isEmpty ? 0 : 1) <= maxLength) {
        if (buffer.isNotEmpty) buffer.write(' ');
        buffer.write(word);
      } else {
        // Если слово уже есть в буфере, сохраняем строку и начинаем новую
        if (buffer.isNotEmpty) {
          lines.add(buffer.toString());
          buffer.clear();
        }
        // Если одно слово длиннее maxLength – принудительно разрываем? 
        // По заданию – не разрываем, но для красоты можно добавить проверку.
        // Здесь просто добавим слово целиком (даже если длиннее)
        if (word.length > maxLength) {
          lines.add(word);
        } else {
          buffer.write(word);
        }
      }
    }
    // Добавляем остаток
    if (buffer.isNotEmpty) lines.add(buffer.toString());
    return lines;
  }
}
