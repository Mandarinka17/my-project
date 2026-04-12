import 'title_set.dart';

/// Краткое содержание статьи из Wikipedia API.
class Summary {
  /// Набор заголовков статьи.
  final TitlesSet titles;

  /// ID страницы.
  final int pageid;

  /// Первые несколько предложений статьи в виде простого текста.
  final String extract;

  /// Первые несколько предложений статьи в формате HTML.
  final String extractHtml;

  /// Код языка страницы (например, "ru", "en").
  final String lang;

  /// Направление письма (например, "ltr").
  final String dir;

  /// URL статьи на Wikipedia.
  final String? url;

  /// Краткое описание из Wikidata (может отсутствовать).
  final String? description;

  Summary({
    required this.titles,
    required this.pageid,
    required this.extract,
    required this.extractHtml,
    required this.lang,
    required this.dir,
    this.url,
    this.description,
  });

  /// Создаёт [Summary] из JSON-объекта.
  static Summary fromJson(Map<String, Object?> json) {
    return switch (json) {
      {
        'titles': final Map<String, Object?> titles,
        'pageid': final int pageid,
        'extract': final String extract,
        'extract_html': final String extractHtml,
        'lang': final String lang,
        'dir': final String dir,
        'content_urls': {
          'desktop': {'page': final String url},
          'mobile': {'page': String _},
        },
        'description': final String description,
      } =>
        Summary(
          titles: TitlesSet.fromJson(titles),
          pageid: pageid,
          extract: extract,
          extractHtml: extractHtml,
          lang: lang,
          dir: dir,
          url: url,
          description: description,
        ),
      {
        'titles': final Map<String, Object?> titles,
        'pageid': final int pageid,
        'extract': final String extract,
        'extract_html': final String extractHtml,
        'lang': final String lang,
        'dir': final String dir,
        'content_urls': {
          'desktop': {'page': final String url},
          'mobile': {'page': String _},
        },
      } =>
        Summary(
          titles: TitlesSet.fromJson(titles),
          pageid: pageid,
          extract: extract,
          extractHtml: extractHtml,
          lang: lang,
          dir: dir,
          url: url,
        ),
      _ => throw FormatException('Could not deserialize Summary, json=$json'),
    };
  }

  @override
  String toString() {
    return 'Summary(titles: $titles, pageid: $pageid, extract: $extract, '
        'extractHtml: $extractHtml, lang: $lang, dir: $dir, '
        'url: $url, description: $description)';
  }
}
