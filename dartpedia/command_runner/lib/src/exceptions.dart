class ArgumentException extends FormatException {
  final String? command;
  final String? argumentName;

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
