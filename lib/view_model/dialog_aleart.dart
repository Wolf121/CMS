class PagesDialog {
  final int id;
  final String title;
  final String description;
  final String type;

  PagesDialog({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
  });

  factory PagesDialog.fromJson(Map<String, dynamic> json) {
    return PagesDialog(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
    );
  }
}
