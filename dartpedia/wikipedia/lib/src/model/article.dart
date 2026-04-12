/// Полная статья (extract).
class Article {
  final int pageId;
  final String title;
  final String extract;

  Article({
    required this.pageId,
    required this.title,
    required this.extract,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      pageId: json['pageid'] ?? 0,
      title: json['title'] ?? '',
      extract: json['extract'] ?? '',
    );
  }

  static List<Article> listFromJson(Map<String, dynamic> jsonData) {
    final pages = jsonData['query']['pages'] as Map<String, dynamic>;
    final articles = <Article>[];
    for (var page in pages.values) {
      articles.add(Article.fromJson(page));
    }
    return articles;
  }
}
