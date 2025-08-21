class Event {
  final String imageUrl;
  final String date;
  final String time;
  final String category;
  final String title;
  final String description;
  final String place;
  final int totalVolunteers;
  final int joinedVolunteers;
  final int hours;
  final String leader;

  Event({
    required this.imageUrl,
    required this.date,
    required this.time,
    required this.category,
    required this.title,
    required this.description,
    required this.place,
    required this.totalVolunteers,
    required this.joinedVolunteers,
    required this.hours,
    required this.leader,
  });
}
