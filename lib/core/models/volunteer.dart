class Volunteer {
  final String name;
  final String imageUrl;
  final int rank;
  final int opportunities;
  final RankTier tier;

  Volunteer({
    required this.name,
    required this.imageUrl,
    required this.rank,
    required this.opportunities,
    required this.tier,
  });
}

enum RankTier { bronze, silver, gold, diamond }
