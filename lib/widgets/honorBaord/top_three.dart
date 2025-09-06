import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/helper/utils.dart';
import 'package:ammerha_management/core/provider/honor_board_provider.dart';
import 'package:ammerha_management/screens/volunteer_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopThreePodiumWidget extends StatelessWidget {
  final List<HonorItem> topThree;
  const TopThreePodiumWidget({super.key, required this.topThree});

  @override
  Widget build(BuildContext context) {
    // ترتيب العرض: الثاني يسار، الأول وسط، الثالث يمين
    final ordered = [topThree[1], topThree[0], topThree[2]];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPodiumItem(context, ordered[0], 150, AppColors.secondary),
          const SizedBox(width: 8),
          _buildPodiumItem(context, ordered[1], 180, AppColors.primary),
          const SizedBox(width: 8),
          _buildPodiumItem(context, ordered[2], 120, AppColors.secondary),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(
    BuildContext context,
    HonorItem item,
    double height,
    Color color,
  ) {
    final u = item.user;
    final pts = u.points ?? 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    VolunteerProfileScreen2(vol: u, showEndButton: false),
              ),
            );
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: (u.imageUrl != null && u.imageUrl!.isNotEmpty)
                    ? NetworkImage(u.imageUrl!)
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
                  child: Image.asset(
                    RankUtils.medalAsset(u.rank),
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          u.name,
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
              // الترتيب
              Text(
                item.position.toString(),
                style: GoogleFonts.almarai(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 10),
              // النقاط
              Text(
                '$pts',
                style: GoogleFonts.almarai(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white.withOpacity(0.95),
                ),
              ),
              Text(
                'نقطة',
                style: GoogleFonts.almarai(
                  fontSize: 12,
                  color: AppColors.white.withOpacity(0.85),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
