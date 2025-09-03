import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/models/filter_options.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterBarWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final FilterOptions currentFilters;

  const FilterBarWidget({super.key, this.onTap, required this.currentFilters});

  @override
  Widget build(BuildContext context) {
    // تحويل قيم الفلاتر إلى نص مقروء
    String timePeriodText;
    switch (currentFilters.timePeriod) {
      case TimePeriod.currentYear:
        timePeriodText = 'العام الجاري';
        break;
      case TimePeriod.total:
        timePeriodText = 'المجمل';
        break;
    }

    // بناء النص النهائي الذي سيتم عرضه
    final String displayText =
        '${currentFilters.department} في $timePeriodText';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // زر الفلترة
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: const Icon(
                  Icons.filter_list,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
            ),

            // النص الديناميكي
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  displayText,
                  style: GoogleFonts.almarai(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center, // لضمان التوسيط
                  overflow: TextOverflow.ellipsis, // في حال كان النص طويلاً
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
