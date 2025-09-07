class NewsItem {
  final String id;
  final String title;
  final String body;
  final String imageUrl; // cover_image.file
  final DateTime publishDate;

  NewsItem({
    required this.id,
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.publishDate,
  });

  factory NewsItem.fromApi(Map<String, dynamic> j) {
    // publish_date looks like: "September 3, 2025 - 2:36 PM"
    // We'll try to convert it, and if it fails, we'll put it now.
    DateTime parsed = DateTime.now();
    final raw = (j['publish_date'] ?? '').toString().trim();
    try {
      parsed = DateTime.parse(raw); //If it is ISO
    } catch (_) {
      try {
        parsed = _fallbackParseHumanDate(raw);
      } catch (_) {}
    }

    return NewsItem(
      id: j['id'].toString(),
      title: j['title']?.toString() ?? '',
      body: j['body']?.toString() ?? '',
      imageUrl: j['cover_image']?['file']?.toString() ?? '',
      publishDate: parsed,
    );
  }

  static DateTime _fallbackParseHumanDate(String s) {
    // Simple parsing for dates like "September 3, 2025 - 2:36 PM"
    final cleaned = s.replaceAll(' - ', ' ');
    return DateTime.tryParse(cleaned) ?? DateTime.now();
  }

  String get arDate {
    // A brief history of the Arab show
    final m = publishDate.month.toString().padLeft(2, '0');
    final d = publishDate.day.toString().padLeft(2, '0');
    return '${publishDate.year}-$m-$d';
  }

  String get date => arDate;
}
