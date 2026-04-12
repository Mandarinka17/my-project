/// Модель статьи, возвращаемая поисковым запросом Wikipedia API.
class Article {
  /// Заголовок статьи.
  final String title;

  /// Краткое содержание (аннотация).
  final String extract;

  Article({required this.title, required this.extract});

  /// Создаёт список [Article] из JSON-ответа поискового API.
  static List<Article> listFromJson(Map<String, Object?> json) {
    final articles = <Article>[];
    if (json case {'query': {'pages': final Map<String, Object?> pages}}) {
      for (final entry in pages.entries) {
        final value = entry.value;
        if (value case {
          'title': final String title,
          'extract': final String extract,
        }) {
          articles.add(Article(title: title, extract: extract));
        }
      }
      return articles;
    }
    throw FormatException('Could not deserialize Article list, json=$json');
  }

  /// Преобразует объект [Article] в JSON-совместимую карту.
  Map<String, Object?> toJson() => {
        'title': title,
        'extract': extract,
      };

  @override
  String toString() => 'Article(title: $title, extract: $extract)';
}
