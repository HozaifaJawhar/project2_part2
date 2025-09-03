import 'package:ammerha_management/core/models/volunteer.dart';
import 'package:flutter/material.dart';

Widget getRankBadgeWidget(RankTier tier, {double size = 24}) {
  String imagePath;
  switch (tier) {
    case RankTier.diamond:
      imagePath = 'assets/icons/diamond_badge.png';
      break;
    case RankTier.gold:
      imagePath = 'assets/icons/medal3.png';
      break;
    case RankTier.silver:
      imagePath = 'assets/icons/silver_badge.png';
      break;
    case RankTier.bronze:
      imagePath = 'assets/icons/bronze_badge.png';
      break;
  }
  return Image.asset(imagePath, width: size, height: size);
}
