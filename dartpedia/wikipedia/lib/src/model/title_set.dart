class TitlesSet {
  /// Канонический заголовок (например, "Dart_(programming_language)")
  final String canonical;

  /// Нормализованный заголовок (например, "Dart (programming language)")
  final String normalized;

  /// Отображаемый заголовок (может содержать HTML)
  final String display;

  TitlesSet({
    required this.canonical,
    required this.normalized,
    required this.display,
  });

  /// Создаёт [TitlesSet] из JSON-объекта.
  static TitlesSet fromJson(Map<String, Object?> json) {
    if (json case {
      'canonical': final String canonical,
      'normalized': final String normalized,
      'display': final String display,
    }) {
      return TitlesSet(
        canonical: canonical,
        normalized: normalized,
        display: display,
      );
    }
    throw FormatException('Could not deserialize TitlesSet, json=$json');
  }

  @override
  String toString() => 'TitlesSet(canonical: $canonical, normalized: $normalized, display: $display)';
}
