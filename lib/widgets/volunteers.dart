class Volunteer {
  final String id;
  final String name;
  final String department;
  final int opportunities;
  final bool hasGoldBadge;

  Volunteer({
    required this.id,
    required this.name,
    required this.department,
    required this.opportunities,
    this.hasGoldBadge = false,
  });
}