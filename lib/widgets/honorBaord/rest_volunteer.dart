import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/models/volunteer.dart';
import 'package:ammerha_management/widgets/honorBaord/rank_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RankListWidget extends StatelessWidget {
  final List<Volunteer> volunteers;

  const RankListWidget({super.key, required this.volunteers});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: volunteers.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final volunteer = volunteers[index];
        return _buildRankListItem(volunteer);
      },
    );
  }

  Widget _buildRankListItem(Volunteer volunteer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // الجزء الأول: الترتيب، الصورة، والاسم
            Row(
              children: [
                // 1. الترتيب
                Text(
                  volunteer.rank.toString(),
                  style: GoogleFonts.almarai(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),

                // 2. صورة البروفايل
                CircleAvatar(
                  radius: 20, // حجم مناسب للقائمة
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: volunteer.imageUrl.isNotEmpty
                      ? NetworkImage(volunteer.imageUrl)
                      : const AssetImage('assets/images/profile.png')
                            as ImageProvider,
                ),
                const SizedBox(width: 12),

                // 3. اسم المتطوع
                Text(
                  volunteer.name,
                  style: GoogleFonts.almarai(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            // الجزء الثاني: الرتبة وعدد الفرص
            Row(
              children: [
                // 4. أيقونة الرتبة
                getRankBadgeWidget(volunteer.tier),
                const SizedBox(width: 8),

                // 5. عدد الفرص
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${volunteer.opportunities} فرصة',
                    style: GoogleFonts.almarai(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
