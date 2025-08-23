import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/models/volunteer_profil_class.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  VolunteerProfilClass volunteerProfile = new VolunteerProfilClass(
    profileImageUrl: 'profileImageUrl',
    name: 'missan',
  );

  CustomDrawer({super.key});

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
                text: 'المتطوعين',
                onTap: () {},
              ),
              _buildDrawerItem(
                icon: Icons.light_mode_outlined,
                text: 'الإداريين',
                onTap: () {},
              ),
              _buildDrawerItem(
                icon: Icons.style_outlined,
                text: 'طلبات التطوع',
                onTap: () {},
              ),
              _buildDrawerItem(
                icon: Icons.delete_outlined,
                text: 'طلبات الإنضمام للفريق الإداري',
                onTap: () {},
              ),
              _buildDrawerItem(
                icon: Icons.info_outline,
                text: 'إضافة رول إداري جديد',
                onTap: () {},
              ),
              _buildDrawerItem(
                icon: Icons.info_outline,
                text: 'إضافة قسم تطوعي جديد',
                onTap: () {},
              ),
              _buildDrawerItem(
                icon: Icons.info_outline,
                text: 'الأخبار',
                onTap: () {},
              ),
              _buildDrawerItem(
                icon: Icons.info_outline,
                text: 'لوحة الشرف',
                onTap: () {},
              ),
              // Spacer pushes the logout item to the bottom of the column.
              // const Spacer(),
              _buildDrawerItem(
                icon: Icons.logout,
                text: 'تسجيل الخروج',
                color: Colors.red.shade700,
                onTap: () {
                  //   Navigator.pushNamedAndRemoveUntil(
                  //     context,
                  //     AppRoutes.loginRoute,
                  //     // remove all previous routes from the stack.
                  //     (Route<dynamic> route) => false,
                  //   );
                },
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
              // Text(
              //  // volunteerProfile.rankName,
              //   style: GoogleFonts.almarai(
              //     color: AppColors.greyText,
              //     fontSize: 14,
              //   ),
              // ),
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
                Flexible(
                  child: Text(
                    text,
                    style: GoogleFonts.almarai(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: color ?? AppColors.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
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
