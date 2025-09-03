import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/models/volunteer.dart';
import 'package:ammerha_management/widgets/honorBaord/rank_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopThreePodiumWidget extends StatelessWidget {
  final List<Volunteer> topThree;

  const TopThreePodiumWidget({super.key, required this.topThree});

  @override
  Widget build(BuildContext context) {
    final orderedTopThree = [topThree[1], topThree[0], topThree[2]];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPodiumItem(
            context,
            orderedTopThree[0],
            150,
            AppColors.secondary,
          ),
          const SizedBox(width: 8),
          _buildPodiumItem(context, orderedTopThree[1], 180, AppColors.primary),
          const SizedBox(width: 8),
          _buildPodiumItem(
            context,
            orderedTopThree[2],
            150,
            AppColors.secondary,
          ),
        ],
      ),
    );
  }

  // Widget _getRankBadge(RankTier tier, {double size = 24}) {
  //   String imagePath;
  //   switch (tier) {
  //     case RankTier.diamond:
  //       imagePath = 'assets/icons/medal3.png';
  //       break;
  //     case RankTier.gold:
  //       imagePath = 'assets/icons/medal3.png';
  //       break;
  //     case RankTier.silver:
  //       imagePath = 'assets/icons/medal3.png';
  //       break;
  //     case RankTier.bronze:
  //       imagePath = 'assets/icons/medal3.png';
  //       break;
  //   }
  //   return Image.asset(imagePath, width: size, height: size);
  // }

  Widget _buildPodiumItem(
    BuildContext context,
    Volunteer volunteer,
    double height,
    Color color,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: volunteer.imageUrl.isNotEmpty
                  ? NetworkImage(volunteer.imageUrl)
                  : const AssetImage('assets/images/profile.png')
                        as ImageProvider,
            ),
            Positioned(
              right: -4,
              bottom: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
                child: getRankBadgeWidget(volunteer.tier, size: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          volunteer.name,
          style: GoogleFonts.almarai(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: height,
          width: MediaQuery.of(context).size.width / 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                volunteer.rank.toString(),
                style: GoogleFonts.almarai(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${volunteer.opportunities}',
                style: GoogleFonts.almarai(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white.withOpacity(0.9),
                ),
              ),
              Text(
                'فرصة تطوعية',
                style: GoogleFonts.almarai(
                  fontSize: 12,
                  color: AppColors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
