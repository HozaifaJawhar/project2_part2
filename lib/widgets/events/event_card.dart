import 'package:ammerha_management/core/models/event.dart';
import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class OpportunityCard extends StatelessWidget {
  final Event event;

  const OpportunityCard({super.key, required this.event});

  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    // يمكنك تغيير التنسيق كما تحب
    return DateFormat('yyyy/MM/dd - HH:mm').format(dt.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    void _showDeleteConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: false, // ما بيسكر إلا بزر
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // أيقونة تحذير
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 40,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'هل أنت متأكد أنك تريد حذف هذه الفعالية',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.almarai(
                      fontSize: 16,
                      color: AppColors.secondaryBlack,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // زر إلغاء
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // بسكر الحوار
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryWhite,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'إلغاء',
                          style: GoogleFonts.almarai(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // زر حذف
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // هون بتحطي كود الحذف الفعلي
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'حذف',
                          style: GoogleFonts.almarai(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    final String dateText = _formatDate(event.date);
    return GestureDetector(
      onTap: () {
        //   Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => EventDetailsScreen(eventId: event.id), // ← بالمعرّف فقط
        //   ),
        // );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 1,
              offset: const Offset(1, 1),
            ),
          ],
        ),

        child: Row(
          children: [
            // صورة الفعالية
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12, right: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: _EventCoverImage(url: event.coverImage?.file),
              ),
            ),
            const SizedBox(width: 12),
            // معلومات الفعالية
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // أزرار (تعديل / حذف)
                  Row(
                    children: [
                      const Icon(
                        size: 17,
                        Icons.date_range_outlined,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 3),
                      Text(
                        dateText,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) => EditEventInfo(eventId: event.id),
                          //   ),
                          // );
                        },
                        child: const Icon(
                          size: 22,
                          Icons.edit_calendar_outlined,
                          color: Colors.amberAccent,
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          _showDeleteConfirmationDialog(context);
                        },
                        child: const Icon(
                          size: 22,
                          Icons.delete_outlined,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // سهم التفاصيل
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => EventDetailsScreen(event: event),
                //   ),
                // );
              },
              child: Container(
                width: 37,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Icon(Icons.arrow_forward, color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventCoverImage extends StatelessWidget {
  final String? url;
  const _EventCoverImage({required this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      // صورة افتراضية من الأصول لو ما في URL
      return const Image(
        image: AssetImage('assets/images/event_image.jpg'),
        width: 75,
        height: 75,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      url!,
      width: 75,
      height: 75,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Image(
        image: AssetImage('assets/images/event_image.jpg'),
        width: 75,
        height: 75,
        fit: BoxFit.cover,
      ),
      // بإمكانك إضافة loadingBuilder إن حبيت
    );
  }
}
