/// Набор заголовков статьи (канонический, нормализованный, отображаемый).
class TitlesSet {
  final String canonical;
  final String normalized;
  final String display;

  TitlesSet({
    required this.canonical,
    required this.normalized,
    required this.display,
  });

  factory TitlesSet.fromJson(Map<String, dynamic> json) {
    return TitlesSet(
      canonical: json['canonical'] ?? '',
      normalized: json['normalized'] ?? '',
      display: json['display'] ?? '',
    );
  }

  @override
  String toString() => 'TitlesSet(canonical: $canonical, normalized: $normalized, display: $display)';
}
