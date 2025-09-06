import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/helper/utils.dart';
import 'package:ammerha_management/core/models/new_volunteer.dart';
import 'package:ammerha_management/core/provider/volunteers_provider.dart';
import 'package:ammerha_management/shared/dialogs/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class VolunteerProfileScreen2 extends StatelessWidget {
  final NewVolunteer vol;
  final bool showEndButton;

  const VolunteerProfileScreen2({
    super.key,
    required this.vol,
    this.showEndButton = false,
  });

  // ------- helpers -------
  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso);
      return intl.DateFormat('yyyy/MM/dd').format(dt);
    } catch (_) {
      return iso;
    }
  }

  String _formatGender(String? g) {
    final v = (g ?? '').toLowerCase().trim();
    if (v == 'male') return 'ذكر';
    if (v == 'female') return 'أنثى';
    return g ?? '';
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url.trim());
    if (uri == null) return;
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // ignore silently or show a snackbar if you like
    }
  }

  Widget _avatarWithRank() {
    final imageUrl = vol.imageUrl;

    Widget avatar;
    if (imageUrl == null ||
        imageUrl.isEmpty ||
        imageUrl.startsWith('assets/')) {
      avatar = const CircleAvatar(
        radius: 60,
        backgroundImage: AssetImage('assets/images/profile.png'),
      );
    } else {
      avatar = CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: NetworkImage(imageUrl),
        onBackgroundImageError: (_, __) {},
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        // Order of Merit at the bottom left of the image
        Positioned(
          bottom: -6,
          left: -6,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Image.asset(
              RankUtils.medalAsset(vol.rank),
              width: 37,
              height: 37,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRowWithDivider(
    String label,
    String? value, {
    TextAlign valueAlign = TextAlign.end,
  }) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.almarai(
                  fontSize: 17,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  v,
                  textDirection: TextDirection.ltr,
                  style: GoogleFonts.almarai(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
        Divider(color: Colors.grey.shade300, thickness: 1, height: 12),
      ],
    );
  }

  Widget _socialRow(BuildContext context) {
    final facebook = (vol.facebook ?? '').trim();
    final linkedin = (vol.linkedIn ?? '').trim();
    final insta = (vol.instagram ?? '').trim();

    final items = <Widget>[];

    if (facebook.isNotEmpty) {
      items.add(
        IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.facebook,
            size: 22,
            color: Color(0xFF1877F2),
          ),
          onPressed: () => _openUrl(facebook),
          tooltip: 'Facebook',
        ),
      );
    }
    if (linkedin.isNotEmpty) {
      items.add(
        IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.linkedin,
            size: 22,
            color: Color(0xFF0A66C2),
          ),
          onPressed: () => _openUrl(linkedin),
          tooltip: 'LinkedIn',
        ),
      );
    }
    if (insta.isNotEmpty) {
      items.add(
        IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.instagram,
            size: 22,
            color: Color(0xFFE4405F),
          ),
          onPressed: () => _openUrl(
            insta.startsWith('http') ? insta : 'https://instagram.com/$insta',
          ),
          tooltip: 'Instagram',
        ),
      );
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: items.expand((w) => [w, const SizedBox(width: 8)]).toList()
          ..removeLast(), // Remove the last SizeBox
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.read<VolunteersProvider>();

    final birth = _formatDate(vol.birthDate);
    final gender = _formatGender(vol.gender);
    final email = vol.email ?? '';
    final phone = vol.phone ?? '';
    final dept = vol.departmentName ?? '';
    final whatsapp = vol.whatsapp ?? '';
    final points = (vol.points ?? 0).toString();
    final rankText = (vol.rank ?? '').isEmpty ? null : vol.rank;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'الملف الشخصي للمتطوع',
            style: GoogleFonts.almarai(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: AppColors.primary,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.primary),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Image + Badge (Stack)
            Center(child: _avatarWithRank()),
            const SizedBox(height: 16),

            // name
            Center(
              child: Text(
                vol.name,
                style: GoogleFonts.almarai(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: AppColors.primary,
                ),
              ),
            ),

            // social media icons
            _socialRow(context),

            const SizedBox(height: 10),

            // Details with commas
            _buildInfoRowWithDivider("الرتبة", rankText),
            _buildInfoRowWithDivider(
              "تاريخ الميلاد",
              birth,
              valueAlign: TextAlign.start,
            ),
            _buildInfoRowWithDivider("الجنس", gender),
            _buildInfoRowWithDivider(
              "البريد",
              email,
              valueAlign: TextAlign.start,
            ),
            _buildInfoRowWithDivider(
              "رقم الهاتف",
              phone,
              valueAlign: TextAlign.start,
            ),
            _buildInfoRowWithDivider(
              "رقم واتساب",
              whatsapp,
              valueAlign: TextAlign.start,
            ),
            _buildInfoRowWithDivider("القسم", dept),
            _buildInfoRowWithDivider("النقاط", points),

            const SizedBox(height: 32),

            // End volunteering
            if (showEndButton) ...[
              ElevatedButton(
                onPressed: () async {
                  final confirmed = await showConfirmDialog(
                    context,
                    title: 'تأكيد الإنهاء',
                    message: 'هل أنت متأكد أنك تريد إنهاء التطوع لهذا المتطوع؟',
                    confirmText: 'إنهاء',
                    cancelText: 'إلغاء',
                    confirmColor: AppColors.primary,
                  );
                  if (confirmed != true) return;
                  try {
                    await prov.endVolunteer(vol.id); // delete call
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'تم إنهاء التطوع',
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.almarai(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      Navigator.of(context).maybePop();
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('فشل العملية: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "إنهاء التطوع",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
