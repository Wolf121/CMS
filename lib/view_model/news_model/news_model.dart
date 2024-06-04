
class NewsItem {
  final String title;
  final String description;
  final String createdAt;
  final String banner;
  final String type;

  NewsItem({
    required this.title,
    required this.description,
    required this.createdAt,
    required this.banner,
    required this.type,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      title: json['title'],
      description: json['description'],
      createdAt: json['created_at'],
      banner: json['banner'],
      type: json['type']??"",
    );
  }
}
