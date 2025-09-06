import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/helper/utils.dart';
import 'package:ammerha_management/core/provider/honor_board_provider.dart';
import 'package:ammerha_management/screens/volunteer_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RankListWidget extends StatelessWidget {
  final List<HonorItem> volunteers;
  const RankListWidget({super.key, required this.volunteers});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: volunteers.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = volunteers[index];
        final u = item.user;
        final pts = u.points ?? 0;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      VolunteerProfileScreen2(vol: u, showEndButton: false),
                ),
              );
            },
            child: Container(
              height: 80,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // the order
                      Text(
                        item.position.toString(),
                        style: GoogleFonts.almarai(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // selfie
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage:
                            (u.imageUrl != null && u.imageUrl!.isNotEmpty)
                            ? NetworkImage(u.imageUrl!)
                            : const AssetImage('assets/images/profile.png')
                                  as ImageProvider,
                      ),
                      const SizedBox(width: 12),
                      // name
                      Text(
                        u.name,
                        style: GoogleFonts.almarai(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // the rank image
                      Image.asset(
                        RankUtils.medalAsset(u.rank),
                        width: 26,
                        height: 26,
                      ),
                      const SizedBox(width: 10),
                      // points
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Text(
                          '$pts نقطة',
                          style: GoogleFonts.almarai(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
