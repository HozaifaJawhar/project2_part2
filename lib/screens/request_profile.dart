import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/models/new_volunteer.dart';
import 'package:ammerha_management/core/provider/volunteer_requests_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

class VolunteerProfileScreen extends StatelessWidget {
  final NewVolunteer req;
  VolunteerProfileScreen({super.key, required this.req});

  // convert date from Iso coordination to BirthDate coordination
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

  String _toEnglishDigits(String input) {
    const arabicIndic = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
    };
    const easternArabicIndic = {
      '۰': '0',
      '۱': '1',
      '۲': '2',
      '۳': '3',
      '۴': '4',
      '۵': '5',
      '۶': '6',
      '۷': '7',
      '۸': '8',
      '۹': '9',
    };
    return input
        .split('')
        .map((ch) => arabicIndic[ch] ?? easternArabicIndic[ch] ?? ch)
        .join();
  }

  Future<int?> _showPointsDialog(BuildContext context) async {
    final pointController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 350,
                maxWidth: 500,
                minHeight: 200,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "إضافة نقاط",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.almarai(
                          fontSize: 18,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        autofocus: true,
                        controller: pointController,

                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "أدخل عدد النقاط",
                          hintStyle: GoogleFonts.almarai(
                            color: AppColors.secondaryBlack.withOpacity(0.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.secondaryBlack,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.secondaryWhite,
                        ),
                        style: GoogleFonts.almarai(
                          color: AppColors.secondaryBlack,
                          fontSize: 16,
                        ),
                        validator: (v) {
                          final raw = (v ?? '').trim();
                          final en = _toEnglishDigits(raw);
                          if (en.isEmpty) return 'الرجاء إدخال عدد النقاط';
                          final n = int.tryParse(en);
                          if (n == null || n < 0) return 'أدخل رقمًا صحيحًا';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          width: 160,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                final en = _toEnglishDigits(
                                  pointController.text.trim(),
                                );
                                final n = int.parse(en);
                                Navigator.of(dialogContext).pop(n);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'تأكيد',
                              style: GoogleFonts.almarai(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _avatar(String? imageUrl) {
    // if we did not get any url, get the url for localy image and use it
    if (imageUrl == null || imageUrl.isEmpty) {
      return const CircleAvatar(
        radius: 60,
        backgroundImage: AssetImage('assets/images/profile.png'),
      );
    }
    // localy url
    if (imageUrl.startsWith('assets/')) {
      return CircleAvatar(radius: 60, backgroundImage: AssetImage(imageUrl));
    }
    // internet url
    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: NetworkImage(imageUrl),
      onBackgroundImageError: (_, __) {},
      child: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.read<VolunteerRequestsProvider>();

    final birth = _formatDate(req.birthDate);
    final gender = _formatGender(req.gender);
    final email = req.email ?? '';
    final phone = req.phone ?? '';
    final dept = req.departmentName ?? '';
    final whatsapp = req.whatsapp ?? '';
    final points = (req.points ?? 0).toString();

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
            // photo
            Center(child: _avatar(req.imageUrl)),
            const SizedBox(height: 20),

            // name
            Center(
              child: Text(
                req.name,
                style: GoogleFonts.almarai(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // info list
            _buildInfoRowIfNotEmpty("تاريخ الميلاد", birth),
            _buildInfoRowIfNotEmpty("الجنس", gender),
            _buildInfoRowIfNotEmpty("البريد", email),
            _buildInfoRowIfNotEmpty("رقم الهاتف", phone),
            _buildInfoRowIfNotEmpty("رقم واتساب", whatsapp),
            _buildInfoRowIfNotEmpty("القسم", dept),
            _buildInfoRowIfNotEmpty("النقاط", points),

            const SizedBox(height: 60),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await prov.approveVolunteer(
                          req.id,
                        ); // active=1 بدون نقاط
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'تم قبول المتطوع',
                                textDirection: TextDirection.rtl,
                                style: GoogleFonts.almarai(
                                  color: AppColors.white,
                                ),
                              ),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                          Navigator.of(context).maybePop();
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'فشل قبول المتطوع: $e',
                                textDirection: TextDirection.rtl,
                                style: GoogleFonts.almarai(
                                  color: AppColors.white,
                                ),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "قبول",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // TODO: rejection
                      Navigator.of(context).maybePop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "تجاهل",
                      style: TextStyle(fontSize: 16, color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () async {
                final p = await _showPointsDialog(context);
                if (p == null) return;
                try {
                  await prov.approveVolunteer(
                    req.id,
                    points: p,
                  ); // active=1 + points
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'تم قبول المتطوع وإضافة النقاط',
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.almarai(color: AppColors.white),
                        ),
                        backgroundColor: AppColors.primary,
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
                backgroundColor: AppColors.darkBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                "قبول كمتطوع قديم",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRowIfNotEmpty(String label, String? value) {
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
}
