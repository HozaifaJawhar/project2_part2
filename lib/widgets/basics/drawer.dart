import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  final VolunteerProfile volunteerProfile;

  const CustomDrawer({super.key, required this.volunteerProfile});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Drawer(
      width: screenWidth * 0.85,
      backgroundColor: Colors.grey.shade100,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDrawerHeader(context),
              const SizedBox(height: 24),
              _buildDrawerItem(
                icon: Icons.settings_outlined,
                text: 'الإعدادات',
                onTap: () {},
              ),
              _buildDrawerItem(
                icon: Icons.light_mode_outlined,
                text: 'المظهر',
                onTap: () {},
              ),
              _buildDrawerItem(
                icon: Icons.style_outlined,
                text: 'طلب شهادة التطوع',
                onTap: () {},
              ),
              _buildDrawerItem(
                icon: Icons.delete_outlined,
                text: 'حذف الحساب وتسجيل الخروج',
                onTap: () {},
              ),
              _buildDrawerItem(
                icon: Icons.info_outline,
                text: 'عن التطبيق',
                onTap: () {},
              ),
              // Spacer pushes the logout item to the bottom of the column.
              const Spacer(),
              _buildDrawerItem(
                icon: Icons.logout,
                text: 'تسجيل الخروج',
                color: Colors.red.shade700,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build the drawer's header section.
  Widget _buildDrawerHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 43,
          backgroundImage: AssetImage(volunteerProfile.profileImageUrl),
        ),
        const SizedBox(width: 8),
        // Expanded ensures the Column takes up the remaining available space.
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Flexible allows the Text widget to shrink if needed, preventing overflow.
                  Flexible(
                    child: Text(
                      volunteerProfile.name,
                      style: GoogleFonts.almarai(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                 // getRankBadgeWidget(volunteerProfile.rankTier, size: 35),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                volunteerProfile.rankName,
                style: GoogleFonts.almarai(
                  color: AppColors.greyText,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper method to build each item in the drawer list.
  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 20.0,
            ),
            child: Row(
              children: [
                Icon(icon, color: color ?? AppColors.primary, size: 26),
                const SizedBox(width: 16),
                Text(
                  text,
                  style: GoogleFonts.almarai(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color ?? AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
