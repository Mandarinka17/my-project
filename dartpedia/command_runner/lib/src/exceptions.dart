/// Исключение, возникающее при ошибках в аргументах командной строки.
class ArgumentException extends FormatException {
  /// Команда, которая обрабатывалась в момент возникновения ошибки.
  final String? command;

  /// Имя аргумента (опции или флага), вызвавшего ошибку.
  final String? argumentName;

  /// Создаёт исключение с сообщением, командой, именем аргумента,
  /// исходным текстом (source) и смещением (offset).
  ArgumentException(
    String message, {
    this.command,
    this.argumentName,
    Object? source,
    int? offset,
  }) : super(message, source, offset);

  @override
  String toString() {
    return 'ArgumentException: $message';
  }
}
