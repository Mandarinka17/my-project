/// Отдельный результат поиска (заголовок и URL).
class SearchResult {
  final String title;
  final String url;

  SearchResult({required this.title, required this.url});

  @override
  String toString() => 'SearchResult(title: $title, url: $url)';
}

/// Контейнер для списка результатов поиска.
class SearchResults {
  final List<SearchResult> results;
  final String? searchTerm;

  SearchResults(this.results, {this.searchTerm});

  /// Создаёт [SearchResults] из JSON-ответа поискового API.
  /// Ожидается, что JSON имеет формат:
  /// [searchTerm, articleTitles, _, urls]
  /// где articleTitles и urls — итерируемые коллекции.
  static SearchResults fromJson(List<Object?> json) {
    if (json.length >= 4 &&
        json[0] is String &&
        json[1] is Iterable &&
        json[3] is Iterable) {
      final searchTerm = json[0] as String;
      final titlesIter = json[1] as Iterable;
      final urlsIter = json[3] as Iterable;

      final results = <SearchResult>[];
      final titles = titlesIter.toList();
      final urls = urlsIter.toList();
      final minLen = titles.length < urls.length ? titles.length : urls.length;

      for (int i = 0; i < minLen; i++) {
        results.add(SearchResult(
          title: titles[i].toString(),
          url: urls[i].toString(),
        ));
      }
      return SearchResults(results, searchTerm: searchTerm);
    }
    throw FormatException('Could not deserialize SearchResults, json=$json');
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('SearchResults for "$searchTerm":');
    for (var result in results) {
      buffer.writeln('  ${result.url}');
    }
    return buffer.toString();
  }
}
